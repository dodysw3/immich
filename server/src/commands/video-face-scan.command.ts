import { readFileSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';
import { Command, CommandRunner, Option } from 'nest-commander';
import sharp from 'sharp';
import type { ScanResult } from 'src/services/video-face.service.js';
import { JobStatus } from 'src/enum.js';
import { VideoFaceService } from 'src/services/video-face.service.js';

interface VideoFaceScanOptions {
  config?: string;
  budget?: number;
  out?: string;
  publish?: boolean;
}

/**
 * Dry-run video face scan: runs the full sampling + grouping pipeline for one
 * asset and writes manifest.json + contact-sheet.html. Writes nothing to the
 * library — this is the tuning-experiment surface.
 */
@Command({
  name: 'video-face-scan',
  description: 'Dry-run multi-frame video face scan (manifest + contact sheet, no library writes)',
  arguments: '<assetId>',
})
export class VideoFaceScanCommand extends CommandRunner {
  constructor(private videoFaceService: VideoFaceService) {
    super();
  }

  async run(passedParams: string[], options: VideoFaceScanOptions = {}): Promise<void> {
    const [assetId] = passedParams;
    if (!assetId) {
      console.error('usage: video-face-scan <assetId> [--config file.json] [--budget N] [--out dir]');
      process.exitCode = 1;
      return;
    }

    let overrides = {};
    if (options.config) {
      overrides = JSON.parse(readFileSync(options.config, 'utf8')) as object;
      console.log(`config overrides from ${options.config}`);
    }
    if (options.budget) {
      console.log(`budget override: ${options.budget} frames`);
    }

    if (options.publish) {
      const status = await this.videoFaceService.scanPublish(assetId, options.budget);
      console.log(`published scan status: ${status}`);
      process.exit(status === JobStatus.Success ? 0 : 1);
    }

    const result = await this.videoFaceService.scanDryRun(assetId, options.budget, overrides);
    try {
      const outDir = options.out ?? process.cwd();
      const manifest = {
        assetId,
        config: result.config,
        configHash: result.configHash,
        modelVersions: result.modelVersions,
        outcome: result.outcome,
        durationMs: result.durationMs,
        extractions: result.extractions,
        detections: result.detections,
        identities: result.identities.map((identity) => ({
          identityKey: identity.identityKey,
          firstObservedMs: identity.firstObservedMs,
          lastObservedMs: identity.lastObservedMs,
          sightings: identity.sightingCount,
          bestFrameMs: identity.bestFrameMs,
          bestScore: identity.bestScore,
          bestSizePx: identity.bestSizePx,
          flagged: identity.flagged,
        })),
        samples: result.samples,
      };
      const manifestPath = join(outDir, 'manifest.json');
      writeFileSync(manifestPath, JSON.stringify(manifest, null, 2));
      const sheetPath = join(outDir, 'contact-sheet.html');
      writeFileSync(sheetPath, await this.contactSheet(result));
      console.log(`outcome=${result.outcome} frames=${result.frames.length} detections=${result.detections} identities=${result.identities.length}`);
      console.log(`wrote ${manifestPath} and ${sheetPath}`);
      process.exit(0);
    } finally {
      await this.videoFaceService.cleanup(result);
    }
  }

  @Option({ flags: '-c, --config [path]', description: 'JSON config overrides' })
  parseConfig(path: string): string {
    return path;
  }

  @Option({ flags: '-b, --budget [frames]', description: 'frame budget override' })
  parseBudget(value: string): number {
    return Number.parseInt(value, 10);
  }

  @Option({ flags: '-o, --out [dir]', description: 'output directory (default cwd)' })
  parseOut(dir: string): string {
    return dir;
  }

  @Option({ flags: '-p, --publish', description: 'persist results to the library (default: dry run)' })
  parsePublish(): boolean {
    return true;
  }

  private async contactSheet(result: ScanResult): Promise<string> {
    const cards: string[] = [];
    for (const identity of result.identities) {
      const framePath = result.framePaths.get(identity.bestFrameMs);
      let image = '';
      if (framePath) {
        const best = identity.sightings.find((s) => s.timeMs === identity.bestFrameMs) ?? identity.sightings[0];
        const pad = 0.25;
        const crop = await sharp(framePath)
          .extract({
            left: Math.max(0, Math.round(best.x1 - (best.x2 - best.x1) * pad)),
            top: Math.max(0, Math.round(best.y1 - (best.y2 - best.y1) * pad)),
            width: Math.max(8, Math.round((best.x2 - best.x1) * (1 + 2 * pad))),
            height: Math.max(8, Math.round((best.y2 - best.y1) * (1 + 2 * pad))),
          })
          .resize(180, 180, { fit: 'inside' })
          .jpeg({ quality: 82 })
          .toBuffer();
        image = `<img src="data:image/jpeg;base64,${crop.toString('base64')}" width="180">`;
      }
      const flag = identity.flagged ? ' &#9888;' : '';
      cards.push(
        `<div class="card">${image}<div class="cap"><b>${identity.identityKey}</b> · first ${(identity.firstObservedMs / 1000).toFixed(2)}s · ` +
          `${identity.sightingCount} sightings · ${identity.bestSizePx}px · score ${identity.bestScore.toFixed(2)}${flag}</div></div>`,
      );
    }
    return `<!doctype html><html><head><meta charset="utf-8"><title>video-face-scan ${result.configHash}</title>
<style>body{font:14px system-ui,sans-serif;background:#111;color:#ddd;margin:16px}
.card{display:inline-block;margin:6px;vertical-align:top;background:#1b1b1b;border-radius:8px;padding:8px}
.card img{border-radius:4px}.cap{font-size:12px;color:#aaa;margin-top:4px}</style></head><body>
<h1>Video face scan — ${result.outcome}</h1>
<p>${result.frames.length} frames · ${result.detections} detections · ${result.identities.length} identities ·
config ${result.configHash} · ${result.modelVersions} · timeline ${(result.durationMs / 1000).toFixed(1)}s</p>
${cards.join('\n')}</body></html>`;
  }
}
