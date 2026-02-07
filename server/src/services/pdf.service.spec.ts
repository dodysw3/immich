import { AssetType, ImmichWorker, JobName, JobStatus } from 'src/enum';
import { PdfService } from 'src/services/pdf.service';
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

describe(PdfService.name, () => {
  let sut: PdfService;
  let mocks: ServiceMocks;

  beforeEach(() => {
    ({ sut, mocks } = newTestService(PdfService));
    mocks.config.getWorker.mockReturnValue(ImmichWorker.Microservices);
    mocks.pdf.isPdfAsset.mockReturnValue(true);
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
          createdAt: new Date('2026-02-06T00:00:00.000Z'),
        },
      ],
      hasNextPage: false,
    });
    mocks.pdf.getMatchingPages.mockResolvedValue([{ pageNumber: 2 }, { pageNumber: 9 }]);

    const result = await sut.search({ user: { id: 'user-1' } } as any, { query: 'revenue', page: 1, size: 50 });

    expect(mocks.pdf.searchByText).toHaveBeenCalledWith('user-1', 'revenue', { page: 1, size: 50 });
    expect(mocks.pdf.getMatchingPages).toHaveBeenCalledWith('asset-5', 'revenue');
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
});
