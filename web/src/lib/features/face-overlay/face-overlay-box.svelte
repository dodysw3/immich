<script lang="ts">
  import { goto, preloadData } from '$app/navigation';
  import { page } from '$app/stores';
  import { QueryParameter } from '$lib/constants';
  import { Route } from '$lib/route';
  import { getFaceLabelCompensation, type FaceOverlayBoundingBox } from '$lib/features/face-overlay/face-overlay.utils';
  import { assetViewerManager } from '$lib/managers/asset-viewer-manager.svelte';
  import { faceOverlayStore } from '$lib/features/face-overlay/face-overlay.store.svelte';
  import { LoadingSpinner } from '@immich/ui';

  type Props = {
    faceBox: FaceOverlayBoundingBox;
    assetId: string;
    variant?: 'default' | 'hover';
  };

  let { faceBox, assetId, variant = 'default' }: Props = $props();
  let isHovered = $state(false);
  let isNavigating = $state(false);
  let hasPreloadedPerson = $state(false);
  let isActive = $derived(faceOverlayStore.activeFaceId === faceBox.id);
  const labelCompensation = $derived(getFaceLabelCompensation(assetViewerManager.zoomState.currentZoom));
  const hoverLabelCompensation = $derived(getFaceLabelCompensation(assetViewerManager.zoomState.currentZoom, 4));
  const labelWidth = $derived(`${faceBox.width / labelCompensation.scale}px`);
  const hoverLabelWidth = $derived(`${faceBox.width / hoverLabelCompensation.scale}px`);

  const getPersonHref = () => {
    const params = new URLSearchParams({
      at: assetId,
      [QueryParameter.PREVIOUS_ROUTE]: $page.url.pathname,
    });
    const personPath = Route.viewPerson({ id: faceBox.personId! });
    return `${personPath}?${params.toString()}`;
  };

  const preloadPersonPage = () => {
    if (!faceBox.personId || hasPreloadedPerson) {
      return;
    }

    hasPreloadedPerson = true;
    void preloadData(getPersonHref());
  };

  const handleClick = async () => {
    if (isNavigating) {
      return;
    }

    if (!faceBox.personId) {
      if (!assetViewerManager.isShowDetailPanel) {
        assetViewerManager.toggleDetailPanel();
      }
      return;
    }

    isNavigating = true;

    try {
      await goto(getPersonHref());
    } catch (error) {
      isNavigating = false;
      throw error;
    }
  };

  $effect(() => {
    if (variant === 'hover') {
      preloadPersonPage();
    }
  });
</script>

<div
  data-zoom-image-ignore
  class="absolute group pointer-events-auto"
  style="top: {faceBox.top}px; left: {faceBox.left}px; width: {faceBox.width}px; height: {faceBox.height}px;"
  role="button"
  tabindex="0"
  onclick={handleClick}
  onkeydown={(event) => event.key === 'Enter' && handleClick()}
  onmouseenter={() => {
    isHovered = true;
    preloadPersonPage();
  }}
  onfocus={preloadPersonPage}
  onmouseleave={() => (isHovered = false)}
  class:cursor-progress={isNavigating}
  class:cursor-pointer={!isNavigating}
>
  {#if isNavigating}
    <div class="absolute inset-0 rounded-lg border-2 border-white bg-black/45"></div>
    <div class="absolute inset-0 flex items-center justify-center pointer-events-none">
      <LoadingSpinner />
    </div>
  {:else if variant === 'hover'}
    <div class="absolute inset-0 border-solid border-white border-3 rounded-lg"></div>
    {#if faceBox.personName}
      <div
        class="absolute left-0 right-0 flex justify-end pointer-events-none overflow-hidden"
        style="top: calc(100% + {hoverLabelCompensation.gap}px);"
      >
        <div
          class="flex-none bg-white/90 text-black px-2 py-1 rounded text-sm font-medium whitespace-nowrap shadow-lg"
          style="width: {hoverLabelWidth}; min-width: {hoverLabelWidth}; transform: scale({hoverLabelCompensation.scale}); transform-origin: top right;"
        >
          {faceBox.personName}
        </div>
      </div>
    {/if}
  {:else if isHovered || isActive}
    <svg class="absolute inset-0 pointer-events-none overflow-visible" width={faceBox.width} height={faceBox.height}>
      <rect
        x="1"
        y="1"
        width={faceBox.width - 2}
        height={faceBox.height - 2}
        rx="8"
        ry="8"
        fill="none"
        stroke="white"
        stroke-width="2.5"
        stroke-dasharray="8 4"
        class="marching-ants"
      />
    </svg>
  {:else}
    <div class="absolute inset-0 rounded-lg border border-green-500"></div>
    {#if faceBox.personName && !isActive}
      <div
        class="absolute left-0 right-0 flex justify-center pointer-events-none overflow-hidden"
        style="top: {faceBox.height}px;"
      >
        <div
          class="flex-none text-center text-white text-xs bg-black/75 px-1 py-0.5 rounded-b break-all"
          style="width: {labelWidth}; min-width: {labelWidth}; transform: scale({labelCompensation.scale}); transform-origin: top center;"
        >
          {faceBox.personName}
        </div>
      </div>
    {/if}
  {/if}
</div>

<style>
  @keyframes march {
    to {
      stroke-dashoffset: -12;
    }
  }
  .marching-ants {
    animation: march 0.4s linear infinite;
  }
</style>
