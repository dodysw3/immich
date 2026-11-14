import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { mkdtemp, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import sharp from 'sharp';
import { OnEvent, OnJob } from 'src/decorators.js';
import { ImmichWorker, JobName, JobStatus, Permission, QueueName } from 'src/enum.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';
import { MachineLearningRepository } from 'src/repositories/machine-learning.repository.js';
import { RotationSuggestionRepository } from 'src/repositories/rotation-suggestion.repository.js';
import { AssetEditRepository } from 'src/repositories/asset-edit.repository.js';
import { AssetRepository } from 'src/repositories/asset.repository.js';
import { AssetJobRepository } from 'src/repositories/asset-job.repository.js';
import { ConfigRepository } from 'src/repositories/config.repository.js';
import { JobRepository } from 'src/repositories/job.repository.js';
import { AccessRepository } from 'src/repositories/access.repository.js';
import {
  RotationSuggestionResponseDto,
  RotationSuggestionStatus,
  type RotationSuggestionApplyDto,
  type RotationSuggestionDismissDto,
  type RotationSuggestionRun,
} from 'src/dtos/rotation-suggestion.dto.js';
import { AssetEditAction, AssetEditActionItem } from 'src/dtos/editing.dto.js';
import { AuthDto } from 'src/dtos/auth.dto.js';
import type { JobOf } from 'src/types.js';
import type { ArgOf } from 'src/repositories/event.repository.js';
import { checkAccess, requireAccess } from 'src/utils/access.js';
import {
  ROTATION_SUGGESTION_MODEL,
  ROTATION_SUGGESTION_PIPELINE_VERSION,
  createRotationSuggestionRunKey,
  isOrientationSuggestionEligible,
} from 'src/utils/rotation-suggestion.js';
import { batched } from 'src/utils/misc.js';
import { AssetService } from 'src/services/asset.service.js';

// The orientation model letterboxes to a 224px canvas internally, so the
// preview only needs enough resolution for the letterbox to be faithful; the
// transfer-size cap keeps multipart payloads small on the ML round-trip.
const ORIENTATION_PREVIEW_MAX_EDGE = 1024;
const ORIENTATION_MAX_DECODE_PIXELS = 16_000_000;

@Injectable()
export class OrientationSuggestionService {
  private logger: LoggingRepository;

  constructor(
    logger: LoggingRepository,
    private configRepository: ConfigRepository,
    private assetRepository: AssetRepository,
    private assetJobRepository: AssetJobRepository,
    private jobRepository: JobRepository,
    private machineLearningRepository: MachineLearningRepository,
    private rotationSuggestionRepository: RotationSuggestionRepository,
    private assetEditRepository: AssetEditRepository,
    private accessRepository: AccessRepository,
    private assetService: AssetService,
    ) {
    logger.setContext(OrientationSuggestionService.name);
    this.logger = logger;
  }

  // Upload-path trigger: same event the interpretation lane rides — it fires
  // once duplicate analysis has concluded for the asset, so a fresh upload
  // gets its suggestion at priority 2 without racing the ingest pipeline.
  @OnEvent({ name: 'AssetDuplicateDetectionCompleted', workers: [ImmichWorker.Microservices] })
  async onDuplicateDetectionCompleted({ assetId }: ArgOf<'AssetDuplicateDetectionCompleted'>) {
    if (!this.configRepository.getEnv().orientationSuggestion.enabled) {
      return;
    }

    await this.jobRepository.queue({
      name: JobName.AssetOrientationSuggestion,
      data: { id: assetId, priority: 2 },
    });
  }

  // Backfill sweep for existing libraries (admin job panel / ops script):
  // every non-hidden, non-deleted image asset at the bulk tier.
  @OnJob({ name: JobName.AssetOrientationSuggestionQueueAll, queue: QueueName.OrientationSuggestion })
  async handleQueueAll(): Promise<JobStatus> {
    if (!this.configRepository.getEnv().orientationSuggestion.enabled) {
      return JobStatus.Skipped;
    }

    for await (const assets of batched(this.assetJobRepository.streamForOrientationSuggestion(), 1000)) {
      await this.jobRepository.queueAll(
        assets.map((asset) => ({ name: JobName.AssetOrientationSuggestion, data: { id: asset.id, priority: 3 } })),
      );
    }

    return JobStatus.Success;
  }

  @OnJob({ name: JobName.AssetOrientationSuggestion, queue: QueueName.OrientationSuggestion })
  async handleSuggestion({ id: assetId }: JobOf<JobName.AssetOrientationSuggestion>): Promise<JobStatus> {
    const config = this.configRepository.getEnv().orientationSuggestion;
    if (!config.enabled) {
      return JobStatus.Skipped;
    }

    const asset = await this.assetRepository.getForEdit(assetId);
    if (!asset || !isOrientationSuggestionEligible(asset)) {
      return JobStatus.Skipped;
    }

    const preview = await this.assetJobRepository.getForOcr(assetId);
    if (!preview?.previewFile) {
      return JobStatus.Skipped;
    }

    const startedAt = new Date();
    const prepared = await sharp(preview.previewFile, { limitInputPixels: ORIENTATION_MAX_DECODE_PIXELS })
      .rotate()
      .resize(ORIENTATION_PREVIEW_MAX_EDGE, ORIENTATION_PREVIEW_MAX_EDGE, { fit: 'inside', withoutEnlargement: true })
      .jpeg({ quality: 85 })
      .toBuffer();

    // The ML repository reads from a path (same contract as /predict callers),
    // so the prepared preview goes through a scratch file that is always
    // cleaned up.
    const scratchDir = await mkdtemp(join(tmpdir(), 'immich-orientation-'));
    const scratchPath = join(scratchDir, 'preview.jpg');
    await writeFile(scratchPath, prepared);

    try {
      const result = await this.machineLearningRepository.orientation(scratchPath, config.modelTier);

      // Abstention is never a fifth rotation class: native abstain or a
      // snapped-class confidence below the threshold both record a run with no
      // rotation class.
      const abstain = result.abstain || result.confidence < config.threshold;
      const run: RotationSuggestionRun = {
        model: ROTATION_SUGGESTION_MODEL,
        tier: config.modelTier,
        predictedRotation: abstain ? null : (result.correctionCw as 0 | 90 | 180 | 270),
        confidence: result.confidence,
        abstain,
        status: 'pending',
        startedAt: startedAt.toISOString(),
        finishedAt: new Date().toISOString(),
      };
      const runKey = createRotationSuggestionRunKey(run.model, run.tier, ROTATION_SUGGESTION_PIPELINE_VERSION);
      // Re-run semantics live in the repository: same-identity re-runs refresh
      // pending runs but never resurrect applied/dismissed verdicts, and a new
      // runKey (model/tier/pipeline change) appends without touching prior runs.
      const recorded = await this.rotationSuggestionRepository.recordRun(assetId, runKey, run);
      this.logger.debug(
        `Rotation suggestion for asset ${assetId}: correction=${run.predictedRotation} confidence=${run.confidence.toFixed(3)} abstain=${run.abstain} (runKey=${runKey.slice(0, 8)} preserved=${recorded.preserved})`,
      );
      return JobStatus.Success;
    } finally {
      await rm(scratchDir, { recursive: true, force: true });
    }
  }

  // Returns null both when no run exists and when the caller cannot read the
  // asset: "responds as if no suggestion exists" (spec), so suggestion
  // existence never leaks across the read-permission boundary.
  async get(auth: AuthDto, assetId: string): Promise<RotationSuggestionResponseDto | null> {
    const accessible = await checkAccess(this.accessRepository, {
      auth,
      permission: Permission.AssetRead,
      ids: [assetId],
    });
    if (!accessible.has(assetId)) {
      return null;
    }

    const latest = await this.rotationSuggestionRepository.getLatestRun(assetId);
    if (!latest) {
      return null;
    }

    const edits = await this.readEdits(assetId);
    return this.toResponseDto(assetId, latest.runKey, latest.run, edits);
  }

  // HTTP shape of get(): 404 both when no run exists and when the caller
  // cannot read the asset ("responds as if no suggestion exists", spec), so
  // suggestion existence never leaks across the read-permission boundary.
  async getOrThrow(auth: AuthDto, assetId: string): Promise<RotationSuggestionResponseDto> {
    const suggestion = await this.get(auth, assetId);
    if (!suggestion) {
      throw new NotFoundException('No rotation suggestion exists for this asset');
    }

    return suggestion;
  }

  // Owner-scoped pending list: actionable suggestions only (non-abstaining,
  // non-zero rotation, still pending after reconciliation with asset_edit).
  async listPending(auth: AuthDto): Promise<RotationSuggestionResponseDto[]> {
    const documents = await this.rotationSuggestionRepository.listDocuments();
    const results: RotationSuggestionResponseDto[] = [];
    for (const { assetId, ownerId, document } of documents) {
      if (ownerId !== auth.user.id) {
        continue;
      }

      const latest = this.latestRunOf(document);
      if (!latest) {
        continue;
      }

      const { runKey, run } = latest;
      if (run.status !== 'pending' || run.abstain || run.predictedRotation === null || run.predictedRotation === 0) {
        continue;
      }

      const edits = await this.readEdits(assetId);
      if (this.computedStatus(run, this.rotateAngleOf(edits)) !== 'pending') {
        continue;
      }

      results.push(this.toResponseDto(assetId, runKey, run, edits));
    }

    return results;
  }

  async apply(auth: AuthDto, assetId: string, dto?: RotationSuggestionApplyDto): Promise<RotationSuggestionResponseDto> {
    await requireAccess(this.accessRepository, { auth, permission: Permission.AssetEditCreate, ids: [assetId] });

    const { runKey, run } = await this.resolveRun(assetId, dto?.runKey);
    if (run.status === 'applied') {
      // Idempotent repeat of an already-applied suggestion.
      const edits = await this.readEdits(assetId);
      return this.toResponseDto(assetId, runKey, { ...run, status: 'applied' }, edits);
    }

    if (run.status !== 'pending') {
      throw new BadRequestException(`Rotation suggestion is ${run.status}`);
    }

    if (run.abstain || run.predictedRotation === null || run.predictedRotation === 0) {
      throw new BadRequestException('This suggestion does not propose a rotation');
    }

    const stored = await this.assetEditRepository.getAll(assetId);
    // Same path as a user rotation in the UI: editAsset validates, replaces
    // all edits, and queues AssetEditThumbnailGeneration (edited
    // preview/thumbnail/fullsize, thumbhash, dimensions, OCR/search/faces).
    // Composition, not duplication (mirrors web's applyInstantRotate): the
    // suggested angle folds into the single allowed rotate edit, sum mod 360.
    // Existing edit ordering — crop first — is untouched, so revalidation in
    // editAsset sees the exact edit list it already accepted before.
    const edits = stored.map(({ action, parameters }) => ({ action, parameters }) as AssetEditActionItem);
    const existingRotate = edits.find(
      (edit): edit is Extract<AssetEditActionItem, { action: AssetEditAction.Rotate }> =>
        edit.action === AssetEditAction.Rotate,
    );
    const angle = ((existingRotate?.parameters.angle ?? 0) + run.predictedRotation) % 360;
    let nextEdits: AssetEditActionItem[];
    if (angle === 0) {
      nextEdits = edits.filter((edit) => edit.action !== AssetEditAction.Rotate);
    } else if (existingRotate) {
      nextEdits = edits.map((edit) => (edit === existingRotate ? { ...edit, parameters: { angle } } : edit));
    } else {
      nextEdits = [...edits, { action: AssetEditAction.Rotate, parameters: { angle } }];
    }

    if (nextEdits.length === 0) {
      await this.assetService.removeAssetEdits(auth, assetId);
    } else {
      await this.assetService.editAsset(auth, assetId, { edits: nextEdits });
    }

    const applied = await this.rotationSuggestionRepository.setStatus(assetId, runKey, 'applied');
    return this.toResponseDto(assetId, runKey, applied ?? { ...run, status: 'applied' }, nextEdits);
  }

  async dismiss(
    auth: AuthDto,
    assetId: string,
    dto?: RotationSuggestionDismissDto,
  ): Promise<RotationSuggestionResponseDto> {
    await requireAccess(this.accessRepository, { auth, permission: Permission.AssetUpdate, ids: [assetId] });

    const { runKey, run } = await this.resolveRun(assetId, dto?.runKey);
    const dismissed = await this.rotationSuggestionRepository.setStatus(assetId, runKey, 'dismissed');
    if (!dismissed) {
      throw new BadRequestException(`Rotation suggestion is not dismissible (current status: ${run.status})`);
    }

    return this.toResponseDto(assetId, runKey, dismissed, await this.readEdits(assetId));
  }

  private async readEdits(assetId: string): Promise<AssetEditActionItem[]> {
    const stored = await this.assetEditRepository.getAll(assetId);
    return stored.map(({ action, parameters }) => ({ action, parameters }) as AssetEditActionItem);
  }

  private async resolveRun(assetId: string, runKey?: string): Promise<{ runKey: string; run: RotationSuggestionRun }> {
    if (runKey) {
      const document = await this.rotationSuggestionRepository.get(assetId);
      const run = document?.runs[runKey];
      if (!run) {
        throw new NotFoundException('No such rotation suggestion run for this asset');
      }

      return { runKey, run };
    }

    const latest = await this.rotationSuggestionRepository.getLatestRun(assetId);
    if (!latest) {
      throw new NotFoundException('No rotation suggestion exists for this asset');
    }

    return latest;
  }

  private latestRunOf(document: { runs: Record<string, RotationSuggestionRun> }): {
    runKey: string;
    run: RotationSuggestionRun;
  } | null {
    let latest: { runKey: string; run: RotationSuggestionRun } | null = null;
    for (const [runKey, run] of Object.entries(document.runs)) {
      if (!latest || (run.finishedAt ?? '') > (latest.run.finishedAt ?? '')) {
        latest = { runKey, run };
      }
    }

    return latest;
  }

  private rotateAngleOf(edits: AssetEditActionItem[]): number | null {
    const rotate = edits.find(
      (edit): edit is Extract<AssetEditActionItem, { action: AssetEditAction.Rotate }> =>
        edit.action === AssetEditAction.Rotate,
    );
    return rotate ? rotate.parameters.angle : null;
  }

  // The stored status is a snapshot; asset_edit is the truth. An applied run
  // whose rotate edit vanished (user cleared edits / set angle 0) reconciles
  // back to pending, and a pending run whose rotation already matches the
  // current edit list reconciles to applied (e.g. applied via instant-rotate).
  private computedStatus(run: RotationSuggestionRun, rotateAngle: number | null): RotationSuggestionStatus {
    if (run.status === 'applied') {
      return rotateAngle === null || rotateAngle === 0 ? 'pending' : 'applied';
    }

    if (
      run.status === 'pending' &&
      run.predictedRotation !== null &&
      run.predictedRotation !== 0 &&
      rotateAngle === run.predictedRotation
    ) {
      return 'applied';
    }

    return run.status;
  }

  private toResponseDto(
    assetId: string,
    runKey: string,
    run: RotationSuggestionRun,
    edits: AssetEditActionItem[],
  ): RotationSuggestionResponseDto {
    return {
      assetId,
      runKey,
      model: run.model,
      tier: run.tier,
      status: this.computedStatus(run, this.rotateAngleOf(edits)),
      abstain: run.abstain,
      predictedRotation: run.predictedRotation,
      confidence: run.confidence,
      startedAt: run.startedAt,
      finishedAt: run.finishedAt,
    };
  }
}
