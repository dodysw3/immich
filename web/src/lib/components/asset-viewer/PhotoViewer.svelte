<script lang="ts">
  import { shortcuts } from '#lib/actions/shortcut.ts';
  import { zoomImageAction } from '#lib/actions/zoom-image.ts';
  import AdaptiveImage from '#lib/components/AdaptiveImage.svelte';
  import AssetViewerEvents from '#lib/components/AssetViewerEvents.svelte';
  import Thumbhash from '#lib/components/Thumbhash.svelte';
  import BoundingBoxOverlay from '#lib/components/asset-viewer/BoundingBoxOverlay.svelte';
  import FaceEditor from '#lib/components/asset-viewer/face-editor/FaceEditor.svelte';
  import { faceOverlayStore } from '#lib/features/face-overlay/face-overlay.store.svelte.ts';
  import { assetViewerManager } from '#lib/managers/asset-viewer-manager.svelte.ts';
  import { castManager } from '#lib/managers/cast-manager.svelte.ts';
  import { ocrManager } from '#lib/stores/ocr.svelte.ts';
  import { SlideshowLook, SlideshowState, slideshowStore } from '#lib/stores/slideshow.store.ts';
  import { handlePromiseError } from '#lib/utils.ts';
  import { canCopyImageToClipboard, copyImageToClipboard } from '#lib/utils/asset-utils.ts';
  import { getNaturalSize, scaleToFit, type Size } from '#lib/utils/container-utils.ts';
  import { handleError } from '#lib/utils/handle-error.ts';
  import { type SharedLinkResponseDto } from '@immich/sdk';
  import { toastManager } from '@immich/ui';
  import { onDestroy, untrack } from 'svelte';
  import { useSwipe, type SwipeCustomEvent } from 'svelte-gestures';
  import { t } from 'svelte-i18n';
  import type { AssetCursor } from './AssetViewer.svelte';

  type Props = {
    cursor: AssetCursor;
    element?: HTMLDivElement;
    sharedLink?: SharedLinkResponseDto;
    onReady?: () => void;
    onError?: () => void;
    onSwipe?: (event: SwipeCustomEvent) => void;
  };

  let { cursor, element = $bindable(), sharedLink, onReady, onError, onSwipe }: Props = $props();

  const { slideshowState, slideshowLook } = slideshowStore;
  const asset = $derived(cursor.current);

  let visibleImageReady: boolean = $state(false);

  let previousAssetId: string | undefined;
  $effect.pre(() => {
    const id = asset.id;
    if (id === previousAssetId) {
      return;
    }
    previousAssetId = id;
    untrack(() => {
      assetViewerManager.resetZoomState();
      visibleImageReady = false;
      assetViewerManager.clearHighlightedFaces();
    });
  });

  onDestroy(() => {
    assetViewerManager.clearHighlightedFaces();
    assetViewerManager.hideHiddenPeople();
  });

  let containerWidth = $state(0);
  let containerHeight = $state(0);

  const container = $derived({
    width: containerWidth,
    height: containerHeight,
  });

  const overlaySize = $derived.by((): Size => {
    if (!assetViewerManager.imgRef || !visibleImageReady) {
      return { width: 0, height: 0 };
    }

    return scaleToFit(getNaturalSize(assetViewerManager.imgRef), { width: containerWidth, height: containerHeight });
  });

  const onCopy = async () => {
    if (!canCopyImageToClipboard() || !assetViewerManager.imgRef) {
      return;
    }

    try {
      await copyImageToClipboard(assetViewerManager.imgRef);
      toastManager.info($t('copied_image_to_clipboard'));
    } catch (error) {
      handleError(error, $t('copy_error'));
    }
  };

  const onZoom = () => {
    const targetZoom = assetViewerManager.zoom > 1 ? 1 : 2;
    assetViewerManager.animatedZoom(targetZoom);
  };

  const onFaceEditModeChange = (isFaceEditMode: boolean) => {
    if (isFaceEditMode && assetViewerManager.zoom > 1) {
      onZoom();
    }
  };

  const onPlaySlideshow = () => ($slideshowState = SlideshowState.PlaySlideshow);
  const onToggleFaceOverlay = () => faceOverlayStore.toggleOverlay();

  // TODO move to action + command palette
  const onCopyShortcut = (event: KeyboardEvent) => {
    // eslint-disable-next-line unicorn/no-unnecessary-global-this
    if (globalThis.getSelection()?.type === 'Range') {
      return;
    }
    event.preventDefault();

    handlePromiseError(onCopy());
  };

  let currentPreviewUrl = $state<string>();

  const onUrlChange = (url: string) => {
    currentPreviewUrl = url;
  };

  $effect(() => {
    if (currentPreviewUrl) {
      void cast(currentPreviewUrl);
    }
  });

  const cast = async (url: string) => {
    if (!url || !castManager.isCasting) {
      return;
    }
    const fullUrl = new URL(url, location.href);

    try {
      await castManager.loadMedia(fullUrl.href);
    } catch (error) {
      handleError(error, 'Unable to cast');
      return;
    }
  };

  const blurredSlideshow = $derived(
    $slideshowState !== SlideshowState.None && $slideshowLook === SlideshowLook.BlurredBackground && !!asset.thumbhash,
  );

  let adaptiveImage = $state<HTMLDivElement | undefined>();
</script>

<AssetViewerEvents {onCopy} {onZoom} {onFaceEditModeChange} />

<svelte:document
  use:shortcuts={[
    { shortcut: { key: 'z' }, onShortcut: onZoom, preventDefault: true },
    { shortcut: { key: 's' }, onShortcut: onPlaySlideshow, preventDefault: true },
    { shortcut: { key: 'c', ctrl: true }, onShortcut: onCopyShortcut, preventDefault: false },
    { shortcut: { key: 'c', meta: true }, onShortcut: onCopyShortcut, preventDefault: false },
    { shortcut: { key: 'f', shift: true }, onShortcut: onToggleFaceOverlay, preventDefault: true },
  ]}
/>

<div
  bind:this={element}
  class="relative size-full select-none"
  bind:clientWidth={containerWidth}
  bind:clientHeight={containerHeight}
  role="presentation"
  ondblclick={onZoom}
  {@attach zoomImageAction({
    zoomTarget: adaptiveImage,
    disabled: assetViewerManager.isFaceEditMode || ocrManager.showOverlay,
    ignoreSelector: '[data-zoom-image-ignore]',
  })}
  {...useSwipe((event) => onSwipe?.(event))}
>
  <AdaptiveImage
    {asset}
    {sharedLink}
    {container}
    objectFit={$slideshowState !== SlideshowState.None && $slideshowLook === SlideshowLook.Cover ? 'cover' : 'contain'}
    {onUrlChange}
    onImageReady={() => {
      visibleImageReady = true;
      onReady?.();
    }}
    onError={() => {
      onError?.();
      onReady?.();
    }}
    bind:imgRef={assetViewerManager.imgRef}
    bind:ref={adaptiveImage}
  >
    {#snippet backdrop()}
      {#if blurredSlideshow}
        <Thumbhash base64ThumbHash={asset.thumbhash!} class="absolute inset-s-0 top-0 left-0 h-dvh w-dvw" />
      {/if}
    {/snippet}
    {#snippet overlays()}
      <BoundingBoxOverlay {overlaySize} labelReferenceWidth={assetViewerManager.imgRef?.clientWidth} />
    {/snippet}
  </AdaptiveImage>

  {#if assetViewerManager.isFaceEditMode && assetViewerManager.imgRef}
    <FaceEditor htmlElement={assetViewerManager.imgRef} {containerWidth} {containerHeight} assetId={asset.id} />
  {/if}
</div>
