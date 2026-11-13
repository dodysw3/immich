import { TranscriptionPresentationManager } from '#lib/managers/transcription-presentation-manager.svelte.ts';
import { factory } from '#test/unit/factories.ts';
import { AssetTypeEnum, Tier, type TranscriptionMatchDto, type TranscriptionSearchItemDto } from '@immich/sdk';
import { describe, expect, test } from 'vitest';

const match = (overrides: Partial<TranscriptionMatchDto> = {}): TranscriptionMatchDto => ({
  passageId: crypto.randomUUID(),
  revision: 'rev-1',
  runKey: 'run-1',
  windowId: '3:3',
  firstSegment: 3,
  lastSegment: 3,
  startMs: 12_000,
  endMs: 16_000,
  snippet: 'selamat pagi semuanya',
  spans: [{ start: 8, end: 12 }],
  tier: Tier.ExactAll,
  score: 0.9,
  ...overrides,
});

const item = (overrides: {
  assetId?: string;
  best?: TranscriptionMatchDto;
  additional?: TranscriptionMatchDto[];
  matchCount?: number;
}): TranscriptionSearchItemDto => ({
  asset: factory.asset({ type: AssetTypeEnum.Video, id: overrides.assetId }),
  bestMatch: overrides.best ?? match(),
  additionalMatches: overrides.additional ?? [],
  matchCount: overrides.matchCount ?? 1,
});

describe('TranscriptionPresentationManager', () => {
  test('stores one presentation per video with the best match selected', () => {
    const manager = new TranscriptionPresentationManager();
    const first = item({ assetId: 'video-1' });
    manager.loadPage([first, item({ assetId: 'video-2' })]);

    expect(manager.get('video-1')?.bestMatch).toBe(first.bestMatch);
    expect(manager.get('video-1')?.selected).toBe(first.bestMatch);
    expect(manager.matches.size).toBe(2);
  });

  test('reloading a page keeps one entry per video (asset-unique identity)', () => {
    const manager = new TranscriptionPresentationManager();
    manager.loadPage([item({ assetId: 'video-1' })]);
    manager.loadPage([item({ assetId: 'video-1' })]);

    expect(manager.matches.size).toBe(1);
  });

  test('deleting assets removes their presentation', () => {
    const manager = new TranscriptionPresentationManager();
    manager.loadPage([item({ assetId: 'video-1' }), item({ assetId: 'video-2' })]);

    manager.removeAssets(new Set(['video-1']));

    expect(manager.get('video-1')).toBeUndefined();
    expect(manager.get('video-2')).toBeDefined();
  });

  test('selecting a distinct moment moves the seek target without changing the count', () => {
    const manager = new TranscriptionPresentationManager();
    const best = match({ passageId: 'p-best', startMs: 12_000 });
    const later = match({ passageId: 'p-later', startMs: 45_000 });
    manager.loadPage([item({ assetId: 'video-1', best, additional: [later], matchCount: 2 })]);

    manager.selectMoment('video-1', later);

    const presentation = manager.get('video-1');
    expect(presentation?.selected.passageId).toBe('p-later');
    expect(presentation?.selected.startMs).toBe(45_000);
    expect(presentation?.bestMatch.passageId).toBe('p-best');
    expect(presentation?.matchCount).toBe(2);

    // switching back to the best match is allowed too
    manager.selectMoment('video-1', best);
    expect(manager.get('video-1')?.selected.passageId).toBe('p-best');
  });

  test('selecting an unknown moment or for an unknown video is a no-op', () => {
    const manager = new TranscriptionPresentationManager();
    const best = match({ passageId: 'p-best' });
    manager.loadPage([item({ assetId: 'video-1', best })]);

    manager.selectMoment('video-1', match({ passageId: 'p-unknown' }));
    expect(manager.get('video-1')?.selected.passageId).toBe('p-best');

    manager.selectMoment('video-2', best);
    expect(manager.get('video-2')).toBeUndefined();
  });

  test('merging moment pages dedupes by passage id and marks completion on the last page', () => {
    const manager = new TranscriptionPresentationManager();
    const best = match({ passageId: 'p-best' });
    const known = match({ passageId: 'p-known', startMs: 30_000 });
    manager.loadPage([item({ assetId: 'video-1', best, additional: [known], matchCount: 4 })]);

    const firstPage = manager.mergeMoments('video-1', {
      configVersion: 'cfg-1',
      count: 2,
      moments: [best, known, match({ passageId: 'p-new-1', startMs: 60_000 })],
      nextCursor: 'cursor-2',
    });
    expect(firstPage.map((m) => m.passageId)).toEqual(['p-new-1']);
    expect(manager.get('video-1')?.additionalMatches.map((m) => m.passageId)).toEqual(['p-known', 'p-new-1']);
    expect(manager.get('video-1')?.momentsComplete).toBe(false);

    const lastPage = manager.mergeMoments('video-1', {
      configVersion: 'cfg-1',
      count: 1,
      moments: [match({ passageId: 'p-new-2', startMs: 90_000 })],
      nextCursor: null,
    });
    expect(lastPage.map((m) => m.passageId)).toEqual(['p-new-2']);
    const presentation = manager.get('video-1');
    expect(presentation?.momentsComplete).toBe(true);
    expect(presentation?.additionalMatches).toHaveLength(3);
  });

  test('a fully known page still marks completion without duplicating moments', () => {
    const manager = new TranscriptionPresentationManager();
    const best = match({ passageId: 'p-best' });
    const known = match({ passageId: 'p-known', startMs: 30_000 });
    manager.loadPage([item({ assetId: 'video-1', best, additional: [known], matchCount: 2 })]);

    const merged = manager.mergeMoments('video-1', {
      configVersion: 'cfg-1',
      count: 2,
      moments: [best, known],
      nextCursor: null,
    });

    expect(merged).toEqual([]);
    const presentation = manager.get('video-1');
    expect(presentation?.additionalMatches).toHaveLength(1);
    expect(presentation?.momentsComplete).toBe(true);
  });

  test('merging moments for an unknown video returns nothing', () => {
    const manager = new TranscriptionPresentationManager();
    const merged = manager.mergeMoments('video-x', {
      configVersion: 'cfg-1',
      count: 1,
      moments: [match()],
      nextCursor: null,
    });
    expect(merged).toEqual([]);
  });

  test('clear drops every entry (new query)', () => {
    const manager = new TranscriptionPresentationManager();
    manager.loadPage([item({ assetId: 'video-1' })]);

    manager.clear();

    expect(manager.matches.size).toBe(0);
  });
});
