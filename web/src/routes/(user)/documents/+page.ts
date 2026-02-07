import { authenticate } from '$lib/utils/auth';
import type { PageLoad } from './$types';

export const load = (async ({ url, fetch }) => {
  await authenticate(url);
  const response = await fetch('/api/documents');
  const items = response.ok ? await response.json() : [];

  return {
    items,
    meta: {
      title: 'Documents',
    },
  };
}) satisfies PageLoad;
