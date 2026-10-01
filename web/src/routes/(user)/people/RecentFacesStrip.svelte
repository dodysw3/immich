<script lang="ts">
  import { getRecentlyMatched, AssetMediaSize } from '@immich/sdk';
  import ImageThumbnail from '$lib/components/assets/thumbnail/ImageThumbnail.svelte';
  import { getAssetMediaUrl } from '$lib/utils';
  import { goto } from '$app/navigation';
  import { Route } from '$lib/route';

  let items = $state<Awaited<ReturnType<typeof getRecentlyMatched>>['items']>([]);
  let loading = $state(true);

  $effect(() => {
    loading = true;
    void getRecentlyMatched({ limit: 50 })
      .then((response) => {
        items = response.items;
      })
      .catch(() => {
        items = [];
      })
      .finally(() => {
        loading = false;
      });
  });

  // the strip lives on /people/, so the asset viewer must target the root
  // /photos/<assetId> route — navigate({ targetRoute: 'current' }) would
  // rewrite into /people/photos/<assetId>, which does not exist
  const handleClick = (assetId: string) => {
    void goto(Route.viewAsset({ id: assetId }));
  };
</script>

{#if !loading && items.length > 0}
  <div class="py-2">
    <div class="flex items-center justify-between px-4 pt-2 pb-1">
      <h2 class="text-lg font-medium text-immich-fg dark:text-immich-dark-fg">Recently recognized</h2>
      <a
        href="/people/recently-matched"
        class="text-sm font-medium text-immich-primary hover:text-immich-primary/80 dark:text-immich-dark-primary"
      >
        View all →
      </a>
    </div>
    <div class="flex scrollbar-hidden gap-2 overflow-x-auto px-4 pb-2">
      {#each items as item (item.assetId + item.personId)}
        <div class="w-32 shrink-0">
          <button
            type="button"
            class="block overflow-hidden rounded-lg transition-transform hover:scale-105 focus:ring-2 focus:ring-immich-primary focus:outline-none"
            onclick={() => handleClick(item.assetId)}
          >
            <ImageThumbnail
              url={getAssetMediaUrl({ id: item.assetId, size: AssetMediaSize.Thumbnail })}
              altText={item.personName || '—'}
              widthStyle="8rem"
              heightStyle="8rem"
              curve
            />
          </button>
          <a
            href={Route.viewPerson({ id: item.personId })}
            class="mt-1 block truncate text-center text-xs font-medium text-immich-primary hover:text-immich-primary/80 dark:text-immich-dark-primary"
            title={item.personName}
          >
            {item.personName || '—'}
          </a>
        </div>
      {/each}
    </div>
  </div>
{/if}

<style>
  .scrollbar-hidden {
    -ms-overflow-style: none;
    scrollbar-width: none;
  }
  .scrollbar-hidden::-webkit-scrollbar {
    display: none;
  }
</style>
