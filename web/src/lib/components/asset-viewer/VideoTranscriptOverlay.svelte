<script lang="ts">
  import { videoTranscriptManager } from '#lib/stores/video-transcript.svelte.ts';

  interface ContentRect {
    width: number;
    height: number;
    offsetX: number;
    offsetY: number;
  }

  let {
    currentTimeMs = 0,
    contentRect = { width: 0, height: 0, offsetX: 0, offsetY: 0 } as ContentRect,
    containerHeight = 0,
    // eslint-disable-next-line no-useless-assignment
    height = $bindable(0),
  }: {
    currentTimeMs?: number;
    contentRect?: ContentRect;
    containerHeight?: number;
    /** Rendered height of the line on screen, 0 when none — the sound tags stack above it. */
    height?: number;
  } = $props();

  const activeSegment = $derived(videoTranscriptManager.segmentAt(currentTimeMs));
  // Hidden while paused-at-zero: a subtitle pinned at t=0 on an unplayed video
  // looks like a rendering artifact rather than a caption.
  const showBar = $derived(videoTranscriptManager.showOverlay && !!activeSegment && currentTimeMs > 0);

  let measuredHeight = $state(0);
  $effect(() => {
    height = showBar ? measuredHeight : 0;
  });

  // Subtitles hug the footage the way YouTube renders them: centered on the
  // displayed media rect, just above its bottom edge (pillarboxed video keeps
  // them inside the picture, not on the container). Falls back to the container
  // bottom while the media rect is not measured yet. The per-line boxes come
  // from box-decoration-break: clone on the inline span — deliberately distinct
  // from the AI captions' rounded card above.
  const placement = $derived.by(() => {
    if (contentRect.width === 0 || contentRect.height === 0) {
      return null;
    }
    return {
      left: contentRect.offsetX,
      width: contentRect.width,
      bottom: Math.max(containerHeight - contentRect.offsetY - contentRect.height, 0) + 12,
    };
  });

  const lineClass = 'whitespace-pre-wrap bg-[rgba(8,8,8,0.75)] px-1.5 py-0.5 text-base leading-relaxed text-white';
  const lineStyle = 'box-decoration-break: clone; -webkit-box-decoration-break: clone;';
</script>

{#if showBar}
  {#if placement}
    <div
      class="pointer-events-none absolute z-10 text-center"
      style="left: {placement.left}px; width: {placement.width}px; bottom: {placement.bottom}px;"
      bind:clientHeight={measuredHeight}
      data-testid="video-transcript-overlay"
    >
      <span class={lineClass} style={lineStyle} role="status" aria-live="polite">{activeSegment!.text}</span>
    </div>
  {:else}
    <div
      class="pointer-events-none absolute inset-x-0 bottom-2 z-10 text-center"
      bind:clientHeight={measuredHeight}
      data-testid="video-transcript-overlay"
    >
      <span class={lineClass} style={lineStyle} role="status" aria-live="polite">{activeSegment!.text}</span>
    </div>
  {/if}
{/if}
