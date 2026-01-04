<script lang="ts">
  import { shortcuts } from '$lib/actions/shortcut';
  import BrokenAsset from '$lib/components/assets/broken-asset.svelte';
  import FaceBoundingBox from '$lib/components/asset-viewer/face-bounding-box.svelte';
  import OcrBoundingBox from '$lib/components/asset-viewer/ocr-bounding-box.svelte';
  import { assetViewerFadeDuration } from '$lib/constants';
  import { faceManager } from '$lib/stores/face-manager.svelte';
  import { ocrManager } from '$lib/stores/ocr.svelte';
  import { getAssetThumbnailUrl, handlePromiseError } from '$lib/utils';
  import { getOcrBoundingBoxes } from '$lib/utils/ocr-utils';
  import { getFaceBoundingBoxes } from '$lib/utils/people-utils';
  import { AssetMediaSize, getAssetInfo, type AssetResponseDto, type PdfPagesResponseDto } from '@immich/sdk';
  import { IconButton, LoadingSpinner } from '@immich/ui';
  import { mdiFaceRecognition, mdiTextRecognition } from '@mdi/js';
  import { onMount, onDestroy } from 'svelte';
  import { t } from 'svelte-i18n';
  import { fade } from 'svelte/transition';
  import { getPdfPages } from '@immich/sdk';

  interface Props {
    asset: AssetResponseDto;
    /** Optional page ID to navigate to initially (for opening from PDF_PAGE search results) */
    initialPageId?: string | null;
    onPreviousAsset?: (() => void) | null;
    onNextAsset?: (() => void) | null;
  }

  let { asset, initialPageId = null, onPreviousAsset = null, onNextAsset = null }: Props = $props();

  let pdfData = $state<PdfPagesResponseDto | null>(null);
  let currentPageIndex = $state(0);
  let loading = $state(true);
  let error = $state(false);
  let thumbnailStripVisible = $state(true);
  let currentPageImageUrl = $state('');
  let pageLoading = $state(false);
  let pageImageElement = $state<HTMLImageElement | null>(null);

  // Simple zoom state for PDF (no zoom support, just default values)
  const defaultZoomState = {
    currentZoom: 1,
    currentPositionX: 0,
    currentPositionY: 0,
    currentRotation: 0,
    enable: false,
  };

  // Computed bounding boxes for overlays
  let ocrBoxes = $derived(
    ocrManager.showOverlay && pageImageElement
      ? getOcrBoundingBoxes(ocrManager.data, defaultZoomState, pageImageElement)
      : [],
  );

  let faceBoxes = $derived(
    faceManager.showOverlay && pageImageElement
      ? getFaceBoundingBoxes(faceManager.data, defaultZoomState, pageImageElement)
      : [],
  );

  onDestroy(() => {
    faceManager.clear();
    ocrManager.clear();
  });

  onMount(async () => {
    await loadPdfPages();
  });

  async function loadPdfPages() {
    loading = true;
    error = false;
    try {
      pdfData = await getPdfPages({ id: asset.id });
      // If an initialPageId is provided, find and navigate to that page
      if (initialPageId) {
        const pageIndex = pdfData.pages.findIndex((page) => page.id === initialPageId);
        currentPageIndex = pageIndex >= 0 ? pageIndex : pdfData.mainPageIndex;
      } else {
        currentPageIndex = pdfData.mainPageIndex;
      }
      updateCurrentPageImage();
    } catch (e) {
      console.error('Failed to load PDF pages:', e);
      error = true;
    } finally {
      loading = false;
    }
  }

  function updateCurrentPageImage() {
    if (pdfData && pdfData.pages[currentPageIndex]) {
      const page = pdfData.pages[currentPageIndex];
      currentPageImageUrl = getAssetThumbnailUrl({ id: page.id, size: AssetMediaSize.Preview });
      // Load face and OCR data for the current page
      loadPageOverlayData(page.id);
    }
  }

  async function loadPageOverlayData(pageId: string) {
    // Clear existing data
    faceManager.clear();
    ocrManager.clear();

    // Load OCR data for this page
    handlePromiseError(ocrManager.getAssetOcr(pageId));

    // Load face data for this page
    try {
      const pageAsset = await getAssetInfo({ id: pageId });
      faceManager.loadFromAsset(pageAsset);
    } catch (e) {
      console.error('Failed to load face data for page:', e);
    }
  }

  function toggleFaceOverlay() {
    faceManager.toggleFaceBoundingBox();
  }

  function toggleOcrOverlay() {
    ocrManager.toggleOcrBoundingBox();
  }

  function goToPage(index: number) {
    if (pdfData && index >= 0 && index < pdfData.pages.length) {
      pageLoading = true;
      currentPageIndex = index;
      updateCurrentPageImage();
    }
  }

  function nextPage() {
    if (pdfData && currentPageIndex < pdfData.pages.length - 1) {
      goToPage(currentPageIndex + 1);
    }
  }

  function previousPage() {
    if (currentPageIndex > 0) {
      goToPage(currentPageIndex - 1);
    }
  }

  function handleKeydown(event: KeyboardEvent) {
    if (event.key === 'ArrowRight' || event.key === 'ArrowDown') {
      if (pdfData && currentPageIndex < pdfData.pages.length - 1) {
        event.preventDefault();
        nextPage();
      } else if (onNextAsset) {
        onNextAsset();
      }
    }
    if (event.key === 'ArrowLeft' || event.key === 'ArrowUp') {
      if (currentPageIndex > 0) {
        event.preventDefault();
        previousPage();
      } else if (onPreviousAsset) {
        onPreviousAsset();
      }
    }
  }

  function handlePageLoad() {
    pageLoading = false;
  }

  function toggleThumbnailStrip() {
    thumbnailStripVisible = !thumbnailStripVisible;
  }

  const currentPage = $derived(pdfData?.pages[currentPageIndex]);
</script>

<svelte:window onkeydown={handleKeydown} />

<div
  class="pdf-viewer flex h-full w-full flex-col select-none"
  transition:fade={{ duration: assetViewerFadeDuration }}
  use:shortcuts={[
    { shortcut: { key: 'ArrowRight' }, onShortcut: nextPage },
    { shortcut: { key: 'ArrowLeft' }, onShortcut: previousPage },
    { shortcut: { key: 'f', shift: true }, onShortcut: toggleFaceOverlay, preventDefault: true },
    { shortcut: { key: 't', shift: true }, onShortcut: toggleOcrOverlay, preventDefault: true },
  ]}
>
  {#if loading}
    <div class="flex h-full items-center justify-center">
      <LoadingSpinner />
    </div>
  {:else if error || !pdfData}
    <div class="flex h-full items-center justify-center">
      <BrokenAsset />
    </div>
  {:else}
    <!-- Main page view -->
    <div class="relative flex flex-1 items-center justify-center overflow-auto bg-black/90">
      {#if pageLoading}
        <div class="absolute inset-0 flex items-center justify-center bg-black/50">
          <LoadingSpinner />
        </div>
      {/if}
      {#if currentPage}
        <div class="relative max-h-full max-w-full">
          <img
            bind:this={pageImageElement}
            src={currentPageImageUrl}
            alt="Page {currentPageIndex + 1}"
            class="max-h-full max-w-full object-contain"
            onload={handlePageLoad}
            draggable="false"
          />

          <!-- OCR bounding boxes -->
          {#each ocrBoxes as ocrBox (ocrBox.id)}
            <OcrBoundingBox {ocrBox} />
          {/each}

          <!-- Face bounding boxes -->
          {#each faceBoxes as faceBox (faceBox.id)}
            <FaceBoundingBox {faceBox} assetId={currentPage.id} />
          {/each}
        </div>
      {/if}

      <!-- Face overlay toggle button -->
      {#if faceManager.hasFaceData}
        <div class="absolute bottom-4 end-4">
          <IconButton
            title={faceManager.showOverlay ? $t('hide_face_recognition') : $t('show_face_recognition')}
            icon={mdiFaceRecognition}
            class={"dark {faceManager.showOverlay ? 'bg-immich-primary text-white dark' : 'dark'}"}
            color="secondary"
            variant="ghost"
            shape="round"
            aria-label={$t('face_recognition')}
            onclick={toggleFaceOverlay}
          />
        </div>
      {/if}

      <!-- OCR overlay toggle button -->
      {#if ocrManager.hasOcrData}
        <div class="absolute bottom-16 end-4">
          <IconButton
            title={ocrManager.showOverlay ? $t('hide_text_recognition') : $t('show_text_recognition')}
            icon={mdiTextRecognition}
            class={"dark {ocrManager.showOverlay ? 'bg-immich-primary text-white dark' : 'dark'}"}
            color="secondary"
            variant="ghost"
            shape="round"
            aria-label={$t('text_recognition')}
            onclick={toggleOcrOverlay}
          />
        </div>
      {/if}
    </div>

    <!-- Page navigation bar -->
    <div class="flex items-center justify-center gap-4 bg-gray-900 px-4 py-2">
      <button
        onclick={previousPage}
        disabled={currentPageIndex === 0}
        class="rounded px-3 py-1 text-white disabled:opacity-50 hover:bg-gray-700 disabled:hover:bg-transparent"
      >
        &larr; Previous
      </button>

      <div class="flex items-center gap-2 text-white">
        <input
          type="number"
          value={currentPageIndex + 1}
          min={1}
          max={pdfData.pageCount}
          onchange={(e) => goToPage(Number(e.currentTarget.value) - 1)}
          class="w-16 rounded bg-gray-800 px-2 py-1 text-center text-white"
        />
        <span>/ {pdfData.pageCount}</span>
      </div>

      <button
        onclick={nextPage}
        disabled={currentPageIndex >= pdfData.pages.length - 1}
        class="rounded px-3 py-1 text-white disabled:opacity-50 hover:bg-gray-700 disabled:hover:bg-transparent"
      >
        Next &rarr;
      </button>

      <button
        onclick={toggleThumbnailStrip}
        class="ml-4 rounded px-3 py-1 text-white hover:bg-gray-700"
        title={thumbnailStripVisible ? 'Hide thumbnails' : 'Show thumbnails'}
      >
        {thumbnailStripVisible ? 'Hide Pages' : 'Show Pages'}
      </button>
    </div>

    <!-- Thumbnail strip -->
    {#if thumbnailStripVisible}
      <div class="flex gap-2 overflow-x-auto bg-gray-800 p-2">
        {#each pdfData.pages as page, index}
          <button
            onclick={() => goToPage(index)}
            class="flex-shrink-0 rounded p-1 {index === currentPageIndex
              ? 'ring-2 ring-primary-500'
              : 'hover:bg-gray-700'}"
          >
            <img
              src={getAssetThumbnailUrl({ id: page.id, size: AssetMediaSize.Thumbnail })}
              alt="Page {index + 1}"
              class="h-20 w-auto object-cover"
              loading="lazy"
            />
            <span class="mt-1 block text-center text-xs text-white">{index + 1}</span>
          </button>
        {/each}
      </div>
    {/if}

    <!-- Status indicator -->
    {#if pdfData.status === 'processing'}
      <div class="bg-yellow-600 px-4 py-2 text-center text-white">
        Processing pages... ({pdfData.pages.length}/{pdfData.pageCount})
      </div>
    {/if}
  {/if}
</div>
