<script lang="ts">
  import { goto } from '$app/navigation';
  import { page } from '$app/stores';
  import { QueryParameter } from '$lib/constants';
  import { Route } from '$lib/route';
  import type { FaceOverlayBoundingBox } from '$lib/features/face-overlay/face-overlay.utils';
  import { assetViewerManager } from '$lib/managers/asset-viewer-manager.svelte';
  import { showFacePanel } from '$lib/stores/face-panel.svelte';
  import { faceOverlayStore } from '$lib/features/face-overlay/face-overlay.store.svelte';

  type Props = {
    faceBox: FaceOverlayBoundingBox;
    assetId: string;
  };

  let { faceBox, assetId }: Props = $props();
  let isHovered = $state(false);
  let isActive = $derived(faceOverlayStore.activeFaceId === faceBox.id);

  const handleClick = () => {
    if (!faceBox.personId) {
      assetViewerManager.openDetailPanel();
      showFacePanel.faceId = faceBox.id;
      showFacePanel.directCreate = true;
      showFacePanel.value = true;
      return;
    }

    const params = new URLSearchParams({
      at: assetId,
      [QueryParameter.PREVIOUS_ROUTE]: $page.url.pathname,
    });
    const personPath = Route.viewPerson({ id: faceBox.personId });
    void goto(`${personPath}?${params.toString()}`);
  };
</script>

<div
  class="absolute group cursor-pointer pointer-events-auto"
  style="top: {faceBox.top}px; left: {faceBox.left}px; width: {faceBox.width}px; height: {faceBox.height}px;"
  role="button"
  tabindex="0"
  onclick={handleClick}
  onkeydown={(event) => event.key === 'Enter' && handleClick()}
  onmouseenter={() => (isHovered = true)}
  onmouseleave={() => (isHovered = false)}
>
  {#if isHovered || isActive}
    <svg
      class="absolute inset-0 pointer-events-none overflow-visible"
      width={faceBox.width}
      height={faceBox.height}
    >
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
        class="absolute left-0 right-0 text-center text-white text-xs bg-black/75 px-1 py-0.5 rounded-b break-all max-w-full pointer-events-none"
        style="top: {faceBox.height}px;"
      >
        {faceBox.personName}
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
