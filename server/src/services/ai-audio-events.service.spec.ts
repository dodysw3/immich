import { writeFileSync } from 'node:fs';
import { join } from 'node:path';
import { describe, expect, it, vi } from 'vitest';
import { AiAudioEventsDocument, AiAudioEventsDocumentSchema, AiAudioEventsRun } from 'src/dtos/ai-audio-events.dto.js';
import { AiVideoTranscriptionDocument } from 'src/dtos/ai-video-transcription.dto.js';
import { AssetType } from 'src/enum.js';
import { AiAudioEventsRepository } from 'src/repositories/ai-audio-events.repository.js';
import { AiVideoTranscriptionRepository } from 'src/repositories/ai-video-transcription.repository.js';
import { AiAudioEventsClientError, AiAudioEventsTagResponse } from 'src/services/ai-audio-events.client.js';
import { AiAudioEventsService } from 'src/services/ai-audio-events.service.js';
import {
  AI_AUDIO_EVENTS_MODEL,
  AI_AUDIO_EVENTS_PROMPT_VERSION,
  createAudioEventsRunKey,
} from 'src/utils/ai-audio-events.js';

const assetId = 'asset-1';
const config = {
  enabled: true,
  url: 'http://host.docker.internal:51906',
  threshold: 0.15,
  maxDurationSec: 300,
  timeoutMs: 60_000,
};
const runKey = createAudioEventsRunKey(AI_AUDIO_EVENTS_MODEL, { threshold: 0.15 }, AI_AUDIO_EVENTS_PROMPT_VERSION);

// YAMNet class indices (see constants/audioset-class-map.ts)
const SPEECH = 0;
const CHILD_SPEECH = 1;
const BEEP = 475;

// The bench car video: beep frames at 4.8 s / 5.28 s over speech.
const carResponse = (): AiAudioEventsTagResponse => ({
  durationMs: 14_805,
  windowMs: 960,
  frameCount: 30,
  inferMs: 32,
  frames: [
    { t: 3840, hits: [{ classIndex: SPEECH, score: 0.37 }] },
    { t: 4800, hits: [{ classIndex: BEEP, score: 0.2429 }] },
    { t: 5280, hits: [{ classIndex: BEEP, score: 0.1396 }] },
    {
      t: 6240,
      hits: [
        { classIndex: SPEECH, score: 0.9 },
        { classIndex: CHILD_SPEECH, score: 0.4 },
      ],
    },
  ],
});

// In-memory stand-in for the jsonb document, with the repository's own
// transition rules and its real (pure) latest-completed-run picker. Every
// write re-validates the whole document like the real repository's reads do.
const makeEventsRepository = (initial: AiAudioEventsDocument | null = null) => {
  let document = initial;
  const update = (key: string, fn: (run: AiAudioEventsRun) => AiAudioEventsRun | undefined) => {
    const current = document?.runs[key];
    const next = current ? fn(current) : undefined;
    if (document && next) {
      document = AiAudioEventsDocumentSchema.parse({ ...document, runs: { ...document.runs, [key]: next } });
    }
    return !!next;
  };
  return {
    document: () => document,
    get: vi.fn(() => Promise.resolve(document)),
    findLatestCompletedRun: vi.fn((doc: AiAudioEventsDocument) =>
      AiAudioEventsRepository.prototype.findLatestCompletedRun.call(null, doc),
    ),
    claim: vi.fn((_assetId: string, identity: Parameters<AiAudioEventsRepository['claim']>[1]) => {
      const run: AiAudioEventsRun = {
        model: identity.model,
        promptVersion: identity.promptVersion,
        status: 'queued',
        trigger: identity.trigger,
        requestedAt: new Date().toISOString(),
        config: identity.config,
        durationMs: identity.durationMs,
        events: [],
      };
      document = AiAudioEventsDocumentSchema.parse({
        schemaVersion: 1,
        runs: { ...document?.runs, [identity.runKey]: run },
      });
      return Promise.resolve(run);
    }),
    transitionToRunning: vi.fn((_assetId: string, key: string) =>
      Promise.resolve(
        update(key, (run) =>
          run.status === 'queued' ? { ...run, status: 'running', startedAt: new Date().toISOString() } : undefined,
        ),
      ),
    ),
    appendEvents: vi.fn((_assetId: string, key: string, events: AiAudioEventsRun['events']) => {
      update(key, (run) => ({ ...run, events: [...run.events, ...events] }));
      return Promise.resolve();
    }),
    complete: vi.fn((_assetId: string, key: string, options: Partial<AiAudioEventsRun>) =>
      Promise.resolve(
        update(key, (run) =>
          run.status === 'running'
            ? { ...run, ...options, status: 'completed', finishedAt: new Date().toISOString() }
            : undefined,
        ),
      ),
    ),
    fail: vi.fn((_assetId: string, key: string, error: AiAudioEventsRun['error']) => {
      update(key, (run) =>
        run.status === 'completed' || run.status === 'failed'
          ? undefined
          : { ...run, status: 'failed', finishedAt: new Date().toISOString(), error },
      );
      return Promise.resolve();
    }),
  };
};

const transcriptDocument = (run: { segments: unknown[]; noSpeech?: boolean }): AiVideoTranscriptionDocument =>
  ({
    schemaVersion: 1,
    runs: {
      ['b'.repeat(64)]: {
        model: 'faster-whisper-large-v3',
        promptVersion: 'video-transcription-0.2.0',
        status: 'completed',
        trigger: 'auto-interpret',
        requestedAt: '2026-11-10T00:00:00.000Z',
        finishedAt: '2026-11-10T00:00:05.000Z',
        config: { language: '' },
        ...run,
      },
    },
  }) as never;

const storedRun = (overrides: Partial<AiAudioEventsRun>) => ({
  model: AI_AUDIO_EVENTS_MODEL,
  promptVersion: AI_AUDIO_EVENTS_PROMPT_VERSION,
  status: 'completed',
  trigger: 'auto-interpret',
  requestedAt: '2026-11-10T00:00:00.000Z',
  config: { threshold: 0.15 },
  events: [],
  ...overrides,
});

const makeService = (
  options: { document?: AiAudioEventsDocument | null; transcript?: AiVideoTranscriptionDocument } = {},
) => {
  const eventsRepository = makeEventsRepository(options.document ?? null);
  const dependencies = {
    logger: { setContext: vi.fn(), debug: vi.fn(), log: vi.fn(), warn: vi.fn() },
    configRepository: { getEnv: vi.fn().mockReturnValue({ aiAudioEvents: config }) },
    assetRepository: {
      getByIds: vi.fn().mockResolvedValue([{ id: assetId, type: AssetType.Video, originalPath: '/media/car.mp4' }]),
    },
    mediaRepository: {
      probe: vi.fn().mockResolvedValue({ format: { duration: 14.805 }, audioStreams: [{ index: 1 }] }),
      // writes into the service's own temp dir, which it removes afterwards
      extractVideoAudio: vi.fn((_input: string, outputDir: string) => {
        const path = join(outputDir, 'audio.wav');
        writeFileSync(path, Buffer.from('RIFF....WAVEfmt '));
        return Promise.resolve(path);
      }),
    },
    eventsRepository,
    transcriptionRepository: {
      get: vi.fn().mockResolvedValue(options.transcript ?? null),
      findLatestCompletedRun: vi.fn((doc: AiVideoTranscriptionDocument) =>
        AiVideoTranscriptionRepository.prototype.findLatestCompletedRun.call(null, doc),
      ),
    },
    client: { tag: vi.fn().mockResolvedValue(carResponse()) },
  };
  const service = new AiAudioEventsService(
    dependencies.logger as never,
    dependencies.configRepository as never,
    dependencies.assetRepository as never,
    dependencies.mediaRepository as never,
    dependencies.eventsRepository as never,
    dependencies.transcriptionRepository as never,
    dependencies.client as never,
  );
  return { service, dependencies };
};

describe(AiAudioEventsService.name, () => {
  it('tags a video, stores the assembled events, and records the trigger', async () => {
    const { service, dependencies } = makeService();

    const run = await service.tagIfMissing(assetId, 'auto-interpret');

    expect(dependencies.client.tag).toHaveBeenCalledTimes(1);
    expect(dependencies.mediaRepository.extractVideoAudio).toHaveBeenCalledWith('/media/car.mp4', expect.any(String), {
      durationSec: 14.805,
    });
    expect(run).toMatchObject({
      status: 'completed',
      trigger: 'auto-interpret',
      model: AI_AUDIO_EVENTS_MODEL,
      promptVersion: AI_AUDIO_EVENTS_PROMPT_VERSION,
      config: { threshold: 0.15 },
      durationMs: 14_805,
      speechSuppressed: false,
      truncated: false,
      metrics: { inferMs: 32, frameCount: 30 },
    });
    expect(run!.events.map(({ label, startMs, endMs }) => ({ label, startMs, endMs }))).toEqual([
      { label: 'Speech', startMs: 3360, endMs: 4320 },
      { label: 'Beep, bleep', startMs: 4320, endMs: 5280 },
      { label: 'Speech', startMs: 5760, endMs: 6720 },
      { label: 'Child speech, kid speaking', startMs: 5760, endMs: 6720 },
    ]);
    expect(Object.keys(dependencies.eventsRepository.document()!.runs)).toEqual([runKey]);
  });

  it('reuses a completed run for the current identity without calling the sidecar', async () => {
    const { service, dependencies } = makeService();
    await service.tagIfMissing(assetId, 'auto-interpret');
    dependencies.client.tag.mockClear();
    dependencies.mediaRepository.extractVideoAudio.mockClear();

    const run = await service.tagIfMissing(assetId, 'auto-interpret');

    expect(run?.status).toBe('completed');
    expect(dependencies.client.tag).not.toHaveBeenCalled();
    expect(dependencies.mediaRepository.extractVideoAudio).not.toHaveBeenCalled();
    expect(dependencies.eventsRepository.claim).toHaveBeenCalledTimes(1);
  });

  it('does not double-claim a run another delivery is still producing', async () => {
    const { service, dependencies } = makeService({
      document: {
        schemaVersion: 1,
        runs: {
          [runKey]: {
            model: AI_AUDIO_EVENTS_MODEL,
            promptVersion: AI_AUDIO_EVENTS_PROMPT_VERSION,
            status: 'running',
            trigger: 'auto-interpret',
            requestedAt: '2026-11-10T00:00:00.000Z',
            config: { threshold: 0.15 },
            events: [],
          },
        },
      },
    });

    await expect(service.tagIfMissing(assetId, 'auto-interpret')).resolves.toBeUndefined();
    expect(dependencies.eventsRepository.claim).not.toHaveBeenCalled();
    expect(dependencies.client.tag).not.toHaveBeenCalled();
  });

  it('forks a new run when the threshold changes and keeps the prior run', async () => {
    const { service, dependencies } = makeService();
    await service.tagIfMissing(assetId, 'auto-interpret');
    dependencies.configRepository.getEnv.mockReturnValue({ aiAudioEvents: { ...config, threshold: 0.2 } });

    const run = await service.tagIfMissing(assetId, 'auto-interpret');

    const runs = dependencies.eventsRepository.document()!.runs;
    expect(Object.keys(runs)).toHaveLength(2);
    expect(runs[runKey].status).toBe('completed');
    expect(run?.config.threshold).toBe(0.2);
    // 0.1396 beep frame falls below the new threshold; 0.2429 survives
    expect(run?.events.find((event) => event.label === 'Beep, bleep')).toMatchObject({ startMs: 4320, endMs: 5280 });
  });

  it('returns the current identity run, not a more recent run of another identity', async () => {
    const { service, dependencies } = makeService();
    await service.tagIfMissing(assetId, 'auto-interpret'); // threshold 0.15
    dependencies.configRepository.getEnv.mockReturnValue({ aiAudioEvents: { ...config, threshold: 0.2 } });
    await service.tagIfMissing(assetId, 'auto-interpret'); // threshold 0.2, finished later
    dependencies.configRepository.getEnv.mockReturnValue({ aiAudioEvents: config });
    dependencies.client.tag.mockClear();

    const run = await service.tagIfMissing(assetId, 'auto-interpret'); // back to 0.15

    expect(run?.config.threshold).toBe(0.15);
    expect(dependencies.client.tag).not.toHaveBeenCalled();
  });

  it('records a failed run and never throws when the sidecar is down', async () => {
    const { service, dependencies } = makeService();
    dependencies.client.tag.mockRejectedValue(new AiAudioEventsClientError('network_error', 'connection refused'));

    await expect(service.tagIfMissing(assetId, 'auto-interpret')).resolves.toBeUndefined();

    expect(dependencies.eventsRepository.document()!.runs[runKey]).toMatchObject({
      status: 'failed',
      error: { code: 'network_error', message: 'connection refused' },
    });
    expect(dependencies.logger.warn).toHaveBeenCalled();
  });

  it('retries a failed run on the next delivery', async () => {
    const { service, dependencies } = makeService();
    dependencies.client.tag.mockRejectedValueOnce(new AiAudioEventsClientError('timeout', 'timed out'));
    await service.tagIfMissing(assetId, 'auto-interpret');

    const run = await service.tagIfMissing(assetId, 'auto-interpret');

    expect(run?.status).toBe('completed');
    expect(dependencies.client.tag).toHaveBeenCalledTimes(2);
  });

  it('stores a completed empty run for a silent video', async () => {
    const { service, dependencies } = makeService();
    dependencies.client.tag.mockResolvedValue({
      ...carResponse(),
      frames: [{ t: 480, hits: [{ classIndex: BEEP, score: 0.06 }] }],
    });

    const run = await service.tagIfMissing(assetId, 'auto-interpret');

    expect(run).toMatchObject({ status: 'completed', events: [] });
    expect(dependencies.eventsRepository.appendEvents).not.toHaveBeenCalled();
  });

  it('documents a video without an audio stream as noAudio without calling the sidecar', async () => {
    const { service, dependencies } = makeService();
    dependencies.mediaRepository.probe.mockResolvedValue({ format: { duration: 10 }, audioStreams: [] });

    const run = await service.tagIfMissing(assetId, 'auto-interpret');

    expect(run).toMatchObject({ status: 'completed', noAudio: true, events: [] });
    expect(dependencies.client.tag).not.toHaveBeenCalled();
  });

  it('drops speech-family events when the transcript has segments', async () => {
    const { service } = makeService({
      transcript: transcriptDocument({ segments: [{ startMs: 0, endMs: 3000, text: 'habis ngisi bensin' }] }),
    });

    const run = await service.tagIfMissing(assetId, 'auto-interpret');

    expect(run?.events.map((event) => event.label)).toEqual(['Beep, bleep']);
    expect(run?.speechSuppressed).toBe(true);
  });

  it('keeps speech-family events as presence evidence when the transcript found no speech', async () => {
    const { service } = makeService({ transcript: transcriptDocument({ segments: [], noSpeech: true }) });

    const run = await service.tagIfMissing(assetId, 'auto-interpret');

    expect(run?.events.map((event) => event.label)).toContain('Child speech, kid speaking');
    expect(run?.speechSuppressed).toBe(false);
  });

  it('caps the tagged audio at maxDurationSec and flags the run as truncated', async () => {
    const { service, dependencies } = makeService();
    dependencies.configRepository.getEnv.mockReturnValue({ aiAudioEvents: { ...config, maxDurationSec: 10 } });

    const run = await service.tagIfMissing(assetId, 'auto-interpret');

    expect(dependencies.mediaRepository.extractVideoAudio).toHaveBeenCalledWith(
      expect.any(String),
      expect.any(String),
      {
        durationSec: 10,
      },
    );
    expect(run?.truncated).toBe(true);
  });

  it('ignores non-video assets', async () => {
    const { service, dependencies } = makeService();
    dependencies.assetRepository.getByIds.mockResolvedValue([{ id: assetId, type: AssetType.Image }]);

    await expect(service.tagIfMissing(assetId, 'auto-interpret')).resolves.toBeUndefined();
    expect(dependencies.mediaRepository.probe).not.toHaveBeenCalled();
  });

  it('does no tagging work when the feature is disabled', async () => {
    const { service, dependencies } = makeService();
    dependencies.configRepository.getEnv.mockReturnValue({ aiAudioEvents: { ...config, enabled: false } });

    await expect(service.tagIfMissing(assetId, 'auto-interpret')).resolves.toBeUndefined();
    expect(dependencies.assetRepository.getByIds).not.toHaveBeenCalled();
    expect(dependencies.client.tag).not.toHaveBeenCalled();
    expect(dependencies.eventsRepository.claim).not.toHaveBeenCalled();
  });

  describe('run document schema', () => {
    it('accepts a completed run with zero events (a silent video)', () => {
      expect(
        AiAudioEventsDocumentSchema.safeParse({ schemaVersion: 1, runs: { [runKey]: storedRun({}) } }).success,
      ).toBe(true);
    });

    it('rejects a failed run without an error', () => {
      expect(
        AiAudioEventsDocumentSchema.safeParse({ schemaVersion: 1, runs: { [runKey]: storedRun({ status: 'failed' }) } })
          .success,
      ).toBe(false);
    });
  });
});
