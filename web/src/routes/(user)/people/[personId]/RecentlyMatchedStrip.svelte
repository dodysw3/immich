<script lang="ts">
  import { getPersonAssets, AssetMediaSize } from '@immich/sdk';
  import ImageThumbnail from '$lib/components/assets/thumbnail/ImageThumbnail.svelte';
  import { getAssetMediaUrl } from '$lib/utils';
  import { navigate } from '$lib/utils/navigation';

  interface Props {
    personId: string;
  }

  let { personId }: Props = $props();

  let assets = $state<Awaited<ReturnType<typeof getPersonAssets>>['assets']>([]);
  let loading = $state(true);

  $effect(() => {
    const id = personId;
    loading = true;
    void getPersonAssets({ id, limit: 20 })
      .then((response) => {
        assets = response.assets;
      })
      .finally(() => {
        loading = false;
      });
  });

  const handleClick = (assetId: string) => {
    void navigate({ targetRoute: 'current', assetId });
  };
</script>

{#if !loading && assets.length > 0}
  <div class="py-2">
    <div class="flex items-center justify-between px-4 pt-2 pb-1">
      <h2 class="text-lg font-medium text-immich-fg dark:text-immich-dark-fg">
        Recently matched
      </h2>
      <a
        href="/people/{personId}/matched"
        class="text-sm font-medium text-immich-primary hover:text-immich-primary/80 dark:text-immich-dark-primary"
      >
        View all →
      </a>
    </div>
    <div class="flex scrollbar-hidden gap-2 overflow-x-auto px-4 pb-2">
      {#each assets as asset (asset.id)}
        <button
          type="button"
          class="block shrink-0 overflow-hidden rounded-lg transition-transform hover:scale-105 focus:ring-2 focus:ring-immich-primary focus:outline-none"
          onclick={() => handleClick(asset.id)}
        >
          <ImageThumbnail
            url={getAssetMediaUrl({ id: asset.id, cacheKey: asset.thumbhash, size: AssetMediaSize.Thumbnail })}
            altText={asset.originalFileName}
            widthStyle="8rem"
            heightStyle="8rem"
            curve
          />
        </button>
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
