import { MetricAttributes, ObservableResult } from '@opentelemetry/api';
import type { LabelCount, Quantiles } from 'src/repositories/library-stats.repository.js';
import { OnEvent } from 'src/decorators.js';
import { ImmichTelemetry, ImmichWorker } from 'src/enum.js';
import { BaseService } from 'src/services/base.service.js';

const POLL_INTERVAL_MS = 5 * 60 * 1000;

type LibraryStats = {
  collectedAt: number;
  pollMs: number;
  assets: { photo: number; video: number; pdf: number; total: number; unlocated: number };
  persons: { total: number; labeled: number; hidden: number };
  faces: { assigned: number; unassigned: number };
  facesPerPhoto: Quantiles;
  ocr: { visible: number; hidden: number };
  ocrCharsPerPhoto: Quantiles;
  byTag: LabelCount[];
  byAlbum: LabelCount[];
  byCity: LabelCount[];
  byCountry: LabelCount[];
};

const EMPTY_STATS: LibraryStats = {
  collectedAt: 0,
  pollMs: 0,
  assets: { photo: 0, video: 0, pdf: 0, total: 0, unlocated: 0 },
  persons: { total: 0, labeled: 0, hidden: 0 },
  faces: { assigned: 0, unassigned: 0 },
  facesPerPhoto: { p50: null, p95: null, assets: 0 },
  ocr: { visible: 0, hidden: 0 },
  ocrCharsPerPhoto: { p50: null, p95: null, assets: 0 },
  byTag: [],
  byAlbum: [],
  byCity: [],
  byCountry: [],
};

export class LibraryStatsService extends BaseService {
  private timer: ReturnType<typeof setInterval> | null = null;
  private polling = false;
  private stats: LibraryStats = EMPTY_STATS;

  @OnEvent({ name: 'AppBootstrap', workers: [ImmichWorker.Microservices] })
  onBootstrap(): void {
    const { telemetry } = this.configRepository.getEnv();
    if (!telemetry.metrics.has(ImmichTelemetry.Library)) {
      return;
    }

    this.registerGauges();
    void this.poll();
    this.timer ??= setInterval(() => void this.poll(), POLL_INTERVAL_MS);
  }

  @OnEvent({ name: 'AppShutdown', workers: [ImmichWorker.Microservices] })
  onShutdown(): void {
    if (!this.timer) {
      return;
    }

    clearInterval(this.timer);
    this.timer = null;
  }

  private registerGauges(): void {
    const telemetry = this.telemetryRepository.library;

    telemetry.observeGauge('immich.library.assets', (result) => {
      this.whenCollected(result, () => {
        result.observe(this.stats.assets.photo, { type: 'photo' });
        result.observe(this.stats.assets.video, { type: 'video' });
        result.observe(this.stats.assets.pdf, { type: 'pdf' });
        result.observe(this.stats.assets.total, { type: 'total' });
      });
    });
    telemetry.observeGauge('immich.library.assets_unlocated', (result) => {
      this.whenCollected(result, () => result.observe(this.stats.assets.unlocated));
    });
    telemetry.observeGauge('immich.library.persons', (result) => {
      this.whenCollected(result, () => {
        result.observe(this.stats.persons.labeled, { state: 'labeled' });
        result.observe(this.stats.persons.total - this.stats.persons.labeled, { state: 'unnamed' });
        result.observe(this.stats.persons.hidden, { state: 'hidden' });
      });
    });
    telemetry.observeGauge('immich.library.faces', (result) => {
      this.whenCollected(result, () => {
        result.observe(this.stats.faces.assigned, { state: 'assigned' });
        result.observe(this.stats.faces.unassigned, { state: 'unassigned' });
      });
    });
    telemetry.observeGauge('immich.library.faces_per_photo', (result) => {
      this.whenCollected(result, () => this.observeQuantiles(result, this.stats.facesPerPhoto));
    });
    telemetry.observeGauge('immich.library.ocr_objects', (result) => {
      this.whenCollected(result, () => {
        result.observe(this.stats.ocr.visible, { state: 'visible' });
        result.observe(this.stats.ocr.hidden, { state: 'hidden' });
      });
    });
    telemetry.observeGauge('immich.library.ocr_chars_per_photo', (result) => {
      this.whenCollected(result, () => this.observeQuantiles(result, this.stats.ocrCharsPerPhoto));
    });
    telemetry.observeGauge('immich.library.assets_by_tag', (result) => {
      this.whenCollected(result, () => this.observeLabelCounts(result, this.stats.byTag, 'tag'));
    });
    telemetry.observeGauge('immich.library.assets_by_album', (result) => {
      this.whenCollected(result, () => this.observeLabelCounts(result, this.stats.byAlbum, 'album'));
    });
    telemetry.observeGauge('immich.library.assets_by_city', (result) => {
      this.whenCollected(result, () => this.observeLabelCounts(result, this.stats.byCity, 'city'));
    });
    telemetry.observeGauge('immich.library.assets_by_country', (result) => {
      this.whenCollected(result, () => this.observeLabelCounts(result, this.stats.byCountry, 'country'));
    });
    telemetry.observeGauge('immich.library.poll_duration', (result) => {
      this.whenCollected(result, () => result.observe(this.stats.pollMs / 1000));
    });
    telemetry.observeGauge('immich.library.poll_timestamp', (result) => {
      this.whenCollected(result, () => result.observe(this.stats.collectedAt / 1000));
    });
  }

  private whenCollected(result: ObservableResult, observe: () => void): void {
    if (this.stats.collectedAt > 0) {
      observe();
    }
  }

  private observeQuantiles(result: ObservableResult, quantiles: Quantiles): void {
    if (quantiles.p50 !== null) {
      result.observe(quantiles.p50, { quantile: 'p50' });
    }
    if (quantiles.p95 !== null) {
      result.observe(quantiles.p95, { quantile: 'p95' });
    }
  }

  private observeLabelCounts(result: ObservableResult, counts: LabelCount[], label: string): void {
    for (const { label: value, count } of counts) {
      const attributes: MetricAttributes = { [label]: value };
      result.observe(count, attributes);
    }
  }

  private async poll(): Promise<void> {
    if (this.polling) {
      return;
    }
    this.polling = true;

    const start = performance.now();
    try {
      // sequential on purpose: parallel percentile scans can exhaust the
      // database container's /dev/shm via dynamic shared memory segments;
      // the whole set takes ~2s single-file, which is fine at a 5 min cadence
      const assets = await this.libraryStatsRepository.getAssetCounts();
      const persons = await this.libraryStatsRepository.getPersonCounts();
      const faces = await this.libraryStatsRepository.getFaceCounts();
      const facesPerPhoto = await this.libraryStatsRepository.getFacesPerPhoto();
      const ocr = await this.libraryStatsRepository.getOcrObjectCounts();
      const ocrCharsPerPhoto = await this.libraryStatsRepository.getOcrCharsPerPhoto();
      const byTag = await this.libraryStatsRepository.getAssetCountsByTag();
      const byAlbum = await this.libraryStatsRepository.getAssetCountsByAlbum();
      const byCity = await this.libraryStatsRepository.getAssetCountsByCity();
      const byCountry = await this.libraryStatsRepository.getAssetCountsByCountry();

      this.stats = {
        collectedAt: Date.now(),
        pollMs: Math.round(performance.now() - start),
        assets,
        persons,
        faces,
        facesPerPhoto,
        ocr,
        ocrCharsPerPhoto,
        byTag,
        byAlbum,
        byCity,
        byCountry,
      };
      this.logger.debug(`Collected library stats in ${this.stats.pollMs}ms`);
    } catch (error) {
      this.logger.warn(`Failed to collect library stats: ${error}`);
    } finally {
      this.polling = false;
    }
  }
}
