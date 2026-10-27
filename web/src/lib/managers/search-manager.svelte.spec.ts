import { AssetTypeEnum } from '@immich/sdk';
import { goto } from '$app/navigation';
import { searchManager } from '$lib/managers/search-manager.svelte';

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
