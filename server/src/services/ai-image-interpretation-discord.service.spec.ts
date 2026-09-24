import { UnrecoverableError } from 'bullmq';
import { AiInterpretationDocument, MuseInterpretationResult } from 'src/dtos/ai-image-interpretation.dto.js';
import { AssetFileType, JobStatus, QueueName } from 'src/enum.js';
import { AiImageInterpretationRepository } from 'src/repositories/ai-image-interpretation.repository.js';
import { AssetJobRepository } from 'src/repositories/asset-job.repository.js';
import { ConfigRepository } from 'src/repositories/config.repository.js';
import { JobRepository } from 'src/repositories/job.repository.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';
import { StorageRepository } from 'src/repositories/storage.repository.js';
import { SystemMetadataRepository } from 'src/repositories/system-metadata.repository.js';
import { UserRepository } from 'src/repositories/user.repository.js';
import {
  AiImageInterpretationDiscordClient,
  AiInterpretationDiscordAlertError,
} from 'src/services/ai-image-interpretation-discord.client.js';
import { AiImageInterpretationDiscordService } from 'src/services/ai-image-interpretation-discord.service.js';

const runKey = 'a'.repeat(64);
const result: MuseInterpretationResult = {
  title: 'A quiet platform',
  literal_description: '',
  visual_analysis: '',
  interpretation: 'The image suggests anticipation.',
  context_and_significance: '',
  notable_details: [],
  identifications: [],
  alternative_interpretations: [],
  uncertainties: [],
  archive_summary: 'A traveler waits on a quiet station platform.',
  search_keywords: [],
};

const completedDocument = {
  schemaVersion: 1,
  runs: {
    [runKey]: {
      model: 'model',
      quant: 'quant',
      promptVersion: 'prompt',
      status: 'completed',
      trigger: 'upload',
      requestedAt: '2026-09-12T11:00:00.000Z',
      finishedAt: '2026-09-12T12:00:00.000Z',
      result,
    },
  },
} satisfies AiInterpretationDocument;

const alertAsset = {
  id: 'asset-1',
  ownerId: 'owner-1',
  originalFileName: 'IMG_1234.JPG',
  localDateTime: new Date('2026-09-13T12:10:59.000Z'),
  dateTimeOriginal: new Date('2026-09-13T12:10:59.000Z'),
  timeZone: null,
  files: [{ id: 'thumbnail', type: AssetFileType.Thumbnail, path: '/data/thumbs/photo.webp', isEdited: false }],
};

const makeService = () => {
  const dependencies = {
    logger: { setContext: vi.fn(), log: vi.fn(), warn: vi.fn() },
    configRepository: {
      getEnv: vi.fn().mockReturnValue({
        aiImageInterpretation: {
          discord: { webhookUrl: 'https://discord.com/api/webhooks/123/token', includeThumbnail: true },
        },
      }),
    },
    interpretationRepository: { get: vi.fn().mockResolvedValue(completedDocument) },
    assetJobRepository: {
      getForAiInterpretationDiscordAlert: vi.fn().mockResolvedValue(alertAsset),
    },
    storageRepository: { readFile: vi.fn().mockResolvedValue(Buffer.from('thumbnail')) },
    systemMetadataRepository: {},
    userRepository: { get: vi.fn().mockResolvedValue({ name: '  Cangka  ', email: 'cangka@example.com' }) },
    jobRepository: {
      getJobCounts: vi.fn().mockResolvedValue({
        active: 2,
        completed: 0,
        failed: 0,
        delayed: 5,
        waiting: 37,
        paused: 0,
      }),
    },
    discordClient: { send: vi.fn().mockResolvedValue(undefined) },
  };
  const service = new AiImageInterpretationDiscordService(
    dependencies.logger as never as LoggingRepository,
    dependencies.configRepository as never as ConfigRepository,
    dependencies.interpretationRepository as never as AiImageInterpretationRepository,
    dependencies.assetJobRepository as never as AssetJobRepository,
    dependencies.storageRepository as never as StorageRepository,
    dependencies.systemMetadataRepository as never as SystemMetadataRepository,
    dependencies.userRepository as never as UserRepository,
    dependencies.jobRepository as never as JobRepository,
    dependencies.discordClient as never as AiImageInterpretationDiscordClient,
  );
  const internals = service as never as { getExternalDomain: ReturnType<typeof vi.fn> };
  internals.getExternalDomain = vi.fn().mockResolvedValue('https://photos.example.com');
  return { service, dependencies };
};

describe(AiImageInterpretationDiscordService.name, () => {
  it('sends the completed run with a trimmed owner name and generated unedited thumbnail', async () => {
    const { service, dependencies } = makeService();

    await expect(service.handleAlert({ assetId: 'asset-1', runKey })).resolves.toBe(JobStatus.Success);

    expect(dependencies.assetJobRepository.getForAiInterpretationDiscordAlert).toHaveBeenCalledWith('asset-1');
    expect(dependencies.userRepository.get).toHaveBeenCalledWith('owner-1', { withDeleted: false });
    expect(dependencies.jobRepository.getJobCounts).toHaveBeenCalledWith(QueueName.ImageInterpretation);
    expect(dependencies.storageRepository.readFile).toHaveBeenCalledWith('/data/thumbs/photo.webp');
    expect(dependencies.discordClient.send).toHaveBeenCalledWith({
      accountName: 'Cangka',
      assetId: 'asset-1',
      externalDomain: 'https://photos.example.com',
      originalFileName: 'IMG_1234.JPG',
      photoDate: '2026-09-13T05:10:59.000Z',
      result,
      thumbnail: {
        buffer: Buffer.from('thumbnail'),
        contentType: 'image/webp',
        filename: 'ai-interpretation-thumbnail.webp',
      },
      waitingCount: 37,
    });
  });

  it('uses the recorded capture instant when the photo has an explicit EXIF timezone', async () => {
    const { service, dependencies } = makeService();
    dependencies.assetJobRepository.getForAiInterpretationDiscordAlert.mockResolvedValue({
      ...alertAsset,
      localDateTime: new Date('2026-09-13T12:10:59.000Z'),
      dateTimeOriginal: new Date('2026-09-13T16:10:59.000Z'),
      timeZone: 'America/New_York',
    });

    await service.handleAlert({ assetId: 'asset-1', runKey });

    expect(dependencies.discordClient.send).toHaveBeenCalledWith(
      expect.objectContaining({ photoDate: '2026-09-13T16:10:59.000Z' }),
    );
  });

  it.each([
    { name: '', email: 'empty@example.com', expected: 'empty@example.com' },
    { name: ' '.repeat(3), email: 'spaces@example.com', expected: 'spaces@example.com' },
    { name: 'Same Name', email: 'first@example.com', expected: 'Same Name' },
    { name: 'Same Name', email: 'second@example.com', expected: 'Same Name' },
  ])('formats owner $email as $expected', async ({ name, email, expected }) => {
    const { service, dependencies } = makeService();
    dependencies.userRepository.get.mockResolvedValue({ name, email });

    await service.handleAlert({ assetId: 'asset-1', runKey });

    expect(dependencies.discordClient.send).toHaveBeenCalledWith(expect.objectContaining({ accountName: expected }));
  });

  it('does not resolve or read thumbnail bytes when thumbnail inclusion is disabled', async () => {
    const { service, dependencies } = makeService();
    dependencies.configRepository.getEnv.mockReturnValue({
      aiImageInterpretation: {
        discord: { webhookUrl: 'https://discord.com/api/webhooks/123/token', includeThumbnail: false },
      },
    });

    await service.handleAlert({ assetId: 'asset-1', runKey });

    expect(dependencies.storageRepository.readFile).not.toHaveBeenCalled();
    expect(dependencies.discordClient.send).toHaveBeenCalledWith(
      expect.not.objectContaining({ thumbnail: expect.anything() }),
    );
  });

  it.each([
    {
      files: [{ id: 'preview', type: AssetFileType.Preview, path: '/data/preview.jpg', isEdited: false }],
      label: 'missing',
    },
    {
      files: [{ id: 'thumbnail', type: AssetFileType.Thumbnail, path: '/data/thumb.avif', isEdited: false }],
      label: 'unsupported',
    },
    {
      files: [{ id: 'thumbnail', type: AssetFileType.Thumbnail, path: '/data/thumb.webp', isEdited: false }],
      label: 'unreadable',
    },
  ])('falls back to text only for a $label thumbnail without using other image files', async ({ files, label }) => {
    const { service, dependencies } = makeService();
    dependencies.assetJobRepository.getForAiInterpretationDiscordAlert.mockResolvedValue({
      ...alertAsset,
      files: [
        ...files,
        { id: 'edited', type: AssetFileType.Thumbnail, path: '/data/edited.webp', isEdited: true },
        { id: 'fullsize', type: AssetFileType.FullSize, path: '/data/fullsize.jpg', isEdited: false },
      ],
    });
    if (label === 'unreadable') {
      dependencies.storageRepository.readFile.mockRejectedValue(new Error('contains private path'));
    }

    await expect(service.handleAlert({ assetId: 'asset-1', runKey })).resolves.toBe(JobStatus.Success);

    expect(dependencies.discordClient.send).toHaveBeenCalledWith(
      expect.not.objectContaining({ thumbnail: expect.anything() }),
    );
    expect(dependencies.storageRepository.readFile).not.toHaveBeenCalledWith('/data/preview.jpg');
    expect(dependencies.storageRepository.readFile).not.toHaveBeenCalledWith('/data/edited.webp');
    expect(dependencies.storageRepository.readFile).not.toHaveBeenCalledWith('/data/fullsize.jpg');
    expect(dependencies.logger.warn).toHaveBeenCalledWith(expect.not.stringContaining('/data/'));
  });

  it('skips when integration or authoritative source state is unavailable', async () => {
    const { service, dependencies } = makeService();
    dependencies.configRepository.getEnv.mockReturnValue({
      aiImageInterpretation: { discord: { includeThumbnail: true } },
    });
    await expect(service.handleAlert({ assetId: 'asset-1', runKey })).resolves.toBe(JobStatus.Skipped);
    expect(dependencies.interpretationRepository.get).not.toHaveBeenCalled();

    dependencies.configRepository.getEnv.mockReturnValue({
      aiImageInterpretation: {
        discord: { webhookUrl: 'https://discord.com/api/webhooks/123/token', includeThumbnail: true },
      },
    });
    dependencies.interpretationRepository.get.mockResolvedValue(null);
    await expect(service.handleAlert({ assetId: 'asset-1', runKey })).resolves.toBe(JobStatus.Skipped);

    dependencies.interpretationRepository.get.mockResolvedValue(completedDocument);
    dependencies.assetJobRepository.getForAiInterpretationDiscordAlert.mockResolvedValue(undefined);
    await expect(service.handleAlert({ assetId: 'asset-1', runKey })).resolves.toBe(JobStatus.Skipped);

    dependencies.assetJobRepository.getForAiInterpretationDiscordAlert.mockResolvedValue({
      ...alertAsset,
      files: [],
    });
    dependencies.userRepository.get.mockResolvedValue(null);
    await expect(service.handleAlert({ assetId: 'asset-1', runKey })).resolves.toBe(JobStatus.Skipped);
    expect(dependencies.discordClient.send).not.toHaveBeenCalled();
  });

  it('retries transient failures and stops permanent failures', async () => {
    const { service, dependencies } = makeService();
    const transient = new AiInterpretationDiscordAlertError('server_error', true);
    dependencies.discordClient.send.mockRejectedValueOnce(transient);
    await expect(service.handleAlert({ assetId: 'asset-1', runKey })).rejects.toBe(transient);

    dependencies.discordClient.send.mockRejectedValueOnce(new AiInterpretationDiscordAlertError('client_error', false));
    await expect(service.handleAlert({ assetId: 'asset-1', runKey })).rejects.toBeInstanceOf(UnrecoverableError);
    expect(dependencies.interpretationRepository.get).toHaveBeenCalledTimes(2);
  });
});
