import { Route } from '#lib/route.ts';
import type { MockData } from '#test/common/data.ts';
import { factory } from '#test/common/factories.ts';
import { expect, test } from '#test/medium/fixtures.ts';
import { AssetTypeEnum } from '@immich/sdk';
import type { Page } from '@playwright/test';
import { readFileSync } from 'node:fs';

// A real 2.5s clip so the native player reaches canplay and accepts seeks.
const seekClip = new Uint8Array(readFileSync(new URL('../../assets/transcript-seek.mp4', import.meta.url)));

const MATCH_START_MS = 1000;

const transcriptMetadata = {
  runs: {
    'run-1': {
      model: 'whisper-test',
      promptVersion: '1',
      status: 'completed',
      trigger: 'manual',
      requestedAt: '2026-11-11T00:00:00.000Z',
      segments: [
        { startMs: 0, endMs: 1500, text: 'selamat pagi semuanya' },
        { startMs: 1500, endMs: 2500, text: 'sampai jumpa' },
      ],
    },
  },
};

const setup = (data: MockData) => {
  const asset = factory.asset({ type: AssetTypeEnum.Video, duration: 2500 });
  data.addAssets(asset);
  return asset;
};

const seekUrl = (assetId: string) =>
  `${Route.viewAsset({ id: assetId })}?matchStartMs=${MATCH_START_MS}&matchPassageId=p-1&matchRevision=rev-1`;

type PlayerState = { currentTime: number; paused: boolean; readyState: number };

const playerState = (page: Page): Promise<PlayerState | null> =>
  page.evaluate(() => {
    const el = document.querySelector<HTMLVideoElement>('video');
    if (!el) {
      return null;
    }
    return { currentTime: el.currentTime, paused: el.paused, readyState: el.readyState };
  });

const waitForPlayerReady = (page: Page) =>
  expect(async () => {
    const state = await playerState(page);
    expect(state, 'the native video player should mount').not.toBeNull();
    expect(state!.readyState, 'the video should reach readyState HAVE_CURRENT_DATA').toBeGreaterThanOrEqual(2);
  }).toPass({ timeout: 10_000 });

test.describe('transcription match seek', () => {
  test.beforeEach(async ({ api, page }) => {
    api.on({
      getAssetMetadataByKey: () => ({ json: { key: 'video-transcripts-v1', value: transcriptMetadata } }),
      getVideoFaces: () => ({ json: { faces: [] } }),
    });
    // Serve the clip with HTTP range support: without it Chromium treats the
    // media as unseekable (seekable stays [0, 0]) even when fully buffered,
    // and the initial seek would be dropped. Page routes take precedence over
    // the context-wide mock.
    await page.route(/\/video\/playback/, async (route) => {
      const rangeHeader = route.request().headers()['range'];
      const baseHeaders = { 'Content-Type': 'video/mp4', 'Accept-Ranges': 'bytes' };
      if (rangeHeader) {
        const match = /bytes=(\d*)-(\d*)/.exec(rangeHeader);
        const start = match?.[1] ? Number.parseInt(match[1]) : 0;
        const end = match?.[2] ? Number.parseInt(match[2]) : seekClip.length - 1;
        await route.fulfill({
          status: 206,
          body: Buffer.from(seekClip.subarray(start, end + 1)),
          headers: { ...baseHeaders, 'Content-Range': `bytes ${start}-${end}/${seekClip.length}` },
        });
        return;
      }
      await route.fulfill({
        status: 200,
        body: Buffer.from(seekClip),
        headers: { ...baseHeaders, 'Content-Length': String(seekClip.length) },
      });
    });
  });

  test('opens at the matched moment and stays paused with autoplay disabled', async ({ page, data, app }) => {
    const asset = setup(data);
    await page.addInitScript(() => {
      try {
        localStorage.setItem('auto-play-video', 'false');
      } catch {
        // about:blank has no storage; the app document sets it on the real navigation
      }
    });

    await page.goto(seekUrl(asset.id));
    await app.viewer.waitForAsset(asset);
    await waitForPlayerReady(page);

    await expect(async () => {
      const state = await playerState(page);
      expect(Math.abs(state!.currentTime - MATCH_START_MS / 1000)).toBeLessThan(0.3);
      expect(state!.paused, 'autoplay disabled must leave the video paused at the matched moment').toBe(true);
    }).toPass({ timeout: 10_000 });
  });

  test('plays from the matched moment with autoplay enabled (never intentionally from zero)', async ({
    page,
    data,
    app,
  }) => {
    const asset = setup(data);
    await page.addInitScript(() => {
      try {
        localStorage.setItem('auto-play-video', 'true');
      } catch {
        // about:blank has no storage
      }
    });

    await page.goto(seekUrl(asset.id));
    await app.viewer.waitForAsset(asset);
    await waitForPlayerReady(page);

    await expect(async () => {
      const state = await playerState(page);
      expect(Math.abs(state!.currentTime - MATCH_START_MS / 1000)).toBeLessThan(0.5);
      expect(state!.paused, 'autoplay enabled must play from the matched moment').toBe(false);
    }).toPass({ timeout: 10_000 });
  });

  test('shows the transcript overlay pinned at timestamp zero for a match opened there', async ({
    page,
    data,
    app,
  }) => {
    const asset = setup(data);
    await page.addInitScript(() => {
      try {
        localStorage.setItem('auto-play-video', 'false');
      } catch {
        // about:blank has no storage
      }
    });

    await page.goto(`${Route.viewAsset({ id: asset.id })}?matchStartMs=0&matchPassageId=p-1&matchRevision=rev-1`);
    await app.viewer.waitForAsset(asset);
    await waitForPlayerReady(page);

    await expect(page.getByTestId('video-transcript-overlay')).toBeVisible();
    await expect(page.getByTestId('video-transcript-overlay')).toContainText('selamat pagi semuanya');
  });

  test('an ordinary open keeps the unplayed start-at-zero behavior', async ({ page, data, app }) => {
    const asset = setup(data);
    await page.addInitScript(() => {
      try {
        localStorage.setItem('auto-play-video', 'false');
      } catch {
        // about:blank has no storage
      }
    });

    await page.goto(Route.viewAsset({ id: asset.id }));
    await app.viewer.waitForAsset(asset);
    await waitForPlayerReady(page);

    await expect(async () => {
      const state = await playerState(page);
      expect(state!.currentTime).toBe(0);
    }).toPass({ timeout: 10_000 });
    await expect(page.getByTestId('video-transcript-overlay')).toHaveCount(0);
  });
});
