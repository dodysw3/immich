<script lang="ts">
  import { assetViewerManager } from '#lib/managers/asset-viewer-manager.svelte.ts';
  import { Route } from '#lib/route.ts';
  import { locale } from '#lib/stores/preferences.store.ts';
  import { getDimensions } from '#lib/utils/asset-utils.ts';
  import { getByteUnitString } from '#lib/utils/byte-units.ts';
  import { fromISODateTime, fromISODateTimeUTC } from '#lib/utils/timeline-util.ts';
  import { getParentPath } from '#lib/utils/tree-utils.ts';
  import { AssetTypeEnum, getAssetAvMetadata, type AssetResponseDto, type AvMetadataResponseDto } from '@immich/sdk';
  import { Duration } from 'luxon';
  import { onDestroy } from 'svelte';
  import { t } from 'svelte-i18n';
  import { slide } from 'svelte/transition';

  interface Props {
    asset: AssetResponseDto;
    isOwner: boolean;
  }

  let { asset, isOwner }: Props = $props();

  interface MetaRow {
    label: string;
    value: string;
  }

  let avMetadata = $state<AvMetadataResponseDto | null>(null);
  let requestId = 0;

  // Mirrors the server probe condition (asset type video or animated .gif source) that populates asset_video/asset_audio.
  const hasAvData = $derived(asset.type === AssetTypeEnum.Video || asset.originalPath.toLowerCase().endsWith('.gif'));

  $effect(() => {
    const assetId = asset.id;
    const currentRequest = ++requestId;
    avMetadata = null;

    if (!hasAvData || !assetViewerManager.isShowAssetPath) {
      return;
    }

    void getAssetAvMetadata({ id: assetId })
      .then((value) => {
        if (currentRequest === requestId) {
          avMetadata = value;
        }
      })
      .catch(() => {
        // Missing stream data should not disrupt the Info panel.
      });
  });

  onDestroy(() => {
    requestId += 1;
  });

  const orientationLabels: Record<string, string> = {
    '2': 'Mirror horizontal',
    '3': 'Rotate 180',
    '4': 'Mirror vertical',
    '5': 'Mirror horizontal, rotate 270 CW',
    '6': 'Rotate 90 CW',
    '7': 'Mirror horizontal, rotate 90 CW',
    '8': 'Rotate 270 CW',
  };

  const formatDateTime = (isoDateTime: string, timeZone?: string) => {
    const dateTime = timeZone ? fromISODateTime(isoDateTime, timeZone) : fromISODateTimeUTC(isoDateTime);

    return dateTime.toLocaleString(
      {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
        hour: 'numeric',
        minute: '2-digit',
        second: '2-digit',
        timeZoneName: timeZone ? 'longOffset' : undefined,
      },
      { locale: $locale },
    );
  };

  const formatDuration = (ms: number) => Duration.fromMillis(ms).toFormat('h:mm:ss');

  const formatFps = (fps: number) => `${fps.toLocaleString($locale, { maximumFractionDigits: 3 })} fps`;

  const formatBitrate = (bps: number) =>
    bps >= 1_000_000
      ? `${(bps / 1_000_000).toLocaleString($locale, { maximumFractionDigits: 1 })} Mbps`
      : `${Math.round(bps / 1000).toLocaleString($locale)} kbps`;

  const formatCodec = (codecName: string | null | undefined, profile?: number | null, level?: number | null) => {
    const parts = [codecName ?? undefined];
    const qualifiers = [
      profile === null || profile === undefined ? undefined : `profile ${profile}`,
      level === null || level === undefined ? undefined : `level ${level}`,
    ].filter((part): part is string => part !== undefined);

    if (qualifiers.length > 0) {
      parts.push(`(${qualifiers.join(', ')})`);
    }

    return parts.filter((part) => part !== undefined).join(' ') || undefined;
  };

  const generalRows = $derived.by((): MetaRow[] => {
    const exifInfo = asset.exifInfo;
    if (!exifInfo) {
      return [];
    }

    const rows: MetaRow[] = [];

    if (asset.originalMimeType) {
      rows.push({ label: $t('mime_type'), value: asset.originalMimeType });
    }

    if (exifInfo.exifImageWidth && exifInfo.exifImageHeight) {
      const { width, height } = getDimensions(exifInfo);
      if (width && height) {
        const megapixel = Math.round((width * height) / 1_000_000);
        rows.push({
          label: $t('resolution'),
          value: megapixel ? `${width} × ${height} (${megapixel} MP)` : `${width} × ${height}`,
        });
      }
    }

    if (exifInfo.fileSizeInByte) {
      rows.push({ label: $t('file_size'), value: getByteUnitString(exifInfo.fileSizeInByte, $locale) });
    }

    const orientation = orientationLabels[exifInfo.orientation ?? ''];
    if (orientation) {
      rows.push({ label: $t('orientation'), value: orientation });
    }

    if (exifInfo.profileDescription) {
      rows.push({ label: $t('color_profile'), value: exifInfo.profileDescription });
    }

    if (exifInfo.colorspace) {
      rows.push({ label: $t('color_space'), value: exifInfo.colorspace });
    }

    if (exifInfo.bitsPerSample) {
      rows.push({ label: $t('bits_per_sample'), value: exifInfo.bitsPerSample.toString() });
    }

    if (exifInfo.projectionType) {
      rows.push({ label: $t('projection_type'), value: exifInfo.projectionType });
    }

    return rows;
  });

  const dateRows = $derived.by((): MetaRow[] => {
    const exifInfo = asset.exifInfo;
    const rows: MetaRow[] = [];

    if (exifInfo?.dateTimeOriginal) {
      rows.push({
        label: $t('date_time_original'),
        value: formatDateTime(exifInfo.dateTimeOriginal, exifInfo.timeZone ?? undefined),
      });
    }

    if (exifInfo?.modifyDate) {
      rows.push({ label: $t('modify_date'), value: formatDateTime(exifInfo.modifyDate) });
    }

    rows.push(
      { label: $t('file_created'), value: formatDateTime(asset.fileCreatedAt) },
      { label: $t('file_modified'), value: formatDateTime(asset.fileModifiedAt) },
    );

    if (exifInfo?.timeZone) {
      rows.push({ label: $t('timezone'), value: exifInfo.timeZone });
    }

    return rows;
  });

  const videoRows = $derived.by((): MetaRow[] => {
    if (asset.type !== AssetTypeEnum.Video) {
      return [];
    }

    const rows: MetaRow[] = [];
    const videoStream = avMetadata?.videoStream;

    if (asset.duration !== null && asset.duration !== undefined) {
      rows.push({ label: $t('duration'), value: formatDuration(asset.duration) });
    }

    if (asset.exifInfo?.fps) {
      rows.push({ label: $t('frame_rate'), value: formatFps(asset.exifInfo.fps) });
    }

    if (videoStream?.frameCount) {
      rows.push({ label: $t('frame_count'), value: videoStream.frameCount.toLocaleString($locale) });
    }

    const codec = formatCodec(videoStream?.codecName, videoStream?.profile, videoStream?.level);
    if (codec) {
      rows.push({ label: $t('codec'), value: codec });
    }

    if (videoStream?.pixelFormat) {
      rows.push({ label: $t('pixel_format'), value: videoStream.pixelFormat });
    }

    if (videoStream?.bitrate) {
      rows.push({ label: $t('bitrate'), value: formatBitrate(videoStream.bitrate) });
    }

    if (videoStream?.formatName) {
      rows.push({ label: $t('container_format'), value: videoStream.formatName });
    }

    if (videoStream?.dvProfile !== null && videoStream?.dvProfile !== undefined) {
      rows.push({
        label: $t('dolby_vision'),
        value: `profile ${videoStream.dvProfile}${videoStream.dvLevel === null || videoStream.dvLevel === undefined ? '' : `, level ${videoStream.dvLevel}`}`,
      });
    }

    return rows;
  });

  const audioRows = $derived.by((): MetaRow[] => {
    const audioStream = avMetadata?.audioStream;
    if (!audioStream) {
      return [];
    }

    const rows: MetaRow[] = [];

    const codec = formatCodec(audioStream.codecName, audioStream.profile);
    if (codec) {
      rows.push({ label: $t('codec'), value: codec });
    }

    if (audioStream.bitrate) {
      rows.push({ label: $t('bitrate'), value: formatBitrate(audioStream.bitrate) });
    }

    return rows;
  });
</script>

{#snippet metaRow(row: MetaRow)}
  <div class="flex justify-between gap-3 text-sm">
    <span class="text-immich-fg-muted dark:text-immich-dark-fg-muted shrink-0">{row.label}</span>
    <span class="text-end wrap-break-word">{row.value}</span>
  </div>
{/snippet}

{#if assetViewerManager.isShowAssetPath}
  <div transition:slide={{ duration: 250 }} class="pb-2">
    {#if isOwner}
      <p class="pb-2 text-xs break-all opacity-50 hover:text-primary">
        <!-- eslint-disable-next-line svelte/no-navigation-without-resolve this is supposed to be treated as an absolute/external link -->
        <a
          href={Route.folders({ path: getParentPath(asset.originalPath) })}
          title={$t('go_to_folder')}
          class="whitespace-pre-wrap"
        >
          {asset.originalPath}
        </a>
      </p>
    {/if}

    {#if generalRows.length > 0}
      <p class="text-immich-fg-muted dark:text-immich-dark-fg-muted py-1 text-sm">{$t('general')}</p>
      {#each generalRows as row (row.label)}
        {@render metaRow(row)}
      {/each}
    {/if}

    {#if dateRows.length > 0}
      <p class="text-immich-fg-muted dark:text-immich-dark-fg-muted pt-3 pb-1 text-sm">{$t('dates')}</p>
      {#each dateRows as row (row.label)}
        {@render metaRow(row)}
      {/each}
    {/if}

    {#if videoRows.length > 0}
      <p class="text-immich-fg-muted dark:text-immich-dark-fg-muted pt-3 pb-1 text-sm">{$t('video')}</p>
      {#each videoRows as row (row.label)}
        {@render metaRow(row)}
      {/each}
    {/if}

    {#if audioRows.length > 0}
      <p class="text-immich-fg-muted dark:text-immich-dark-fg-muted pt-3 pb-1 text-sm">{$t('audio')}</p>
      {#each audioRows as row (row.label)}
        {@render metaRow(row)}
      {/each}
    {/if}
  </div>
{/if}
