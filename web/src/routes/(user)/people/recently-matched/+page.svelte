<script lang="ts">
  import { goto } from '$app/navigation';
  import ControlAppBar from '$lib/components/shared-components/ControlAppBar.svelte';
  import ImageThumbnail from '$lib/components/assets/thumbnail/ImageThumbnail.svelte';
  import { Route } from '$lib/route';
  import { getAssetMediaUrl } from '$lib/utils';
  import { getRecentlyMatched, AssetMediaSize } from '@immich/sdk';
  import { LoadingSpinner } from '@immich/ui';
  import { mdiArrowLeft } from '@mdi/js';
  import { t } from 'svelte-i18n';
  import type { PageData } from './$types';

  interface Props {
    data: PageData;
  }

  let { data }: Props = $props();

  const PAGE_SIZE = 100;

  let items = $state(data.items);
  let total = $state(data.total);
  let loading = $state(false);
  let lastItemContainer: HTMLElement | undefined = $state();
  // the server counts total over the request's recency window, which widens
  // with offset — so pagination ends on a partial page, not on total
  let lastPageFull = $state(data.items.length >= PAGE_SIZE);
  let nextOffset = $state(data.items.length);

  let hasMore = $derived(lastPageFull);
  let count = $derived(Math.max(total, items.length));

  const loadMore = async () => {
    if (loading || !hasMore) {
      return;
    }
    loading = true;
    try {
      const response = await getRecentlyMatched({ limit: PAGE_SIZE, offset: nextOffset });
      nextOffset += response.items.length;
      // the live feed shifts between fetches, so a pair can straddle two pages
      const seen = new Set(items.map((item) => item.assetId + item.personId));
      items.push(...response.items.filter((item) => !seen.has(item.assetId + item.personId)));
      total = response.total;
      lastPageFull = response.items.length >= PAGE_SIZE;
    } finally {
      loading = false;
    }
  };

  const intersectionObserver = new IntersectionObserver((entries) => {
    const entry = entries.find((entry) => entry.target === lastItemContainer);
    if (entry?.isIntersecting) {
      void loadMore();
    }
  });

  $effect(() => {
    if (!lastItemContainer) {
      return;
    }

    intersectionObserver.disconnect();
    intersectionObserver.observe(lastItemContainer);
  });

  const handleClick = (assetId: string) => {
    void goto(Route.viewAsset({ id: assetId }));
  };
</script>

{#snippet card(item: Awaited<ReturnType<typeof getRecentlyMatched>>['items'][number])}
  <button
    type="button"
    class="block w-full overflow-hidden rounded-lg transition-transform hover:scale-105 focus:ring-2 focus:ring-immich-primary focus:outline-none"
    onclick={() => handleClick(item.assetId)}
  >
    <ImageThumbnail
      url={getAssetMediaUrl({ id: item.assetId, size: AssetMediaSize.Thumbnail })}
      altText={item.personName || '—'}
      widthStyle="100%"
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
{/snippet}

<header>
  <div class="fixed inset-s-0 top-0 z-2 w-full">
    <ControlAppBar onClose={() => goto(Route.people())} backIcon={mdiArrowLeft}>
      <div class="w-full flex-1 ps-4">
        <p class="text-lg font-medium text-immich-fg dark:text-immich-dark-fg">Recently recognized</p>
        <p class="text-sm text-gray-500 dark:text-gray-400">
          {$t('assets_count', { values: { count } })}
        </p>
      </div>
    </ControlAppBar>
  </div>
</header>

<section class="min-h-[calc(100vh-8rem)] pt-24 pb-16">
  <div class="grid w-full grid-cols-3 gap-2 px-4 sm:grid-cols-5 lg:grid-cols-8 xl:grid-cols-10">
    {#each items as item, index (item.assetId + item.personId)}
      {#if hasMore && index === items.length - 1}
        <div bind:this={lastItemContainer}>
          {@render card(item)}
        </div>
      {:else}
        <div>
          {@render card(item)}
        </div>
      {/if}
    {/each}
  </div>

  {#if loading && items.length === 0}
    <div class="flex min-h-[calc(66vh-11rem)] w-full place-content-center items-center">
      <LoadingSpinner />
    </div>
  {/if}
</section>
