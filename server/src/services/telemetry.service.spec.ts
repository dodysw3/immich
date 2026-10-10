import { JobName, JobStatus, QueueName } from 'src/enum.js';
import { TelemetryService } from 'src/services/telemetry.service.js';
import { ServiceMocks, newTestService } from 'test/utils.js';

describe(TelemetryService.name, () => {
  let sut: TelemetryService;
  let mocks: ServiceMocks;

  beforeEach(() => {
    ({ sut, mocks } = newTestService(TelemetryService));
  });

  describe('onJobSuccess', () => {
    it('should record duration and count status', () => {
      sut.onJobSuccess({
        job: { name: JobName.Ocr, data: { id: 'asset-1' }, processedOn: Date.now() - 500 },
        response: JobStatus.Success,
      });

      expect(mocks.telemetry.jobs.recordHistogram).toHaveBeenCalledWith(
        'immich.jobs.duration',
        expect.any(Number),
        { job_name: 'ocr' },
        { unit: 'ms', description: 'Duration in ms of each job run, labeled by job name' },
      );
      expect(mocks.telemetry.jobs.addToCounter).toHaveBeenCalledWith('immich.jobs.ocr.success', 1);
    });

    it('should record duration even when the handler does not return a job status', () => {
      sut.onJobSuccess({
        job: { name: JobName.Ocr, data: { id: 'asset-1' }, processedOn: Date.now() - 100 },
        response: undefined,
      });

      expect(mocks.telemetry.jobs.recordHistogram).toHaveBeenCalled();
      expect(mocks.telemetry.jobs.addToCounter).not.toHaveBeenCalled();
    });

    it('should skip duration when processedOn is missing', () => {
      sut.onJobSuccess({ job: { name: JobName.Ocr, data: { id: 'asset-1' } }, response: JobStatus.Success });

      expect(mocks.telemetry.jobs.recordHistogram).not.toHaveBeenCalled();
      expect(mocks.telemetry.jobs.addToCounter).toHaveBeenCalledWith('immich.jobs.ocr.success', 1);
    });
  });

  describe('onJobError', () => {
    it('should record duration and count failure', () => {
      sut.onJobError({
        job: { name: JobName.AssetDetectFaces, data: { id: 'asset-1' }, processedOn: Date.now() - 2000 },
        error: new Error('boom'),
      });

      expect(mocks.telemetry.jobs.recordHistogram).toHaveBeenCalledWith(
        'immich.jobs.duration',
        expect.any(Number),
        { job_name: 'asset_detect_faces' },
        { unit: 'ms', description: 'Duration in ms of each job run, labeled by job name' },
      );
      expect(mocks.telemetry.jobs.addToCounter).toHaveBeenCalledWith('immich.jobs.asset_detect_faces.failed', 1);
    });

    it('should count failure without duration when processedOn is missing', () => {
      sut.onJobError({ job: { name: JobName.Ocr, data: { id: 'asset-1' } }, error: new Error('boom') });

      expect(mocks.telemetry.jobs.recordHistogram).not.toHaveBeenCalled();
      expect(mocks.telemetry.jobs.addToCounter).toHaveBeenCalledWith('immich.jobs.ocr.failed', 1);
    });
  });

  describe('onJobStart/onJobComplete', () => {
    it('should track the active gauge', () => {
      sut.onJobStart(QueueName.Ocr, { name: JobName.Ocr, data: { id: 'asset-1' } });
      sut.onJobComplete(QueueName.Ocr, { name: JobName.Ocr, data: { id: 'asset-1' } });

      expect(mocks.telemetry.jobs.addToGauge).toHaveBeenNthCalledWith(1, 'immich.queues.ocr.active', 1);
      expect(mocks.telemetry.jobs.addToGauge).toHaveBeenNthCalledWith(2, 'immich.queues.ocr.active', -1);
    });
  });
});
