<script lang="ts">
  import { onMount } from 'svelte';

  type PdfDocument = {
    numPages: number;
    getPage: (page: number) => Promise<{
      getViewport: (options: { scale: number }) => { width: number; height: number };
      render: (options: { canvasContext: CanvasRenderingContext2D; viewport: { width: number; height: number } }) => {
        promise: Promise<void>;
      };
    }>;
  };

  interface Props {
    assetId: string;
  }

  let { assetId }: Props = $props();
  let canvas: HTMLCanvasElement;
  let pdf: PdfDocument | null = null;
  let totalPages = $state(0);
  let currentPage = $state(1);
  let scale = $state(1.2);
  let loading = $state(true);
  let error = $state<string | null>(null);

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

  const updatePage = async (offset: number) => {
    if (!pdf) {
      return;
    }

    const target = Math.min(Math.max(1, currentPage + offset), totalPages);
    if (target === currentPage) {
      return;
    }

    currentPage = target;
    await renderPage();
  };

  const updateScale = async (next: number) => {
    scale = Math.min(2.5, Math.max(0.5, next));
    await renderPage();
  };

  onMount(async () => {
    try {
      const pdfjs = await import('pdfjs-dist');
      // pdf.js worker must be set in browser context before loading documents.
      pdfjs.GlobalWorkerOptions.workerSrc = new URL('pdfjs-dist/build/pdf.worker.min.mjs', import.meta.url).toString();
      const task = pdfjs.getDocument(`/api/assets/${assetId}/original`);
      const loaded = (await task.promise) as unknown as PdfDocument;
      pdf = loaded;
      totalPages = loaded.numPages;
      currentPage = 1;
      await renderPage();
    } catch (value) {
      error = value instanceof Error ? value.message : 'Failed to load PDF';
    } finally {
      loading = false;
    }
  });
</script>

<div class="overflow-hidden rounded-2xl border border-gray-200 dark:border-gray-700">
  <div class="flex items-center justify-between border-b border-gray-200 px-3 py-2 text-xs dark:border-gray-700">
    <div class="flex items-center gap-2">
      <button class="rounded border px-2 py-1" onclick={() => updatePage(-1)} disabled={currentPage <= 1}>
        Prev
      </button>
      <button class="rounded border px-2 py-1" onclick={() => updatePage(1)} disabled={currentPage >= totalPages}>
        Next
      </button>
      <span>Page {currentPage}/{Math.max(1, totalPages)}</span>
    </div>

    <div class="flex items-center gap-2">
      <button class="rounded border px-2 py-1" onclick={() => updateScale(scale - 0.1)}>-</button>
      <span>{Math.round(scale * 100)}%</span>
      <button class="rounded border px-2 py-1" onclick={() => updateScale(scale + 0.1)}>+</button>
    </div>
  </div>

  {#if loading}
    <div class="flex h-[72vh] items-center justify-center text-sm text-gray-500 dark:text-gray-300">Loading PDF...</div>
  {:else if error}
    <div class="flex h-[72vh] items-center justify-center px-4 text-sm text-red-600 dark:text-red-400">{error}</div>
  {:else}
    <div class="h-[72vh] overflow-auto bg-gray-50 p-4 dark:bg-gray-900">
      <canvas bind:this={canvas} class="mx-auto rounded-lg bg-white shadow-sm dark:bg-gray-800" />
    </div>
  {/if}
</div>
