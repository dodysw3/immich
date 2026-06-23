<script lang="ts">
  import { afterNavigate, beforeNavigate, goto } from '$app/navigation';
  import { navigating } from '$app/stores';
  import { page } from '$app/state';
  import ActionMenuItem from '$lib/components/ActionMenuItem.svelte';
  import ButtonContextMenu from '$lib/components/shared-components/context-menu/ButtonContextMenu.svelte';
  import ControlAppBar from '$lib/components/shared-components/ControlAppBar.svelte';
  import GalleryViewer from '$lib/components/shared-components/gallery-viewer/GalleryViewer.svelte';
  import ArchiveAction from '$lib/components/timeline/actions/ArchiveAction.svelte';
  import ChangeDate from '$lib/components/timeline/actions/ChangeDateAction.svelte';
  import ChangeDescription from '$lib/components/timeline/actions/ChangeDescriptionAction.svelte';
  import ChangeLocation from '$lib/components/timeline/actions/ChangeLocationAction.svelte';
  import CreateSharedLink from '$lib/components/timeline/actions/CreateSharedLinkAction.svelte';
  import DeleteAssets from '$lib/components/timeline/actions/DeleteAssetsAction.svelte';
  import DownloadAction from '$lib/components/timeline/actions/DownloadAction.svelte';
  import FavoriteAction from '$lib/components/timeline/actions/FavoriteAction.svelte';
  import SetVisibilityAction from '$lib/components/timeline/actions/SetVisibilityAction.svelte';
  import TagAction from '$lib/components/timeline/actions/TagAction.svelte';
  import AssetSelectControlBar from '$lib/components/timeline/AssetSelectControlBar.svelte';
  import { assetMultiSelectManager } from '$lib/managers/asset-multi-select-manager.svelte';
  import { authManager } from '$lib/managers/auth-manager.svelte';
  import type { Viewport } from '$lib/managers/timeline-manager/types';
  import { Route } from '$lib/route';
  import { getAssetBulkActions } from '$lib/services/asset.service';
  import { SessionStorageKey } from '$lib/constants';
  import { handlePromiseError } from '$lib/utils';
  import { handleError } from '$lib/utils/handle-error';
  import { isPeopleRoute } from '$lib/utils/navigation';
  import { toTimelineAsset } from '$lib/utils/timeline-util';
  import { createPageMap, getLoadedAssets } from '$lib/utils/page-map';
  import { getPersonAssets } from '@immich/sdk';
  import {
    ActionButton,
    CommandPaletteDefaultProvider,
    Icon,
    IconButton,
    LoadingSpinner,
  } from '@immich/ui';
  import { mdiArrowLeft, mdiDotsVertical, mdiImageOffOutline, mdiSelectAll } from '@mdi/js';
  import { onDestroy, tick } from 'svelte';
  import { t } from 'svelte-i18n';
  import type { PageData } from './$types';

  interface Props {
    data: PageData;
  }

  let { data }: Props = $props();

  const viewport: Viewport = $state({ width: 0, height: 0 });
  let previousRoute = $state<string>(Route.photos());

  /** PageMap holds all pages tracked by page number */
  let pageMap = $state(createPageMap());
  let total = $state(data.total);
  let currentPage = $state(1);
  let isLoading = $state(false);

  // Initialize page 1 from server data (direct property mutation for full reactivity)
  if (data.assets.length > 0) {
    pageMap[1] = { status: 'loaded', assets: data.assets, height: 0 };
  }

  const hasMore = $derived(getLoadedAssets(pageMap).length < total);

  const fetchPage = async (page: number) => {
    const response = await getPersonAssets({
      id: data.person.id,
      page,
      limit: 100,
    });
    pageMap[page] = { status: 'loaded', assets: response.assets, height: 0 };
    total = response.total;
  };

  const matchedPrefix = `/people/${data.person.id}/matched`;

  const unsubscribeNavigating = navigating.subscribe((navigation) => {
    if (navigation?.to) {
      const existing = sessionStorage.getItem(SessionStorageKey.MATCHED_SCROLL_POSITION);
      if (!existing && !navigation.to.url.pathname.startsWith(matchedPrefix)) {
        const scrollPos = document.scrollingElement?.scrollTop ?? 0;
        if (scrollPos > 0) {
          sessionStorage.setItem(SessionStorageKey.MATCHED_SCROLL_POSITION, scrollPos.toString());
        }
        if (currentPage > 1) {
          sessionStorage.setItem(SessionStorageKey.MATCHED_SCROLL_PAGE, currentPage.toString());
        }
      }
    }
  });

  handlePromiseError(
    (async () => {
      const savedPage = sessionStorage.getItem(SessionStorageKey.MATCHED_SCROLL_PAGE);
      if (savedPage) {
        const targetPage = parseInt(savedPage, 10);
        for (let p = 2; p <= targetPage; p++) {
          try {
            await fetchPage(p);
          } catch {
            // skip failed pages
          }
        }
        currentPage = targetPage;
        sessionStorage.removeItem(SessionStorageKey.MATCHED_SCROLL_PAGE);
      }

      const savedScroll = sessionStorage.getItem(SessionStorageKey.MATCHED_SCROLL_POSITION);
      if (savedScroll) {
        await tick();
        document.scrollingElement?.scrollTo({
          top: parseFloat(savedScroll),
          behavior: 'instant',
        });
        sessionStorage.removeItem(SessionStorageKey.MATCHED_SCROLL_POSITION);
      }
    })(),
  );

  onDestroy(() => {
    unsubscribeNavigating();
  });

  let scrollBeforeAssetView = 0;

  const isAssetUrl = (pathname: string) => pathname.includes('/matched/photos/');

  beforeNavigate(({ to, from }) => {
    if (from?.url && to?.url && from.url.pathname.startsWith(matchedPrefix) && to.url.pathname.startsWith(matchedPrefix)) {
      if (!isAssetUrl(from.url.pathname) && isAssetUrl(to.url.pathname)) {
        scrollBeforeAssetView = document.scrollingElement?.scrollTop ?? 0;
      }
    }
  });

  afterNavigate(({ from, to }) => {
    if (from?.url && to?.url && isAssetUrl(from.url.pathname) && !isAssetUrl(to.url.pathname) && scrollBeforeAssetView > 0) {
      const restore = scrollBeforeAssetView;
      scrollBeforeAssetView = 0;
      void tick().then(() => {
        document.scrollingElement?.scrollTo({ top: restore, behavior: 'instant' });
      });
    }
  });

  afterNavigate(({ from }) => {
    if (from?.url && from.route.id !== page.route.id) {
      previousRoute = from.url.href;
    }
    const route = from?.route?.id;
    if (isPeopleRoute(route)) {
      previousRoute = Route.people();
    }
  });

  const loadMore = async () => {
    if (isLoading || !hasMore) {
      return;
    }
    isLoading = true;
    currentPage += 1;
    try {
      await fetchPage(currentPage);
    } catch (error) {
      handleError(error, $t('error_loading_image'));
    } finally {
      isLoading = false;
    }
  };

  /** Re-fetch a specific page when a ghost page scrolls back into viewport */
  const reloadPage = async (pageNum: number) => {
    try {
      const response = await getPersonAssets({
        id: data.person.id,
        page: pageNum,
        limit: 100,
      });
      pageMap[pageNum] = { status: 'loaded', assets: response.assets, height: 0 };
    } catch (error) {
      handleError(error, $t('error_loading_image'));
      // If reload fails, mark as ghost again to allow retry
      const existing = pageMap[pageNum];
      if (existing && existing.status === 'loading') {
        pageMap[pageNum] = { status: 'ghost', height: existing.ghostHeight };
      }
    }
  };

  const onAssetDelete = (assetIds: string[]) => {
    const assetIdSet = new Set(assetIds);
    for (const state of Object.values(pageMap)) {
      if (state.status === 'loaded') {
        state.assets = state.assets.filter((a) => !assetIdSet.has(a.id));
      }
    }
    total -= assetIds.length;
  };

  const handleSetVisibility = (assetIds: string[]) => {
    assetMultiSelectManager.clear();
    onAssetDelete(assetIds);
  };

  const handleSelectAll = () => {
    assetMultiSelectManager.selectAssets(getLoadedAssets(pageMap).map((asset) => toTimelineAsset(asset)));
  };
</script>

<section
  class="m-4 mb-12 max-h-screen bg-immich-bg dark:bg-immich-dark-bg"
  bind:clientHeight={viewport.height}
  bind:clientWidth={viewport.width}
>
  {#if getLoadedAssets(pageMap).length > 0}
    <GalleryViewer
      assets={[]}
      {viewport}
      assetInteraction={assetMultiSelectManager}
      onEndReached={hasMore ? loadMore : undefined}
      showArchiveIcon={true}
      {pageMap}
      {reloadPage}
      pageHeaderOffset={64}
    />
  {:else if !isLoading}
    <div class="flex min-h-[calc(100vh-12rem)] items-center justify-center">
      <div class="flex flex-col items-center text-center">
        <Icon icon={mdiImageOffOutline} size="4em" class="text-gray-300 dark:text-gray-600" />
        <p class="mt-4 text-lg text-gray-500 dark:text-gray-400">No assets found</p>
      </div>
    </div>
  {/if}

  {#if isLoading && getLoadedAssets(pageMap).length === 0}
    <div class="flex min-h-[calc(100vh-12rem)] items-center justify-center">
      <LoadingSpinner />
    </div>
  {/if}
</section>

<header>
  {#if assetMultiSelectManager.selectionActive}
    <div class="fixed inset-s-0 top-0 z-2 w-full">
      <AssetSelectControlBar>
        {@const Actions = getAssetBulkActions($t)}
        <CommandPaletteDefaultProvider name={$t('assets')} actions={Object.values(Actions)} />
        <CreateSharedLink />
        <IconButton
          shape="round"
          color="secondary"
          variant="ghost"
          aria-label={$t('select_all')}
          icon={mdiSelectAll}
          onclick={handleSelectAll}
        />
        <ActionButton action={Actions.AddToAlbum} />
        {#if assetMultiSelectManager.isAllUserOwned}
          <FavoriteAction
            removeFavorite={assetMultiSelectManager.isAllFavorite}
            onFavorite={() => {
              assetMultiSelectManager.clear();
            }}
          />
          <ButtonContextMenu icon={mdiDotsVertical} title={$t('menu')}>
            <ActionMenuItem action={Actions.AddToAlbum} />
            <DownloadAction menuItem />
            <ChangeDate menuItem />
            <ChangeDescription menuItem />
            <ChangeLocation menuItem />
            <ArchiveAction
              menuItem
              unarchive={assetMultiSelectManager.isAllArchived}
              onArchive={() => {
                assetMultiSelectManager.clear();
              }}
            />
            <SetVisibilityAction menuItem onVisibilitySet={handleSetVisibility} />
            {#if authManager.preferences.tags.enabled}
              <TagAction menuItem />
            {/if}
            <DeleteAssets menuItem {onAssetDelete} />
          </ButtonContextMenu>
        {:else}
          <DownloadAction />
        {/if}
      </AssetSelectControlBar>
    </div>
  {:else}
    <div class="fixed inset-s-0 top-0 z-2 w-full">
      <ControlAppBar onClose={() => goto(previousRoute)} backIcon={mdiArrowLeft}>
        <div class="w-full flex-1 ps-4">
          <p class="text-lg font-medium text-immich-fg dark:text-immich-dark-fg">
            {data.person.name || $t('person')} — Recently matched
          </p>
          <p class="text-sm text-gray-500 dark:text-gray-400">
            {$t('assets_count', { values: { count: total } })}
          </p>
        </div>
      </ControlAppBar>
    </div>
  {/if}
</header>
