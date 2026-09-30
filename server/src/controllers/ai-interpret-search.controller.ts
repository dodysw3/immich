import { Body, Controller, HttpCode, HttpStatus, Post } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import type { AuthDto } from 'src/dtos/auth.dto.js';
import { Endpoint, HistoryBuilder } from 'src/decorators.js';
import { AiInterpretSearchDto, AiInterpretSearchResponseDto } from 'src/dtos/search.dto.js';
import { ApiTag, Permission } from 'src/enum.js';
import { Auth, Authenticated } from 'src/middleware/auth.guard.js';
import { AiInterpretSearchService } from 'src/services/ai-interpret-search.service.js';

@ApiTags(ApiTag.Search)
@Controller('search')
export class AiInterpretSearchController {
  constructor(private service: AiInterpretSearchService) {}

  @Post('ai-interpret')
  @Authenticated({ permission: Permission.AssetRead })
  @HttpCode(HttpStatus.OK)
  @Endpoint({
    summary: 'AI interpretation search',
    description:
      'Search assets by the AI interpretation of their contents. Results are fused from a dense semantic branch and a lexical keyword branch.',
    history: new HistoryBuilder().added('v3.2.0'),
  })
  searchAiInterpret(@Auth() auth: AuthDto, @Body() dto: AiInterpretSearchDto): Promise<AiInterpretSearchResponseDto> {
    return this.service.searchAiInterpret(auth, dto);
  }
}
