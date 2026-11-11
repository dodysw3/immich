import { authenticate } from '#lib/utils/auth.ts';
import { getFormatter } from '#lib/utils/i18n.ts';
import { getExploreCameras } from '@immich/sdk';
import type { PageLoad } from './$types';

export const load = (async ({ params, url }) => {
  await authenticate(url);

  const explore = await getExploreCameras({ make: params.make });

  return {
    make: params.make,
    models: explore[0]?.items ?? [],
    meta: {
      title: params.make,
    },
  };
}) satisfies PageLoad;
