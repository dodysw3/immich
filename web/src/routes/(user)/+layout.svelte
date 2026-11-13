<script lang="ts">
  import { QueryParameter } from '#lib/constants.ts';
  import { assetViewerManager } from '#lib/managers/asset-viewer-manager.svelte.ts';
  import type { Snippet } from 'svelte';
  import { page } from '$app/state';
  import UploadCover from './DragAndDropUploadOverlay.svelte';

  interface Props {
    children?: Snippet;
  }

  let { children }: Props = $props();

  // $page.data.asset is loaded by route specific +page.ts loaders if that
  // route contains the assetId path.
  $effect.pre(() => {
    if (page.data.asset) {
      assetViewerManager.setAsset(page.data.asset);
    } else {
      assetViewerManager.showAssetViewer(false);
    }
    const asset = page.url.searchParams.get('at');
    assetViewerManager.gridScrollTarget = { at: asset };
    syncMatchOpenFromUrl();
  });

  /**
  Transcription match-open state from the viewer URL. The timestamp is untrusted
  input: only finite non-negative integers become a seek, clamped to the asset
  duration, and the instruction is scoped to the asset in the path so it can
  never seek a different video. Navigating without match params clears it.
  */
  function syncMatchOpenFromUrl() {
    const asset = page.data.asset;
    const startMsRaw = page.url.searchParams.get(QueryParameter.MATCH_START_MS);
    const passageId = page.url.searchParams.get(QueryParameter.MATCH_PASSAGE_ID);
    const revision = page.url.searchParams.get(QueryParameter.MATCH_REVISION);
    if (!asset || startMsRaw === null || !passageId || !revision) {
      assetViewerManager.clearMatchOpen();
      return;
    }
    const startMs = Number(startMsRaw);
    if (!Number.isSafeInteger(startMs) || startMs < 0) {
      assetViewerManager.clearMatchOpen();
      return;
    }
    const durationMs = asset.duration && Number.isFinite(asset.duration) ? asset.duration : undefined;
    assetViewerManager.setMatchOpen({
      assetId: asset.id,
      passageId,
      revision,
      startMs: durationMs === undefined ? startMs : Math.min(startMs, Math.max(durationMs, 0)),
    });
  }
</script>

<div class:display-none={assetViewerManager.isViewing}>
  {@render children?.()}
</div>
<UploadCover />

<style>
  :root {
    overscroll-behavior: none;
  }
  .display-none {
    display: none;
  }
</style>
