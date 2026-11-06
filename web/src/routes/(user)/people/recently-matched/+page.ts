import { authenticate } from '#lib/utils/auth.ts';
import { getRecentlyMatched } from '@immich/sdk';
import type { PageLoad } from './$types';

export const load = (async ({ url }) => {
  await authenticate(url);

  const response = await getRecentlyMatched({ limit: 100 });

  return {
    items: response.items,
    total: response.total,
    meta: {
      title: 'Recently recognized',
    },
  };
}) satisfies PageLoad;
