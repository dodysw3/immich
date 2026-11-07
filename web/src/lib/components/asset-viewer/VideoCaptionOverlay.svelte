<script lang="ts">
  import { videoCaptionManager } from '#lib/stores/video-caption.svelte.ts';

  interface ContentRect {
    width: number;
    height: number;
    offsetX: number;
    offsetY: number;
  }

  let {
    currentTimeMs = 0,
    contentRect = { width: 0, height: 0, offsetX: 0, offsetY: 0 } as ContentRect,
    containerWidth = 0,
    containerHeight = 0,
  }: {
    currentTimeMs?: number;
    contentRect?: ContentRect;
    containerWidth?: number;
    containerHeight?: number;
  } = $props();

  const activeSegment = $derived(videoCaptionManager.segmentAt(currentTimeMs));
  // Hidden while paused-at-zero: a caption pinned at t=0 on an unplayed video
  // looks like a rendering artifact rather than a caption.
  const showBar = $derived(videoCaptionManager.showOverlay && !!activeSegment && currentTimeMs > 0);

  // Vertical (pillarboxed) video leaves wide black bars left and right; park
  // the caption in the right one so it covers as little of the footage as
  // possible. Landscape video (or a cramped layout) falls back to the classic
  // bottom-center bar.
  const MIN_BAR_WIDTH = 220;
  const sidePlacement = $derived.by(() => {
    const rightEdge = contentRect.offsetX + contentRect.width;
    const barWidth = containerWidth - rightEdge;
    if (contentRect.width === 0 || barWidth < MIN_BAR_WIDTH) {
      return null;
    }
    return {
      left: rightEdge + 12,
      top: Math.max(containerHeight * 0.18, 96),
    };
  });
</script>

{#if showBar}
  {#if sidePlacement}
    <div
      class="pointer-events-none absolute z-10"
      style="left: {sidePlacement.left}px; right: 16px; top: {sidePlacement.top}px;"
      data-testid="video-caption-overlay"
    >
      <div
        class="w-full rounded-lg bg-black/75 px-4 py-2 text-left text-sm leading-snug text-white shadow-lg"
        role="status"
        aria-live="polite"
      >
        <p class="whitespace-pre-wrap">{activeSegment!.caption}</p>
      </div>
    </div>
  {:else}
    <div
      class="pointer-events-none absolute inset-x-0 bottom-14 z-10 flex justify-center px-8"
      data-testid="video-caption-overlay"
    >
      <div
        class="max-w-[90%] rounded-lg bg-black/75 px-4 py-2 text-center text-sm leading-snug text-white shadow-lg"
        role="status"
        aria-live="polite"
      >
        <p class="whitespace-pre-wrap">{activeSegment!.caption}</p>
      </div>
    </div>
  {/if}
{/if}
