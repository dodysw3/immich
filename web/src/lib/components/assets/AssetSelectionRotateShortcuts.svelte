<script lang="ts">
  import { shouldIgnoreEvent } from '$lib/actions/shortcut';
  import { ProjectionType } from '$lib/constants';
  import type { AssetMultiSelectManager } from '$lib/managers/asset-multi-select-manager.svelte';
  import { assetViewerManager } from '$lib/managers/asset-viewer-manager.svelte';
  import { editManager } from '$lib/managers/edit/edit-manager.svelte';
  import { searchStore } from '$lib/stores/search.svelte';
  import { handlePromiseError } from '$lib/utils';
  import { isModalOpen } from '@immich/ui';

  type Props = {
    assetInteraction: AssetMultiSelectManager;
  };

  let { assetInteraction }: Props = $props();

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
</script>

<svelte:document onkeydown={onRotateShortcut} />
