import request from 'supertest';
import { TranscriptionSearchController } from 'src/controllers/transcription-search.controller.js';
import { Permission } from 'src/enum.js';
import { TranscriptFrameService } from 'src/services/transcript-frame.service.js';
import { TranscriptSearchService } from 'src/services/transcript-search.service.js';
import { ControllerContext, automock, controllerSetup } from 'test/utils.js';

describe(TranscriptionSearchController.name, () => {
  let ctx: ControllerContext;
  const service = automock(TranscriptSearchService, { args: [{ setContext: () => {} }], strict: false });

  beforeAll(async () => {
    ctx = await controllerSetup(TranscriptionSearchController, [
      { provide: TranscriptSearchService, useValue: service },
      { provide: TranscriptFrameService, useValue: { resolveFrame: vi.fn() } },
    ]);
    return () => ctx.close();
  });

  beforeEach(() => {
    service.resetAllMocks();
    ctx.reset();
  });

  describe('POST /search/transcription', () => {
    it('should require asset read permission and pass through the query', async () => {
      service.searchTranscription.mockResolvedValue({ count: 0, items: [], nextCursor: null, configVersion: 'x' });

      const { status } = await request(ctx.getHttpServer())
        .post('/search/transcription')
        .send({ q: 'boarding announcement' });

      expect(status).toBe(200);
      expect(service.searchTranscription).toHaveBeenCalledWith(
        undefined,
        expect.objectContaining({ q: 'boarding announcement', size: 20 }),
      );
      expect(ctx.authenticate).toHaveBeenCalledWith(
        expect.objectContaining({ metadata: expect.objectContaining({ permission: Permission.AssetRead }) }),
      );
    });

    it('rejects empty and oversized queries', async () => {
      const empty = await request(ctx.getHttpServer())
        .post('/search/transcription')
        .send({ q: ' '.repeat(3) });
      const oversized = await request(ctx.getHttpServer())
        .post('/search/transcription')
        .send({ q: 'x'.repeat(201) });

      expect(empty.status).toBe(400);
      expect(oversized.status).toBe(400);
    });
  });

  describe('POST /search/transcription/moments', () => {
    it('should require asset read permission', async () => {
      service.searchMoments.mockResolvedValue({ count: 0, moments: [], nextCursor: null, configVersion: 'x' });

      await request(ctx.getHttpServer())
        .post('/search/transcription/moments')
        .send({ assetId: '0b5e0b5e-0b5e-4b5e-8b5e-0b5e0b5e0b5e', q: 'x' });

      expect(ctx.authenticate).toHaveBeenCalledWith(
        expect.objectContaining({ metadata: expect.objectContaining({ permission: Permission.AssetRead }) }),
      );
    });
  });
});
