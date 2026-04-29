import { authenticate } from '$lib/utils/auth';
import type { PageLoad } from './$types';

export const load = (async ({ url, fetch }) => {
  await authenticate(url);
  const query = url.searchParams.get('query')?.trim() || '';
  const requestedStatus = url.searchParams.get('status')?.trim() || '';
  const status =
    requestedStatus === 'pending' || requestedStatus === 'processing' || requestedStatus === 'ready' || requestedStatus === 'failed'
      ? requestedStatus
      : '';
  const endpoint = query
    ? `/api/documents/search?query=${encodeURIComponent(query)}&page=1${
        status ? `&status=${encodeURIComponent(status)}` : ''
      }`
    : `/api/documents?page=1${status ? `&status=${encodeURIComponent(status)}` : ''}`;
  const response = await fetch(endpoint);
  const payload = response.ok
    ? await response.json()
    : { items: [], nextPage: null, summary: { total: 0, pending: 0, processing: 0, ready: 0, failed: 0 } };
  const summary = payload.summary || { total: 0, pending: 0, processing: 0, ready: 0, failed: 0 };

  return {
    items: payload.items || [],
    nextPage: payload.nextPage || null,
    summary,
    query,
    status,
    meta: {
      title: 'Documents',
    },
  };
}) satisfies PageLoad;
