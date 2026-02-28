import { BadRequestException, Injectable } from '@nestjs/common';
import { Insertable } from 'kysely';
import { OnEvent } from 'src/decorators';
import { AuthDto } from 'src/dtos/auth.dto';
import {
  ExternalOcrFailureDto,
  ExternalOcrResultDto,
  ExternalOcrWriteResponseDto,
} from 'src/dtos/external-ocr.dto';
import { AssetType, AssetVisibility, Permission } from 'src/enum';
import { ArgOf } from 'src/repositories/event.repository';
import { AssetOcrTable } from 'src/schema/tables/asset-ocr.table';
import { BaseService } from 'src/services/base.service';
import { tokenizeForSearch } from 'src/utils/database';
import { isOcrEnabled } from 'src/utils/misc';

const EXTERNAL_OCR_PROVENANCE_KEY = 'external.ocr.v1';
const EXTERNAL_OCR_STATUS_KEY = 'external.ocr.status';
const MAX_OCR_LINES = 10_000;
const MAX_SEARCH_TEXT_LENGTH = 1_000_000;

@Injectable()
export class ExternalOcrService extends BaseService {
  @OnEvent({ name: 'AssetCreate' })
  async handleAssetCreate({ asset }: ArgOf<'AssetCreate'>): Promise<void> {
    const { machineLearning } = await this.getConfig({ withCache: true });
    if (isOcrEnabled(machineLearning)) {
      return;
    }

    if (asset.type !== AssetType.Image) {
      return;
    }

    if (asset.visibility === AssetVisibility.Hidden) {
      return;
    }

    await this.assetRepository.upsertJobStatus({ assetId: asset.id, ocrAt: new Date() });
    this.logger.debug(`Queued external OCR trigger for new asset ${asset.id}`);
  }

  async writeResult(auth: AuthDto, assetId: string, dto: ExternalOcrResultDto): Promise<ExternalOcrWriteResponseDto> {
    await this.requireAccess({ auth, permission: Permission.AssetUpdate, ids: [assetId] });
    await this.findAssetOrFail(assetId);

    if (dto.lines.length > MAX_OCR_LINES) {
      throw new BadRequestException(`Too many OCR lines (max ${MAX_OCR_LINES})`);
    }

    const incomingOcrData = dto.lines.map<Insertable<AssetOcrTable>>((line) => ({
      assetId,
      x1: line.x1,
      y1: line.y1,
      x2: line.x2,
      y2: line.y2,
      x3: line.x3,
      y3: line.y3,
      x4: line.x4,
      y4: line.y4,
      boxScore: line.boxScore,
      textScore: line.textScore,
      text: line.text,
      isVisible: true,
    }));

    let ocrData = incomingOcrData;
    if (dto.mode === 'merge') {
      const existing = await this.ocrRepository.getByAssetId(assetId, { isVisible: undefined });
      ocrData = [...existing, ...incomingOcrData];
    }

    const searchText = this.buildSearchText(dto, ocrData);
    if (searchText.length > MAX_SEARCH_TEXT_LENGTH) {
      throw new BadRequestException(`searchText exceeds maximum length of ${MAX_SEARCH_TEXT_LENGTH}`);
    }

    await this.ocrRepository.upsert(assetId, ocrData, searchText);
    await this.assetRepository.upsertJobStatus({ assetId, ocrAt: new Date() });

    await this.assetRepository.upsertMetadata(assetId, [
      {
        key: EXTERNAL_OCR_PROVENANCE_KEY,
        value: {
          provider: dto.provider,
          model: dto.model,
          modelRevision: dto.modelRevision,
          sourceChecksum: dto.sourceChecksum,
          language: dto.language,
          processedAt: dto.processedAt,
        },
      },
      {
        key: EXTERNAL_OCR_STATUS_KEY,
        value: {
          status: 'success',
          provider: dto.provider,
          modelRevision: dto.modelRevision,
          processedAt: dto.processedAt,
          written: ocrData.length,
        },
      },
    ]);

    return { written: ocrData.length, searchTextLength: searchText.length };
  }

  async reportFailure(auth: AuthDto, assetId: string, dto: ExternalOcrFailureDto): Promise<void> {
    await this.requireAccess({ auth, permission: Permission.AssetUpdate, ids: [assetId] });
    await this.findAssetOrFail(assetId);

    await this.assetRepository.upsertMetadata(assetId, [
      {
        key: EXTERNAL_OCR_STATUS_KEY,
        value: {
          status: 'failed',
          provider: dto.provider,
          reason: dto.reason,
          retryCount: dto.retryCount,
          retriable: dto.retriable,
          failedAt: new Date().toISOString(),
        },
      },
    ]);
  }

  private buildSearchText(dto: ExternalOcrResultDto, ocrData: Insertable<AssetOcrTable>[]): string {
    if (dto.mode === 'replace' && dto.searchText) {
      return dto.searchText;
    }

    const text = ocrData
      .map((line) => (typeof line.text === 'string' ? line.text : ''))
      .filter(Boolean)
      .join(' ');

    return tokenizeForSearch(text).join(' ');
  }

  private async findAssetOrFail(assetId: string) {
    const asset = await this.assetRepository.getById(assetId);
    if (!asset) {
      throw new BadRequestException('Asset not found');
    }

    return asset;
  }
}
