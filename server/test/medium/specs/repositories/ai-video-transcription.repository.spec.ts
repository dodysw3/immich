import { AssetMetadataKey, AssetType } from 'src/enum.js';
import { AiVideoTranscriptionRepository } from 'src/repositories/ai-video-transcription.repository.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';
import { BaseService } from 'src/services/base.service.js';
import { newMediumService } from 'test/medium.factory.js';
import { getKyselyDB } from 'test/utils.js';

const rawRunKey = 'a'.repeat(64);
const isolatedRunKey = 'b'.repeat(64);
const retryableBefore = '2026-11-19T00:00:00.000Z';

const setup = async () => {
  const db = await getKyselyDB();
  const { ctx } = newMediumService(BaseService, {
    database: db,
    real: [],
    mock: [LoggingRepository],
  });
  return { ctx, sut: new AiVideoTranscriptionRepository(db) };
};

const rawRun = (overrides: Record<string, unknown> = {}) => ({
  model: 'faster-whisper-large-v3',
  promptVersion: 'video-transcription-0.2.0',
  status: 'completed',
  trigger: 'upload',
  requestedAt: '2026-11-12T00:00:00.000Z',
  finishedAt: '2026-11-12T00:01:00.000Z',
  config: { language: '' },
  segments: [{ startMs: 0, endMs: 1000, text: 'hello' }],
  ...overrides,
});

const isolatedRun = (overrides: Record<string, unknown> = {}) => ({
  ...rawRun(),
  producer: { voiceIsolation: 'inworld-voice-isolator-v1' },
  voiceIsolation: { accepted: false },
  ...overrides,
});

describe(AiVideoTranscriptionRepository.name, () => {
  it('selects completed audio-bearing raw runs without a completed isolated run', async () => {
    const { ctx, sut } = await setup();
    const { user } = await ctx.newUser();

    const create = async (
      runs: Record<string, unknown>,
      overrides: { type?: AssetType; deletedAt?: Date } = {},
    ): Promise<string> => {
      const { asset } = await ctx.newAsset({
        ownerId: user.id,
        type: overrides.type ?? AssetType.Video,
        ...(overrides.deletedAt !== undefined && { deletedAt: overrides.deletedAt }),
      });
      await ctx.newMetadata({
        assetId: asset.id,
        key: AssetMetadataKey.VideoTranscriptsV1,
        value: { schemaVersion: 2, runs },
      });
      return asset.id;
    };

    const eligible = await create({ [rawRunKey]: rawRun() });
    await create({ [rawRunKey]: rawRun(), [isolatedRunKey]: isolatedRun({ status: 'completed' }) });
    await create({
      [rawRunKey]: rawRun(),
      [isolatedRunKey]: isolatedRun({ status: 'failed', finishedAt: '2026-11-20T00:00:00.000Z' }),
    });
    const retryable = await create({
      [rawRunKey]: rawRun(),
      [isolatedRunKey]: isolatedRun({ status: 'failed', finishedAt: '2026-11-01T00:00:00.000Z' }),
    });
    await create({ [rawRunKey]: rawRun({ status: 'queued' }) });
    await create({ [rawRunKey]: rawRun({ noAudio: true }) });
    await create({ [rawRunKey]: rawRun(), [isolatedRunKey]: isolatedRun({ status: 'queued' }) });
    await create({
      [rawRunKey]: rawRun(),
      [isolatedRunKey]: isolatedRun({
        status: 'running',
        lease: { ownerId: 'worker', expiresAt: '2026-11-21T00:00:00.000Z' },
      }),
    });
    const inlineDeferred = await create({
      [rawRunKey]: rawRun(),
      [isolatedRunKey]: isolatedRun({ status: 'running' }),
    });
    await create({ [rawRunKey]: rawRun() }, { type: AssetType.Image });
    await create({ [rawRunKey]: rawRun() }, { deletedAt: new Date('2026-11-18T00:00:00.000Z') });

    // Audio-event metadata rides along for the gate, without a second query.
    await ctx.newMetadata({
      assetId: eligible,
      key: AssetMetadataKey.VideoAudioEventsV1,
      value: {
        schemaVersion: 1,
        runs: {
          ['c'.repeat(64)]: {
            model: 'yamnet',
            promptVersion: 'video-audio-events-0.1.0',
            status: 'completed',
            trigger: 'auto-interpret',
            requestedAt: '2026-11-12T00:00:00.000Z',
            config: { threshold: 0.15 },
            events: [{ mid: '/m/09x0r', label: 'Speech', score: 0.9, startMs: 0, endMs: 2000 }],
          },
        },
      },
    });

    const candidates = await sut.streamVoiceIsolationCandidates({
      rawRunKey,
      isolatedRunKey,
      limit: 50,
      retryableBefore,
    });

    expect(candidates.map((candidate) => candidate.id).sort()).toEqual([eligible, retryable, inlineDeferred].sort());
    expect(candidates.find((candidate) => candidate.id === eligible)?.audioEventsValue).toMatchObject({
      runs: { ['c'.repeat(64)]: { events: [{ mid: '/m/09x0r' }] } },
    });

    // Keyset pagination: a bounded first page resumes strictly after its last id.
    const firstPage = await sut.streamVoiceIsolationCandidates({
      rawRunKey,
      isolatedRunKey,
      limit: 1,
      retryableBefore,
    });
    expect(firstPage).toHaveLength(1);
    const secondPage = await sut.streamVoiceIsolationCandidates({
      rawRunKey,
      isolatedRunKey,
      limit: 50,
      afterId: firstPage[0].id,
      retryableBefore,
    });
    expect(secondPage.map((candidate) => candidate.id)).toEqual(
      [eligible, retryable, inlineDeferred].filter((id) => id > firstPage[0].id).sort(),
    );
  });

  it('counts stored and effective isolated runs separately from raw coverage', async () => {
    const { ctx, sut } = await setup();
    const { user } = await ctx.newUser();

    const create = async (runs: Record<string, unknown>): Promise<string> => {
      const { asset } = await ctx.newAsset({ ownerId: user.id, type: AssetType.Video });
      await ctx.newMetadata({
        assetId: asset.id,
        key: AssetMetadataKey.VideoTranscriptsV1,
        value: { schemaVersion: 2, runs },
      });
      return asset.id;
    };

    await create({ [rawRunKey]: rawRun(), [isolatedRunKey]: isolatedRun({ voiceIsolation: { accepted: true } }) });
    await create({ [rawRunKey]: rawRun(), [isolatedRunKey]: isolatedRun({ voiceIsolation: { accepted: false } }) });
    await create({ [rawRunKey]: rawRun() });
    // A queued isolated run is neither stored nor effective yet.
    await create({ [rawRunKey]: rawRun(), [isolatedRunKey]: isolatedRun({ status: 'running' }) });

    const enabled = await sut.getCoverageCounts(rawRunKey, 'legacy', 0, {
      isolatedRunKey,
      voiceIsolationEnabled: true,
    });
    expect(enabled.isolated).toEqual({ stored: 2, effective: 1 });

    // Kill switch: stored runs remain, none are served.
    const disabled = await sut.getCoverageCounts(rawRunKey, 'legacy', 0, {
      isolatedRunKey,
      voiceIsolationEnabled: false,
    });
    expect(disabled.isolated).toEqual({ stored: 2, effective: 0 });
  });
});
