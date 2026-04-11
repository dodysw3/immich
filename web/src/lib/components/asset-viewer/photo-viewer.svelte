<script lang="ts">
  import { shortcuts } from '$lib/actions/shortcut';
  import { thumbhash } from '$lib/actions/thumbhash';
  import { zoomImageAction } from '$lib/actions/zoom-image';
  import AdaptiveImage from '$lib/components/AdaptiveImage.svelte';
  import FaceEditor from '$lib/components/asset-viewer/face-editor/face-editor.svelte';
  import OcrBoundingBox from '$lib/components/asset-viewer/ocr-bounding-box.svelte';
  import AssetViewerEvents from '$lib/components/AssetViewerEvents.svelte';
  import FaceOverlayBox from '$lib/features/face-overlay/face-overlay-box.svelte';
  import { faceOverlayStore } from '$lib/features/face-overlay/face-overlay.store.svelte';
  import type { FaceOverlayBoundingBox } from '$lib/features/face-overlay/face-overlay.utils';
  import { assetViewerManager } from '$lib/managers/asset-viewer-manager.svelte';
  import { castManager } from '$lib/managers/cast-manager.svelte';
  import { ocrManager } from '$lib/stores/ocr.svelte';
  import { boundingBoxesArray, type Faces } from '$lib/stores/people.store';
  import { SlideshowLook, SlideshowState, slideshowStore } from '$lib/stores/slideshow.store';
  import { handlePromiseError } from '$lib/utils';
  import { canCopyImageToClipboard, copyImageToClipboard } from '$lib/utils/asset-utils';
  import { getNaturalSize, scaleToFit, type Size } from '$lib/utils/container-utils';
  import { handleError } from '$lib/utils/handle-error';
  import { getOcrBoundingBoxes } from '$lib/utils/ocr-utils';
  import { getBoundingBox, type BoundingBox } from '$lib/utils/people-utils';
  import { type SharedLinkResponseDto } from '@immich/sdk';
  import { toastManager } from '@immich/ui';
  import { onDestroy, untrack } from 'svelte';
  import { useSwipe, type SwipeCustomEvent } from 'svelte-gestures';
  import { t } from 'svelte-i18n';
  import type { AssetCursor } from './asset-viewer.svelte';

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
      $boundingBoxesArray = [];
    });
  });

  onDestroy(() => {
    $boundingBoxesArray = [];
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

  const highlightedBoxes = $derived(getBoundingBox($boundingBoxesArray, overlaySize));
  const isHighlighting = $derived(highlightedBoxes.length > 0);

  let visibleBoxes = $state<BoundingBox[]>([]);
  let visibleBoundingBoxes = $state<Faces[]>([]);
  $effect(() => {
    if (isHighlighting) {
      visibleBoxes = highlightedBoxes;
      visibleBoundingBoxes = $boundingBoxesArray;
    }
  });

  const ocrBoxes = $derived(ocrManager.showOverlay ? getOcrBoundingBoxes(ocrManager.data, overlaySize) : []);

  const faceBoxes = $derived.by((): FaceOverlayBoundingBox[] => {
    if (!faceOverlayStore.showOverlay || assetViewerManager.isFaceEditMode || !visibleImageReady || !overlaySize.width) {
      return [];
    }

    return faceOverlayStore.data.map((face) => {
      const [box] = getBoundingBox([face], overlaySize);
      return {
        ...box!,
        personId: face.personId,
        personName: face.personName,
      };
    });
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

  const onPlaySlideshow = () => ($slideshowState = SlideshowState.PlaySlideshow);
  const onToggleFaceOverlay = () => faceOverlayStore.toggleOverlay();

  $effect(() => {
    if (assetViewerManager.isFaceEditMode && assetViewerManager.zoom > 1) {
      onZoom();
    }
  });

  // TODO move to action + command palette
  const onCopyShortcut = (event: KeyboardEvent) => {
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
    const fullUrl = new URL(url, globalThis.location.href);

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

  const facePersonData = $derived.by(() => {
    // eslint-disable-next-line svelte/prefer-svelte-reactivity
    const metadataById = new Map<string, { personId: string; personName: string }>();
    const faces: Faces[] = [];
    for (const person of asset.people ?? []) {
      for (const face of person.faces ?? []) {
        faces.push(face);
        metadataById.set(face.id, { personId: person.id, personName: person.name });
      }
    }
    return { faces, metadataById };
  });

  const faces = $derived(facePersonData.faces);

  const hoverFaceBoxes = $derived.by((): FaceOverlayBoundingBox[] => {
    if (!overlaySize.width || !overlaySize.height) {
      return [];
    }

    return getBoundingBox($boundingBoxesArray, overlaySize).flatMap((box, index) => {
      const face = $boundingBoxesArray[index];
      const metadata = facePersonData.metadataById.get(face.id);
      if (!metadata) {
        return [];
      }

      return [{ ...box, ...metadata }];
    });
  });

  const handleImageMouseMove = (event: MouseEvent) => {
    $boundingBoxesArray = [];
    if (!assetViewerManager.imgRef || !element || assetViewerManager.isFaceEditMode || ocrManager.showOverlay) {
      return;
    }

    const natural = getNaturalSize(assetViewerManager.imgRef);
    const scaled = scaleToFit(natural, container);
    const { currentZoom, currentPositionX, currentPositionY } = assetViewerManager.zoomState;

    const contentOffsetX = (container.width - scaled.width) / 2;
    const contentOffsetY = (container.height - scaled.height) / 2;

    const containerRect = element.getBoundingClientRect();
    const mouseX = (event.clientX - containerRect.left - contentOffsetX * currentZoom - currentPositionX) / currentZoom;
    const mouseY = (event.clientY - containerRect.top - contentOffsetY * currentZoom - currentPositionY) / currentZoom;

    const faceBounds = getBoundingBox(faces, overlaySize);

    for (const [index, box] of faceBounds.entries()) {
      if (mouseX >= box.left && mouseX <= box.left + box.width && mouseY >= box.top && mouseY <= box.top + box.height) {
        $boundingBoxesArray.push(faces[index]);
      }
    }
  };

  const handleImageMouseLeave = () => {
    $boundingBoxesArray = [];
  };
</script>

<AssetViewerEvents {onCopy} {onZoom} />

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
  class="relative h-full w-full select-none"
  bind:clientWidth={containerWidth}
  bind:clientHeight={containerHeight}
  role="presentation"
  ondblclick={onZoom}
  onmousemove={handleImageMouseMove}
  onmouseleave={handleImageMouseLeave}
  use:zoomImageAction={{
    zoomTarget: adaptiveImage,
    disabled: assetViewerManager.isFaceEditMode || ocrManager.showOverlay,
    ignoreSelector: '[data-zoom-image-ignore]',
  }}
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
        <canvas
          use:thumbhash={{ base64ThumbHash: asset.thumbhash! }}
          class="absolute top-0 left-0 inset-s-0 h-dvh w-dvw"
        ></canvas>
      {/if}
    {/snippet}
    {#snippet overlays()}
      {#each hoverFaceBoxes as faceBox (faceBox.id)}
        <FaceOverlayBox {faceBox} assetId={asset.id} variant="hover" />
      {/each}

      <div
        class="absolute inset-0 pointer-events-none transition-opacity duration-150"
        style:opacity={isHighlighting ? 1 : 0}
      >
        <svg class="absolute inset-0 w-full h-full">
          <defs>
            <mask id="face-dim-mask">
              <rect width="100%" height="100%" fill="white" />
              {#each visibleBoxes as box (box.id)}
                <rect x={box.left} y={box.top} width={box.width} height={box.height} fill="black" rx="8" />
              {/each}
            </mask>
          </defs>
          <rect width="100%" height="100%" fill="rgba(0,0,0,0.4)" mask="url(#face-dim-mask)" />
        </svg>
        {#each visibleBoxes as boundingbox, index (boundingbox.id)}
          <div
            class="absolute border-solid border-white border-3 rounded-lg"
            style="top: {boundingbox.top}px; left: {boundingbox.left}px; height: {boundingbox.height}px; width: {boundingbox.width}px;"
          ></div>
          {@const highlightedFace = visibleBoundingBoxes[index]}
          {@const highlightedMetadata = highlightedFace ? facePersonData.metadataById.get(highlightedFace.id) : undefined}
          {#if highlightedMetadata?.personName}
            <div
              class="absolute bg-white/90 text-black px-2 py-1 rounded text-sm font-medium whitespace-nowrap pointer-events-none shadow-lg"
              style="top: {boundingbox.top + boundingbox.height + 4}px; left: {boundingbox.left +
                boundingbox.width}px; transform: translateX(-100%);"
            >
              {highlightedMetadata.personName}
            </div>
          {/if}
        {/each}
      </div>

      {#each ocrBoxes as ocrBox (ocrBox.id)}
        <OcrBoundingBox {ocrBox} />
      {/each}

      {#each faceBoxes as faceBox (faceBox.id)}
        <FaceOverlayBox {faceBox} assetId={asset.id} />
      {/each}
    {/snippet}
  </AdaptiveImage>

  {#if assetViewerManager.isFaceEditMode && assetViewerManager.imgRef}
    <FaceEditor htmlElement={assetViewerManager.imgRef} {containerWidth} {containerHeight} assetId={asset.id} />
  {/if}
</div>
