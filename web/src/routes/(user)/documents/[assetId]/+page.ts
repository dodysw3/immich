import { authenticate } from '$lib/utils/auth';
import type { PageLoad } from './$types';

export const load = (async ({ url, params }) => {
  await authenticate(url);

  return {
    meta: {
      title: 'PDF Viewer',
    },
    assetId: params.assetId,
  };
}) satisfies PageLoad;
