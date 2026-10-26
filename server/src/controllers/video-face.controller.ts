import { Controller, Get, Next, Param, Res } from '@nestjs/common';
import type { NextFunction, Response } from 'express';
import { createZodDto } from 'nestjs-zod';
import { z } from 'zod';
import { ApiTags } from '@nestjs/swagger';
import type { AuthDto } from 'src/dtos/auth.dto.js';
import { VideoFacesResponseDto } from 'src/dtos/video-face.dto.js';
import { Endpoint, HistoryBuilder } from 'src/decorators.js';
import { ApiTag, Permission, RouteKey } from 'src/enum.js';
import { Auth, Authenticated, FileResponse } from 'src/middleware/auth.guard.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';
import { VideoFaceService } from 'src/services/video-face.service.js';
import { sendFile } from 'src/utils/file.js';
import { UUIDParamDto } from 'src/validation.js';

const VideoFaceRouteParamsSchema = z.object({ id: z.uuidv4(), faceId: z.uuidv4() });

export class VideoFaceRouteParamsDto extends createZodDto(VideoFaceRouteParamsSchema) {}

@ApiTags(ApiTag.Assets)
@Controller(RouteKey.Asset)
export class VideoFaceController {
  private logger: LoggingRepository;

  constructor(
    private service: VideoFaceService,
    logger: LoggingRepository,
  ) {
    this.logger = logger;
    this.logger.setContext(VideoFaceController.name);
  }

  @Get(':id/video-faces')
  @Authenticated({ permission: Permission.AssetRead })
  @Endpoint({
    summary: 'List faces discovered in a video',
    description:
      'Per-identity faces from the multi-frame video scan: first observed, sightings, and the latest run outcome for coverage display.',
    history: new HistoryBuilder().added('v3.3.0'),
  })
  getVideoFaces(@Auth() auth: AuthDto, @Param() { id }: UUIDParamDto): Promise<VideoFacesResponseDto> {
    return this.service.getVideoFaces(auth, id);
  }

  @Get(':id/video-faces/:faceId/thumbnail')
  @FileResponse()
  @Authenticated({ permission: Permission.AssetRead })
  @Endpoint({
    summary: 'Face crop from its representative frame',
    description: 'Crops the identity representative frame at its timestamp. WebP, cacheable per face until re-scan.',
    history: new HistoryBuilder().added('v3.3.0'),
  })
  async getFaceThumbnail(
    @Res() res: Response,
    @Next() next: NextFunction,
    @Auth() auth: AuthDto,
    @Param() { id, faceId }: VideoFaceRouteParamsDto,
  ): Promise<void> {
    await sendFile(res, next, () => this.service.getFaceThumbnail(auth, id, faceId), this.logger);
  }
}
