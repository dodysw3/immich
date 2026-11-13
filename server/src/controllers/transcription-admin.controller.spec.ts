import request from 'supertest';
import { TranscriptionAdminController } from 'src/controllers/transcription-admin.controller.js';
import { Permission } from 'src/enum.js';
import { AiVideoTranscriptionService } from 'src/services/ai-video-transcription.service.js';
import { ControllerContext, automock, controllerSetup } from 'test/utils.js';

describe(TranscriptionAdminController.name, () => {
  let ctx: ControllerContext;
  const service = automock(AiVideoTranscriptionService, { args: [{ setContext: () => {} }], strict: false });

  beforeAll(async () => {
    ctx = await controllerSetup(TranscriptionAdminController, [
      { provide: AiVideoTranscriptionService, useValue: service },
    ]);
    return () => ctx.close();
  });

  beforeEach(() => {
    service.resetAllMocks();
    ctx.reset();
  });

  describe('GET /admin/transcription/coverage', () => {
    it('returns coverage counts', async () => {
      service.getCoverageCounts.mockResolvedValue({
        missing: 1,
        inProgress: 2,
        failed: 3,
        partial: 4,
        complete: 5,
        noAudio: 6,
        noSpeech: 7,
        indexCurrent: 8,
        indexPending: 9,
        indexFailed: 10,
      });

      const { status, body } = await request(ctx.getHttpServer()).get('/admin/transcription/coverage');

      expect(status).toBe(200);
      expect(body).toEqual({
        missing: 1,
        inProgress: 2,
        failed: 3,
        partial: 4,
        complete: 5,
        noAudio: 6,
        noSpeech: 7,
        indexCurrent: 8,
        indexPending: 9,
        indexFailed: 10,
      });
    });

    it('should require admin maintenance permission', async () => {
      await request(ctx.getHttpServer()).get(`/admin/transcription/coverage`);

      expect(ctx.authenticate).toHaveBeenCalledWith(
        expect.objectContaining({
          metadata: expect.objectContaining({ permission: Permission.Maintenance, adminRoute: true }),
        }),
      );
    });
  });

  describe('POST /admin/transcription/reconcile', () => {
    it('queues reconciliation', async () => {
      const { status, body } = await request(ctx.getHttpServer()).post('/admin/transcription/reconcile');

      expect(status).toBe(200);
      expect(body).toEqual({ queued: true });
      expect(service.queueReconciliation).toHaveBeenCalledTimes(1);
    });

    it('should require admin maintenance permission', async () => {
      await request(ctx.getHttpServer()).post(`/admin/transcription/reconcile`);

      expect(ctx.authenticate).toHaveBeenCalledWith(
        expect.objectContaining({
          metadata: expect.objectContaining({ permission: Permission.Maintenance, adminRoute: true }),
        }),
      );
    });
  });
});
