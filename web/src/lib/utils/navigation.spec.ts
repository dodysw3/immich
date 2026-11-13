import { QueryParameter } from '#lib/constants.ts';
import { currentUrlReplaceAssetId, type AssetMatchNavigation } from '#lib/utils/navigation.ts';
import { setPage } from '#test/unit/mocks/app-state.svelte.ts';
import { beforeEach, describe, expect, test } from 'vitest';

const match: AssetMatchNavigation = {
  passageId: '0195b7a2-passages',
  revision: 'abc123',
  startMs: 42_500,
};

describe('navigation with a Transcription match', () => {
  beforeEach(() => {
    setPage({
      url: new URL('http://localhost/search?query=%7B%22transcription%22%3A%22boarding%20announcement%22%7D'),
      params: {},
      route: { id: '/(user)/search/[[photos=photos]]/[[assetId=id]]' },
    });
  });

  test('opening an asset with a match carries the match identity in the URL', () => {
    const url = currentUrlReplaceAssetId('asset-1', match);

    const parsed = new URL(url, 'http://localhost');
    expect(parsed.pathname).toBe('/search/photos/asset-1');
    expect(parsed.searchParams.get(QueryParameter.MATCH_START_MS)).toBe('42500');
    expect(parsed.searchParams.get(QueryParameter.MATCH_PASSAGE_ID)).toBe(match.passageId);
    expect(parsed.searchParams.get(QueryParameter.MATCH_REVISION)).toBe(match.revision);
    // the search query survives the round-trip
    expect(JSON.parse(parsed.searchParams.get('query')!)).toEqual({ transcription: 'boarding announcement' });
  });

  test('an ordinary asset open drops stale match params', () => {
    setPage({
      url: new URL(
        'http://localhost/search?query=%7B%22transcription%22%3A%22boarding%20announcement%22%7D&matchStartMs=42500&matchPassageId=stale&matchRevision=stale',
      ),
      params: {},
      route: { id: '/(user)/search/[[photos=photos]]/[[assetId=id]]' },
    });

    const parsed = new URL(currentUrlReplaceAssetId('asset-2'), 'http://localhost');
    expect(parsed.searchParams.has(QueryParameter.MATCH_START_MS)).toBe(false);
    expect(parsed.searchParams.has(QueryParameter.MATCH_PASSAGE_ID)).toBe(false);
    expect(parsed.searchParams.has(QueryParameter.MATCH_REVISION)).toBe(false);
  });

  test('a match with timestamp zero serializes exactly', () => {
    const parsed = new URL(currentUrlReplaceAssetId('asset-3', { ...match, startMs: 0 }), 'http://localhost');
    expect(parsed.searchParams.get(QueryParameter.MATCH_START_MS)).toBe('0');
  });
});
