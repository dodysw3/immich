import { Injectable } from '@nestjs/common';
import { UnrecoverableError } from 'bullmq';
import { DateTime } from 'luxon';
import { setTimeout } from 'node:timers/promises';
import type { JobOf } from 'src/types.js';
import { AssetFile } from 'src/database.js';
import { OnJob } from 'src/decorators.js';
import { AssetFileType, JobName, JobStatus, QueueName } from 'src/enum.js';
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
  AiInterpretationDiscordThumbnail,
} from 'src/services/ai-image-interpretation-discord.client.js';
import { getAssetFile } from 'src/utils/asset.util.js';
import { getConfig } from 'src/utils/config.js';
import { getFilenameExtension } from 'src/utils/file.js';
import { mimeTypes } from 'src/utils/mime-types.js';

const SUPPORTED_THUMBNAIL_TYPES = new Set<AiInterpretationDiscordThumbnail['contentType']>([
  'image/gif',
  'image/jpeg',
  'image/png',
  'image/webp',
]);
const DEFAULT_PHOTO_TIME_ZONE = 'Asia/Jakarta';

const getPhotoDate = ({
  dateTimeOriginal,
  localDateTime,
  timeZone,
}: {
  dateTimeOriginal: Date | null;
  localDateTime: Date;
  timeZone: string | null;
}) => {
  if (timeZone && dateTimeOriginal) {
    return dateTimeOriginal.toISOString();
  }

  const assumedDate = DateTime.fromJSDate(localDateTime, { zone: 'UTC' }).setZone(DEFAULT_PHOTO_TIME_ZONE, {
    keepLocalTime: true,
  });
  if (!assumedDate.isValid) {
    return localDateTime.toISOString();
  }

  return assumedDate.toUTC().toISO();
};

@Injectable()
export class AiImageInterpretationDiscordService {
  constructor(
    private logger: LoggingRepository,
    private configRepository: ConfigRepository,
    private interpretationRepository: AiImageInterpretationRepository,
    private assetJobRepository: AssetJobRepository,
    private storageRepository: StorageRepository,
    private systemMetadataRepository: SystemMetadataRepository,
    private userRepository: UserRepository,
    private jobRepository: JobRepository,
    private discordClient: AiImageInterpretationDiscordClient,
  ) {
    this.logger.setContext(AiImageInterpretationDiscordService.name);
  }

  @OnJob({ name: JobName.SendAiInterpretationDiscordAlert, queue: QueueName.Notification })
  async handleAlert({ assetId, runKey }: JobOf<JobName.SendAiInterpretationDiscordAlert>): Promise<JobStatus> {
    const discordConfig = this.configRepository.getEnv().aiImageInterpretation.discord;
    if (!discordConfig.webhookUrl) {
      return JobStatus.Skipped;
    }

    const document = await this.interpretationRepository.get(assetId);
    const run = document?.runs[runKey];
    if (!run || run.status !== 'completed' || !run.result) {
      return JobStatus.Skipped;
    }

    const asset = await this.assetJobRepository.getForAiInterpretationDiscordAlert(assetId);
    if (!asset) {
      return JobStatus.Skipped;
    }

    const owner = await this.userRepository.get(asset.ownerId, { withDeleted: false });
    if (!owner) {
      return JobStatus.Skipped;
    }

    const thumbnail = discordConfig.includeThumbnail ? await this.loadThumbnail(assetId, asset.files) : undefined;
    const externalDomain = await this.getExternalDomain();
    const { waiting: waitingCount } = await this.jobRepository.getJobCounts(QueueName.ImageInterpretation);

    try {
      await this.discordClient.send({
        accountName: owner.name.trim() || owner.email,
        assetId,
        externalDomain,
        originalFileName: asset.originalFileName,
        photoDate: getPhotoDate(asset),
        result: run.result,
        thumbnail,
        waitingCount,
      });
    } catch (error) {
      if (error instanceof AiInterpretationDiscordAlertError) {
        if (!error.retryable) {
          throw new UnrecoverableError(error.message);
        }

        if (error.retryAfterMs) {
          await setTimeout(Math.min(error.retryAfterMs, 60_000));
        }
      }
      throw error;
    }

    this.logger.log(`Sent AI interpretation Discord alert for ${assetId}/${runKey}`);
    return JobStatus.Success;
  }

  private async getExternalDomain() {
    const { server } = await getConfig(
      {
        configRepo: this.configRepository,
        metadataRepo: this.systemMetadataRepository,
        logger: this.logger,
      },
      { withCache: true },
    );
    return server.externalDomain || undefined;
  }

  private async loadThumbnail(
    assetId: string,
    files: AssetFile[],
  ): Promise<AiInterpretationDiscordThumbnail | undefined> {
    const file = getAssetFile(files, AssetFileType.Thumbnail, { isEdited: false });
    if (!file) {
      this.logger.warn(`Discord alert for ${assetId} has no generated thumbnail; sending text only`);
      return;
    }

    const contentType = mimeTypes.lookup(file.path);
    if (!SUPPORTED_THUMBNAIL_TYPES.has(contentType as AiInterpretationDiscordThumbnail['contentType'])) {
      this.logger.warn(`Discord alert for ${assetId} has an unsupported generated thumbnail; sending text only`);
      return;
    }

    try {
      const extension = getFilenameExtension(file.path).toLowerCase();
      return {
        buffer: await this.storageRepository.readFile(file.path),
        contentType: contentType as AiInterpretationDiscordThumbnail['contentType'],
        filename: `ai-interpretation-thumbnail${extension}`,
      };
    } catch {
      this.logger.warn(`Discord alert for ${assetId} could not read its generated thumbnail; sending text only`);
      return;
    }
  }
}
