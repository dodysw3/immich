<script lang="ts">
  import { getBaseUrl } from '@immich/sdk';
  import { onMount, onDestroy } from 'svelte';
  import PdfDocumentInfo from '$lib/components/pdf-viewer/PdfDocumentInfo.svelte';
  import PdfSearchBar from '$lib/components/pdf-viewer/PdfSearchBar.svelte';
  import Icon from '$lib/components/elements/icon.svelte';
  import {
    mdiChevronLeft,
    mdiChevronRight,
    mdiMagnifyMinusOutline,
    mdiMagnifyPlusOutline,
    mdiFitToPageOutline,
  } from '@mdi/js';

  interface Props {
    assetId: string;
  }

  let { assetId }: Props = $props();

  let pdfDoc: any = $state(null);
  let currentPage = $state(1);
  let totalPages = $state(0);
  let scale = $state(1.5);
  let canvasElement: HTMLCanvasElement;
  let rendering = $state(false);
  let loading = $state(true);
  let error = $state('');
  let documentInfo: any = $state(null);
  let pdfjsLib: any;

  onMount(async () => {
    try {
      pdfjsLib = await import('pdfjs-dist');
      pdfjsLib.GlobalWorkerOptions.workerSrc = new URL(
        'pdfjs-dist/build/pdf.worker.min.mjs',
        import.meta.url,
      ).toString();

      await loadPdf();
      await loadDocumentInfo();
    } catch (e) {
      error = e instanceof Error ? e.message : 'Failed to initialize PDF viewer';
      loading = false;
    }
  });

  async function loadPdf() {
    loading = true;
    try {
      const url = `${getBaseUrl()}/assets/${assetId}/original`;
      const loadingTask = pdfjsLib.getDocument(url);
      pdfDoc = await loadingTask.promise;
      totalPages = pdfDoc.numPages;
      await renderPage(currentPage);
    } catch (e) {
      error = e instanceof Error ? e.message : 'Failed to load PDF';
    } finally {
      loading = false;
    }
  }

  async function loadDocumentInfo() {
    try {
      const response = await fetch(`${getBaseUrl()}/documents/${assetId}`, { credentials: 'include' });
      if (response.ok) {
        documentInfo = await response.json();
      }
    } catch {
      // Non-critical, ignore
    }
  }

  async function renderPage(pageNum: number) {
    if (!pdfDoc || rendering) return;

    rendering = true;
    try {
      const page = await pdfDoc.getPage(pageNum);
      const viewport = page.getViewport({ scale });

      const canvas = canvasElement;
      const context = canvas.getContext('2d');
      if (!context) return;

      canvas.height = viewport.height;
      canvas.width = viewport.width;

      await page.render({ canvasContext: context, viewport }).promise;
    } catch (e) {
      console.error('Error rendering page:', e);
    } finally {
      rendering = false;
    }
  }

  function goToPage(pageNum: number) {
    if (pageNum < 1 || pageNum > totalPages) return;
    currentPage = pageNum;
    renderPage(currentPage);
  }

  function prevPage() {
    goToPage(currentPage - 1);
  }

  function nextPage() {
    goToPage(currentPage + 1);
  }

  function zoomIn() {
    scale = Math.min(scale + 0.25, 5);
    renderPage(currentPage);
  }

  function zoomOut() {
    scale = Math.max(scale - 0.25, 0.5);
    renderPage(currentPage);
  }

  function fitToWidth() {
    scale = 1.5;
    renderPage(currentPage);
  }

  function handleKeydown(event: KeyboardEvent) {
    if (event.key === 'ArrowLeft') prevPage();
    if (event.key === 'ArrowRight') nextPage();
  }
</script>

<svelte:window onkeydown={handleKeydown} />

<div class="flex h-full flex-col">
  <!-- Toolbar -->
  <div class="flex items-center justify-between border-b border-gray-200 bg-white px-4 py-2 dark:border-gray-700 dark:bg-gray-900">
    <div class="flex items-center gap-2">
      <!-- Page navigation -->
      <button onclick={prevPage} disabled={currentPage <= 1} class="rounded p-1 hover:bg-gray-100 disabled:opacity-30 dark:hover:bg-gray-700">
        <Icon path={mdiChevronLeft} size="24" />
      </button>
      <span class="text-sm tabular-nums">
        <input
          type="number"
          value={currentPage}
          min={1}
          max={totalPages}
          onchange={(e) => goToPage(Number((e.target as HTMLInputElement).value))}
          class="w-12 rounded border border-gray-300 px-1 text-center text-sm dark:border-gray-600 dark:bg-gray-800"
        />
        / {totalPages}
      </span>
      <button onclick={nextPage} disabled={currentPage >= totalPages} class="rounded p-1 hover:bg-gray-100 disabled:opacity-30 dark:hover:bg-gray-700">
        <Icon path={mdiChevronRight} size="24" />
      </button>
    </div>

    <div class="flex items-center gap-2">
      <!-- Zoom controls -->
      <button onclick={zoomOut} class="rounded p-1 hover:bg-gray-100 dark:hover:bg-gray-700">
        <Icon path={mdiMagnifyMinusOutline} size="20" />
      </button>
      <span class="text-sm tabular-nums">{Math.round(scale * 100)}%</span>
      <button onclick={zoomIn} class="rounded p-1 hover:bg-gray-100 dark:hover:bg-gray-700">
        <Icon path={mdiMagnifyPlusOutline} size="20" />
      </button>
      <button onclick={fitToWidth} class="rounded p-1 hover:bg-gray-100 dark:hover:bg-gray-700">
        <Icon path={mdiFitToPageOutline} size="20" />
      </button>
    </div>

    <PdfSearchBar {assetId} />
  </div>

  <!-- PDF content area -->
  <div class="flex flex-1 overflow-hidden">
    <!-- Document info sidebar -->
    {#if documentInfo}
      <div class="hidden w-64 flex-shrink-0 overflow-y-auto border-r border-gray-200 bg-gray-50 p-4 dark:border-gray-700 dark:bg-gray-800 lg:block">
        <PdfDocumentInfo info={documentInfo} />
      </div>
    {/if}

    <!-- Canvas area -->
    <div class="flex-1 overflow-auto bg-gray-500/20 p-4">
      {#if loading}
        <div class="flex h-full items-center justify-center">
          <div class="text-gray-500 dark:text-gray-400">Loading PDF...</div>
        </div>
      {:else if error}
        <div class="flex h-full items-center justify-center">
          <div class="text-red-500">{error}</div>
        </div>
      {:else}
        <div class="flex justify-center">
          <canvas
            bind:this={canvasElement}
            class="shadow-lg"
          ></canvas>
        </div>
      {/if}
    </div>
  </div>
</div>
