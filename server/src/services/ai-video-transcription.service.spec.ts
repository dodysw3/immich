import { writeFileSync } from 'node:fs';
import { join } from 'node:path';
import { describe, expect, it, vi } from 'vitest';
import { AiVideoTranscriptionDocument, AiVideoTranscriptionRun } from 'src/dtos/ai-video-transcription.dto.js';
import { AssetType, JobName, JobStatus } from 'src/enum.js';
import { AiVideoTranscriptionRepository } from 'src/repositories/ai-video-transcription.repository.js';
import { AiVideoTranscriptionClientError } from 'src/services/ai-video-transcription.client.js';
import { AiVideoTranscriptionService } from 'src/services/ai-video-transcription.service.js';
import {
  AI_VIDEO_TRANSCRIPTION_COVERAGE_POLICY,
  AI_VIDEO_TRANSCRIPTION_PRODUCER_VERSION,
  createLegacyVideoTranscriptionRunKey,
  createVideoTranscriptionRunKey,
} from 'src/utils/ai-video-transcription.js';

const assetId = 'asset-1';

const config = {
  enabled: true,
  url: 'http://127.0.0.1:51905',
  model: 'faster-whisper-large-v3',
  timeoutMs: 1000,
  language: '',
  maxDurationSec: 7200,
  chunkDurationSec: 300,
  chunkOverlapSec: 2,
};

const runKey = createVideoTranscriptionRunKey({
  model: config.model,
  producerVersion: AI_VIDEO_TRANSCRIPTION_PRODUCER_VERSION,
  language: config.language,
  coveragePolicy: AI_VIDEO_TRANSCRIPTION_COVERAGE_POLICY,
});

type SidecarResponse = {
  language?: string;
  languageProbability?: number;
  noSpeech?: boolean;
  reason?: string;
  segments: Array<{ startSec: number; endSec: number; text: string }>;
};

const makeService = (
  options: {
    document?: AiVideoTranscriptionDocument | null;
    probe?: { format: { duration: number }; audioStreams: unknown[] };
    claimRun?: Partial<AiVideoTranscriptionRun>;
    resumedChunks?: number;
    /** Sequential chunk-transcription responses; chunks are processed in order. */
    sidecar?: (call: number) => SidecarResponse;
  } = {},
) => {
  let sidecarCall = 0;
  const dependencies = {
    logger: { setContext: vi.fn(), debug: vi.fn(), log: vi.fn(), warn: vi.fn() },
    configRepository: { getEnv: vi.fn().mockReturnValue({ aiVideoTranscription: config }) },
    assetRepository: {
      getByIds: vi.fn().mockResolvedValue([{ id: assetId, type: AssetType.Video, originalPath: '/media/car.mp4' }]),
    },
    mediaRepository: {
      probe:
        options.probe === undefined
          ? vi.fn().mockResolvedValue({ format: { duration: 120 }, audioStreams: [{ index: 1 }] })
          : vi.fn().mockResolvedValue(options.probe),
      // The legacy whole-file extractor: the chunked producer must never use it.
      extractVideoAudio: vi.fn().mockResolvedValue(null),
      // Writes into the service's own temp dir, which it removes afterwards.
      extractVideoAudioChunk: vi.fn((_input: string, outputDir: string, window: { startSec: number }) => {
        const path = join(outputDir, `audio-chunk-${window.startSec}.wav`);
        writeFileSync(path, Buffer.from('RIFF....WAVEfmt '));
        return Promise.resolve(path);
      }),
    },
    transcriptionRepository: {
      get: vi.fn().mockResolvedValue(options.document ?? null),
      claim: vi.fn().mockResolvedValue({
        alreadyExists: false,
        runKey,
        run: { status: 'running', segments: [], ...options.claimRun },
        resumedChunks: options.resumedChunks ?? 0,
      }),
      appendSegments: vi.fn(() => Promise.resolve()),
      complete: vi.fn((_assetId: string, _runKey: string, _options: Record<string, unknown>) => Promise.resolve(true)),
      fail: vi.fn(() => Promise.resolve()),
      completeChunk: vi.fn(() => Promise.resolve(true)),
      failChunk: vi.fn(() => Promise.resolve(true)),
      renewLease: vi.fn(() => Promise.resolve(true)),
      findLatestCompletedRun: vi.fn((doc: AiVideoTranscriptionDocument) =>
        AiVideoTranscriptionRepository.prototype.findLatestCompletedRun.call(null, doc),
      ),
    },
    jobRepository: { queue: vi.fn(() => Promise.resolve()) },
    assetJobRepository: { streamForTranscriptionReconcile: vi.fn() },
    client: {
      transcribe: vi.fn(
        (_audio: Buffer) =>
          Promise.resolve(
            options.sidecar
              ? options.sidecar(sidecarCall++)
              : {
                  language: 'en',
                  languageProbability: 0.9,
                  noSpeech: false,
                  segments: [{ startSec: 0.5, endSec: 2.5, text: 'hello world' }],
                },
          ) as Promise<SidecarResponse>,
      ),
    },
  };
  const service = new AiVideoTranscriptionService(
    dependencies.logger as never,
    dependencies.configRepository as never,
    dependencies.assetRepository as never,
    dependencies.mediaRepository as never,
    dependencies.transcriptionRepository as never,
    dependencies.client as never,
    dependencies.jobRepository as never,
    dependencies.assetJobRepository as never,
  );
  return { service, dependencies };
};

/** Reconcile sweep helpers (module scope: shared across sweep tests). */
const video = (id: string, transcriptValue: unknown) => ({ id, transcriptValue });

const streamOf = function* (assets: Array<{ id: string; transcriptValue: unknown }>) {
  for (const asset of assets) {
    yield asset;
  }
};

const sweepRun = (overrides: Partial<AiVideoTranscriptionRun> = {}): AiVideoTranscriptionRun => ({
  model: config.model,
  promptVersion: 'video-transcription-0.2.0',
  status: 'running',
  trigger: 'upload',
  requestedAt: '2026-11-12T00:00:00.000Z',
  config: { language: '' },
  segments: [],
  ...overrides,
});

const doc = (runs: Record<string, AiVideoTranscriptionRun>): AiVideoTranscriptionDocument => ({
  schemaVersion: 2,
  runs,
});

const reconcileSweep = async (service: AiVideoTranscriptionService, budget?: number) =>
  (service as never as { reconcile: (budget?: number) => Promise<number> }).reconcile(budget);

describe(AiVideoTranscriptionService.name, () => {
  it('queue handler: skips without touching transcripts when disabled', async () => {
    const { service, dependencies } = makeService();
    dependencies.configRepository.getEnv.mockReturnValue({ aiVideoTranscription: { ...config, enabled: false } });

    const status = await service.handleTranscribeVideo({ id: assetId });

    expect(status).toBe(JobStatus.Skipped);
    // Disabled mode preserves existing transcripts: no claim, no fail, no work.
    expect(dependencies.transcriptionRepository.claim).not.toHaveBeenCalled();
    expect(dependencies.transcriptionRepository.fail).not.toHaveBeenCalled();
    expect(dependencies.transcriptionRepository.complete).not.toHaveBeenCalled();
    expect(dependencies.client.transcribe).not.toHaveBeenCalled();
  });

  it('upload hook: schedules transcription for new videos on the upload tier', async () => {
    const { service, dependencies } = makeService();

    await service.onAssetMetadataExtracted({ assetId, userId: 'user-1' });

    expect(dependencies.jobRepository.queue).toHaveBeenCalledWith({
      name: JobName.AssetTranscribeVideo,
      data: { id: assetId, priority: 2, trigger: 'upload' },
    });
  });

  it('upload hook: schedules nothing when transcription is disabled', async () => {
    const { service, dependencies } = makeService();
    dependencies.configRepository.getEnv.mockReturnValue({ aiVideoTranscription: { ...config, enabled: false } });

    await service.onAssetMetadataExtracted({ assetId, userId: 'user-1' });

    expect(dependencies.jobRepository.queue).not.toHaveBeenCalled();
  });

  it('upload hook: schedules nothing for non-video assets', async () => {
    const { service, dependencies } = makeService();
    dependencies.assetRepository.getByIds.mockResolvedValue([
      { id: assetId, type: AssetType.Image, originalPath: '/media/car.jpg' },
    ]);

    await service.onAssetMetadataExtracted({ assetId, userId: 'user-1' });

    expect(dependencies.jobRepository.queue).not.toHaveBeenCalled();
  });

  it('concurrent deliveries: interpretation chaining skips while an upload job is queued', async () => {
    const { service, dependencies } = makeService();
    // The upload job claimed/queued the run before interpretation chained in.
    dependencies.transcriptionRepository.get.mockResolvedValue({
      schemaVersion: 2,
      runs: {
        [runKey]: {
          model: config.model,
          promptVersion: 'v',
          status: 'queued',
          trigger: 'upload',
          requestedAt: '2026-11-12T00:00:00.000Z',
          config: { language: '' },
          segments: [],
        },
      },
    });

    const run = await service.transcribeIfMissing(assetId, 'auto-interpret');

    expect(dependencies.transcriptionRepository.claim).not.toHaveBeenCalled();
    expect(dependencies.client.transcribe).not.toHaveBeenCalled();
    expect(run).toBeUndefined();
  });

  it('concurrent deliveries: a refused claim produces no second active transcription', async () => {
    const { service, dependencies } = makeService();
    dependencies.transcriptionRepository.claim.mockResolvedValue({
      alreadyExists: true,
      runKey,
      run: { status: 'running', segments: [] },
      reason: 'active-lease',
    });

    const status = await service.handleTranscribeVideo({ id: assetId, trigger: 'upload' });

    expect(status).toBe(JobStatus.Success);
    expect(dependencies.client.transcribe).not.toHaveBeenCalled();
    expect(dependencies.transcriptionRepository.complete).not.toHaveBeenCalled();
    expect(dependencies.transcriptionRepository.fail).not.toHaveBeenCalled();
  });

  it('queue handler: reports failures to the queue instead of swallowing them', async () => {
    const { service, dependencies } = makeService();
    dependencies.mediaRepository.extractVideoAudioChunk.mockRejectedValue(new Error('ffmpeg boom'));

    await expect(service.handleTranscribeVideo({ id: assetId, trigger: 'upload' })).rejects.toThrow('ffmpeg boom');
    expect(dependencies.transcriptionRepository.fail).toHaveBeenCalledWith(
      assetId,
      runKey,
      expect.objectContaining({ code: 'media_error' }),
    );
  });

  it('queue handler: succeeds after producing a run', async () => {
    const { service, dependencies } = makeService();

    const status = await service.handleTranscribeVideo({ id: assetId, trigger: 'upload' });

    expect(status).toBe(JobStatus.Success);
    expect(dependencies.transcriptionRepository.claim).toHaveBeenCalledTimes(1);
    expect(dependencies.transcriptionRepository.claim.mock.calls[0][1].trigger).toBe('upload');
  });

  it('completion hook: successful transcription enqueues a search-index sync', async () => {
    const { service, dependencies } = makeService();

    await service.handleTranscribeVideo({ id: assetId, trigger: 'upload' });

    expect(dependencies.jobRepository.queue).toHaveBeenCalledWith({
      name: JobName.TranscriptIndexSync,
      data: { id: assetId },
    });
  });

  it('records terminal no-audio when the probe verifies no audio stream', async () => {
    const { service, dependencies } = makeService({ probe: { format: { duration: 30 }, audioStreams: [] } });

    await service.transcribeIfMissing(assetId, 'auto-interpret');

    expect(dependencies.transcriptionRepository.complete).toHaveBeenCalledWith(
      assetId,
      expect.any(String),
      expect.objectContaining({ noAudio: true }),
    );
    // Terminal outcome: no extraction, no sidecar request, no failure row.
    expect(dependencies.mediaRepository.extractVideoAudioChunk).not.toHaveBeenCalled();
    expect(dependencies.mediaRepository.extractVideoAudio).not.toHaveBeenCalled();
    expect(dependencies.client.transcribe).not.toHaveBeenCalled();
    expect(dependencies.transcriptionRepository.fail).not.toHaveBeenCalled();
  });

  it('fails retryably when chunk extraction fails despite a probed audio stream', async () => {
    const { service, dependencies } = makeService();
    dependencies.mediaRepository.extractVideoAudioChunk.mockRejectedValue(new Error('ffmpeg boom'));

    await service.transcribeIfMissing(assetId, 'auto-interpret');

    // A corrupt/broken stream is a failure eligible for retry — never a
    // terminal no-audio outcome. The failing chunk is marked and the run fails.
    expect(dependencies.transcriptionRepository.complete).not.toHaveBeenCalled();
    expect(dependencies.transcriptionRepository.failChunk).toHaveBeenCalledWith(assetId, runKey, 0, {
      code: 'media_error',
      message: expect.stringContaining('ffmpeg boom'),
    });
    expect(dependencies.transcriptionRepository.fail).toHaveBeenCalledWith(
      assetId,
      runKey,
      expect.objectContaining({ code: 'media_error' }),
    );
    expect(dependencies.client.transcribe).not.toHaveBeenCalled();
  });

  it('fails retryably when the probe itself fails', async () => {
    const { service, dependencies } = makeService();
    dependencies.mediaRepository.probe.mockRejectedValue(new Error('unreadable file'));

    await service.transcribeIfMissing(assetId, 'auto-interpret');

    expect(dependencies.transcriptionRepository.complete).not.toHaveBeenCalled();
    expect(dependencies.transcriptionRepository.fail).toHaveBeenCalledWith(
      assetId,
      expect.any(String),
      expect.objectContaining({ code: 'media_error', message: expect.stringContaining('unreadable file') }),
    );
  });

  it('fails retryably when the sidecar request fails to transport mid-run', async () => {
    const { service, dependencies } = makeService();
    dependencies.client.transcribe.mockRejectedValue(
      new AiVideoTranscriptionClientError('network_error', 'sidecar unreachable'),
    );

    await service.transcribeIfMissing(assetId, 'auto-interpret');

    expect(dependencies.transcriptionRepository.complete).not.toHaveBeenCalled();
    expect(dependencies.transcriptionRepository.failChunk).toHaveBeenCalledWith(
      assetId,
      runKey,
      0,
      expect.objectContaining({ code: 'network_error' }),
    );
    expect(dependencies.transcriptionRepository.fail).toHaveBeenCalledWith(
      assetId,
      runKey,
      expect.objectContaining({ code: 'network_error' }),
    );
  });

  it('records terminal no-speech when every chunk verifies no usable speech', async () => {
    const { service, dependencies } = makeService({
      probe: { format: { duration: 400 }, audioStreams: [{}] },
      sidecar: () => ({ noSpeech: true, segments: [] }),
    });

    await service.transcribeIfMissing(assetId, 'auto-interpret');

    expect(dependencies.client.transcribe).toHaveBeenCalledTimes(2);
    expect(dependencies.transcriptionRepository.complete).toHaveBeenCalledWith(
      assetId,
      runKey,
      expect.objectContaining({ noSpeech: true }),
    );
    expect(dependencies.transcriptionRepository.fail).not.toHaveBeenCalled();
  });

  it('transcribes beyond the legacy 7200s cap in bounded chunks without a whole-video WAV', async () => {
    const { service, dependencies } = makeService({
      probe: { format: { duration: 7300 }, audioStreams: [{}] },
      sidecar: (call) => ({
        language: 'id',
        // The final chunk's window starts 2s before its responsibility range,
        // so its segment must start inside the range to survive overlap dedup.
        segments: [{ startSec: call === 24 ? 5 : 1, endSec: 6, text: 'words' }],
      }),
    });

    await service.transcribeIfMissing(assetId, 'auto-interpret');

    // 25 bounded windows (24 x 300s + 100s tail), never one whole-video request.
    expect(dependencies.mediaRepository.extractVideoAudio).not.toHaveBeenCalled();
    expect(dependencies.mediaRepository.extractVideoAudioChunk).toHaveBeenCalledTimes(25);
    const windows = dependencies.mediaRepository.extractVideoAudioChunk.mock.calls.map(
      (call: unknown[]) => call[2] as { startSec: number; durationSec: number },
    );
    for (const [index, window] of windows.entries()) {
      expect(window.startSec).toBe(Math.max(0, index * 300 - 2));
      // Interior windows pad both sides; the final window clamps to the duration.
      expect(window.durationSec).toBeLessThanOrEqual(304);
    }
    expect(windows.at(-1)!.startSec).toBe(7200 - 2);
    expect(windows.at(-1)!.startSec + windows.at(-1)!.durationSec).toBe(7300);
    expect(dependencies.transcriptionRepository.appendSegments).not.toHaveBeenCalled();

    // Absolute timestamps: every chunk contributes its window-shifted segment.
    const chunkSegments = dependencies.transcriptionRepository.completeChunk.mock.calls.map(
      (call: unknown[]) => call[3] as Array<{ startMs: number }>,
    );
    expect(chunkSegments).toHaveLength(25);
    expect(chunkSegments[0][0].startMs).toBe(1000);
    expect(chunkSegments.at(-1)![0].startMs).toBe(7_198_000 + 5000);

    // Final completion carries no truncated flag — the old cap no longer truncates.
    const completeOptions = dependencies.transcriptionRepository.complete.mock.calls[0][2];
    expect(completeOptions.truncated).toBeUndefined();
    expect(completeOptions.noSpeech).toBeUndefined();
  });

  it('shifts chunk-local timestamps to absolute offsets, deduplicates overlap, and keeps timestamp zero', async () => {
    const { service, dependencies } = makeService({
      probe: { format: { duration: 400 }, audioStreams: [{}] },
      sidecar: (call) => {
        if (call === 0) {
          // Window [0, 302]: a segment at absolute zero and one straddling
          // the 300s boundary (kept: it starts inside chunk 0's range).
          return {
            segments: [
              { startSec: 0, endSec: 1, text: ' pembuka' },
              { startSec: 299.5, endSec: 301, text: 'straddler' },
            ],
          };
        }
        // Window [298, 402]: the same straddler (dropped: starts before this
        // chunk's range), a fresh segment, and one beyond the duration.
        return {
          segments: [
            { startSec: 1.5, endSec: 2.5, text: 'straddler copy' },
            { startSec: 4, endSec: 5, text: 'bagian dua' },
            { startSec: 105, endSec: 106, text: 'beyond the end' },
          ],
        };
      },
    });

    await service.transcribeIfMissing(assetId, 'auto-interpret');

    const chunkSegments = dependencies.transcriptionRepository.completeChunk.mock.calls.map(
      (call: unknown[]) => call[3] as Array<{ startMs: number; endMs: number; text: string }>,
    );
    expect(chunkSegments[0]).toEqual([
      { startMs: 0, endMs: 1000, text: ' pembuka' },
      { startMs: 299_500, endMs: 301_000, text: 'straddler' },
    ]);
    expect(chunkSegments[1]).toEqual([{ startMs: 302_000, endMs: 303_000, text: 'bagian dua' }]);
  });

  it('keeps mixed speech/silence runs as speech (noSpeech only when nothing was produced)', async () => {
    const { service, dependencies } = makeService({
      probe: { format: { duration: 400 }, audioStreams: [{}] },
      sidecar: (call) =>
        call === 0
          ? { noSpeech: true, segments: [] }
          : { language: 'en', segments: [{ startSec: 10, endSec: 12, text: 'finally speech' }] },
    });

    await service.transcribeIfMissing(assetId, 'auto-interpret');

    const completeOptions = dependencies.transcriptionRepository.complete.mock.calls[0][2];
    expect(completeOptions.noSpeech).toBeUndefined();
    expect(dependencies.transcriptionRepository.completeChunk).toHaveBeenCalledTimes(2);
  });

  it('resumes from durably completed chunks without re-extracting them', async () => {
    const { service, dependencies } = makeService({
      probe: { format: { duration: 600 }, audioStreams: [{}] },
      resumedChunks: 1,
      claimRun: {
        chunks: [
          { index: 0, startMs: 0, endMs: 300_000, status: 'completed', completedAt: '2026-11-11T00:00:00.000Z' },
          { index: 1, startMs: 300_000, endMs: 600_000, status: 'pending' },
        ],
      },
      sidecar: () => ({ segments: [{ startSec: 5, endSec: 6, text: 'lanjutan' }] }),
    });

    await service.transcribeIfMissing(assetId, 'auto-interpret');

    // Only the pending chunk is extracted and transcribed; the final window
    // clamps to the video duration (600s), not end + overlap.
    expect(dependencies.mediaRepository.extractVideoAudioChunk).toHaveBeenCalledTimes(1);
    expect(dependencies.mediaRepository.extractVideoAudioChunk.mock.calls[0][2]).toEqual({
      startSec: 298,
      durationSec: 302,
    });
    expect(dependencies.client.transcribe).toHaveBeenCalledTimes(1);
    expect(dependencies.transcriptionRepository.completeChunk).toHaveBeenCalledWith(
      assetId,
      runKey,
      1,
      [{ startMs: 303_000, endMs: 304_000, text: 'lanjutan' }],
      { startMs: 298_000, endMs: 600_000 },
    );
    expect(dependencies.transcriptionRepository.renewLease).toHaveBeenCalledWith(
      assetId,
      runKey,
      expect.any(String),
      expect.any(Number),
    );
  });

  it('skips producing when the claim is refused for valid completed work or an active lease', async () => {
    const { service, dependencies } = makeService();
    dependencies.transcriptionRepository.claim.mockResolvedValue({
      alreadyExists: true,
      runKey,
      run: { status: 'completed', segments: [{ startMs: 0, endMs: 1000, text: 'existing' }] },
      reason: 'completed',
    });

    await service.transcribeIfMissing(assetId, 'auto-interpret');

    expect(dependencies.client.transcribe).not.toHaveBeenCalled();
    expect(dependencies.transcriptionRepository.complete).not.toHaveBeenCalled();
    expect(dependencies.transcriptionRepository.fail).not.toHaveBeenCalled();
  });

  it('proceeds to reclaim a running run whose lease has expired', async () => {
    const { service, dependencies } = makeService({
      document: {
        schemaVersion: 2,
        runs: {
          [runKey]: {
            model: config.model,
            promptVersion: 'video-transcription-0.2.0',
            status: 'running',
            trigger: 'auto-interpret',
            requestedAt: '2026-11-11T00:00:00.000Z',
            startedAt: '2026-11-11T00:00:00.000Z',
            config: { language: '' },
            segments: [],
            lease: { ownerId: 'dead-worker', expiresAt: '2026-11-11T00:00:01.000Z' },
          },
        },
      },
    });

    await service.transcribeIfMissing(assetId, 'auto-interpret');

    expect(dependencies.transcriptionRepository.claim).toHaveBeenCalledTimes(1);
    expect(dependencies.client.transcribe).toHaveBeenCalledTimes(1);
  });

  it('returns the latest completed run without claiming when disabled', async () => {
    const { service, dependencies } = makeService();
    dependencies.configRepository.getEnv.mockReturnValue({ aiVideoTranscription: { ...config, enabled: false } });

    await service.transcribeIfMissing(assetId, 'auto-interpret');

    expect(dependencies.transcriptionRepository.claim).not.toHaveBeenCalled();
    expect(dependencies.client.transcribe).not.toHaveBeenCalled();
  });

  describe('legacy coverage assessment', () => {
    const legacyKey = createLegacyVideoTranscriptionRunKey(config.model, 'video-transcription-0.2.0');
    const legacyCompleted = (overrides: Partial<AiVideoTranscriptionRun> = {}): AiVideoTranscriptionRun => ({
      model: config.model,
      promptVersion: 'video-transcription-0.2.0',
      status: 'completed',
      trigger: 'auto-interpret',
      requestedAt: '2026-10-20T00:00:00.000Z',
      finishedAt: '2026-10-20T00:01:00.000Z',
      config: { language: '' },
      durationMs: 60_000,
      segments: [{ startMs: 0, endMs: 4000, text: 'hello world' }],
      ...overrides,
    });
    const legacyDocument = (run: AiVideoTranscriptionRun): AiVideoTranscriptionDocument => ({
      schemaVersion: 1,
      runs: { [legacyKey]: run },
    });

    it('reuses a trustworthy legacy full run without claiming or inferring', async () => {
      const { service, dependencies } = makeService({ document: legacyDocument(legacyCompleted()) });

      await service.transcribeIfMissing(assetId, 'auto-interpret');

      expect(dependencies.transcriptionRepository.claim).not.toHaveBeenCalled();
      expect(dependencies.client.transcribe).not.toHaveBeenCalled();
    });

    it('reuses a legacy no-speech outcome without claiming', async () => {
      const { service, dependencies } = makeService({
        document: legacyDocument(legacyCompleted({ noSpeech: true, segments: [] })),
      });

      await service.transcribeIfMissing(assetId, 'auto-interpret');

      expect(dependencies.transcriptionRepository.claim).not.toHaveBeenCalled();
      expect(dependencies.client.transcribe).not.toHaveBeenCalled();
    });

    it('schedules a chunked full run over a truncated legacy run', async () => {
      const { service, dependencies } = makeService({
        document: legacyDocument(legacyCompleted({ truncated: true })),
      });

      await service.transcribeIfMissing(assetId, 'auto-interpret');

      expect(dependencies.transcriptionRepository.claim).toHaveBeenCalledTimes(1);
      expect(dependencies.transcriptionRepository.claim.mock.calls[0][1].runKey).toBe(runKey);
      expect(dependencies.client.transcribe).toHaveBeenCalledTimes(1);
    });

    it('verifies a legacy no-audio outcome by probe without inference', async () => {
      const { service, dependencies } = makeService({
        probe: { format: { duration: 60 }, audioStreams: [] },
        document: legacyDocument(legacyCompleted({ noAudio: true, segments: [] })),
      });

      await service.transcribeIfMissing(assetId, 'auto-interpret');

      // The probe re-checks absence of audio; the sidecar is never invoked.
      expect(dependencies.mediaRepository.probe).toHaveBeenCalledTimes(1);
      expect(dependencies.client.transcribe).not.toHaveBeenCalled();
      expect(dependencies.transcriptionRepository.complete).toHaveBeenCalledWith(
        assetId,
        runKey,
        expect.objectContaining({ noAudio: true }),
      );
    });

    it('prefers reusing trustworthy legacy work over retrying a failed current run', async () => {
      const { service, dependencies } = makeService({
        document: {
          schemaVersion: 2,
          runs: {
            [runKey]: {
              model: config.model,
              promptVersion: 'video-transcription-0.2.0',
              status: 'failed',
              trigger: 'auto-interpret',
              requestedAt: '2026-11-11T00:00:00.000Z',
              finishedAt: '2026-11-11T00:00:05.000Z',
              config: { language: '' },
              segments: [],
              error: { code: 'network_error', message: 'sidecar unreachable' },
            },
            [legacyKey]: legacyCompleted(),
          },
        },
      });

      await service.transcribeIfMissing(assetId, 'auto-interpret');

      expect(dependencies.transcriptionRepository.claim).not.toHaveBeenCalled();
      expect(dependencies.client.transcribe).not.toHaveBeenCalled();
    });
  });
  describe('reconciliation sweep', () => {
    it('enqueues videos with no transcript document (missing work)', async () => {
      const { service, dependencies } = makeService();
      dependencies.assetJobRepository.streamForTranscriptionReconcile.mockReturnValue(streamOf([video('a1', null)]));

      expect(await reconcileSweep(service)).toBe(1);
      expect(dependencies.jobRepository.queue).toHaveBeenCalledWith({
        name: JobName.AssetTranscribeVideo,
        data: { id: 'a1', priority: 3, trigger: 'reconcile', force: false },
      });
    });

    it('enqueues abandoned runs (restart recovery: expired lease) but not live ones', async () => {
      const { service, dependencies } = makeService();
      dependencies.assetJobRepository.streamForTranscriptionReconcile.mockReturnValue(
        streamOf([
          video(
            'dead',
            doc({
              [runKey]: sweepRun({ status: 'running', lease: { ownerId: 'w', expiresAt: '2026-11-11T00:00:01.000Z' } }),
            }),
          ),
          video(
            'live',
            doc({
              [runKey]: sweepRun({ status: 'running', lease: { ownerId: 'w', expiresAt: '2099-01-01T00:00:00.000Z' } }),
            }),
          ),
        ]),
      );

      expect(await reconcileSweep(service)).toBe(1);
      expect(dependencies.jobRepository.queue).toHaveBeenCalledTimes(1);
      expect((dependencies.jobRepository.queue.mock.calls[0] as unknown[])[0]).toMatchObject({ data: { id: 'dead' } });
    });

    it('recovers lost jobs: stale queued rows re-enqueue with force, fresh ones wait', async () => {
      const { service, dependencies } = makeService();
      // Relative to the current clock: the 24h staleness gate must not age this fixture out.
      const stale = new Date(Date.now() - 7 * 24 * 60 * 60_000).toISOString();
      const fresh = new Date(Date.now() - 60 * 60_000).toISOString();
      dependencies.assetJobRepository.streamForTranscriptionReconcile.mockReturnValue(
        streamOf([
          video('stale', doc({ [runKey]: sweepRun({ status: 'queued', requestedAt: stale }) })),
          video('fresh', doc({ [runKey]: sweepRun({ status: 'queued', requestedAt: fresh }) })),
        ]),
      );

      expect(await reconcileSweep(service)).toBe(1);
      expect(dependencies.jobRepository.queue).toHaveBeenCalledWith({
        name: JobName.AssetTranscribeVideo,
        data: { id: 'stale', priority: 3, trigger: 'reconcile', force: true },
      });
    });

    it('never re-enqueues failed runs (operator retry) or trustworthy legacy coverage', async () => {
      const { service, dependencies } = makeService();
      const legacyKey = createLegacyVideoTranscriptionRunKey(config.model, 'video-transcription-0.2.0');
      dependencies.assetJobRepository.streamForTranscriptionReconcile.mockReturnValue(
        streamOf([
          video(
            'failed',
            doc({ [runKey]: sweepRun({ status: 'failed', error: { code: 'media_error', message: 'corrupt' } }) }),
          ),
          video(
            'legacy-ok',
            doc({
              [legacyKey]: {
                ...sweepRun({
                  status: 'completed',
                  finishedAt: '2026-11-01T00:00:00.000Z',
                  segments: [{ startMs: 0, endMs: 1, text: 'x' }],
                }),
              },
            }),
          ),
          video(
            'legacy-truncated',
            doc({
              [legacyKey]: {
                ...sweepRun({
                  status: 'completed',
                  finishedAt: '2026-11-01T00:00:00.000Z',
                  truncated: true,
                  segments: [{ startMs: 0, endMs: 1, text: 'x' }],
                }),
              },
            }),
          ),
        ]),
      );

      expect(await reconcileSweep(service)).toBe(1);
      expect((dependencies.jobRepository.queue.mock.calls[0] as unknown[])[0]).toMatchObject({
        data: { id: 'legacy-truncated' },
      });
    });

    it('bounds each sweep with an enqueue budget (repeated sweeps continue)', async () => {
      const { service, dependencies } = makeService();
      dependencies.assetJobRepository.streamForTranscriptionReconcile.mockReturnValue(
        streamOf([video('a1', null), video('a2', null), video('a3', null)]),
      );

      expect(await reconcileSweep(service, 2)).toBe(2);
      expect(dependencies.jobRepository.queue).toHaveBeenCalledTimes(2);
    });

    it('treats unparseable transcript metadata as work needing verification', async () => {
      const { service, dependencies } = makeService();
      dependencies.assetJobRepository.streamForTranscriptionReconcile.mockReturnValue(
        streamOf([video('broken', { not: 'a document' })]),
      );

      expect(await reconcileSweep(service)).toBe(1);
    });

    it('skips the sweep entirely when disabled', async () => {
      const { service, dependencies } = makeService();
      dependencies.configRepository.getEnv.mockReturnValue({ aiVideoTranscription: { ...config, enabled: false } });

      expect(await service.handleReconcile()).toBe(JobStatus.Skipped);
      expect(dependencies.assetJobRepository.streamForTranscriptionReconcile).not.toHaveBeenCalled();
    });

    it('forced delivery reclaims a stale queued row through the atomic claim', async () => {
      const { service, dependencies } = makeService({
        document: doc({ [runKey]: sweepRun({ status: 'queued', requestedAt: '2026-11-01T00:00:00.000Z' }) }),
      });

      const status = await service.handleTranscribeVideo({ id: assetId, trigger: 'reconcile', force: true });

      expect(status).toBe(JobStatus.Success);
      expect(dependencies.transcriptionRepository.claim).toHaveBeenCalledTimes(1);
    });
  });
});
