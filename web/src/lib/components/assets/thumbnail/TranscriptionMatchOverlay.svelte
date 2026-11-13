<script lang="ts">
  import ButtonContextMenu from '#lib/components/shared-components/context-menu/ButtonContextMenu.svelte';
  import MenuOption from '#lib/components/shared-components/context-menu/MenuOption.svelte';
  import type { TranscriptionPresentation } from '#lib/managers/transcription-presentation-manager.svelte.ts';
  import { getMatchFrame, type TranscriptionMatchDto } from '@immich/sdk';
  import { mdiCheck, mdiImageMultipleOutline } from '@mdi/js';
  import { Duration } from 'luxon';
  import { onDestroy } from 'svelte';
  import { t } from 'svelte-i18n';

  interface Props {
    assetId: string;
    presentation: TranscriptionPresentation;
    onSelectMoment?: ((match: TranscriptionMatchDto) => void) | undefined;
    onLoadMoments?: (() => Promise<{ moments: TranscriptionMatchDto[]; nextCursor: string | null }>) | undefined;
  }

  let { assetId, presentation, onSelectMoment = undefined, onLoadMoments = undefined }: Props = $props();

  let frameUrl = $state<string | undefined>(undefined);
  let frameFailed = $state(false);
  let latestRequest = 0;
  let activeUrl: string | undefined = undefined;

  const revokeActiveUrl = () => {
    if (activeUrl) {
      URL.revokeObjectURL(activeUrl);
      activeUrl = undefined;
    }
  };

  // The matched frame is fetched lazily: this overlay only mounts for cards in
  // or near the viewport (GalleryViewer gates mounting), so only visible cards
  // request a decode. Failures fall back to the ordinary thumbnail underneath.
  // The previous frame stays on screen until a switch succeeds or fails; URLs
  // are revoked when replaced and on destroy.
  $effect(() => {
    const passageId = presentation.selected.passageId;
    const requestId = ++latestRequest;
    getMatchFrame({ assetId, passageId })
      .then((blob) => {
        if (requestId !== latestRequest) {
          return;
        }
        revokeActiveUrl();
        activeUrl = URL.createObjectURL(blob);
        frameUrl = activeUrl;
        frameFailed = false;
      })
      .catch(() => {
        if (requestId === latestRequest) {
          frameUrl = undefined;
          frameFailed = true;
        }
      });
  });

  onDestroy(revokeActiveUrl);

  const formatTimestamp = (startMs: number) => {
    const seconds = Math.floor(startMs / 1000);
    if (seconds < 60) {
      return Duration.fromObject({ seconds }).toFormat('m:ss');
    }
    if (seconds < 3600) {
      return Duration.fromObject({ seconds }).toFormat('mm:ss');
    }
    return Duration.fromObject({ seconds }).toFormat('h:mm:ss');
  };

  /** Matched text and context as plain parts; Svelte renders them as escaped text nodes. */
  const snippetParts = (match: TranscriptionMatchDto) => {
    const parts: { text: string; highlighted: boolean }[] = [];
    let cursor = 0;
    for (const span of [...match.spans].sort((a, b) => a.start - b.start)) {
      if (span.start > cursor) {
        parts.push({ text: match.snippet.slice(cursor, span.start), highlighted: false });
      }
      if (!(span.end > cursor)) {
        continue;
      }

      parts.push({ text: match.snippet.slice(Math.max(span.start, cursor), span.end), highlighted: true });
      cursor = span.end;
    }
    if (cursor < match.snippet.length) {
      parts.push({ text: match.snippet.slice(cursor), highlighted: false });
    }
    return parts;
  };

  const moments = $derived([presentation.bestMatch, ...presentation.additionalMatches]);
  const hasMoreMoments = $derived(
    !presentation.momentsComplete && presentation.matchCount > moments.length && !!onLoadMoments,
  );

  let isLoadingMoments = $state(false);
  const loadMoreMoments = async () => {
    if (!onLoadMoments || isLoadingMoments) {
      return;
    }
    isLoadingMoments = true;
    try {
      await onLoadMoments();
    } finally {
      isLoadingMoments = false;
    }
  };

  const stopPropagation = (event: Event) => event.stopPropagation();
</script>

<!-- Matched frame at the selected moment; hidden while loading or on failure so
     the ordinary thumbnail (and its hover preview) stays the fallback. -->
{#if frameUrl && !frameFailed}
  <img
    src={frameUrl}
    alt=""
    draggable="false"
    data-testid="transcription-frame"
    class="absolute inset-0 z-1 size-full object-cover group-focus-visible:rounded-lg"
  />
{/if}

<!-- Timestamp badge for the selected moment (segment start, not word-aligned) -->
<div
  class="pointer-events-none absolute inset-s-0 top-0 z-10 flex place-items-center justify-start gap-1 text-xs font-medium text-white"
>
  <span
    class="rounded-sm bg-black/60 px-1.5 py-0.5 tabular-nums text-shadow-[1px_1px_6px_rgb(0_0_0)]"
    data-testid="transcription-timestamp"
  >
    {formatTimestamp(presentation.selected.startMs)}
  </span>
</div>

<!-- Transcript snippet with highlighted match spans; plain text nodes, never HTML -->
<div
  class="pointer-events-none absolute inset-x-0 bottom-0 z-10 bg-linear-to-t from-black/75 via-black/40 to-transparent px-1.5 pt-6 pb-1.5"
>
  <p
    class="text-white-shadow line-clamp-2 text-[11px] leading-snug font-medium wrap-break-word text-white"
    data-testid="transcription-snippet"
  >
    {#each snippetParts(presentation.selected) as part, index (index)}
      {#if part.highlighted}<mark class="bg-primary/60 text-white">{part.text}</mark>{:else}{part.text}{/if}
    {/each}
  </p>
</div>

{#if moments.length > 1 || hasMoreMoments}
  <!-- Additional matching moments; clicks must not open the card itself -->
  <div
    class="pointer-events-auto absolute inset-e-0 bottom-8 z-10"
    onclick={stopPropagation}
    onkeydown={stopPropagation}
    role="presentation"
  >
    <ButtonContextMenu
      icon={mdiImageMultipleOutline}
      title={$t('transcription_search_additional_moments')}
      align="bottom-right"
      direction="left"
      variant="ghost"
      buttonClass="transcription-moments-button"
    >
      {#each moments as moment (moment.passageId)}
        <MenuOption
          text={formatTimestamp(moment.startMs)}
          subtitle={moment.snippet}
          icon={moment.passageId === presentation.selected.passageId ? mdiCheck : undefined}
          onClick={() => onSelectMoment?.(moment)}
        />
      {/each}
      {#if hasMoreMoments}
        <MenuOption
          text={isLoadingMoments ? $t('loading') : $t('transcription_search_load_more_moments')}
          onClick={() => void loadMoreMoments()}
        />
      {/if}
    </ButtonContextMenu>
  </div>
{/if}
