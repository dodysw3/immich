import { authenticate } from '#lib/utils/auth.ts';
import { getFormatter } from '#lib/utils/i18n.ts';
import { getAssetsByCameraMake } from '@immich/sdk';
import type { PageLoad } from './$types';

export const load = (async ({ url }) => {
  await authenticate(url);
  const items = await getAssetsByCameraMake();
  const $t = await getFormatter();

  return {
    items,
    meta: {
      title: $t('cameras'),
    },
  };
}) satisfies PageLoad;
