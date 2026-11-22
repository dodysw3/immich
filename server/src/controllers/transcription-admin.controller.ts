import { Controller, Get, HttpCode, HttpStatus, Post } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { createZodDto } from '@immich/nestjs-standard-schema/zod';
import { Endpoint, HistoryBuilder } from 'src/decorators.js';
import {
  TranscriptionCoverageCountsSchema,
  TranscriptionReconcileResponseSchema,
  TranscriptionVoiceIsolationResponseSchema,
} from 'src/dtos/ai-video-transcription.dto.js';
import { ApiTag, Permission } from 'src/enum.js';
import { Authenticated } from 'src/middleware/auth.guard.js';
import { AiVideoTranscriptionService } from 'src/services/ai-video-transcription.service.js';

export class TranscriptionCoverageCountsDto extends createZodDto(TranscriptionCoverageCountsSchema) {}
export class TranscriptionReconcileResponseDto extends createZodDto(TranscriptionReconcileResponseSchema) {}
export class TranscriptionVoiceIsolationResponseDto extends createZodDto(TranscriptionVoiceIsolationResponseSchema) {}

/**
Admin transcription coverage and reconciliation controls, independent of
captioning and interpretation. Pause/resume and retries reuse the existing
queue management endpoints on the `videoTranscription` queue.
*/
@ApiTags(ApiTag.Maintenance)
@Controller('admin/transcription')
export class TranscriptionAdminController {
  constructor(private service: AiVideoTranscriptionService) {}

  @Get('coverage')
  @Endpoint({
    summary: 'Transcription coverage totals',
    description:
      'Counts of videos per transcription coverage state (missing, in progress, failed, partial, complete, no-audio, no-speech) plus search-index currency. Populated independently of captioning and interpretation.',
    history: new HistoryBuilder().added('v3.5.0'),
  })
  @Authenticated({ permission: Permission.Maintenance, admin: true })
  getCoverageCounts(): Promise<TranscriptionCoverageCountsDto> {
    return this.service.getCoverageCounts();
  }

  @Post('reconcile')
  @HttpCode(HttpStatus.OK)
  @Endpoint({
    summary: 'Queue transcription reconciliation',
    description:
      'Schedules the deduplicated keyset sweep that finds missing, partial, and abandoned transcription work. Bounded per sweep; failed media is never auto-retried.',
    history: new HistoryBuilder().added('v3.5.0'),
  })
  @Authenticated({ permission: Permission.Maintenance, admin: true })
  async queueReconciliation(): Promise<TranscriptionReconcileResponseDto> {
    await this.service.queueReconciliation();
    return { queued: true };
  }

  @Post('voice-isolation')
  @HttpCode(HttpStatus.OK)
  @Endpoint({
    summary: 'Queue voice-isolation backfill',
    description:
      'Schedules the deduplicated, budgeted keyset sweep that queues the gated voice-isolated second pass for already-completed raw transcripts. No-op when the isolator is unconfigured or the kill switch is off.',
    history: new HistoryBuilder().added('v3.6.0'),
  })
  @Authenticated({ permission: Permission.Maintenance, admin: true })
  queueVoiceIsolation(): Promise<TranscriptionVoiceIsolationResponseDto> {
    return this.service.queueVoiceIsolationBackfill();
  }
}
