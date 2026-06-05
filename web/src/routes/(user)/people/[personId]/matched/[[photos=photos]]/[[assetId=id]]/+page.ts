import { getPerson, getPersonAssets } from '@immich/sdk';
import { authenticate } from '$lib/utils/auth';
import { getFormatter } from '$lib/utils/i18n';
import type { PageLoad } from './$types';

export const load = (async ({ params, url }) => {
  await authenticate(url);

  const [person, assetsResponse] = await Promise.all([
    getPerson({ id: params.personId }),
    getPersonAssets({ id: params.personId, page: 1, limit: 100 }),
  ]);
  const $t = await getFormatter();

  return {
    person,
    assets: assetsResponse.assets,
    total: assetsResponse.total,
    meta: {
      title: `Recently matched - ${person.name || $t('person')}`,
    },
  };
}) satisfies PageLoad;
