import { describe, expect, it, vi } from 'vitest';
import { AiVideoTranscriptionDocument, AiVideoTranscriptionRun } from 'src/dtos/ai-video-transcription.dto.js';
import { JobStatus } from 'src/enum.js';
import { TranscriptIndexService } from 'src/services/transcript-index.service.js';
import {
  AI_VIDEO_TRANSCRIPTION_COVERAGE_POLICY,
  AI_VIDEO_TRANSCRIPTION_PRODUCER_VERSION,
  createTranscriptionRevision,
  createVideoTranscriptionRunKey,
} from 'src/utils/ai-video-transcription.js';
import { TRANSCRIPT_INDEX_VERSION } from 'src/utils/transcript-index.js';

const runKey = createVideoTranscriptionRunKey({
  model: 'faster-whisper-large-v3',
  producerVersion: AI_VIDEO_TRANSCRIPTION_PRODUCER_VERSION,
  language: '',
  coveragePolicy: AI_VIDEO_TRANSCRIPTION_COVERAGE_POLICY,
});

const completedRun = (overrides: Partial<AiVideoTranscriptionRun> = {}): AiVideoTranscriptionRun => ({
  model: 'faster-whisper-large-v3',
  promptVersion: 'video-transcription-0.2.0',
  status: 'completed',
  trigger: 'upload',
  requestedAt: '2026-11-12T00:00:00.000Z',
  finishedAt: '2026-11-12T00:01:00.000Z',
  config: { language: '' },
  durationMs: 10_000,
  targetDurationMs: 10_000,
  coverage: { intervals: [{ startMs: 0, endMs: 10_000 }] },
  segments: [
    { startMs: 0, endMs: 4000, text: 'satu dua' },
    { startMs: 4500, endMs: 9000, text: 'tiga empat' },
  ],
  revision: createTranscriptionRevision({
    segments: [
      { startMs: 0, endMs: 4000, text: 'satu dua' },
      { startMs: 4500, endMs: 9000, text: 'tiga empat' },
    ],
    noAudio: false,
    noSpeech: false,
  }),
  producer: {
    service: 'faster-whisper-sidecar',
    model: 'faster-whisper-large-v3',
    producerVersion: AI_VIDEO_TRANSCRIPTION_PRODUCER_VERSION,
    language: '',
    coveragePolicy: AI_VIDEO_TRANSCRIPTION_COVERAGE_POLICY,
  },
  ...overrides,
});

const document = (run: AiVideoTranscriptionRun): AiVideoTranscriptionDocument => ({
  schemaVersion: 2,
  runs: { [runKey]: run },
});

const makeService = (
  options: {
    document?: AiVideoTranscriptionDocument | null;
    state?: Record<string, unknown> | null;
    stream?: Array<Record<string, unknown>>;
  } = {},
) => {
  const dependencies = {
    logger: { setContext: vi.fn(), debug: vi.fn(), log: vi.fn(), warn: vi.fn() },
    configRepository: {
      getEnv: vi
        .fn()
        .mockReturnValue({ aiVideoTranscription: { enabled: true, model: 'faster-whisper-large-v3', language: '' } }),
    },
    jobRepository: { queue: vi.fn(() => Promise.resolve()) },
    assetJobRepository: {
      streamForTranscriptIndexReconcile: vi.fn().mockReturnValue(
        (function* () {
          for (const row of options.stream ?? []) {
            yield row;
          }
        })(),
      ),
    },
    indexRepository: {
      getState: vi.fn().mockResolvedValue(options.state ?? null),
      replacePassages: vi.fn(() => Promise.resolve()),
      markFailed: vi.fn(() => Promise.resolve()),
    },
    transcriptionRepository: { get: vi.fn().mockResolvedValue(options.document ?? null) },
  };
  // Structural no-inference guarantee: the indexer has no sidecar/whisper client at all.
  const service = new TranscriptIndexService(
    dependencies.logger as never,
    dependencies.configRepository as never,
    dependencies.jobRepository as never,
    dependencies.assetJobRepository as never,
    dependencies.indexRepository as never,
    dependencies.transcriptionRepository as never,
  );
  return { service, dependencies };
};

describe(TranscriptIndexService.name, () => {
  it('indexes an existing completed transcript without any inference', async () => {
    const { service, dependencies } = makeService({ document: document(completedRun()) });

    expect(await service.syncAsset('asset-1')).toBe(true);

    expect(dependencies.indexRepository.replacePassages).toHaveBeenCalledTimes(1);
    const [assetId, replace] = dependencies.indexRepository.replacePassages.mock.calls[0] as unknown as [
      string,
      {
        revision: string;
        runKey: string;
        coverageState: string;
        passages: Array<{ windowId: string; text: string; tokens: string[] }>;
      },
    ];
    expect(assetId).toBe('asset-1');
    expect(replace.revision).toBe(completedRun().revision);
    expect(replace.runKey).toBe(runKey);
    expect(replace.coverageState).toBe('complete');
    // Windows: single segments plus the adjacent pair (gap 500ms ≤ 2s, span ≤ 30s).
    expect(replace.passages.map((passage) => passage.windowId)).toEqual(['0:0', '0:1', '1:1']);
    expect(replace.passages[0]!.tokens).toEqual(['satu', 'dua']);
  });

  it('indexes a legacy partial transcript with a computed revision and no Whisper', async () => {
    const legacy = completedRun({ truncated: true, revision: undefined });
    const { service, dependencies } = makeService({ document: document(legacy) });

    expect(await service.syncAsset('asset-1')).toBe(true);

    const [, replace] = dependencies.indexRepository.replacePassages.mock.calls[0] as unknown as [
      string,
      { revision: string; coverageState: string },
    ];
    expect(replace.coverageState).toBe('partial');
    expect(replace.revision).toBe(createTranscriptionRevision(legacy));
  });

  it('skips re-indexing when the revision and index version are current', async () => {
    const run = completedRun();
    const { service, dependencies } = makeService({
      document: document(run),
      state: {
        assetId: 'asset-1',
        revision: run.revision,
        indexVersion: TRANSCRIPT_INDEX_VERSION,
        error: null,
      },
    });

    expect(await service.syncAsset('asset-1')).toBe(true);
    expect(dependencies.indexRepository.replacePassages).not.toHaveBeenCalled();
  });

  it('re-indexes when the revision changed under the same runKey', async () => {
    const run = completedRun();
    const { service, dependencies } = makeService({
      document: document(run),
      state: {
        assetId: 'asset-1',
        revision: '0'.repeat(64),
        indexVersion: TRANSCRIPT_INDEX_VERSION,
        error: null,
      },
    });

    expect(await service.syncAsset('asset-1')).toBe(true);
    expect(dependencies.indexRepository.replacePassages).toHaveBeenCalledTimes(1);
  });

  it('records indexing failures and preserves the source metadata', async () => {
    const { service, dependencies } = makeService({ document: document(completedRun()) });
    dependencies.indexRepository.replacePassages.mockRejectedValue(new Error('disk full'));

    await expect(service.syncAsset('asset-1')).rejects.toThrow('disk full');

    expect(dependencies.indexRepository.markFailed).toHaveBeenCalledWith(
      'asset-1',
      runKey,
      TRANSCRIPT_INDEX_VERSION,
      'disk full',
    );
    // Source transcript document untouched: only the derived state row records the error.
    expect(dependencies.transcriptionRepository.get).toHaveBeenCalledTimes(1);
  });

  it('returns false when there is no usable completed run', async () => {
    const { service, dependencies } = makeService({ document: null });

    expect(await service.syncAsset('asset-1')).toBe(false);
    expect(dependencies.indexRepository.replacePassages).not.toHaveBeenCalled();
  });

  it('reconciles missing, stale and failed rows but not current ones', async () => {
    const run = completedRun();
    const { service, dependencies } = makeService({
      stream: [
        {
          assetId: 'missing',
          transcriptValue: document(run),
          indexedRevision: null,
          indexedVersion: null,
          indexedError: null,
        },
        {
          assetId: 'stale-revision',
          transcriptValue: document(run),
          indexedRevision: '0'.repeat(64),
          indexedVersion: TRANSCRIPT_INDEX_VERSION,
          indexedError: null,
        },
        {
          assetId: 'failed',
          transcriptValue: document(run),
          indexedRevision: run.revision,
          indexedVersion: TRANSCRIPT_INDEX_VERSION,
          indexedError: 'boom',
        },
        {
          assetId: 'current',
          transcriptValue: document(run),
          indexedRevision: run.revision,
          indexedVersion: TRANSCRIPT_INDEX_VERSION,
          indexedError: null,
        },
      ],
    });

    await service.handleReconcile();

    const queued = dependencies.jobRepository.queue.mock.calls.map(
      (call: unknown[]) => (call[0] as { data: { id: string } }).data.id,
    );
    expect(queued).toEqual(['missing', 'stale-revision', 'failed']);
  });

  it('skips the reconcile sweep when disabled', async () => {
    const { service, dependencies } = makeService();
    dependencies.configRepository.getEnv.mockReturnValue({
      aiVideoTranscription: { enabled: false, model: 'faster-whisper-large-v3', language: '' },
    });

    expect(await service.handleReconcile()).toBe(JobStatus.Skipped);
    expect(dependencies.assetJobRepository.streamForTranscriptIndexReconcile).not.toHaveBeenCalled();
  });
});
