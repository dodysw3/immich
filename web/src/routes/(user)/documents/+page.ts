import { authenticate } from '$lib/utils/auth';
import type { PageLoad } from './$types';

export const load = (async ({ url, fetch }) => {
  await authenticate(url);
  const query = url.searchParams.get('query')?.trim() || '';
  const endpoint = query ? `/api/documents/search?query=${encodeURIComponent(query)}` : '/api/documents';
  const response = await fetch(endpoint);
  const items = response.ok ? await response.json() : [];

  return {
    items,
    query,
    meta: {
      title: 'Documents',
    },
  };
}) satisfies PageLoad;
