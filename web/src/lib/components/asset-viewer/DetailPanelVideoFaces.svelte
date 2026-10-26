<script lang="ts">
  import { assetViewerManager } from '$lib/managers/asset-viewer-manager.svelte';
  import { getFaceThumbnail, getVideoFaces, type AssetResponseDto, type VideoFacesResponseDto } from '@immich/sdk';
  import { Duration } from 'luxon';
  import { t } from 'svelte-i18n';

  interface Props {
    asset: AssetResponseDto;
  }

  const { asset }: Props = $props();

  let data = $state<VideoFacesResponseDto | null>(null);
  let thumbnails = $state<Record<string, string>>({});

  // duration is milliseconds on AssetResponseDto
  const durationMs = $derived(asset.duration ?? 0);

  $effect(() => {
    let disposed = false;
    const urls: string[] = [];
    getVideoFaces({ id: asset.id })
      .then(async (response) => {
        if (disposed) {
          return;
        }
        data = response;
        for (const face of response.faces) {
          const blob = await getFaceThumbnail({ id: asset.id, faceId: face.id });
          const url = URL.createObjectURL(blob);
          urls.push(url);
          thumbnails = { ...thumbnails, [face.id]: url };
        }
      })
      .catch(() => {
        // asset was never scanned or endpoint unavailable — the strip stays hidden
      });
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
        {@const total = data?.run?.durationMs || durationMs || 1}
        <button
          type="button"
          class="group cursor-pointer text-left outline-none"
          onclick={() => seekTo(face.firstObservedMs)}
          title={$t('video_face_seek_hint', { values: { time: formatTime(face.firstObservedMs) } })}
        >
          {#if thumbnails[face.id]}
            <img
              src={thumbnails[face.id]}
              alt={face.personName ?? $t('video_face_unknown')}
              class="h-full w-full rounded-xl object-cover outline-offset-2 outline-immich-primary group-focus-visible:outline-2 dark:outline-immich-dark-primary"
            />
          {:else}
            <div class="flex aspect-square w-full items-center justify-center rounded-xl bg-gray-200 text-xs dark:bg-gray-700">
              …
            </div>
          {/if}
          <p class="mt-1 truncate font-medium" title={face.personName ?? $t('video_face_unknown')}>
            {face.personName ?? $t('video_face_unknown')}
          </p>
          <p class="font-light text-xs">
            {$t('video_face_first_observed', { values: { time: formatTime(face.firstObservedMs) } })}
          </p>
          <!-- sparse "seen at" markers: point positions only, never presence bands -->
          <div class="relative mt-1 h-1 w-full rounded bg-gray-200 dark:bg-gray-700">
            {#each face.sightings as sighting (sighting.timeMs)}
              <span
                class="absolute top-[-1px] h-[6px] w-[2px] rounded bg-immich-primary dark:bg-immich-dark-primary"
                style="left: {Math.min(98, (sighting.timeMs / total) * 100)}%"
              ></span>
            {/each}
          </div>
        </button>
      {/each}
    </div>
    {#if coveragePercent !== null}
      <p class="mt-2 font-light text-xs">
        {$t('video_face_coverage', { values: { percent: coveragePercent } })}
      </p>
    {/if}
  </section>
{/if}
