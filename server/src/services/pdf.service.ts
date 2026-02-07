import { Injectable, NotFoundException } from '@nestjs/common';
import { mkdtemp } from 'node:fs/promises';
import { dirname, join } from 'node:path';
import readline from 'node:readline';
import { tmpdir } from 'node:os';
import { JOBS_ASSET_PAGINATION_SIZE } from 'src/constants';
import { OnEvent, OnJob } from 'src/decorators';
import { AuthDto } from 'src/dtos/auth.dto';
import {
  PdfDocumentListResponseDto,
  PdfDocumentQueryDto,
  PdfDocumentResponseDto,
  PdfInDocumentSearchDto,
  PdfInDocumentSearchResultDto,
  PdfSearchResponseDto,
  PdfDocumentSearchDto,
  PdfPageResponseDto,
  PdfSearchResultDto,
} from 'src/dtos/pdf.dto';
import { JobName, JobStatus, QueueName } from 'src/enum';
import { ArgOf } from 'src/repositories/event.repository';
import { BaseService } from 'src/services/base.service';
import { JobItem, JobOf } from 'src/types';
import { tokenizeForSearch } from 'src/utils/database';
import { isOcrEnabled } from 'src/utils/misc';

const DEFAULT_PDF_TEXT_EXTRACTION_PAGE_LIMIT = 250;

type PdfMetadata = {
  pageCount: number;
  title: string | null;
  author: string | null;
  subject: string | null;
  creator: string | null;
  producer: string | null;
  creationDate: Date | null;
};

@Injectable()
export class PdfService extends BaseService {
  private hasLoggedMissingPdftotext = false;
  private hasLoggedMissingPdftoppm = false;
  private hasLoggedMissingPdfinfo = false;

  @OnEvent({ name: 'AssetMetadataExtracted' })
  async onAssetMetadataExtracted({ assetId }: ArgOf<'AssetMetadataExtracted'>) {
    if (!this.isPdfEnabled()) {
      return;
    }

    const asset = await this.pdfRepository.getAssetForProcessing(assetId);
    if (!asset || !this.pdfRepository.isPdfAsset(asset)) {
      return;
    }

    await this.pdfRepository.updateDocumentStatus(asset.id, 'pending');
    await this.jobRepository.queue({ name: JobName.PdfProcess, data: { id: asset.id } });
  }

  @OnJob({ name: JobName.PdfProcessQueueAll, queue: QueueName.PdfProcessing })
  async handleQueueAll({ force }: JobOf<JobName.PdfProcessQueueAll>): Promise<JobStatus> {
    if (!this.isPdfEnabled()) {
      return JobStatus.Skipped;
    }

    const jobs: JobItem[] = [];
    const assets = this.pdfRepository.streamPdfAssetIds(force);

    for await (const asset of assets) {
      jobs.push({ name: JobName.PdfProcess, data: { id: asset.id } });
      if (jobs.length >= JOBS_ASSET_PAGINATION_SIZE) {
        await this.jobRepository.queueAll(jobs);
        jobs.length = 0;
      }
    }

    await this.jobRepository.queueAll(jobs);
    return JobStatus.Success;
  }

  @OnJob({ name: JobName.PdfProcess, queue: QueueName.PdfProcessing })
  async handlePdfProcess({ id }: JobOf<JobName.PdfProcess>): Promise<JobStatus> {
    if (!this.isPdfEnabled()) {
      return JobStatus.Skipped;
    }

    const { machineLearning } = await this.getConfig({ withCache: true });
    const asset = await this.pdfRepository.getAssetForProcessing(id);
    if (!asset || asset.deletedAt || !this.pdfRepository.isPdfAsset(asset)) {
      return JobStatus.Skipped;
    }

    await this.pdfRepository.updateDocumentStatus(id, 'processing', null);
    const startedAt = Date.now();

    const maxFileSize = this.getPdfMaxFileSizeBytes();
    if (maxFileSize > 0) {
      const stat = await this.storageRepository.stat(asset.originalPath);
      if (stat.size > maxFileSize) {
        this.logger.warn(`Skipping PDF processing for ${id}: file exceeds PDF_MAX_FILE_SIZE_MB`);
        await this.pdfRepository.updateDocumentStatus(id, 'failed', 'File exceeds configured size limit');
        return JobStatus.Failed;
      }
    }

    try {
      const metadata = await this.readPdfMetadata(asset.originalPath);
      await this.pdfRepository.upsertDocument({
        assetId: id,
        pageCount: metadata.pageCount,
        title: metadata.title,
        author: metadata.author,
        subject: metadata.subject,
        creator: metadata.creator,
        producer: metadata.producer,
        creationDate: metadata.creationDate,
        processedAt: null,
        status: 'processing',
        lastError: null,
      });

      let pages: Array<{
        assetId: string;
        pageNumber: number;
        text: string;
        textSource: 'embedded' | 'none';
        width: number | null;
        height: number | null;
      }> = [];
      let ocrPages = 0;
      if (metadata.pageCount > 0 && metadata.pageCount <= this.getPdfMaxPagesPerDoc()) {
        pages = await this.extractTextByPage(asset.originalPath, id, metadata.pageCount);
        if (isOcrEnabled(machineLearning) && this.isPdfOcrEnabled()) {
          ocrPages = await this.ocrTextlessPages(asset.originalPath, pages, machineLearning.ocr);
        }
      } else if (metadata.pageCount > this.getPdfMaxPagesPerDoc()) {
        this.logger.warn(`Skipping PDF page indexing for ${id}: page count ${metadata.pageCount} exceeds limit`);
      }

      await this.pdfRepository.replacePages(id, pages);
      const searchText = tokenizeForSearch(pages.map((item) => item.text).join(' ')).join(' ');
      await this.pdfRepository.upsertSearch(id, searchText);
      await this.pdfRepository.markDocumentReady(id, new Date());

      await this.assetRepository.upsertJobStatus({ assetId: id });
      this.logger.log(
        `Processed PDF ${id} in ${Date.now() - startedAt}ms (pages=${metadata.pageCount}, indexed=${pages.length}, ocr=${ocrPages})`,
      );
      return JobStatus.Success;
    } catch (error) {
      const reason = error instanceof Error ? error.message : 'Unknown PDF processing error';
      await this.pdfRepository.updateDocumentStatus(id, 'failed', reason.slice(0, 500));
      this.logger.warn(`PDF processing failed for ${id} after ${Date.now() - startedAt}ms: ${reason}`);
      return JobStatus.Failed;
    }
  }

  async getDocuments(auth: AuthDto, dto: PdfDocumentQueryDto): Promise<PdfDocumentListResponseDto> {
    const page = dto.page ?? 1;
    const size = dto.size ?? 50;
    const [documentPage, summary] = await Promise.all([
      this.pdfRepository.getDocumentsByOwner(auth.user.id, { page, size, status: dto.status }),
      this.pdfRepository.getDocumentStatusSummaryByOwner(auth.user.id),
    ]);
    const fallbackSummary = { total: 0, pending: 0, processing: 0, ready: 0, failed: 0 };

    return {
      items: documentPage.items.map((item) => this.mapDocument(item)),
      nextPage: documentPage.hasNextPage ? `${page + 1}` : null,
      summary: summary ?? fallbackSummary,
    };
  }

  async getDocument(auth: AuthDto, id: string): Promise<PdfDocumentResponseDto> {
    const item = await this.pdfRepository.getDocumentByOwner(auth.user.id, id);
    if (!item) {
      throw new NotFoundException('PDF document not found');
    }

    return this.mapDocument(item);
  }

  async getPages(auth: AuthDto, id: string): Promise<PdfPageResponseDto[]> {
    await this.ensureDocumentAccess(auth.user.id, id);
    const pages = await this.pdfRepository.getPagesByOwner(auth.user.id, id);
    return pages.map((page) => ({
      id: page.id,
      assetId: page.assetId,
      pageNumber: page.pageNumber,
      text: page.text,
      textSource: page.textSource,
      width: page.width,
      height: page.height,
    }));
  }

  async getPage(auth: AuthDto, id: string, pageNumber: number): Promise<PdfPageResponseDto> {
    await this.ensureDocumentAccess(auth.user.id, id);
    const page = await this.pdfRepository.getPageByOwner(auth.user.id, id, pageNumber);
    if (!page) {
      throw new NotFoundException('PDF page not found');
    }

    return {
      id: page.id,
      assetId: page.assetId,
      pageNumber: page.pageNumber,
      text: page.text,
      textSource: page.textSource,
      width: page.width,
      height: page.height,
    };
  }

  async search(auth: AuthDto, dto: PdfDocumentSearchDto): Promise<PdfSearchResponseDto> {
    const query = dto.query.trim();
    const fallbackSummary = { total: 0, pending: 0, processing: 0, ready: 0, failed: 0 };
    if (!query) {
      const summary = await this.pdfRepository.getDocumentStatusSummaryByOwner(auth.user.id);
      return { items: [], nextPage: null, summary: summary ?? fallbackSummary };
    }

    const page = dto.page ?? 1;
    const size = dto.size ?? 50;
    const [searchPage, summary] = await Promise.all([
      this.pdfRepository.searchByText(auth.user.id, query, {
        page,
        size,
        status: dto.status,
      }),
      this.pdfRepository.getDocumentStatusSummaryByOwner(auth.user.id),
    ]);
    const { items, hasNextPage } = searchPage;
    const assetIds = items.map((item) => item.assetId);
    const matchingEntries = await this.pdfRepository.getMatchingPagesByAssets(assetIds, query);
    const matchingByAsset = new Map<string, number[]>();
    for (const entry of matchingEntries) {
      const pages = matchingByAsset.get(entry.assetId) ?? [];
      pages.push(entry.pageNumber);
      matchingByAsset.set(entry.assetId, pages);
    }

    const results: PdfSearchResultDto[] = [];
    for (const item of items) {
      results.push({
        ...this.mapDocument(item),
        matchingPages: matchingByAsset.get(item.assetId) ?? [],
      });
    }

    return { items: results, nextPage: hasNextPage ? `${page + 1}` : null, summary: summary ?? fallbackSummary };
  }

  async searchInDocument(
    auth: AuthDto,
    id: string,
    dto: PdfInDocumentSearchDto,
  ): Promise<PdfInDocumentSearchResultDto[]> {
    await this.ensureDocumentAccess(auth.user.id, id);
    const query = dto.query.trim();
    if (!query) {
      return [];
    }
    const size = dto.size ?? 100;

    const rows = await this.pdfRepository.searchPagesByOwner(auth.user.id, id, query, size);
    return rows.map((row) => this.toInDocumentResult(row.pageNumber, row.text, query));
  }

  async reprocessDocument(auth: AuthDto, id: string): Promise<void> {
    const item = await this.pdfRepository.getDocumentByOwner(auth.user.id, id);
    if (!item) {
      throw new NotFoundException('PDF document not found');
    }

    if (item.status === 'pending' || item.status === 'processing') {
      this.logger.debug(`Skipping reprocess for ${id}: already ${item.status}`);
      return;
    }

    await this.pdfRepository.updateDocumentStatus(id, 'pending', null);
    await this.jobRepository.queue({ name: JobName.PdfProcess, data: { id } });
  }

  private async ensureDocumentAccess(ownerId: string, id: string): Promise<void> {
    const item = await this.pdfRepository.getDocumentByOwner(ownerId, id);
    if (!item) {
      throw new NotFoundException('PDF document not found');
    }
  }

  private mapDocument(item: {
    assetId: string;
    originalFileName: string;
    pageCount: number | null;
    title: string | null;
    author: string | null;
    processedAt: Date | null;
    status: 'pending' | 'processing' | 'ready' | 'failed' | null;
    lastError: string | null;
    createdAt: Date;
  }): PdfDocumentResponseDto {
    return {
      assetId: item.assetId,
      originalFileName: item.originalFileName,
      pageCount: item.pageCount ?? 0,
      title: item.title,
      author: item.author,
      processedAt: item.processedAt,
      status: item.status ?? 'pending',
      lastError: item.lastError,
      createdAt: item.createdAt,
    };
  }

  private async readPdfMetadata(path: string): Promise<PdfMetadata> {
    const tags = await this.metadataRepository.readTags(path);
    const value = tags as Record<string, unknown>;
    const pageCount = this.toNumber(value.PageCount) ?? 0;

    return {
      pageCount,
      title: this.toStringOrNull(value.Title),
      author: this.toStringOrNull(value.Author),
      subject: this.toStringOrNull(value.Subject),
      creator: this.toStringOrNull(value.Creator),
      producer: this.toStringOrNull(value.Producer),
      creationDate: this.toDateOrNull(value.CreateDate),
    };
  }

  private async extractTextByPage(path: string, assetId: string, pageCount: number) {
    const rows: Array<{
      assetId: string;
      pageNumber: number;
      text: string;
      textSource: 'embedded' | 'none';
      width: number | null;
      height: number | null;
    }> = [];
    const minEmbeddedTextLength = this.getPdfMinEmbeddedTextLength();
    const dimensions = await this.extractPageDimensions(path, pageCount);

    for (let pageNumber = 1; pageNumber <= pageCount; pageNumber++) {
      const text = await this.extractPageText(path, pageNumber);
      const normalized = text.trim();
      const dimension = dimensions.get(pageNumber);
      rows.push({
        assetId,
        pageNumber,
        text: normalized,
        textSource: normalized.length >= minEmbeddedTextLength ? 'embedded' : 'none',
        width: dimension?.width ?? null,
        height: dimension?.height ?? null,
      });
    }

    return rows;
  }

  private extractPageDimensions(path: string, pageCount: number): Promise<Map<number, { width: number; height: number }>> {
    return new Promise((resolve) => {
      const child = this.processRepository.spawn('pdfinfo', ['-f', '1', '-l', `${pageCount}`, path]);
      const lines: string[] = [];
      const rl = readline.createInterface({ input: child.stdout });

      rl.on('line', (line) => lines.push(line));
      child.on('error', (error) => {
        if ((error as NodeJS.ErrnoException).code === 'ENOENT') {
          if (!this.hasLoggedMissingPdfinfo) {
            this.logger.warn('pdfinfo is not available, skipping PDF page dimensions');
            this.hasLoggedMissingPdfinfo = true;
          }
          resolve(new Map());
          return;
        }

        this.logger.warn(`pdfinfo failed for PDF page dimensions: ${error}`);
        resolve(new Map());
      });
      child.on('close', (code) => {
        if (code !== 0) {
          resolve(new Map());
          return;
        }

        const dimensions = new Map<number, { width: number; height: number }>();
        for (const line of lines) {
          const match = /^\s*Page\s+(\d+)\s+size:\s+([0-9.]+)\s+x\s+([0-9.]+)\s+pts/i.exec(line);
          if (!match) {
            continue;
          }

          const pageNumber = Number.parseInt(match[1]!, 10);
          const width = Number.parseFloat(match[2]!);
          const height = Number.parseFloat(match[3]!);
          if (Number.isFinite(pageNumber) && Number.isFinite(width) && Number.isFinite(height)) {
            dimensions.set(pageNumber, { width, height });
          }
        }

        resolve(dimensions);
      });
    });
  }

  private extractPageText(path: string, pageNumber: number): Promise<string> {
    return new Promise((resolve) => {
      const child = this.processRepository.spawn('pdftotext', [
        '-q',
        '-enc',
        'UTF-8',
        '-f',
        `${pageNumber}`,
        '-l',
        `${pageNumber}`,
        path,
        '-',
      ]);
      const lines: string[] = [];
      const rl = readline.createInterface({ input: child.stdout });

      rl.on('line', (line) => lines.push(line));
      child.on('error', (error) => {
        if ((error as NodeJS.ErrnoException).code === 'ENOENT') {
          if (!this.hasLoggedMissingPdftotext) {
            this.logger.warn('pdftotext is not available, skipping PDF text extraction');
            this.hasLoggedMissingPdftotext = true;
          }
          resolve('');
          return;
        }

        this.logger.warn(`pdftotext failed for page ${pageNumber}: ${error}`);
        resolve('');
      });
      child.on('close', (code) => {
        if (code !== 0) {
          resolve('');
          return;
        }

        resolve(lines.join('\n').trim());
      });
    });
  }

  private async ocrTextlessPages(
    inputPath: string,
    pages: Array<{ pageNumber: number; text: string; textSource: 'embedded' | 'none' | 'ocr' }>,
    ocrConfig: Parameters<typeof this.machineLearningRepository.ocr>[1],
  ): Promise<number> {
    const candidates = pages.filter((page) => page.textSource === 'none');
    if (candidates.length === 0) {
      return 0;
    }

    let updatedPages = 0;
    for (const page of candidates) {
      const renderedPath = await this.renderPdfPage(inputPath, page.pageNumber);
      if (!renderedPath) {
        continue;
      }

      try {
        const response = await this.machineLearningRepository.ocr(renderedPath, ocrConfig);
        const text = response.text.join(' ').trim();
        if (text.length > 0) {
          page.text = text;
          page.textSource = 'ocr';
          updatedPages++;
        }
      } catch (error) {
        this.logger.warn(`OCR failed for PDF page ${page.pageNumber}: ${error}`);
      } finally {
        await this.storageRepository.unlink(renderedPath);
        await this.storageRepository.unlinkDir(dirname(renderedPath), { recursive: true, force: true });
      }
    }

    return updatedPages;
  }

  private async renderPdfPage(inputPath: string, pageNumber: number): Promise<string | null> {
    const folder = await mkdtemp(join(tmpdir(), 'immich-pdf-'));
    const prefix = join(folder, `page-${pageNumber}`);
    const outputPath = `${prefix}.png`;

    const success = await new Promise<boolean>((resolve) => {
      const child = this.processRepository.spawn('pdftoppm', [
        '-f',
        `${pageNumber}`,
        '-l',
        `${pageNumber}`,
        '-singlefile',
        '-png',
        inputPath,
        prefix,
      ]);
      child.on('error', (error) => {
        if ((error as NodeJS.ErrnoException).code === 'ENOENT') {
          if (!this.hasLoggedMissingPdftoppm) {
            this.logger.warn('pdftoppm is not available, skipping PDF OCR fallback');
            this.hasLoggedMissingPdftoppm = true;
          }
          resolve(false);
          return;
        }

        this.logger.warn(`pdftoppm failed for PDF page ${pageNumber}: ${error}`);
        resolve(false);
      });
      child.on('close', (code) => resolve(code === 0));
    });

    if (!success) {
      await this.storageRepository.unlinkDir(folder, { recursive: true, force: true });
      return null;
    }

    return outputPath;
  }

  private toNumber(value: unknown): number | null {
    if (typeof value === 'number' && Number.isFinite(value)) {
      return value;
    }
    if (typeof value === 'string') {
      const num = Number(value);
      if (Number.isFinite(num)) {
        return num;
      }
    }
    return null;
  }

  private toStringOrNull(value: unknown): string | null {
    return typeof value === 'string' && value.length > 0 ? value : null;
  }

  private toDateOrNull(value: unknown): Date | null {
    if (value instanceof Date) {
      return value;
    }
    if (value && typeof value === 'object' && 'toDate' in value && typeof value.toDate === 'function') {
      const parsed = value.toDate() as Date;
      return parsed instanceof Date ? parsed : null;
    }
    return null;
  }

  private isPdfEnabled() {
    return this.configRepository.getEnv().pdf.enabled;
  }

  private isPdfOcrEnabled() {
    return this.configRepository.getEnv().pdf.ocrEnabled;
  }

  private getPdfMaxPagesPerDoc() {
    const value = this.configRepository.getEnv().pdf.maxPagesPerDoc;
    return Number.isFinite(value) && value > 0 ? Math.floor(value) : DEFAULT_PDF_TEXT_EXTRACTION_PAGE_LIMIT;
  }

  private getPdfMaxFileSizeBytes() {
    const value = this.configRepository.getEnv().pdf.maxFileSizeMb;
    return value !== null && Number.isFinite(value) && value > 0 ? Math.floor(value * 1024 * 1024) : 0;
  }

  private getPdfMinEmbeddedTextLength() {
    const value = this.configRepository.getEnv().pdf.minEmbeddedTextLength;
    return Number.isFinite(value) && value > 0 ? Math.floor(value) : 10;
  }

  private toInDocumentResult(pageNumber: number, text: string, query: string): PdfInDocumentSearchResultDto {
    const source = text || '';
    const haystack = source.toLowerCase();
    const needle = query.trim().toLowerCase();
    const matchIndex = Math.max(0, haystack.indexOf(needle));
    const snippetStart = Math.max(0, matchIndex - 40);
    const snippetEnd = Math.min(source.length, matchIndex + needle.length + 80);
    const snippet = source.slice(snippetStart, snippetEnd).trim();

    return {
      pageNumber,
      snippet: snippet.length > 0 ? snippet : source.slice(0, 120).trim(),
      matchIndex,
    };
  }
}
