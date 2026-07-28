import { SyncController } from 'src/controllers/sync.controller';
import { GlobalExceptionFilter } from 'src/middleware/global-exception.filter';
import { SyncService } from 'src/services/sync.service';
import request from 'supertest';
import { errorDto } from 'test/medium/responses';
import { ControllerContext, controllerSetup, mockBaseService } from 'test/utils';

describe(SyncController.name, () => {
  let ctx: ControllerContext;
  const syncService = mockBaseService(SyncService);
  const errorService = { handleError: vi.fn() };

  beforeAll(async () => {
    ctx = await controllerSetup(SyncController, [
      { provide: SyncService, useValue: syncService },
      { provide: GlobalExceptionFilter, useValue: errorService },
    ]);
    return () => ctx.close();
  });

  beforeEach(() => {
    syncService.resetAllMocks();
    errorService.handleError.mockReset();
    ctx.reset();
  });

  describe('POST /sync/stream', () => {
    it('should be an authenticated route', async () => {
      await request(ctx.getHttpServer()).post('/sync/stream');
      expect(ctx.authenticate).toHaveBeenCalled();
    });

    it('should require sync request type enums', async () => {
      const { status, body } = await request(ctx.getHttpServer())
        .post('/sync/stream')
        .send({ types: ['invalid'] });
      expect(status).toBe(400);
      expect(body).toEqual(
        errorDto.validationError([
          { path: ['types', 0], message: expect.stringContaining('Invalid option: expected one of') },
        ]),
      );
      expect(ctx.authenticate).toHaveBeenCalled();
    });

    it('should handle errors after headers are sent', async () => {
      syncService.stream.mockImplementation((_auth: any, res: any, _dto: any) => {
        res.write('data\n');
        return Promise.reject(new Error('stream error after headers sent'));
      });

      const { status } = await request(ctx.getHttpServer())
        .post('/sync/stream')
        .set('Authorization', 'Bearer test')
        .send({ types: ['AssetsV1'] })
        .buffer(true)
        .parse((res, callback) => {
          const data: Buffer[] = [];
          res.on('data', (chunk: Buffer) => {
            data.push(chunk);
          });
          res.on('end', () => callback(null, Buffer.concat(data)));
        });

      expect(status).toBe(200);
      expect(errorService.handleError).toHaveBeenCalledWith(
        expect.anything(),
        expect.objectContaining({ message: 'stream error after headers sent' }),
      );
    });
  });

  describe('GET /sync/ack', () => {
    it('should be an authenticated route', async () => {
      await request(ctx.getHttpServer()).get('/sync/ack');
      expect(ctx.authenticate).toHaveBeenCalled();
    });
  });

  describe('POST /sync/ack', () => {
    it('should be an authenticated route', async () => {
      await request(ctx.getHttpServer()).post('/sync/ack');
      expect(ctx.authenticate).toHaveBeenCalled();
    });

    it('should not allow more than 1,000 entries', async () => {
      const acks = Array.from({ length: 1001 }, (_, i) => `ack-${i}`);
      const { status, body } = await request(ctx.getHttpServer()).post('/sync/ack').send({ acks });
      expect(status).toBe(400);
      expect(body).toEqual(
        errorDto.validationError([{ path: ['acks'], message: 'Too big: expected array to have <=1000 items' }]),
      );
      expect(ctx.authenticate).toHaveBeenCalled();
    });
  });

  describe('DELETE /sync/ack', () => {
    it('should be an authenticated route', async () => {
      await request(ctx.getHttpServer()).delete('/sync/ack');
      expect(ctx.authenticate).toHaveBeenCalled();
    });

    it('should require sync response type enums', async () => {
      const { status, body } = await request(ctx.getHttpServer())
        .delete('/sync/ack')
        .send({ types: ['invalid'] });
      expect(status).toBe(400);
      expect(body).toEqual(
        errorDto.validationError([
          { path: ['types', 0], message: expect.stringContaining('Invalid option: expected one of') },
        ]),
      );
      expect(ctx.authenticate).toHaveBeenCalled();
    });
  });
});
