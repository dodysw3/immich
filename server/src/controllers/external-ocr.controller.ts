import { Body, Controller, HttpCode, HttpStatus, Param, Put } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { Endpoint, HistoryBuilder } from 'src/decorators';
import {
  ExternalOcrFailureDto,
  ExternalOcrResultDto,
  ExternalOcrWriteResponseDto,
} from 'src/dtos/external-ocr.dto';
import { AuthDto } from 'src/dtos/auth.dto';
import { ApiTag, Permission } from 'src/enum';
import { Auth, Authenticated } from 'src/middleware/auth.guard';
import { ExternalOcrService } from 'src/services/external-ocr.service';
import { UUIDParamDto } from 'src/validation';

@ApiTags(ApiTag.Assets)
@Controller('external-ocr')
export class ExternalOcrController {
  constructor(private service: ExternalOcrService) {}

  @Put('assets/:id/result')
  @Authenticated({ permission: Permission.AssetUpdate })
  @Endpoint({
    summary: 'Write external OCR result',
    description: 'Write external OCR result and searchable text through Immich repositories.',
    history: new HistoryBuilder().added('v2.6.0').alpha('v2.6.0'),
  })
  writeResult(
    @Auth() auth: AuthDto,
    @Param() { id }: UUIDParamDto,
    @Body() dto: ExternalOcrResultDto,
  ): Promise<ExternalOcrWriteResponseDto> {
    return this.service.writeResult(auth, id, dto);
  }

  @Put('assets/:id/failure')
  @Authenticated({ permission: Permission.AssetUpdate })
  @HttpCode(HttpStatus.NO_CONTENT)
  @Endpoint({
    summary: 'Report external OCR failure',
    description: 'Store failure details from external OCR processing.',
    history: new HistoryBuilder().added('v2.6.0').alpha('v2.6.0'),
  })
  async reportFailure(@Auth() auth: AuthDto, @Param() { id }: UUIDParamDto, @Body() dto: ExternalOcrFailureDto) {
    await this.service.reportFailure(auth, id, dto);
  }
}
