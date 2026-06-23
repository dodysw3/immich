<script lang="ts">
  import { goto } from '$app/navigation';
  import { shortcuts, type ShortcutOptions } from '$lib/actions/shortcut';
  import type { Action } from '$lib/components/asset-viewer/actions/action';
  import type { AssetCursor } from '$lib/components/asset-viewer/AssetViewer.svelte';
  import Thumbnail from '$lib/components/assets/thumbnail/Thumbnail.svelte';
  import { AssetAction } from '$lib/constants';
  import Portal from '$lib/elements/Portal.svelte';
  import type { AssetMultiSelectManager } from '$lib/managers/asset-multi-select-manager.svelte';
  import { assetViewerManager } from '$lib/managers/asset-viewer-manager.svelte';
  import { featureFlagsManager } from '$lib/managers/feature-flags-manager.svelte';
  import type { TimelineAsset, Viewport } from '$lib/managers/timeline-manager/types';
  import AssetDeleteConfirmModal from '$lib/modals/AssetDeleteConfirmModal.svelte';
  import ShortcutsModal from '$lib/modals/ShortcutsModal.svelte';
  import { Route } from '$lib/route';
  import { keyboardManager } from '$lib/stores/keyboard-manager.svelte';
  import { showDeleteModal } from '$lib/stores/preferences.store';
  import { handlePromiseError } from '$lib/utils';
  import { deleteAssets } from '$lib/utils/actions';
  import { archiveAssets, getNextAsset, getPreviousAsset, navigateToAsset } from '$lib/utils/asset-utils';
  import { moveFocus } from '$lib/utils/focus-util';
  import { handleError } from '$lib/utils/handle-error';
  import { getJustifiedLayoutFromAssets } from '$lib/utils/layout-utils';
  import { navigate } from '$lib/utils/navigation';
  import { isTimelineAsset, toTimelineAsset } from '$lib/utils/timeline-util';
  import { type PageMap, getLoadedAssets, getContainerHeight, findGhostPagesNearViewport } from '$lib/utils/page-map';
  import { TUNABLES } from '$lib/utils/tunables';
  import { AssetVisibility, type AssetResponseDto } from '@immich/sdk';
  import { modalManager } from '@immich/ui';
  import { debounce, throttle } from 'lodash-es';
  import { t } from 'svelte-i18n';

  const {
    TIMELINE: { INTERSECTION_EXPAND_TOP, INTERSECTION_EXPAND_BOTTOM },
  } = TUNABLES;

  type Props = {
    assets: AssetResponseDto[];
    viewerAssets?: AssetResponseDto[];
    assetInteraction: AssetMultiSelectManager;
    disableAssetSelect?: boolean;
    showArchiveIcon?: boolean;
    viewport: Viewport;
    onEndReached?: (() => void) | undefined;
    showAssetName?: boolean;
    onReload?: (() => void) | undefined;
    pageHeaderOffset?: number;
    slidingWindowOffset?: number;
    arrowNavigation?: boolean;
    allowDeletion?: boolean;
    pageMap?: PageMap | undefined;
    reloadPage?: ((pageNum: number) => Promise<void>) | undefined;
  };

  let {
    assets = $bindable(),
    viewerAssets,
    assetInteraction,
    disableAssetSelect = false,
    showArchiveIcon = false,
    viewport,
    onEndReached = undefined,
    showAssetName = false,
    onReload = undefined,
    slidingWindowOffset = 0,
    pageHeaderOffset = 0,
    arrowNavigation = true,
    allowDeletion = true,
    pageMap = undefined,
    reloadPage = undefined,
  }: Props = $props();

  const resolvedAssets = $derived(pageMap ? getLoadedAssets(pageMap) : assets);

  const navigationAssets = $derived(viewerAssets ?? resolvedAssets);

  const geometry = $derived(
    getJustifiedLayoutFromAssets(resolvedAssets, {
      spacing: 2,
      heightTolerance: 0.5,
      rowHeight: Math.floor(viewport.width) < 850 ? 100 : 235,
      rowWidth: Math.floor(viewport.width),
    }),
  );

  const loadingHeightSum = $derived.by(() => {
    if (!pageMap) {
      return 0;
    }
    let sum = 0;
    for (const state of Object.values(pageMap)) {
      if (state.status === 'loading') {
        sum += state.ghostHeight;
      }
    }
    return sum;
  });

  $effect(() => {
    if (!pageMap) {
      return;
    }
    const sortedKeys = Object.keys(pageMap).map(Number).sort((a, b) => a - b);
    for (const pageNum of sortedKeys) {
      const state = pageMap[pageNum];
      if (state.status === 'loaded') {
        const range = pageAssetRanges.get(pageNum);
        if (range) {
          const height =
            geometry.getTop(range.last) + geometry.getHeight(range.last) - geometry.getTop(range.first);
          if (state.height !== height) {
            pageMap[pageNum] = { ...state, height };
          }
        }
      }
    }
  });

  const effectiveContainerHeight = $derived(
    pageMap ? getContainerHeight(pageMap) + loadingHeightSum : geometry.containerHeight,
  );

  const assetPositionOffsets = $derived.by(() => {
    if (!pageMap) {
      return [];
    }
    const offsets: number[] = [];
    const sortedKeys = Object.keys(pageMap)
      .map(Number)
      .sort((a, b) => a - b);
    let ghostAccum = 0;

    for (const key of sortedKeys) {
      const state = pageMap[key];
      if (state.status === 'ghost') {
        ghostAccum += state.height;
      } else if (state.status === 'loaded') {
        for (let j = 0; j < state.assets.length; j++) {
          offsets.push(ghostAccum);
        }
      }
    }

    return offsets;
  });

  const pageAssetRanges = $derived.by(() => {
    if (!pageMap) {
      return new Map<number, { first: number; last: number }>();
    }
    const ranges = new Map<number, { first: number; last: number }>();
    const sortedKeys = Object.keys(pageMap).map(Number).sort((a, b) => a - b);
    let assetIndex = 0;

    for (const pageNum of sortedKeys) {
      const state = pageMap[pageNum];
      if (state.status === 'loaded') {
        const first = assetIndex;
        assetIndex += state.assets.length;
        ranges.set(pageNum, { first, last: assetIndex - 1 });
      }
    }

    return ranges;
  });

  const visibleLoadingPages = $derived.by(() => {
    if (!pageMap) {
      return [];
    }
    const sortedKeys = Object.keys(pageMap).map(Number).sort((a, b) => a - b);
    const result: { top: number; height: number }[] = [];
    let accumulated = 0;
    const windowBottom = slidingWindow.bottom;
    const windowTop = slidingWindow.top - pageHeaderOffset;

    for (const key of sortedKeys) {
      const state = pageMap[key];
      if (state.status === 'loading') {
        const top = accumulated;
        const height = state.ghostHeight || 0;
        if (height > 0 && top + height > windowTop && top < windowBottom) {
          result.push({ top, height });
        }
        accumulated += height;
      } else if (state.status === 'loaded' || state.status === 'ghost') {
        accumulated += state.height;
      }
    }
    return result;
  });

  let lastViewportWidth = $state(viewport.width);
  $effect(() => {
    if (pageMap && lastViewportWidth > 0 && viewport.width !== lastViewportWidth) {
      for (const pageNum of Object.keys(pageMap).map(Number).sort((a, b) => a - b)) {
        const state = pageMap[pageNum];
        if (state.status === 'ghost') {
          pageMap[pageNum] = { status: 'unloaded' };
        }
      }
    }
    lastViewportWidth = viewport.width;
  });

  const getStyle = (i: number) => {
    const offset = assetPositionOffsets[i] || 0;
    return `top: ${geometry.getTop(i) + offset}px; left: ${geometry.getLeft(i)}px; width: ${geometry.getWidth(i)}px; height: ${geometry.getHeight(i)}px;`;
  };

  const isInOrNearViewport = (i: number) => {
    const window = slidingWindow;
    const offset = assetPositionOffsets[i] || 0;
    const top = geometry.getTop(i) + offset;
    return top + pageHeaderOffset < window.bottom && top + geometry.getHeight(i) > window.top;
  };

  let lastAssetMouseEvent: TimelineAsset | null = $state(null);
  let scrollTop = $state(0);

  let slidingWindow = $derived.by(() => {
    const top = (scrollTop || 0) - slidingWindowOffset - INTERSECTION_EXPAND_TOP;
    const bottom = top + viewport.height + slidingWindowOffset + INTERSECTION_EXPAND_BOTTOM;
    return { top, bottom };
  });

  const updateCurrentAsset = (asset: AssetResponseDto) => {
    if (pageMap) {
      for (const state of Object.values(pageMap)) {
        if (state.status === 'loaded') {
          const index = state.assets.findIndex((a) => a.id === asset.id);
          if (index !== -1) {
            state.assets[index] = asset;
            return;
          }
        }
      }
    } else {
      const index = assets.findIndex((oldAsset) => oldAsset.id === asset.id);
      assets[index] = asset;
    }
  };

  const updateSlidingWindow = () => {
    scrollTop = document.scrollingElement?.scrollTop ?? 0;
    if (pageMap) {
      runEviction();
      triggerGhostReloads();
    }
  };

  const debouncedOnEndReached = debounce(() => {
    if (pageMap) {
      const loadingPages = Object.values(pageMap).filter((s) => s.status === 'loading');
      if (loadingPages.length === 0) {
        onEndReached?.();
      }
    } else {
      onEndReached?.();
    }
  }, 750, { maxWait: 100, leading: true });

  const runEviction = throttle(
    () => {
      if (!pageMap || !reloadPage) {
        return;
      }
      const threshold = 3;
      const currentScroll = document.scrollingElement?.scrollTop ?? 0;
      const viewportH = viewport.height || 800;
      const rangeTop = currentScroll - threshold * viewportH;
      const rangeBottom = currentScroll + viewportH + threshold * viewportH;

      let accumulated = 0;
      const sortedKeys = Object.keys(pageMap).map(Number).sort((a, b) => a - b);

      for (const pageNum of sortedKeys) {
        const state = pageMap[pageNum];
        let pageHeight = 0;
        if (state.status === 'loaded') {
          const range = pageAssetRanges.get(pageNum);
          if (range) {
            pageHeight =
              geometry.getTop(range.last) + geometry.getHeight(range.last) - geometry.getTop(range.first);
          }
        } else if (state.status === 'ghost') {
          pageHeight = state.height;
        }

        const pageTop = accumulated;
        const pageBottom = accumulated + pageHeight;

        if (state.status === 'loaded' && pageHeight > 0 && (pageBottom <= rangeTop || pageTop >= rangeBottom)) {
          pageMap[pageNum] = { status: 'ghost', height: pageHeight };
        }

        if (pageHeight > 0) {
          accumulated += pageHeight;
        }
      }
    },
    200,
    { trailing: true },
  );

  const triggerGhostReloads = throttle(
    () => {
      if (!pageMap || !reloadPage) {
        return;
      }
      const currentScroll = document.scrollingElement?.scrollTop ?? 0;
      const viewportH = viewport.height || 800;
      const threshold = 2;

      const nearbyGhosts = findGhostPagesNearViewport(pageMap, currentScroll, viewportH, threshold);

      for (const pageNum of nearbyGhosts) {
        const currentState = pageMap[pageNum];
        if (currentState && currentState.status === 'ghost' && !loadingPagesSet.has(pageNum)) {
          loadingPagesSet.add(pageNum);
          pageMap[pageNum] = { status: 'loading', ghostHeight: currentState.height };
          reloadPage(pageNum).finally(() => {
            loadingPagesSet.delete(pageNum);
          });
        }
      }
    },
    250,
    { trailing: true },
  );

  const loadingPagesSet = new Set<number>();

  let lastEndReachedBottom = 0;
  $effect(() => {
    if (effectiveContainerHeight - slidingWindow.bottom <= viewport.height) {
      if (slidingWindow.bottom > lastEndReachedBottom || lastEndReachedBottom === 0) {
        debouncedOnEndReached();
        lastEndReachedBottom = slidingWindow.bottom;
      }
    } else {
      lastEndReachedBottom = 0;
    }
  });

  const selectAllAssets = () => {
    assetInteraction.selectAssets(resolvedAssets.map((a) => toTimelineAsset(a)));
  };

  const handleSelectAssets = (asset: TimelineAsset) => {
    if (!asset) {
      return;
    }
    const deselect = assetInteraction.hasSelectedAsset(asset.id);

    if (deselect) {
      for (const candidate of assetInteraction.candidates) {
        assetInteraction.removeAssetFromMultiselectGroup(candidate.id);
      }
      assetInteraction.removeAssetFromMultiselectGroup(asset.id);
    } else {
      for (const candidate of assetInteraction.candidates) {
        assetInteraction.selectAsset(candidate);
      }
      assetInteraction.selectAsset(asset);
    }

    assetInteraction.clearCandidates();
    assetInteraction.setAssetSelectionStart(deselect ? null : asset);
  };

  const handleSelectAssetCandidates = (asset: TimelineAsset | null) => {
    if (asset) {
      selectAssetCandidates(asset);
    }
    lastAssetMouseEvent = asset;
  };

  const selectAssetCandidates = (endAsset: TimelineAsset) => {
    if (!keyboardManager.shift) {
      return;
    }

    const startAsset = assetInteraction.startAsset;
    if (!startAsset) {
      return;
    }

    let start = resolvedAssets.findIndex((a) => a.id === startAsset.id);
    let end = resolvedAssets.findIndex((a) => a.id === endAsset.id);

    if (start > end) {
      [start, end] = [end, start];
    }

    assetInteraction.setAssetSelectionCandidates(resolvedAssets.slice(start, end + 1).map((a) => toTimelineAsset(a)));
  };

  const onSelectStart = (event: Event) => {
    if (assetInteraction.selectionActive && keyboardManager.shift) {
      event.preventDefault();
    }
  };

  const onDelete = () => {
    const hasTrashedAsset = assetInteraction.assets.some((asset) => asset.isTrashed);
    handlePromiseError(trashOrDelete(hasTrashedAsset));
  };

  const trashOrDelete = async (force: boolean = false) => {
    const forceOrNoTrash = force || !featureFlagsManager.value.trash;
    const selectedAssets = assetInteraction.assets;

    if ($showDeleteModal && forceOrNoTrash) {
      const confirmed = await modalManager.show(AssetDeleteConfirmModal, { size: selectedAssets.length });
      if (!confirmed) {
        return;
      }
    }

    const removeFromData = (assetIds: string[]) => {
      if (pageMap) {
        for (const state of Object.values(pageMap)) {
          if (state.status === 'loaded') {
            state.assets = state.assets.filter((a) => !assetIds.includes(a.id));
          }
        }
      } else {
        assets = assets.filter((asset) => !assetIds.includes(asset.id));
      }
    };

    await deleteAssets(
      forceOrNoTrash,
      removeFromData,
      selectedAssets,
      onReload,
    );

    assetInteraction.clear();
  };

  const toggleArchive = async () => {
    const ids = await archiveAssets(
      assetInteraction.assets,
      assetInteraction.isAllArchived ? AssetVisibility.Timeline : AssetVisibility.Archive,
    );
    if (ids) {
      if (pageMap) {
        for (const state of Object.values(pageMap)) {
          if (state.status === 'loaded') {
            state.assets = state.assets.filter((a) => !ids.includes(a.id));
          }
        }
      } else {
        assets = assets.filter((asset) => !ids.includes(asset.id));
      }
      assetInteraction.clear();
    }
  };

  const focusNextAsset = () => moveFocus((element) => element.dataset.thumbnailFocusContainer !== undefined, 'next');
  const focusPreviousAsset = () =>
    moveFocus((element) => element.dataset.thumbnailFocusContainer !== undefined, 'previous');

  let isShortcutModalOpen = false;

  const handleOpenShortcutModal = async () => {
    if (isShortcutModalOpen) {
      return;
    }

    isShortcutModalOpen = true;
    await modalManager.show(ShortcutsModal, {});
    isShortcutModalOpen = false;
  };

  const shortcutList = $derived(
    (() => {
      if (assetViewerManager.isViewing) {
        return [];
      }

      const shortcuts: ShortcutOptions[] = [
        { shortcut: { key: '?', shift: true }, onShortcut: handleOpenShortcutModal },
        { shortcut: { key: '/' }, onShortcut: () => goto(Route.explore()) },
        { shortcut: { key: 'A', ctrl: true }, onShortcut: () => selectAllAssets() },
        ...(arrowNavigation
          ? [
              { shortcut: { key: 'ArrowRight' }, preventDefault: false, onShortcut: focusNextAsset },
              { shortcut: { key: 'ArrowLeft' }, preventDefault: false, onShortcut: focusPreviousAsset },
            ]
          : []),
      ];

      if (assetInteraction.selectionActive) {
        shortcuts.push(
          { shortcut: { key: 'Escape' }, onShortcut: () => assetInteraction.clear() },
          { shortcut: { key: 'D', ctrl: true }, onShortcut: () => assetInteraction.clear() },
        );
        if (allowDeletion) {
          shortcuts.push(
            { shortcut: { key: 'Delete' }, onShortcut: onDelete },
            { shortcut: { key: 'Delete', shift: true }, onShortcut: () => trashOrDelete(true) },
            { shortcut: { key: 'a', shift: true }, onShortcut: toggleArchive },
          );
        }
      }

      return shortcuts;
    })(),
  );

  const handleRandom = async (): Promise<{ id: string } | undefined> => {
    if (navigationAssets.length === 0) {
      return;
    }
    try {
      const randomIndex = Math.floor(Math.random() * navigationAssets.length);
      const asset = navigationAssets[randomIndex];

      await navigateToAsset(asset);
      return asset;
    } catch (error) {
      handleError(error, $t('errors.cannot_navigate_next_asset'));
      return;
    }
  };

  const handleAction = async (action: Action) => {
    switch (action.type) {
      case AssetAction.ARCHIVE:
      case AssetAction.DELETE:
      case AssetAction.TRASH: {
        const nextAsset = assetCursor.nextAsset ?? assetCursor.previousAsset;
        if (pageMap) {
          for (const state of Object.values(pageMap)) {
            if (state.status === 'loaded') {
              const idx = state.assets.findIndex((a) => a.id === action.asset.id);
              if (idx !== -1) {
                state.assets.splice(idx, 1);
                break;
              }
            }
          }
        } else {
          assets.splice(
            assets.findIndex((currentAsset) => currentAsset.id === action.asset.id),
            1,
          );
        }
        if (resolvedAssets.length === 0) {
          return await goto(Route.photos());
        }
        if (nextAsset) {
          await navigateToAsset(nextAsset);
        }
        break;
      }
      // no default
    }
  };

  const assetMouseEventHandler = (asset: TimelineAsset | null) => {
    if (assetInteraction.selectionActive) {
      handleSelectAssetCandidates(asset);
    }
  };

  $effect(() => {
    if (!lastAssetMouseEvent) {
      assetInteraction.clearCandidates();
    }
  });

  $effect(() => {
    if (!keyboardManager.shift) {
      assetInteraction.clearCandidates();
    }
  });

  $effect(() => {
    if (keyboardManager.shift && lastAssetMouseEvent) {
      selectAssetCandidates(lastAssetMouseEvent);
    }
  });

  const assetCursor = $derived<AssetCursor>({
    current: assetViewerManager.asset!,
    nextAsset: getNextAsset(navigationAssets, assetViewerManager.asset),
    previousAsset: getPreviousAsset(navigationAssets, assetViewerManager.asset),
  });
</script>

<svelte:document onselectstart={onSelectStart} use:shortcuts={shortcutList} onscroll={() => updateSlidingWindow()} />

{#if resolvedAssets.length > 0}
  <div
    style:position="relative"
    style:height={effectiveContainerHeight + 'px'}
    style:width={geometry.containerWidth + 'px'}
  >
    {#each resolvedAssets as asset, index (asset.id + '-' + index)}
      {#if isInOrNearViewport(index)}
        {@const currentAsset = toTimelineAsset(asset)}
        <div class="absolute" style:overflow="clip" style={getStyle(index)}>
          <Thumbnail
            readonly={disableAssetSelect}
            onClick={() => {
              if (assetInteraction.selectionActive) {
                handleSelectAssets(currentAsset);
                return;
              }
              void navigateToAsset(asset);
            }}
            onSelect={() => handleSelectAssets(currentAsset)}
            onPreview={assetInteraction.selectionActive ? () => void navigateToAsset(asset) : undefined}
            onMouseEvent={() => assetMouseEventHandler(currentAsset)}
            {showArchiveIcon}
            asset={currentAsset}
            selected={assetInteraction.hasSelectedAsset(currentAsset.id)}
            selectionCandidate={assetInteraction.hasSelectionCandidate(currentAsset.id)}
            thumbnailWidth={geometry.getWidth(index)}
            thumbnailHeight={geometry.getHeight(index)}
          />
          {#if showAssetName && !isTimelineAsset(asset)}
            <div
              class="absolute bottom-0 w-full overflow-clip bg-slate-50/75 bg-linear-to-t p-1 text-center font-mono text-xs font-semibold text-ellipsis whitespace-pre-wrap dark:bg-slate-800/75"
            >
              {asset.originalFileName}
            </div>
          {/if}
        </div>
      {/if}
    {/each}

    {#each visibleLoadingPages as loadingPage (loadingPage.top)}
      <div
        class="absolute w-full"
        style="top: {loadingPage.top}px; height: {loadingPage.height}px"
      >
        <div
          class="flex size-full animate-pulse items-center justify-center rounded-lg bg-gray-200 dark:bg-gray-700"
        >
          <svg
            class="size-8 animate-spin text-gray-400 dark:text-gray-500"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
          >
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
            <path
              class="opacity-75"
              fill="currentColor"
              d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"
            />
          </svg>
        </div>
      </div>
    {/each}
  </div>
{/if}

<!-- Overlay Asset Viewer -->
{#if assetViewerManager.isViewing}
  <Portal target="body">
    {#await import('$lib/components/asset-viewer/AssetViewer.svelte') then { default: AssetViewer }}
      <AssetViewer
        cursor={assetCursor}
        onAction={handleAction}
        onRandom={handleRandom}
        onAssetChange={updateCurrentAsset}
        onClose={() => {
          assetViewerManager.showAssetViewer(false);
          handlePromiseError(navigate({ targetRoute: 'current', assetId: null }));
        }}
      />
    {/await}
  </Portal>
{/if}
