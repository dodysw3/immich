<script lang="ts">
  import { videoAudioEventsManager } from '#lib/stores/video-audio-events.svelte.ts';
  import { formatSoundTag } from '#lib/utils/video-audio-events.ts';

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
    hasTranscript = false,
    transcriptHeight = 0,
  }: {
    currentTimeMs?: number;
    contentRect?: ContentRect;
    containerHeight?: number;
    /** The asset has transcript subtitles: sit in the slot above their line. */
    hasTranscript?: boolean;
    /** Measured height of the transcript line currently on screen (0 when none). */
    transcriptHeight?: number;
  } = $props();

  // Mirrors VideoTranscriptOverlay: subtitles sit 12 px above the bottom edge
  // of the displayed media rect; one text-base/leading-relaxed line is ~26 px.
  const BOTTOM_GAP = 12;
  const EDGE_INSET = 12;
  const ONE_LINE_SLOT = 26;
  const STACK_GAP = 8;

  const activeEvents = $derived(videoAudioEventsManager.eventsAt(currentTimeMs));
  // Hidden while paused-at-zero, like the transcript and caption overlays.
  const showTags = $derived(videoAudioEventsManager.showOverlay && activeEvents.length > 0 && currentTimeMs > 0);

  // Sound tags and transcript lines run on independent timelines, so the tags
  // keep a fixed slot just above the transcript line (left-aligned, the line
  // itself is centered) instead of sharing its spot; the slot rises with a
  // multi-line transcript so they never overlap. Without a transcript on the
  // asset the tags take the transcript's own bottom slot.
  const lift = $derived(hasTranscript ? Math.max(transcriptHeight, ONE_LINE_SLOT) + STACK_GAP : 0);
  const placement = $derived.by(() => {
    if (contentRect.width === 0 || contentRect.height === 0) {
      return null;
    }
    return {
      left: contentRect.offsetX + EDGE_INSET,
      maxWidth: Math.max(contentRect.width - 2 * EDGE_INSET, 0),
      bottom: Math.max(containerHeight - contentRect.offsetY - contentRect.height, 0) + BOTTOM_GAP + lift,
    };
  });

  const tagClass = 'whitespace-nowrap bg-[rgba(8,8,8,0.75)] px-1.5 py-0.5 text-sm leading-relaxed text-white';
</script>

{#if showTags}
  <div
    class="pointer-events-none absolute z-10 flex flex-wrap gap-1"
    style={placement
      ? `left: ${placement.left}px; max-width: ${placement.maxWidth}px; bottom: ${placement.bottom}px;`
      : `left: ${EDGE_INSET}px; bottom: ${8 + lift}px;`}
    role="status"
    aria-live="polite"
    data-testid="video-audio-events-overlay"
  >
    {#each activeEvents as event (event.label)}
      <span class={tagClass}>{formatSoundTag(event)}</span>
    {/each}
  </div>
{/if}
