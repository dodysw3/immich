import { searchManager } from '#lib/managers/search-manager.svelte.ts';
import { AssetTypeEnum } from '@immich/sdk';
import { goto } from '$app/navigation';

vi.mock('$app/navigation', () => ({ goto: vi.fn() }));

describe('SearchManager', () => {
  beforeEach(() => {
    localStorage.clear();
    searchManager.reset();
  });

  it('preserves the unfinished interpretation filter and stacked images when refining a search', async () => {
    searchManager.setQuery({ type: AssetTypeEnum.Image, hasAiInterpretation: false, withStacked: true });
    expect(searchManager.filter.display.withoutAiInterpretation).toBe(true);
    searchManager.filter.display.isFavorite = true;
    await searchManager.submit();
    const url = new URL(vi.mocked(goto).mock.calls.at(-1)![0].toString(), 'http://localhost');
    expect(JSON.parse(url.searchParams.get('query')!)).toMatchObject({
      type: AssetTypeEnum.Image,
      hasAiInterpretation: false,
      withStacked: true,
      isFavorite: true,
    });

    searchManager.filter.display.withoutAiInterpretation = false;
    await searchManager.submit();
    const clearedUrl = new URL(vi.mocked(goto).mock.calls.at(-1)![0].toString(), 'http://localhost');
    expect(JSON.parse(clearedUrl.searchParams.get('query')!)).not.toHaveProperty('hasAiInterpretation');
  });

  it('defaults to smart search', () => {
    expect(searchManager.filter.queryType).toBe('smart');
  });

  it('round-trips a transcription query through the URL payload', async () => {
    searchManager.setQuery({ transcription: 'boarding announcement' });
    expect(searchManager.filter.queryType).toBe('transcription');
    expect(searchManager.filter.query).toBe('boarding announcement');
    expect(searchManager.filter.transcription).toBe('boarding announcement');

    await searchManager.submit();
    const url = new URL(vi.mocked(goto).mock.calls.at(-1)![0].toString(), 'http://localhost');
    const serialized = JSON.parse(url.searchParams.get('query')!);
    expect(serialized).toMatchObject({ transcription: 'boarding announcement' });
    expect(serialized.query).toBeUndefined();

    // reloading that URL restores the same mode
    searchManager.reset();
    searchManager.setQuery(serialized);
    expect(searchManager.filter.queryType).toBe('transcription');
    expect(searchManager.filter.transcription).toBe('boarding announcement');
  });

  it('treats transcription as a valid saved query type', () => {
    searchManager.setQueryType('transcription');
    expect(searchManager.filter.queryType).toBe('transcription');

    searchManager.reset();
    expect(searchManager.filter.queryType).toBe('transcription');
  });

  it('keeps transcription distinct from the ai mode', () => {
    searchManager.setQuery({ transcription: 'selamat pagi' });
    searchManager.setQuery({ ai: 'sunset over the beach' });
    expect(searchManager.filter.queryType).toBe('ai');
    expect(searchManager.filter.transcription).toBeUndefined();

    searchManager.setQuery({ transcription: 'selamat pagi' });
    expect(searchManager.filter.queryType).toBe('transcription');
    expect(searchManager.filter.ai).toBeUndefined();
  });

  it('remembers the selected query type', () => {
    searchManager.setQueryType('metadata');
    expect(searchManager.filter.queryType).toBe('metadata');

    searchManager.reset();
    expect(searchManager.filter.queryType).toBe('metadata');
  });

  it('overrides a previously stored query type', () => {
    localStorage.setItem('searchQueryType', 'metadata');
    searchManager.reset();

    searchManager.setQueryType('smart');
    searchManager.reset();
    expect(searchManager.filter.queryType).toBe('smart');
  });

  it('ignores an invalid stored query type', () => {
    localStorage.setItem('searchQueryType', 'invalid');
    searchManager.reset();
    expect(searchManager.filter.queryType).toBe('smart');
  });
});
