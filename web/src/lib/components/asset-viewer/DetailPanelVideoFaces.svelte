<script lang="ts">
  import { assetViewerManager } from '#lib/managers/asset-viewer-manager.svelte.ts';
  import { videoFacesManager } from '#lib/stores/video-faces.svelte.ts';
  import { getFaceThumbnail, type AssetResponseDto } from '@immich/sdk';
  import { Icon } from '@immich/ui';
  import { mdiArrowRightDropCircleOutline } from '@mdi/js';
  import { Duration } from 'luxon';
  import { t } from 'svelte-i18n';

  interface Props {
    asset: AssetResponseDto;
  }

  const { asset }: Props = $props();

  const data = $derived(videoFacesManager.data);
  let thumbnails = $state<Record<string, string>>({});

  // duration is milliseconds on AssetResponseDto
  const durationMs = $derived(asset.duration ?? 0);

  $effect(() => {
    let disposed = false;
    const urls: string[] = [];
    const faces = videoFacesManager.data?.faces ?? [];
    void (async () => {
      for (const face of faces) {
        const blob = await getFaceThumbnail({ id: asset.id, faceId: face.id });
        const url = URL.createObjectURL(blob);
        if (disposed) {
          URL.revokeObjectURL(url);
          return;
        }
        urls.push(url);
        thumbnails = { ...thumbnails, [face.id]: url };
      }
    })();
    return () => {
      disposed = true;
      for (const url of urls) {
        URL.revokeObjectURL(url);
      }
    };
  });

  const seekTo = (timeMs: number) => {
    assetViewerManager.requestVideoSeek(timeMs);
  };

  const formatTime = (ms: number) => Duration.fromMillis(ms).toFormat('m:ss');

  const coveragePercent = $derived.by(() => {
    const run = data?.run;
    if (!run) {
      return null;
    }
    const total = run.durationMs || durationMs || 1;
    return Math.round(((run.lastSampledMs - run.firstSampledMs) / total) * 100);
  });
</script>

{#if data && data.faces.length > 0}
  <section class="text-sm">
    <div class="mt-2 grid grid-cols-4 gap-2">
      {#each data.faces as face (face.id)}
        {const total = $derived(data?.run?.durationMs || durationMs || 1)}
        <div class="group relative text-left">
          <button
            type="button"
            class="block w-full cursor-pointer outline-none"
            onclick={() => seekTo(face.firstObservedMs)}
            title={$t('video_face_seek_hint', { values: { time: formatTime(face.firstObservedMs) } })}
          >
            {#if thumbnails[face.id]}
              <img
                src={thumbnails[face.id]}
                alt={face.personName ?? $t('video_face_unknown')}
                class="size-full rounded-xl object-cover outline-offset-2 outline-immich-primary group-focus-within:outline-2 dark:outline-immich-dark-primary"
              />
            {:else}
              <div
                class="flex aspect-square w-full items-center justify-center rounded-xl bg-gray-200 text-xs dark:bg-gray-700"
              >
                …
              </div>
            {/if}
            <p class="mt-1 truncate font-medium" title={face.personName ?? $t('video_face_unknown')}>
              {face.personName ?? $t('video_face_unknown')}
            </p>
            <p class="text-xs font-light">
              {$t('video_face_first_observed', { values: { time: formatTime(face.firstObservedMs) } })}
            </p>
            <!-- sparse "seen at" markers: point positions only, never presence bands -->
            <div class="relative mt-1 h-1 w-full rounded-sm bg-gray-200 dark:bg-gray-700">
              {#each face.sightings as sighting (sighting.timeMs)}
                <span
                  class="absolute -top-px h-[6px] w-[2px] rounded-sm bg-immich-primary dark:bg-immich-dark-primary"
                  style="left: {Math.min(98, (sighting.timeMs / total) * 100)}%"
                ></span>
              {/each}
            </div>
          </button>
          <!-- explicit jump-to-first-sighting affordance over the thumbnail -->
          <button
            type="button"
            class="absolute top-1 right-1 rounded-full bg-black/50 p-1 text-white opacity-0 transition-opacity group-hover:opacity-100 focus-visible:opacity-100"
            onclick={(event) => {
              event.stopPropagation();
              seekTo(face.firstObservedMs);
            }}
            title={$t('video_face_seek_hint', { values: { time: formatTime(face.firstObservedMs) } })}
            aria-label={$t('video_face_seek_hint', { values: { time: formatTime(face.firstObservedMs) } })}
          >
            <Icon icon={mdiArrowRightDropCircleOutline} size="16" />
          </button>
        </div>
      {/each}
    </div>
    {#if coveragePercent !== null}
      <p class="mt-2 text-xs font-light">
        {$t('video_face_coverage', { values: { percent: coveragePercent } })}
      </p>
    {/if}
  </section>
{/if}
