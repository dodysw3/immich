import { Body, Controller, Get, HttpCode, HttpStatus, Next, Param, Post, Res } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import type { NextFunction, Response } from 'express';
import { Endpoint, HistoryBuilder } from 'src/decorators.js';
import type { AuthDto } from 'src/dtos/auth.dto.js';
import {
  TranscriptionMomentsDto,
  TranscriptionMomentsResponseDto,
  TranscriptionSearchDto,
  TranscriptionSearchResponseDto,
} from 'src/dtos/search.dto.js';
import { ApiTag, Permission } from 'src/enum.js';
import { Auth, Authenticated, FileResponse } from 'src/middleware/auth.guard.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';
import { TranscriptFrameService } from 'src/services/transcript-frame.service.js';
import { TranscriptSearchService } from 'src/services/transcript-search.service.js';
import { sendFile } from 'src/utils/file.js';
import { TranscriptionFrameParamsDto } from 'src/validation.js';

/**
Dedicated speech-transcript search: searches spoken words in video
transcripts only (exact-first lexical ranking with a spelling fallback).
Independent of AI interpretation and smart search; access rules match the
other search modes.
*/
@ApiTags(ApiTag.Search)
@Controller('search')
export class TranscriptionSearchController {
  constructor(
    private service: TranscriptSearchService,
    private frameService: TranscriptFrameService,
    private logger: LoggingRepository,
  ) {}

  @Post('transcription')
  @Authenticated({ permission: Permission.AssetRead })
  @HttpCode(HttpStatus.OK)
  @Endpoint({
    summary: 'Transcription search',
    description:
      'Search videos by words spoken in their audio. Exact phrases outrank exact all-token matches, which outrank spelling variants; timestamps are segment starts, not word-aligned.',
    history: new HistoryBuilder().added('v3.5.0'),
  })
  searchTranscription(
    @Auth() auth: AuthDto,
    @Body() dto: TranscriptionSearchDto,
  ): Promise<TranscriptionSearchResponseDto> {
    return this.service.searchTranscription(auth, dto);
  }

  @Post('transcription/moments')
  @Authenticated({ permission: Permission.AssetRead })
  @HttpCode(HttpStatus.OK)
  @Endpoint({
    summary: 'Transcription additional moments',
    description:
      'Paginated additional matching moments for one video and query, with the same access rules as the search itself.',
    history: new HistoryBuilder().added('v3.5.0'),
  })
  searchMoments(@Auth() auth: AuthDto, @Body() dto: TranscriptionMomentsDto): Promise<TranscriptionMomentsResponseDto> {
    return this.service.searchMoments(auth, dto);
  }

  @Get('transcription/frame/:assetId/:passageId')
  @FileResponse()
  @Authenticated({ permission: Permission.AssetRead })
  @Endpoint({
    summary: 'Matching frame for a Transcription result',
    description:
      'Decodes (and privately caches) the frame at the selected passage start. Identity is server-resolved from the opaque passage id; access is enforced on every response, including cached ones.',
    history: new HistoryBuilder().added('v3.5.0'),
  })
  async getMatchFrame(
    @Auth() auth: AuthDto,
    @Param() { assetId, passageId }: TranscriptionFrameParamsDto,
    @Res() res: Response,
    @Next() next: NextFunction,
  ): Promise<void> {
    await sendFile(res, next, () => this.frameService.resolveFrame(auth, assetId, passageId), this.logger);
  }
}
