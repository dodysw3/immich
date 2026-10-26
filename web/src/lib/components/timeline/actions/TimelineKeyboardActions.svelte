<script lang="ts">
  import { goto } from '$app/navigation';
  import { shortcuts, shouldIgnoreEvent, type ShortcutOptions } from '$lib/actions/shortcut';
  import {
    setFocusToAsset as setFocusAssetInit,
    setFocusTo as setFocusToInit,
  } from '$lib/components/timeline/actions/focus-actions';
  import { ProjectionType } from '$lib/constants';
  import type { AssetMultiSelectManager } from '$lib/managers/asset-multi-select-manager.svelte';
  import { assetViewerManager } from '$lib/managers/asset-viewer-manager.svelte';
  import { editManager } from '$lib/managers/edit/edit-manager.svelte';
  import { eventManager } from '$lib/managers/event-manager.svelte';
  import { featureFlagsManager } from '$lib/managers/feature-flags-manager.svelte';
  import { TimelineManager } from '$lib/managers/timeline-manager/timeline-manager.svelte';
  import type { TimelineAsset } from '$lib/managers/timeline-manager/types';
  import AssetDeleteConfirmModal from '$lib/modals/AssetDeleteConfirmModal.svelte';
  import NavigateToDateModal from '$lib/modals/NavigateToDateModal.svelte';
  import ShortcutsModal from '$lib/modals/ShortcutsModal.svelte';
  import { Route } from '$lib/route';
  import { handleStack } from '$lib/services/stack.service';
  import { keyboardManager } from '$lib/stores/keyboard-manager.svelte';
  import { showDeleteModal } from '$lib/stores/preferences.store';
  import { searchStore } from '$lib/stores/search.svelte';
  import { handlePromiseError } from '$lib/utils';
  import { deleteAssets } from '$lib/utils/actions';
  import { archiveAssets, selectAllAssets } from '$lib/utils/asset-utils';
  import { AssetVisibility } from '@immich/sdk';
  import { isModalOpen, modalManager } from '@immich/ui';

  type Props = {
    timelineManager: TimelineManager;
    assetInteraction: AssetMultiSelectManager;
    onEscape?: () => void;
    scrollToAsset: (asset: TimelineAsset) => boolean;
  };

  let { timelineManager = $bindable(), assetInteraction, onEscape, scrollToAsset }: Props = $props();

  const trashOrDelete = async (forceRequested?: boolean) => {
    const force = forceRequested || !featureFlagsManager.value.trash;
    const selectedAssets = assetInteraction.assets;

    if ($showDeleteModal && force) {
      const confirmed = await modalManager.show(AssetDeleteConfirmModal, { size: selectedAssets.length });
      if (!confirmed) {
        return;
      }
    }

    await deleteAssets(
      force,
      (assetIds) => timelineManager.removeAssets(assetIds),
      selectedAssets,
      force ? undefined : (assets) => timelineManager.upsertAssets(assets),
    );
    assetInteraction.clear();
  };

  const onDelete = () => {
    const hasTrashedAsset = assetInteraction.assets.some((asset) => asset.isTrashed);
    handlePromiseError(trashOrDelete(hasTrashedAsset));
  };

  const onStackAssets = async () => {
    await handleStack(assetInteraction.assets.map((asset) => asset.id));
    onEscape?.();
  };

  const toggleArchive = async () => {
    const visibility = assetInteraction.isAllArchived ? AssetVisibility.Timeline : AssetVisibility.Archive;
    const ids = await archiveAssets(assetInteraction.assets, visibility);
    timelineManager.update(ids, (asset) => (asset.visibility = visibility));
    eventManager.emit('AssetsArchive', ids);
    assetInteraction.clear();
  };

  const onInstantRotateSelected = (angle: 90 | -90) => {
    const rotatable = assetInteraction.ownedAssets.filter(
      (asset) => asset.isImage && !asset.livePhotoVideoId && asset.projectionType !== ProjectionType.EQUIRECTANGULAR,
    );

    if (rotatable.length === 0) {
      return;
    }

    handlePromiseError(editManager.applyInstantRotateBulk(rotatable, angle));
  };

  // Match on keyboard "code" so physical Shift+[ / Shift+] works regardless of produced character.
  const onRotateShortcut = (event: KeyboardEvent) => {
    if (
      event.defaultPrevented ||
      shouldIgnoreEvent(event) ||
      event.repeat ||
      searchStore.isSearchEnabled ||
      assetViewerManager.isViewing ||
      isModalOpen() ||
      !assetInteraction.selectionActive
    ) {
      return;
    }

    const noExtraModifiers = !event.ctrlKey && !event.altKey && !event.metaKey;
    const isRotateLeft = noExtraModifiers && event.shiftKey && event.code === 'BracketLeft';
    const isRotateRight = noExtraModifiers && event.shiftKey && event.code === 'BracketRight';

    if (!isRotateLeft && !isRotateRight) {
      return;
    }

    event.preventDefault();
    event.stopPropagation();

    onInstantRotateSelected(isRotateLeft ? -90 : 90);
  };

  const onSelectStart = (e: Event) => {
    if (!searchStore.isSearchEnabled && assetInteraction.selectionActive && keyboardManager.shift) {
      e.preventDefault();
    }
  };

  const isEmpty = $derived(timelineManager.isInitialized && timelineManager.months.length === 0);
  let isShortcutModalOpen = false;

  const handleOpenShortcutModal = async () => {
    if (isShortcutModalOpen) {
      return;
    }

    isShortcutModalOpen = true;
    await modalManager.show(ShortcutsModal, {});
    isShortcutModalOpen = false;
  };

  $effect(() => {
    if (isEmpty) {
      assetInteraction.clear();
    }
  });

  const setFocusTo = setFocusToInit.bind(undefined, scrollToAsset, timelineManager);
  const setFocusAsset = setFocusAssetInit.bind(undefined, scrollToAsset);

  const handleOpenDateModal = async () => {
    const asset = await modalManager.show(NavigateToDateModal, { timelineManager });
    if (asset) {
      setFocusAsset(asset);
    }
  };

  const shortcutList = $derived.by(() => {
    if (searchStore.isSearchEnabled || assetViewerManager.isViewing || isModalOpen()) {
      return [];
    }

    const shortcuts: ShortcutOptions[] = [
      { shortcut: { key: '?', shift: true }, onShortcut: handleOpenShortcutModal },
      { shortcut: { key: '/' }, onShortcut: () => goto(Route.explore()) },
      { shortcut: { key: 'A', ctrl: true }, onShortcut: () => selectAllAssets(timelineManager, assetInteraction) },
      { shortcut: { key: 'ArrowRight' }, onShortcut: () => setFocusTo('earlier', 'asset') },
      { shortcut: { key: 'ArrowLeft' }, onShortcut: () => setFocusTo('later', 'asset') },
      { shortcut: { key: 'D' }, onShortcut: () => setFocusTo('earlier', 'day') },
      { shortcut: { key: 'M' }, onShortcut: () => setFocusTo('earlier', 'month') },
      { shortcut: { key: 'M', shift: true }, onShortcut: () => setFocusTo('later', 'month') },
      { shortcut: { key: 'Y' }, onShortcut: () => setFocusTo('earlier', 'year') },
      { shortcut: { key: 'Y', shift: true }, onShortcut: () => setFocusTo('later', 'year') },
      { shortcut: { key: 'G' }, onShortcut: handleOpenDateModal },
    ];
    if (onEscape) {
      shortcuts.push({ shortcut: { key: 'Escape' }, onShortcut: onEscape });
    }

    if (assetInteraction.selectionActive) {
      shortcuts.push(
        { shortcut: { key: 'Delete' }, onShortcut: onDelete },
        { shortcut: { key: 'Delete', shift: true }, onShortcut: () => trashOrDelete(true) },
        { shortcut: { key: 'D', ctrl: true }, onShortcut: () => assetInteraction.clear() },
        { shortcut: { key: 's' }, onShortcut: () => onStackAssets() },
        { shortcut: { key: 'a', shift: true }, onShortcut: toggleArchive },
      );
    } else {
      // conflicting shortcuts
      shortcuts.push({ shortcut: { key: 'D', shift: true }, onShortcut: () => setFocusTo('later', 'day') });
    }

    return shortcuts;
  });
</script>

<svelte:document onselectstart={onSelectStart} onkeydown={onRotateShortcut} use:shortcuts={shortcutList} />
