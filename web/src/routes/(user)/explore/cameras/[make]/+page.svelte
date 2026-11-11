<script lang="ts">
  import UserPageLayout from '#lib/components/layouts/UserPageLayout.svelte';
  import EmptyPlaceholder from '#lib/components/shared-components/EmptyPlaceholder.svelte';
  import { Route } from '#lib/route.ts';
  import { getAssetMediaUrl } from '#lib/utils.ts';
  import { getCameraName } from '#lib/utils/camera-utils.ts';
  import { AssetMediaSize } from '@immich/sdk';
  import { t } from 'svelte-i18n';
  import type { PageData } from './$types';

  interface Props {
    data: PageData;
  }

  let { data }: Props = $props();

  let models = $derived(data.models);
</script>

<UserPageLayout title={data.meta.title}>
  {#if models.length > 0}
    <div class="mt-4 flex flex-row flex-wrap gap-4">
      {#each models as item (item.data.id)}
        <a class="relative" href={Route.search({ make: data.make, model: item.value })} draggable="false">
          <div
            class="flex w-[calc((100vw-(72px+5rem))/2)] max-w-39 justify-center overflow-hidden rounded-xl brightness-75 filter"
          >
            <img
              src={getAssetMediaUrl({ id: item.data.id, size: AssetMediaSize.Thumbnail })}
              alt={item.value}
              class="size-39 object-cover"
              loading="lazy"
            />
          </div>
          <span
            class="absolute bottom-2 w-full px-1 text-center text-sm font-medium text-ellipsis text-white backdrop-blur-[1px] hover:cursor-pointer"
          >
            {getCameraName(data.make, item.value)}
          </span>
        </a>
      {/each}
    </div>
  {:else}
    <EmptyPlaceholder text={$t('no_explore_results_message')} class="mx-auto mt-10" />
  {/if}
</UserPageLayout>
