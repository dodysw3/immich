import { PdfController } from 'src/pdf/controllers/pdf.controller';
import { PdfService } from 'src/pdf/services/pdf.service';
import { AssetMediaService } from 'src/services/asset-media.service';
import request from 'supertest';
import { errorDto } from 'test/medium/responses';
import { ControllerContext, controllerSetup, mockBaseService } from 'test/utils';

describe(PdfController.name, () => {
  let ctx: ControllerContext;
  const service = mockBaseService(PdfService);
  const assetMediaService = mockBaseService(AssetMediaService);

  beforeAll(async () => {
    ctx = await controllerSetup(PdfController, [
      { provide: PdfService, useValue: service },
      { provide: AssetMediaService, useValue: assetMediaService },
    ]);
    return () => ctx.close();
  });

  beforeEach(() => {
    service.resetAllMocks();
    assetMediaService.resetAllMocks();
    ctx.reset();
  });

  describe('GET /pdf/assets', () => {
    it('should be an authenticated route', async () => {
      await request(ctx.getHttpServer()).get('/pdf/assets');
      expect(ctx.authenticate).toHaveBeenCalled();
    });
  });

  describe('GET /pdf/assets/:id', () => {
    it('should be an authenticated route', async () => {
      await request(ctx.getHttpServer()).get('/pdf/assets/12345678-1234-1234-1234-123456789abc');
      expect(ctx.authenticate).toHaveBeenCalled();
    });

    it('should reject an invalid uuid', async () => {
      const { status, body } = await request(ctx.getHttpServer()).get('/pdf/assets/invalid-uuid');
      expect(status).toBe(400);
      expect(body).toEqual(errorDto.badRequest(['id must be a valid UUID']));
    });
  });

  describe('GET /pdf/assets/:id/pages', () => {
    it('should be an authenticated route', async () => {
      await request(ctx.getHttpServer()).get('/pdf/assets/12345678-1234-1234-1234-123456789abc/pages');
      expect(ctx.authenticate).toHaveBeenCalled();
    });

    it('should reject an invalid uuid', async () => {
      const { status, body } = await request(ctx.getHttpServer()).get('/pdf/assets/invalid-uuid/pages');
      expect(status).toBe(400);
      expect(body).toEqual(errorDto.badRequest(['id must be a valid UUID']));
    });
  });

  describe('GET /pdf/assets/:id/pages/:pageNumber', () => {
    it('should be an authenticated route', async () => {
      await request(ctx.getHttpServer()).get('/pdf/assets/12345678-1234-1234-1234-123456789abc/pages/1');
      expect(ctx.authenticate).toHaveBeenCalled();
    });

    it('should reject an invalid uuid', async () => {
      const { status, body } = await request(ctx.getHttpServer()).get('/pdf/assets/invalid-uuid/pages/1');
      expect(status).toBe(400);
      expect(body).toEqual(errorDto.badRequest(['id must be a valid UUID']));
    });

    it('should reject page number as not a number', async () => {
      const { status, body } = await request(ctx.getHttpServer()).get(
        '/pdf/assets/12345678-1234-1234-1234-123456789abc/pages/abc',
      );
      expect(status).toBe(400);
      expect(body).toEqual(errorDto.badRequest(['pageNumber must be a number conforming to the specified constraints']));
    });
  });

  describe('GET /pdf/assets/:id/download', () => {
    it('should be an authenticated route', async () => {
      await request(ctx.getHttpServer()).get('/pdf/assets/12345678-1234-1234-1234-123456789abc/download');
      expect(ctx.authenticate).toHaveBeenCalled();
    });

    it('should reject an invalid uuid', async () => {
      const { status, body } = await request(ctx.getHttpServer()).get('/pdf/assets/invalid-uuid/download');
      expect(status).toBe(400);
      expect(body).toEqual(errorDto.badRequest(['id must be a valid UUID']));
    });
  });

  describe('GET /pdf/page/:id/image', () => {
    it('should be an authenticated route', async () => {
      await request(ctx.getHttpServer()).get('/pdf/page/12345678-1234-1234-1234-123456789abc/image');
      expect(ctx.authenticate).toHaveBeenCalled();
    });

    it('should reject an invalid uuid', async () => {
      const { status, body } = await request(ctx.getHttpServer()).get('/pdf/page/invalid-uuid/image');
      expect(status).toBe(400);
      expect(body).toEqual(errorDto.badRequest(['id must be a valid UUID']));
    });
  });

  describe('POST /pdf/upload', () => {
    it('should be an authenticated route', async () => {
      await request(ctx.getHttpServer()).post('/pdf/upload');
      expect(ctx.authenticate).toHaveBeenCalled();
    });
  });
});
