import { searchManager } from '#lib/managers/search-manager.svelte.ts';
import { Route } from '#lib/route.ts';
import { placeholderImage } from '#test/common/helpers.ts';
import { factory } from '#test/unit/factories.ts';
import { test } from '#test/unit/fixtures.ts';
import { AssetTypeEnum, Tier, type TranscriptionMatchDto, type TranscriptionSearchItemDto } from '@immich/sdk';
import { tick } from 'svelte';
import { expect, vi } from 'vitest';
import Page from './+page.svelte';
import { load } from './+page.ts';

const holiday = factory.tag({ name: 'holiday' });
const family = factory.tag({ name: 'family' });

test.beforeEach(({ data }) => {
  data.setPreferences(factory.preferences({ tags: { enabled: true, sidebarWeb: true } })).addTags([holiday, family]);
});

test.afterEach(() => {
  searchManager.reset();
});

test('removing a chip drops the tag and keeps focus in the panel', async ({ router, render, settle, app }) => {
  await router.goto(Route.search({ tagIds: [holiday.id, family.id] }));
  await render(Page, load);
  await settle();
  await app.search.openFilter('tag_plus_more_tags');

  await app.search.tags.chip('holiday').click();

  await expect.element(app.search.tags.chip('holiday')).not.toBeInTheDocument();
  await expect.element(app.search.tags.chip('family')).toBeVisible();
  expect([...(searchManager.filter.tagIds ?? [])]).toEqual([family.id]);
  expect(app.search.tags.section().element().contains(document.activeElement)).toBe(true);
});

test('untagged replaces the tags and toggling it off restores none', async ({ router, render, settle, app }) => {
  await router.goto(Route.search({ tagIds: [holiday.id] }));
  await render(Page, load);
  await settle();
  await app.search.openFilter('holiday');

  await app.search.tags.untaggedButton().click();
  expect(searchManager.filter.tagIds).toBeNull();
  await expect.element(app.search.tags.chip('holiday')).not.toBeInTheDocument();

  await app.search.tags.untaggedButton().click();
  expect([...(searchManager.filter.tagIds ?? [])]).toEqual([]);
});

const moment = (overrides: Partial<TranscriptionMatchDto> = {}): TranscriptionMatchDto => ({
  passageId: crypto.randomUUID(),
  revision: 'rev-1',
  runKey: 'run-1',
  windowId: '2:2',
  firstSegment: 2,
  lastSegment: 2,
  startMs: 30_000,
  endMs: 34_000,
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
  asset: factory.asset({ type: AssetTypeEnum.Video, id: overrides.assetId, duration: 300_000 }),
  bestMatch: overrides.best ?? moment(),
  additionalMatches: overrides.additional ?? [],
  matchCount: overrides.matchCount ?? 1,
});

const frameHandlers = {
  getMatchFrame: () => ({ body: placeholderImage(undefined, 'frame'), contentType: 'image/svg+xml' }),
};

test('renders one card per video with the matched snippet, badge, and moments', async ({
  api,
  router,
  render,
  settle,
}) => {
  // the snippet contains raw <bandara>; the highlight spans must render it as text, not HTML
  const best = moment({
    passageId: 'p-1',
    snippet: 'kita berangkat ke <bandara> sekarang',
    spans: [{ start: 18, end: 27 }],
  });
  const later = moment({
    passageId: 'p-2',
    startMs: 90_000,
    snippet: 'bandara soekarno hatta',
    spans: [{ start: 0, end: 7 }],
  });
  const videoA = '0195aaaa-0000-7000-8000-000000000001';
  const videoB = '0195aaaa-0000-7000-8000-000000000002';

  api.on({
    searchTranscription: () => ({
      json: {
        count: 2,
        items: [item({ assetId: videoA, best, additional: [later], matchCount: 2 }), item({ assetId: videoB })],
        nextCursor: null,
        configVersion: 'cfg-1',
      },
    }),
    ...frameHandlers,
  });

  await router.goto(Route.search({ transcription: 'bandara' }));
  await render(Page, load);
  await settle();
  await settle();
  expect(api.searchTranscription).toHaveBeenCalledWith({
    body: expect.objectContaining({ q: 'bandara', explain: true }),
  });

  // one top-level card per video, keyed by the asset id
  const cards = document.querySelectorAll<HTMLDivElement>('[data-asset]');
  expect([...cards].map((card) => card.dataset.asset)).toEqual([videoA, videoB]);

  // the best match's snippet with highlighted spans (matched text in <mark>)
  const snippets = document.querySelectorAll('[data-testid="transcription-snippet"]');
  expect(snippets.length).toBe(2);
  expect(snippets[0]!.textContent).toContain('kita berangkat ke');
  expect(snippets[0]!.querySelector('mark')?.textContent).toBe('<bandara>');
  // timestamps are segment starts, formatted
  const badges = document.querySelectorAll('[data-testid="transcription-timestamp"]');
  expect(badges[0]!.textContent?.trim()).toBe('0:30');
  expect(badges[1]!.textContent?.trim()).toBe('0:30');

  // matched frames loaded for both cards
  await vi.waitFor(() => {
    expect(document.querySelectorAll('[data-testid="transcription-frame"]')).toHaveLength(2);
  });

  // the multi-moment video offers its additional moments; the single-moment one does not
  const momentButtons = document.querySelectorAll('button.transcription-moments-button');
  expect(momentButtons.length).toBe(1);
});

test('a frame decode failure keeps the match explanation on the ordinary thumbnail', async ({
  api,
  router,
  render,
  settle,
}) => {
  const videoA = '0195aaaa-0000-7000-8000-000000000005';

  api.on({
    searchTranscription: () => ({
      json: {
        count: 1,
        items: [item({ assetId: videoA })],
        nextCursor: null,
        configVersion: 'cfg-1',
      },
    }),
    getMatchFrame: () => ({ status: 500, json: { message: 'decode failed', statusCode: 500 } }),
  });

  await router.goto(Route.search({ transcription: 'bandara' }));
  await render(Page, load);
  await settle();
  await settle();
  expect(api.searchTranscription).toHaveBeenCalledWith({
    body: expect.objectContaining({ q: 'bandara', explain: true }),
  });
  // no matched-frame <img> rendered; the snippet and timestamp badge stay visible
  const card = document.querySelector<HTMLDivElement>(`[data-asset="${CSS.escape(videoA)}"]`)!;
  expect(card).toBeDefined();
  expect(card.querySelector('[data-testid="transcription-frame"]')).toBeNull();
  expect(card.querySelector('[data-testid="transcription-snippet"]')).not.toBeNull();
  expect(card.querySelector('[data-testid="transcription-timestamp"]')).not.toBeNull();
});

test('selecting an additional moment updates the snippet and timestamp without duplicating the card', async ({
  api,
  router,
  render,
  settle,
}) => {
  const best = moment({ passageId: 'p-1' });
  const later = moment({
    passageId: 'p-2',
    startMs: 90_000,
    snippet: 'bandara soekarno hatta',
    spans: [{ start: 0, end: 7 }],
  });
  const videoA = '0195aaaa-0000-7000-8000-000000000003';

  api.on({
    searchTranscription: () => ({
      json: {
        count: 1,
        items: [item({ assetId: videoA, best, additional: [later], matchCount: 2 })],
        nextCursor: null,
        configVersion: 'cfg-1',
      },
    }),
    ...frameHandlers,
  });

  await router.goto(Route.search({ transcription: 'bandara' }));
  await render(Page, load);
  await settle();
  await settle();
  expect(api.searchTranscription).toHaveBeenCalledWith({
    body: expect.objectContaining({ q: 'bandara', explain: true }),
  });

  document.querySelector<HTMLButtonElement>('button.transcription-moments-button')!.click();
  await tick();
  const menuItems = document.querySelectorAll<HTMLElement>('li[role="menuitem"]');
  expect(menuItems).toHaveLength(2);

  menuItems[1]!.click();
  await settle();
  await settle();

  // still exactly one card, now showing the selected moment
  expect(document.querySelectorAll(`[data-asset="${CSS.escape(videoA)}"]`)).toHaveLength(1);
  const badge = document.querySelector('[data-testid="transcription-timestamp"]');
  expect(badge?.textContent?.trim()).toBe('01:30');
  const snippet = document.querySelector('[data-testid="transcription-snippet"]');
  expect(snippet?.textContent).toContain('soekarno');
  expect(snippet?.querySelector('mark')?.textContent).toBe('bandara');
});

test('loading more moments appends distinct moments and stops at completion', async ({
  api,
  router,
  render,
  settle,
}) => {
  const best = moment({ passageId: 'p-1' });
  const known = moment({ passageId: 'p-2', startMs: 60_000, snippet: 'kedua' });
  const extra = moment({ passageId: 'p-3', startMs: 120_000, snippet: 'ketiga' });
  const videoA = '0195aaaa-0000-7000-8000-000000000004';

  api.on({
    searchTranscription: () => ({
      json: {
        count: 1,
        items: [item({ assetId: videoA, best, additional: [known], matchCount: 3 })],
        nextCursor: null,
        configVersion: 'cfg-1',
      },
    }),
    searchMoments: () => ({
      json: { configVersion: 'cfg-1', count: 1, moments: [best, known, extra], nextCursor: null },
    }),
    ...frameHandlers,
  });

  await router.goto(Route.search({ transcription: 'bandara' }));
  await render(Page, load);
  await settle();
  await settle();

  document.querySelector<HTMLButtonElement>('button.transcription-moments-button')!.click();
  await tick();
  const loadMore = [...document.querySelectorAll<HTMLElement>('li[role="menuitem"]')].find((li) =>
    li.textContent?.includes('transcription_search_load_more_moments'),
  );
  expect(loadMore).toBeDefined();
  loadMore!.click();
  await settle();
  await settle();

  expect(api.searchTranscription).toHaveBeenCalledWith({
    body: expect.objectContaining({ q: 'bandara', explain: true }),
  });
  expect(api.searchMoments).toHaveBeenCalledWith({
    body: expect.objectContaining({ assetId: videoA, q: 'bandara' }),
  });

  // reopen the menu: the loaded moment is now listed and no further load-more remains
  document.querySelector<HTMLButtonElement>('button.transcription-moments-button')!.click();
  await tick();
  expect(document.querySelectorAll('li[role="menuitem"]')).toHaveLength(3);
  const loadMoreAfter = [...document.querySelectorAll('li[role="menuitem"]')].find((li) =>
    li.textContent?.includes('transcription_search_load_more_moments'),
  );
  expect(loadMoreAfter).toBeUndefined();
});

test('empty transcription results distinguish an unindexed library from no match', async ({
  api,
  router,
  render,
  settle,
}) => {
  api.on({
    searchTranscription: () => ({
      json: {
        count: 0,
        items: [],
        nextCursor: null,
        configVersion: 'cfg-1',
        coverage: { totalVideos: 7, indexedVideos: 0, pendingIndex: 7, indexErrors: 0 },
      },
    }),
  });

  await router.goto(Route.search({ transcription: 'bandara' }));
  await render(Page, load);
  await settle();
  await settle();
  expect(api.searchTranscription).toHaveBeenCalledWith({
    body: expect.objectContaining({ q: 'bandara', explain: true }),
  });

  // the harness catalog maps keys to themselves, so assert the key
  await vi.waitFor(() => {
    expect(document.body.textContent).toContain('transcription_search_unindexed_hint');
  });
});

test('partial indexing shows a completeness caveat when nothing matched', async ({ api, router, render, settle }) => {
  api.on({
    searchTranscription: () => ({
      json: {
        count: 0,
        items: [],
        nextCursor: null,
        configVersion: 'cfg-1',
        coverage: { totalVideos: 9, indexedVideos: 4, pendingIndex: 5, indexErrors: 0 },
      },
    }),
  });

  await router.goto(Route.search({ transcription: 'nonexistentwords' }));
  await render(Page, load);
  await settle();
  expect(api.searchTranscription).toHaveBeenCalledWith({
    body: expect.objectContaining({ q: 'nonexistentwords', explain: true }),
  });

  await vi.waitFor(() => {
    expect(document.body.textContent).toContain('transcription_search_partial_hint');
  });
});
