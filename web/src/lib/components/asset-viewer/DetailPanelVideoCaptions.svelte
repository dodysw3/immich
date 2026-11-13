<script lang="ts">
  import { assetViewerManager } from '#lib/managers/asset-viewer-manager.svelte.ts';
  import { videoCaptionManager } from '#lib/stores/video-caption.svelte.ts';
  import type { AssetResponseDto } from '@immich/sdk';
  import { Duration } from 'luxon';
  import { t } from 'svelte-i18n';

  interface Props {
    asset: AssetResponseDto;
  }

  const { asset }: Props = $props();

  const run = $derived(videoCaptionManager.run);
  const segments = $derived(videoCaptionManager.segments);
  const totalMs = $derived(run?.durationMs || asset.duration || 1);

  // Live progress: while a run is queued/running, poll until it settles.
  $effect(() => {
    const status = run?.status;
    if (status !== 'queued' && status !== 'running') {
      return;
    }
    const assetId = asset.id;
    const interval = setInterval(() => {
      void videoCaptionManager.getAssetCaptions(assetId);
    }, 4000);
    return () => clearInterval(interval);
  });

  const seekTo = (timeMs: number) => {
    assetViewerManager.requestVideoSeek(timeMs);
  };

  const formatTime = (ms: number) => Duration.fromMillis(ms).toFormat('m:ss');

  const currentTimeMs = $derived(assetViewerManager.videoCurrentTimeMs ?? -1);
  const activeIndex = $derived(
    segments.findIndex((segment) => currentTimeMs >= segment.startMs && currentTimeMs < segment.endMs),
  );

  const statusLabel = $derived.by(() => {
    switch (run?.status) {
      case 'queued': {
        return $t('video_captions_queued');
      }
      case 'running': {
        return $t('video_captions_running');
      }
      case 'failed': {
        return $t('video_captions_failed');
      }
      case 'completed': {
        return '';
      }
      default: {
        return '';
      }
    }
  });
</script>

{#if run}
  <section class="mt-6 px-4" data-testid="video-captions">
    <div class="flex items-baseline justify-between gap-2 pb-2">
      <p class="text-immich-fg-muted dark:text-immich-dark-fg-muted text-sm">{$t('video_captions')}</p>
      {#if statusLabel}
        <span
          class="text-immich-fg-muted dark:text-immich-dark-fg-muted shrink-0 text-xs"
          data-testid="video-captions-status"
        >
          {statusLabel}
        </span>
      {/if}
    </div>

    {#if run.status === 'failed'}
      <p class="text-immich-fg-muted dark:text-immich-dark-fg-muted pb-2 text-xs wrap-break-word">
        {[run.error?.code, run.error?.message].filter((part): part is string => !!part).join(': ')}
      </p>
    {/if}

    {#if segments.length > 0}
      <!-- coverage bands: caption windows across the (possibly truncated) timeline -->
      <div class="relative mb-3 h-1.5 w-full rounded-sm bg-gray-200 dark:bg-gray-700">
        {#each segments as segment, index (segment.startMs)}
          <span
            class="absolute top-0 h-full rounded-sm {index === activeIndex
              ? 'bg-immich-primary dark:bg-immich-dark-primary'
              : 'bg-immich-primary/40 dark:bg-immich-dark-primary/40'}"
            style="left: {Math.min(98, (segment.startMs / totalMs) * 100)}%; width: {Math.max(
              1,
              ((segment.endMs - segment.startMs) / totalMs) * 100,
            )}%"
          ></span>
        {/each}
      </div>

      <div class="flex flex-col gap-2 pb-1">
        {#each segments as segment, index (segment.startMs)}
          <button
            type="button"
            class="cursor-pointer rounded-lg p-1.5 text-start outline-none {index === activeIndex
              ? 'bg-immich-primary/10 dark:bg-immich-dark-primary/10'
              : 'hover:bg-gray-100 dark:hover:bg-gray-800'}"
            onclick={() => seekTo(segment.startMs)}
            title={$t('video_face_seek_hint', { values: { time: formatTime(segment.startMs) } })}
            data-testid="video-caption-segment"
          >
            <p
              class="text-xs font-medium {index === activeIndex
                ? 'text-immich-primary dark:text-immich-dark-primary'
                : ''}"
            >
              {formatTime(segment.startMs)} – {formatTime(segment.endMs)}
            </p>
            <p class="text-sm wrap-break-word">{segment.caption}</p>
          </button>
        {/each}
      </div>
    {/if}

    {#if run.truncated}
      <p class="text-immich-fg-muted dark:text-immich-dark-fg-muted pb-1 text-xs">
        {$t('video_captions_truncated')}
      </p>
    {/if}

    {#if run.model}
      <p class="text-immich-fg-muted dark:text-immich-dark-fg-muted pb-1 text-xs">
        {run.servedModel || run.model}
      </p>
    {/if}
  </section>
{/if}
