import { AssetType, ImmichWorker, JobName, JobStatus } from 'src/enum';
import { PdfService } from 'src/services/pdf.service';
import { mockEnvData } from 'test/repositories/config.repository.mock';
import { makeStream, newTestService, ServiceMocks } from 'test/utils';
import { EventEmitter } from 'node:events';
import { PassThrough } from 'node:stream';

const makeChildProcess = (output: string, code = 0) => {
  const child = new EventEmitter() as any;
  child.stdout = new PassThrough();
  child.stderr = new PassThrough();

  queueMicrotask(() => {
    if (output) {
      child.stdout.write(output);
    }
    child.stdout.end();
    child.emit('close', code);
  });

  return child;
};

const makeErroredChildProcess = (error: NodeJS.ErrnoException) => {
  const child = new EventEmitter() as any;
  child.stdout = new PassThrough();
  child.stderr = new PassThrough();

  queueMicrotask(() => {
    child.emit('error', error);
    child.stdout.end();
  });

  return child;
};

describe(PdfService.name, () => {
  let sut: PdfService;
  let mocks: ServiceMocks;

  beforeEach(() => {
    ({ sut, mocks } = newTestService(PdfService));
    mocks.config.getWorker.mockReturnValue(ImmichWorker.Microservices);
    mocks.pdf.isPdfAsset.mockReturnValue(true);
    mocks.config.getEnv.mockReturnValue(mockEnvData({}));
  });

  it('should queue PDF process on metadata extraction for PDFs', async () => {
    mocks.pdf.getAssetForProcessing.mockResolvedValue({
      id: 'asset-1',
      ownerId: 'user-1',
      originalPath: '/uploads/doc.pdf',
      originalFileName: 'doc.pdf',
      type: AssetType.Other,
      deletedAt: null,
    });

    await sut.onAssetMetadataExtracted({ assetId: 'asset-1', userId: 'user-1' });

    expect(mocks.job.queue).toHaveBeenCalledWith({ name: JobName.PdfProcess, data: { id: 'asset-1' } });
  });

  it('should skip queueing when PDF_ENABLE is false', async () => {
    mocks.config.getEnv.mockReturnValue(
      mockEnvData({ pdf: { enabled: false, ocrEnabled: true, maxPagesPerDoc: 250, maxFileSizeMb: null } }),
    );
    mocks.pdf.getAssetForProcessing.mockResolvedValue({
      id: 'asset-disabled',
      ownerId: 'user-1',
      originalPath: '/uploads/doc.pdf',
      originalFileName: 'doc.pdf',
      type: AssetType.Other,
      deletedAt: null,
    });

    await sut.onAssetMetadataExtracted({ assetId: 'asset-disabled', userId: 'user-1' });

    expect(mocks.job.queue).not.toHaveBeenCalled();
  });

  it('should ignore non-PDF assets on metadata extraction', async () => {
    mocks.pdf.isPdfAsset.mockReturnValue(false);
    mocks.pdf.getAssetForProcessing.mockResolvedValue({
      id: 'asset-2',
      ownerId: 'user-1',
      originalPath: '/uploads/image.jpg',
      originalFileName: 'image.jpg',
      type: AssetType.Image,
      deletedAt: null,
    });

    await sut.onAssetMetadataExtracted({ assetId: 'asset-2', userId: 'user-1' });

    expect(mocks.job.queue).not.toHaveBeenCalled();
  });

  it('should queue all discovered PDF assets', async () => {
    mocks.pdf.streamPdfAssetIds.mockReturnValue(makeStream([{ id: 'a1' }, { id: 'a2' }]));

    const result = await sut.handleQueueAll({ force: false });

    expect(result).toBe(JobStatus.Success);
    expect(mocks.pdf.streamPdfAssetIds).toHaveBeenCalledWith(false);
    expect(mocks.job.queueAll).toHaveBeenCalledWith([
      { name: JobName.PdfProcess, data: { id: 'a1' } },
      { name: JobName.PdfProcess, data: { id: 'a2' } },
    ]);
  });

  it('should skip processing when asset is missing', async () => {
    mocks.pdf.getAssetForProcessing.mockResolvedValue(undefined);

    const result = await sut.handlePdfProcess({ id: 'missing-id' });

    expect(result).toBe(JobStatus.Skipped);
    expect(mocks.pdf.upsertDocument).not.toHaveBeenCalled();
  });

  it('should process metadata and index empty page set for 0-page PDFs', async () => {
    mocks.pdf.getAssetForProcessing.mockResolvedValue({
      id: 'asset-3',
      ownerId: 'user-1',
      originalPath: '/uploads/zero.pdf',
      originalFileName: 'zero.pdf',
      type: AssetType.Other,
      deletedAt: null,
    });
    mocks.metadata.readTags.mockResolvedValue({ PageCount: 0, Title: 'Zero' } as any);

    const result = await sut.handlePdfProcess({ id: 'asset-3' });

    expect(result).toBe(JobStatus.Success);
    expect(mocks.pdf.upsertDocument).toHaveBeenCalledWith(
      expect.objectContaining({ assetId: 'asset-3', pageCount: 0, title: 'Zero' }),
    );
    expect(mocks.pdf.replacePages).toHaveBeenCalledWith('asset-3', []);
    expect(mocks.pdf.upsertSearch).toHaveBeenCalledWith('asset-3', '');
  });

  it('should run OCR fallback for textless pages', async () => {
    mocks.pdf.getAssetForProcessing.mockResolvedValue({
      id: 'asset-4',
      ownerId: 'user-1',
      originalPath: '/uploads/scan.pdf',
      originalFileName: 'scan.pdf',
      type: AssetType.Other,
      deletedAt: null,
    });
    mocks.metadata.readTags.mockResolvedValue({ PageCount: 1, Title: 'Scan' } as any);
    mocks.process.spawn.mockImplementation((command: string) => {
      if (command === 'pdfinfo') {
        return makeChildProcess('Page    1 size:      612 x 792 pts (letter)');
      }
      if (command === 'pdftotext') {
        return makeChildProcess('');
      }
      if (command === 'pdftoppm') {
        return makeChildProcess('');
      }
      throw new Error(`Unexpected command: ${command}`);
    });
    mocks.machineLearning.ocr.mockResolvedValue({
      box: [],
      boxScore: [],
      text: ['hello from ocr'],
      textScore: [],
    });

    const result = await sut.handlePdfProcess({ id: 'asset-4' });

    expect(result).toBe(JobStatus.Success);
    expect(mocks.machineLearning.ocr).toHaveBeenCalledTimes(1);
    expect(mocks.pdf.replacePages).toHaveBeenCalledWith(
      'asset-4',
      expect.arrayContaining([
        expect.objectContaining({
          pageNumber: 1,
          text: 'hello from ocr',
          textSource: 'ocr',
        }),
      ]),
    );
  });

  it('should skip OCR fallback when PDF_OCR_ENABLE is false', async () => {
    mocks.config.getEnv.mockReturnValue(
      mockEnvData({ pdf: { enabled: true, ocrEnabled: false, maxPagesPerDoc: 250, maxFileSizeMb: null } }),
    );
    mocks.pdf.getAssetForProcessing.mockResolvedValue({
      id: 'asset-4c',
      ownerId: 'user-1',
      originalPath: '/uploads/scan-no-ocr.pdf',
      originalFileName: 'scan-no-ocr.pdf',
      type: AssetType.Other,
      deletedAt: null,
    });
    mocks.metadata.readTags.mockResolvedValue({ PageCount: 1, Title: 'Scan' } as any);
    mocks.process.spawn.mockImplementation((command: string) => {
      if (command === 'pdfinfo') {
        return makeChildProcess('Page    1 size:      612 x 792 pts (letter)');
      }
      if (command === 'pdftotext') {
        return makeChildProcess('');
      }
      if (command === 'pdftoppm') {
        return makeChildProcess('');
      }
      throw new Error(`Unexpected command: ${command}`);
    });

    const result = await sut.handlePdfProcess({ id: 'asset-4c' });

    expect(result).toBe(JobStatus.Success);
    expect(mocks.machineLearning.ocr).not.toHaveBeenCalled();
    expect(mocks.pdf.replacePages).toHaveBeenCalledWith(
      'asset-4c',
      expect.arrayContaining([expect.objectContaining({ textSource: 'none' })]),
    );
  });

  it('should skip text extraction when page count exceeds PDF_MAX_PAGES_PER_DOC', async () => {
    mocks.config.getEnv.mockReturnValue(
      mockEnvData({ pdf: { enabled: true, ocrEnabled: true, maxPagesPerDoc: 1, maxFileSizeMb: null } }),
    );
    mocks.pdf.getAssetForProcessing.mockResolvedValue({
      id: 'asset-4d',
      ownerId: 'user-1',
      originalPath: '/uploads/large.pdf',
      originalFileName: 'large.pdf',
      type: AssetType.Other,
      deletedAt: null,
    });
    mocks.metadata.readTags.mockResolvedValue({ PageCount: 5, Title: 'Large' } as any);

    const result = await sut.handlePdfProcess({ id: 'asset-4d' });

    expect(result).toBe(JobStatus.Success);
    expect(mocks.process.spawn).not.toHaveBeenCalled();
    expect(mocks.pdf.replacePages).toHaveBeenCalledWith('asset-4d', []);
  });

  it('should run OCR fallback for low-text pages', async () => {
    mocks.pdf.getAssetForProcessing.mockResolvedValue({
      id: 'asset-4b',
      ownerId: 'user-1',
      originalPath: '/uploads/scan-low-text.pdf',
      originalFileName: 'scan-low-text.pdf',
      type: AssetType.Other,
      deletedAt: null,
    });
    mocks.metadata.readTags.mockResolvedValue({ PageCount: 1, Title: 'Scan' } as any);
    mocks.process.spawn.mockImplementation((command: string) => {
      if (command === 'pdfinfo') {
        return makeChildProcess('Page    1 size:      612 x 792 pts (letter)');
      }
      if (command === 'pdftotext') {
        return makeChildProcess('tiny');
      }
      if (command === 'pdftoppm') {
        return makeChildProcess('');
      }
      throw new Error(`Unexpected command: ${command}`);
    });
    mocks.machineLearning.ocr.mockResolvedValue({
      box: [],
      boxScore: [],
      text: ['ocr replacement text'],
      textScore: [],
    });

    const result = await sut.handlePdfProcess({ id: 'asset-4b' });

    expect(result).toBe(JobStatus.Success);
    expect(mocks.machineLearning.ocr).toHaveBeenCalledTimes(1);
    expect(mocks.pdf.replacePages).toHaveBeenCalledWith(
      'asset-4b',
      expect.arrayContaining([
        expect.objectContaining({
          pageNumber: 1,
          text: 'ocr replacement text',
          textSource: 'ocr',
        }),
      ]),
    );
  });

  it('should store page width and height from pdfinfo output', async () => {
    mocks.pdf.getAssetForProcessing.mockResolvedValue({
      id: 'asset-dimensions',
      ownerId: 'user-1',
      originalPath: '/uploads/report.pdf',
      originalFileName: 'report.pdf',
      type: AssetType.Other,
      deletedAt: null,
    });
    mocks.metadata.readTags.mockResolvedValue({ PageCount: 1, Title: 'Report' } as any);
    mocks.process.spawn.mockImplementation((command: string) => {
      if (command === 'pdfinfo') {
        return makeChildProcess('Page    1 size:      595.2 x 841.8 pts (A4)\n');
      }
      if (command === 'pdftotext') {
        return makeChildProcess('enough text for embedded extraction\n');
      }
      throw new Error(`Unexpected command: ${command}`);
    });

    const result = await sut.handlePdfProcess({ id: 'asset-dimensions' });

    expect(result).toBe(JobStatus.Success);
    expect(mocks.pdf.replacePages).toHaveBeenCalledWith(
      'asset-dimensions',
      expect.arrayContaining([expect.objectContaining({ pageNumber: 1, width: 595.2, height: 841.8 })]),
    );
  });

  it('should continue indexing when pdfinfo is not installed and log once', async () => {
    mocks.pdf.getAssetForProcessing
      .mockResolvedValueOnce({
        id: 'asset-missing-pdfinfo-1',
        ownerId: 'user-1',
        originalPath: '/uploads/m1.pdf',
        originalFileName: 'm1.pdf',
        type: AssetType.Other,
        deletedAt: null,
      })
      .mockResolvedValueOnce({
        id: 'asset-missing-pdfinfo-2',
        ownerId: 'user-1',
        originalPath: '/uploads/m2.pdf',
        originalFileName: 'm2.pdf',
        type: AssetType.Other,
        deletedAt: null,
      });
    mocks.metadata.readTags.mockResolvedValue({ PageCount: 1, Title: 'MissingPdfinfo' } as any);
    mocks.process.spawn.mockImplementation((command: string) => {
      if (command === 'pdfinfo') {
        return makeErroredChildProcess({ code: 'ENOENT' } as NodeJS.ErrnoException);
      }
      if (command === 'pdftotext') {
        return makeChildProcess('enough embedded text\n');
      }
      throw new Error(`Unexpected command: ${command}`);
    });

    const firstResult = await sut.handlePdfProcess({ id: 'asset-missing-pdfinfo-1' });
    const secondResult = await sut.handlePdfProcess({ id: 'asset-missing-pdfinfo-2' });

    expect(firstResult).toBe(JobStatus.Success);
    expect(secondResult).toBe(JobStatus.Success);
    expect(mocks.logger.warn).toHaveBeenCalledWith('pdfinfo is not available, skipping PDF page dimensions');
    expect(
      mocks.logger.warn.mock.calls.filter((call) => call[0] === 'pdfinfo is not available, skipping PDF page dimensions'),
    ).toHaveLength(1);
    expect(mocks.pdf.replacePages).toHaveBeenCalledWith(
      'asset-missing-pdfinfo-1',
      expect.arrayContaining([expect.objectContaining({ pageNumber: 1, width: null, height: null })]),
    );
    expect(mocks.pdf.replacePages).toHaveBeenCalledWith(
      'asset-missing-pdfinfo-2',
      expect.arrayContaining([expect.objectContaining({ pageNumber: 1, width: null, height: null })]),
    );
  });

  it('should continue indexing when pdfinfo exits with non-zero status', async () => {
    mocks.pdf.getAssetForProcessing.mockResolvedValue({
      id: 'asset-pdfinfo-nonzero',
      ownerId: 'user-1',
      originalPath: '/uploads/nonzero.pdf',
      originalFileName: 'nonzero.pdf',
      type: AssetType.Other,
      deletedAt: null,
    });
    mocks.metadata.readTags.mockResolvedValue({ PageCount: 1, Title: 'NonZero' } as any);
    mocks.process.spawn.mockImplementation((command: string) => {
      if (command === 'pdfinfo') {
        return makeChildProcess('', 1);
      }
      if (command === 'pdftotext') {
        return makeChildProcess('embedded text\n');
      }
      throw new Error(`Unexpected command: ${command}`);
    });

    const result = await sut.handlePdfProcess({ id: 'asset-pdfinfo-nonzero' });

    expect(result).toBe(JobStatus.Success);
    expect(mocks.pdf.replacePages).toHaveBeenCalledWith(
      'asset-pdfinfo-nonzero',
      expect.arrayContaining([expect.objectContaining({ pageNumber: 1, width: null, height: null })]),
    );
  });

  it('should include matching pages in search response', async () => {
    mocks.pdf.searchByText.mockResolvedValue({
      items: [
        {
          assetId: 'asset-5',
          originalFileName: 'report.pdf',
          pageCount: 12,
          title: 'Report',
          author: 'Alice',
          processedAt: new Date('2026-02-07T00:00:00.000Z'),
          status: 'ready',
          lastError: null,
          createdAt: new Date('2026-02-06T00:00:00.000Z'),
        },
      ],
      hasNextPage: false,
    });
    mocks.pdf.getMatchingPagesByAssets.mockResolvedValue([
      { assetId: 'asset-5', pageNumber: 2 },
      { assetId: 'asset-5', pageNumber: 9 },
    ]);

    const result = await sut.search({ user: { id: 'user-1' } } as any, { query: 'revenue', page: 1, size: 50 });

    expect(mocks.pdf.searchByText).toHaveBeenCalledWith('user-1', 'revenue', { page: 1, size: 50 });
    expect(mocks.pdf.getMatchingPagesByAssets).toHaveBeenCalledWith(['asset-5'], 'revenue');
    expect(result).toEqual({
      items: [
        expect.objectContaining({
          assetId: 'asset-5',
          originalFileName: 'report.pdf',
          matchingPages: [2, 9],
        }),
      ],
      nextPage: null,
    });
  });

  it('should return empty search results for whitespace-only query', async () => {
    const result = await sut.search({ user: { id: 'user-1' } } as any, { query: '   ', page: 1, size: 50 });

    expect(result).toEqual({ items: [], nextPage: null });
    expect(mocks.pdf.searchByText).not.toHaveBeenCalled();
    expect(mocks.pdf.getMatchingPagesByAssets).not.toHaveBeenCalled();
  });

  it('should group matching pages by asset for multi-document search', async () => {
    mocks.pdf.searchByText.mockResolvedValue({
      items: [
        {
          assetId: 'asset-a',
          originalFileName: 'alpha.pdf',
          pageCount: 5,
          title: 'Alpha',
          author: null,
          processedAt: new Date('2026-02-07T00:00:00.000Z'),
          status: 'ready',
          lastError: null,
          createdAt: new Date('2026-02-06T00:00:00.000Z'),
        },
        {
          assetId: 'asset-b',
          originalFileName: 'beta.pdf',
          pageCount: 8,
          title: 'Beta',
          author: null,
          processedAt: new Date('2026-02-07T00:00:00.000Z'),
          status: 'ready',
          lastError: null,
          createdAt: new Date('2026-02-05T00:00:00.000Z'),
        },
      ],
      hasNextPage: false,
    });
    mocks.pdf.getMatchingPagesByAssets.mockResolvedValue([
      { assetId: 'asset-a', pageNumber: 3 },
      { assetId: 'asset-a', pageNumber: 4 },
      { assetId: 'asset-b', pageNumber: 1 },
    ]);

    const result = await sut.search({ user: { id: 'user-1' } } as any, { query: 'project', page: 1, size: 50 });

    expect(mocks.pdf.getMatchingPagesByAssets).toHaveBeenCalledWith(['asset-a', 'asset-b'], 'project');
    expect(result.items).toEqual([
      expect.objectContaining({ assetId: 'asset-a', matchingPages: [3, 4] }),
      expect.objectContaining({ assetId: 'asset-b', matchingPages: [1] }),
    ]);
  });

  it('should return snippets for in-document search', async () => {
    mocks.pdf.getDocumentByOwner.mockResolvedValue({
      assetId: 'asset-6',
      originalFileName: 'memo.pdf',
      pageCount: 3,
      title: 'Memo',
      author: null,
      processedAt: null,
      status: 'ready',
      lastError: null,
      createdAt: new Date('2026-02-06T00:00:00.000Z'),
    });
    mocks.pdf.searchPagesByOwner.mockResolvedValue([
      { pageNumber: 2, text: 'This is a longer paragraph about quarterly revenue growth and forecasts.' },
    ]);

    const result = await sut.searchInDocument({ user: { id: 'user-1' } } as any, 'asset-6', { query: 'revenue' });

    expect(mocks.pdf.searchPagesByOwner).toHaveBeenCalledWith('user-1', 'asset-6', 'revenue');
    expect(result).toEqual([
      expect.objectContaining({
        pageNumber: 2,
        matchIndex: expect.any(Number),
      }),
    ]);
    expect(result[0]!.snippet.toLowerCase()).toContain('revenue');
  });

  it('should return empty in-document results for whitespace-only query', async () => {
    mocks.pdf.getDocumentByOwner.mockResolvedValue({
      assetId: 'asset-6',
      originalFileName: 'memo.pdf',
      pageCount: 3,
      title: 'Memo',
      author: null,
      processedAt: null,
      status: 'ready',
      lastError: null,
      createdAt: new Date('2026-02-06T00:00:00.000Z'),
    });

    const result = await sut.searchInDocument({ user: { id: 'user-1' } } as any, 'asset-6', { query: '   ' });

    expect(result).toEqual([]);
    expect(mocks.pdf.searchPagesByOwner).not.toHaveBeenCalled();
  });

  it('should queue reprocess for an owned document', async () => {
    mocks.pdf.getDocumentByOwner.mockResolvedValue({
      assetId: 'asset-7',
      originalFileName: 'retry.pdf',
      pageCount: 2,
      title: 'Retry',
      author: null,
      processedAt: null,
      status: 'failed',
      lastError: 'test error',
      createdAt: new Date('2026-02-06T00:00:00.000Z'),
    });

    await sut.reprocessDocument({ user: { id: 'user-1' } } as any, 'asset-7');

    expect(mocks.pdf.updateDocumentStatus).toHaveBeenCalledWith('asset-7', 'pending', null);
    expect(mocks.job.queue).toHaveBeenCalledWith({ name: JobName.PdfProcess, data: { id: 'asset-7' } });
  });
});
