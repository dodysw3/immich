<script lang="ts">
  import { faceOverlayStore } from '#lib/features/face-overlay/face-overlay.store.svelte.ts';
  import { assetViewerManager, type Faces } from '#lib/managers/asset-viewer-manager.svelte.ts';
  import { faceManager } from '#lib/stores/face.svelte.ts';
  import { ocrManager } from '#lib/stores/ocr.svelte.ts';
  import { videoFacesManager } from '#lib/stores/video-faces.svelte.ts';
  import type { Size } from '#lib/utils/container-utils.ts';
  import { getOcrBoundingBoxes } from '#lib/utils/ocr-utils.ts';
  import {
    getBoundingBox,
    getFaceLabelStyle,
    getVideoFaceSightingBoxes,
    type BoundingBox,
  } from '#lib/utils/people-utils.ts';
  import { onDestroy } from 'svelte';
  import OcrBoundingBox from './OcrBoundingBox.svelte';

  type Props = {
    /** Displayed content size (the image or video rect), in container pixels. */
    overlaySize: Size;
    offsetX?: number;
    offsetY?: number;
    /** Width used to keep active face labels inside the content area. */
    labelReferenceWidth?: number;
    /** Live playback clock (ms) for time-indexed video face boxes. */
    videoFaceTimeMs?: number | null;
  };

  let { overlaySize, offsetX = 0, offsetY = 0, labelReferenceWidth, videoFaceTimeMs = null }: Props = $props();

  const faceLabelOffset = 32;
  const labelSpace = $derived(labelReferenceWidth ?? overlaySize.width);

  const highlightedBoxes = $derived(getBoundingBox(assetViewerManager.highlightedFaces, overlaySize));
  const isHighlighting = $derived(highlightedBoxes.length > 0);

  let visibleBoxes = $state<BoundingBox[]>([]);
  $effect(() => {
    if (isHighlighting) {
      visibleBoxes = highlightedBoxes;
    }
  });

  const ocrBoxes = $derived(ocrManager.showOverlay ? getOcrBoundingBoxes(ocrManager.data, overlaySize) : []);

  const faceToNameMap = $derived.by(() => {
    // eslint-disable-next-line svelte/prefer-svelte-reactivity
    const map = new Map<Faces, string>();
    for (const face of faceManager.data) {
      if (!face.person) {
        continue;
      }
      if (face.person.isHidden && !assetViewerManager.isShowingHiddenPeople) {
        continue;
      }
      map.set(face, face.person.name);
    }
    return map;
  });

  const faces = $derived(Array.from(faceToNameMap.keys()));

  // we want to bind to `boundingbox.labelWidth`, which requires deep reactivity
  // $derived does not currently support that, only $state does.
  let boundingBoxes = $state<Array<BoundingBox & { name?: string; face?: Faces; referenceLabel?: string }>>([]);
  $effect(() => {
    if (assetViewerManager.isFaceEditMode || ocrManager.showOverlay) {
      return;
    }

    // scanned videos: face boxes follow the sightings (time-indexed) instead of
    // the static published best-frame boxes, so they track playback position
    const videoFaceData = videoFacesManager.data;
    if (videoFaceData && videoFaceData.faces.length > 0) {
      const allFaces = faceOverlayStore.showOverlay
        ? videoFaceData.faces
        : videoFaceData.faces.filter((face) => face.personName);
      boundingBoxes = getVideoFaceSightingBoxes(allFaces, videoFaceTimeMs ?? 0, overlaySize).map((box) => ({
        ...box,
        name: box.personName ?? undefined,
      }));
      return;
    }

    const referenceLabels = faceManager.faceReferenceLabels;

    if (faceOverlayStore.showOverlay) {
      const allFaces = faceManager.data.filter(
        (face) => !face.person?.isHidden || assetViewerManager.isShowingHiddenPeople,
      );
      const boxes = getBoundingBox(allFaces, overlaySize);
      boundingBoxes = boxes.map((box, index) => ({
        ...box,
        face: allFaces[index],
        name: allFaces[index].person?.name ?? undefined,
        referenceLabel: referenceLabels.get(allFaces[index].id),
      }));
      return;
    }

    const knownBoxes = getBoundingBox(faces, overlaySize);
    const result = knownBoxes.map((box, index) => ({
      ...box,
      face: faces[index],
      name: faceToNameMap.get(faces[index]),
      referenceLabel: referenceLabels.get(faces[index].id),
    }));

    if (assetViewerManager.highlightedFaces.length === 0) {
      boundingBoxes = result;
    }

    const knownIds = new Set(faces.map((f) => f.id));
    const unassignedFaces = assetViewerManager.highlightedFaces.filter((f) => !knownIds.has(f.id));
    const unassignedBoxes = getBoundingBox(unassignedFaces, overlaySize);
    for (let i = 0; i < unassignedBoxes.length; i++) {
      result.push({
        ...unassignedBoxes[i],
        face: unassignedFaces[i],
        name: undefined,
        referenceLabel: referenceLabels.get(unassignedFaces[i].id),
      });
    }

    boundingBoxes = result;
  });

  onDestroy(() => {
    assetViewerManager.clearHighlightedFaces();
  });
</script>

<div
  class="absolute overflow-hidden"
  style:top="{offsetY}px"
  style:left="{offsetX}px"
  style:width="{overlaySize.width}px"
  style:height="{overlaySize.height}px"
>
  <div
    class="pointer-events-none absolute inset-0 transition-opacity duration-150"
    style:opacity={isHighlighting ? 1 : 0}
  >
    <svg class="absolute inset-0 size-full">
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
  </div>
  {#each boundingBoxes as boundingbox (boundingbox.id)}
    {const isActive = $derived(assetViewerManager.highlightedFaces.some((f) => f.id === boundingbox.id))}
    {const showPersistent = $derived(faceOverlayStore.showOverlay && !isActive)}
    {const displayLabel = $derived(boundingbox.referenceLabel ?? boundingbox.name)}
    {const label = $derived(getFaceLabelStyle(displayLabel, boundingbox, boundingBoxes))}
    <!-- svelte-ignore a11y_no_static_element_interactions -->
    <div
      class="pointer-events-auto absolute rounded-lg {isActive &&
        'border-3 border-solid border-white'} {showPersistent && 'border border-green-500'}"
      style="top: {boundingbox.top}px; left: {boundingbox.left}px; height: {boundingbox.height}px; width: {boundingbox.width}px;"
      onpointerenter={() => {
        if (boundingbox.face) {
          assetViewerManager.setHighlightedFaces([boundingbox.face]);
        }
      }}
      onpointerleave={() => assetViewerManager.clearHighlightedFaces()}
    >
      {#if isActive && displayLabel}
        {const labelAbove = $derived(
          boundingbox.top + boundingbox.height + faceLabelOffset > overlaySize.height &&
            boundingbox.top >= faceLabelOffset,
        )}
        <div
          aria-hidden="true"
          class="absolute rounded-sm bg-white/90 px-2 py-1 text-sm font-medium whitespace-nowrap text-black shadow-lg"
          bind:clientWidth={boundingbox.labelWidth}
          style="{labelAbove ? 'bottom' : 'top'}: {boundingbox.height + 4}px; {labelSpace
            ? boundingbox.left >= boundingbox.labelWidth - boundingbox.width
              ? `right: ${Math.max(boundingbox.left + boundingbox.width - labelSpace, 0)}px;`
              : `left: ${-boundingbox.left}px;`
            : ''}"
        >
          {displayLabel}
        </div>
      {:else if showPersistent}
        <div
          aria-hidden="true"
          class="pointer-events-none absolute inset-x-0 flex justify-center"
          style="top: {boundingbox.height}px;"
        >
          <div
            class="max-w-full flex-none rounded-b bg-black/50 px-1 py-0.5 text-center text-white {label.wrap
              ? ''
              : 'whitespace-nowrap'}"
            style="width: {boundingbox.width}px; font-size: {label.fontSize}px;"
          >
            {displayLabel ?? '…'}
          </div>
        </div>
      {/if}
    </div>
  {/each}

  {#each ocrBoxes as ocrBox (ocrBox.id)}
    <OcrBoundingBox {ocrBox} />
  {/each}
</div>
