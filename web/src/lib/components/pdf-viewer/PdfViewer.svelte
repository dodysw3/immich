<script lang="ts">
  import { base } from '$app/paths';
  import { onMount, tick } from 'svelte';

  type PdfDocument = {
    numPages: number;
    getPage: (page: number) => Promise<{
      getViewport: (options: { scale: number }) => { width: number; height: number };
      render: (options: { canvasContext: CanvasRenderingContext2D; viewport: { width: number; height: number } }) => {
        promise: Promise<void>;
      };
    }>;
  };

  type PageThumbnail = {
    pageNumber: number;
    dataUrl: string;
  };

  interface Props {
    assetId: string;
    requestedPage?: number;
    onPageChange?: (page: number) => void;
  }

  let { assetId, requestedPage = 1, onPageChange }: Props = $props();
  let canvas: HTMLCanvasElement;
  let pdf = $state<PdfDocument | null>(null);
  let totalPages = $state(0);
  let currentPage = $state(1);
  let scale = $state(1.2);
  let loading = $state(true);
  let error = $state<string | null>(null);
  let thumbnails = $state<PageThumbnail[]>([]);
  let pendingRequestedPage = $state<number | null>(null);
  const THUMBNAIL_PAGE_LIMIT = 40;

  const normalizePageNumber = (page: number) => {
    const next = Number(page);
    return Number.isFinite(next) ? Math.max(1, Math.floor(next)) : 1;
  };

  const renderPage = async () => {
    if (!pdf || !canvas) {
      return;
    }

    const page = await pdf.getPage(currentPage);
    const viewport = page.getViewport({ scale });
    const ctx = canvas.getContext('2d');
    if (!ctx) {
      return;
    }

    canvas.width = viewport.width;
    canvas.height = viewport.height;
    await page.render({ canvasContext: ctx, viewport }).promise;
  };

  const clampPage = (page: number) => Math.min(Math.max(1, page), Math.max(1, totalPages));

  const setPage = async (page: number, emit = true) => {
    if (!pdf) {
      return;
    }

    const target = clampPage(normalizePageNumber(page));
    if (target === currentPage) {
      return;
    }

    currentPage = target;
    await renderPage();
    if (emit) {
      onPageChange?.(currentPage);
    }
  };

  const updatePage = async (offset: number) => {
    await setPage(currentPage + offset);
  };

  const updateScale = async (next: number) => {
    scale = Math.min(2.5, Math.max(0.5, next));
    await renderPage();
  };

  const renderThumbnail = async (pageNumber: number) => {
    if (!pdf) {
      return null;
    }

    const page = await pdf.getPage(pageNumber);
    const viewport = page.getViewport({ scale: 0.2 });
    const thumbCanvas = document.createElement('canvas');
    const ctx = thumbCanvas.getContext('2d');
    if (!ctx) {
      return null;
    }

    thumbCanvas.width = viewport.width;
    thumbCanvas.height = viewport.height;
    await page.render({ canvasContext: ctx, viewport }).promise;
    return thumbCanvas.toDataURL('image/webp', 0.8);
  };

  const buildThumbnails = async () => {
    if (!pdf) {
      return;
    }

    const limit = Math.min(totalPages, THUMBNAIL_PAGE_LIMIT);
    const next: PageThumbnail[] = [];
    for (let page = 1; page <= limit; page++) {
      const dataUrl = await renderThumbnail(page);
      if (dataUrl) {
        next.push({ pageNumber: page, dataUrl });
      }
    }

    thumbnails = next;
  };

  onMount(async () => {
    try {
      const pdfjs = await import('pdfjs-dist');
      // pdf.js worker must be set in browser context before loading documents.
      pdfjs.GlobalWorkerOptions.workerSrc = new URL('pdfjs-dist/build/pdf.worker.min.mjs', import.meta.url).toString();
      // Needed for JPX/JPEG2000 and other wasm-backed decoders (e.g. openjpeg.wasm).
      const wasmUrl = `${base}/pdfjs/wasm/`;
      const task = pdfjs.getDocument({ url: `/api/assets/${assetId}/original`, wasmUrl });
      const loaded = (await task.promise) as unknown as PdfDocument;
      pdf = loaded;
      totalPages = loaded.numPages;
      currentPage = clampPage(normalizePageNumber(requestedPage));
    } catch (error_) {
      error = error_ instanceof Error ? error_.message : 'Failed to load PDF';
    } finally {
      loading = false;
    }

    if (pdf) {
      await tick();
      await renderPage();
      void buildThumbnails();
      if (pendingRequestedPage !== null) {
        await setPage(pendingRequestedPage, false);
        pendingRequestedPage = null;
      }
      onPageChange?.(currentPage);
    }
  });

  $effect(() => {
    const target = normalizePageNumber(requestedPage);
    if (pdf) {
      void setPage(target, false);
      return;
    }

    pendingRequestedPage = target;
  });
</script>

<div class="overflow-hidden rounded-2xl border border-gray-200 dark:border-gray-700">
  <div class="flex items-center justify-between border-b border-gray-200 px-3 py-2 text-xs dark:border-gray-700">
    <div class="flex items-center gap-2">
      <button type="button" class="rounded border px-2 py-1" onclick={() => updatePage(-1)} disabled={currentPage <= 1}>
        Prev
      </button>
      <button type="button" class="rounded border px-2 py-1" onclick={() => updatePage(1)} disabled={currentPage >= totalPages}>
        Next
      </button>
      <span>Page {currentPage}/{Math.max(1, totalPages)}</span>
    </div>

    <div class="flex items-center gap-2">
      <button type="button" class="rounded border px-2 py-1" onclick={() => updateScale(scale - 0.1)}>-</button>
      <span>{Math.round(scale * 100)}%</span>
      <button type="button" class="rounded border px-2 py-1" onclick={() => updateScale(scale + 0.1)}>+</button>
    </div>
  </div>

  {#if loading}
    <div class="flex h-[72vh] items-center justify-center text-sm text-gray-500 dark:text-gray-300">Loading PDF...</div>
  {:else if error}
    <div class="flex h-[72vh] items-center justify-center px-4 text-sm text-red-600 dark:text-red-400">{error}</div>
  {:else}
    {#if thumbnails.length > 0}
      <div class="max-w-full overflow-x-auto border-b border-gray-200 px-3 py-2 dark:border-gray-700">
        <div class="flex w-max gap-2">
          {#each thumbnails as thumb (thumb.pageNumber)}
            <button
              type="button"
              class={`overflow-hidden rounded border ${
                thumb.pageNumber === currentPage ? 'border-primary-500' : 'border-gray-300 dark:border-gray-700'
              }`}
              onclick={() => setPage(thumb.pageNumber)}
              title={`Page ${thumb.pageNumber}`}
            >
              <img class="h-14 w-11 object-cover" src={thumb.dataUrl} alt={`Page ${thumb.pageNumber}`} />
            </button>
          {/each}
        </div>
      </div>
    {/if}
    <div class="h-[72vh] overflow-auto bg-gray-50 p-4 dark:bg-gray-900">
      <canvas bind:this={canvas} class="mx-auto rounded-lg bg-white shadow-sm dark:bg-gray-800" />
    </div>
  {/if}
</div>
