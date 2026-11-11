<script lang="ts">
  import UserPageLayout from '#lib/components/layouts/UserPageLayout.svelte';
  import { locale } from '#lib/stores/preferences.store.ts';
  import { Route } from '#lib/route.ts';
  import { getAssetMediaUrl } from '#lib/utils.ts';
  import { AssetMediaSize, type AssetResponseDto } from '@immich/sdk';
  import { t } from 'svelte-i18n';
  import type { PageData } from './$types';

  interface Props {
    data: PageData;
  }

  let { data }: Props = $props();

  type AssetWithMake = AssetResponseDto & {
    exifInfo: {
      make: string;
    };
  };

  let cameras = $derived(data.items.filter((item): item is AssetWithMake => !!item.exifInfo?.make));
</script>

<UserPageLayout title={data.meta.title} description={`(${cameras.length.toLocaleString($locale)})`}>
  <div class="mt-4 flex flex-row flex-wrap gap-4">
    {#each cameras as item (item.id)}
      <a class="relative" href={Route.exploreCamera({ make: item.exifInfo.make })} draggable="false">
        <div
          class="flex w-[calc((100vw-(72px+5rem))/2)] max-w-39 justify-center overflow-hidden rounded-xl brightness-75 filter"
        >
          <img
            src={getAssetMediaUrl({ id: item.id, size: AssetMediaSize.Thumbnail })}
            alt={item.exifInfo.make}
            class="size-39 object-cover"
            loading="lazy"
          />
        </div>
        <span
          class="absolute bottom-2 w-full px-1 text-center text-sm font-medium text-ellipsis text-white capitalize backdrop-blur-[1px] hover:cursor-pointer"
        >
          {item.exifInfo.make}
        </span>
      </a>
    {/each}
  </div>
</UserPageLayout>
