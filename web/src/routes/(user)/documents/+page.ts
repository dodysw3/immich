import { authenticate } from '$lib/utils/auth';
import type { PageLoad } from './$types';

export const load = (async ({ url, fetch }) => {
  await authenticate(url);
  const query = url.searchParams.get('query')?.trim() || '';
  const page = Number(url.searchParams.get('page') || '1');
  const normalizedPage = Number.isFinite(page) && page > 0 ? Math.floor(page) : 1;
  const endpoint = query
    ? `/api/documents/search?query=${encodeURIComponent(query)}&page=${normalizedPage}`
    : `/api/documents?page=${normalizedPage}`;
  const response = await fetch(endpoint);
  const payload = response.ok ? await response.json() : { items: [], nextPage: null };

  return {
    items: payload.items || [],
    nextPage: payload.nextPage || null,
    page: normalizedPage,
    query,
    meta: {
      title: 'Documents',
    },
  };
}) satisfies PageLoad;
