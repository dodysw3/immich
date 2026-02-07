<script lang="ts">
  import { toastManager } from '@immich/ui';
  import PdfDocumentInfo from '$lib/components/pdf-viewer/PdfDocumentInfo.svelte';
  import PdfSearchBar from '$lib/components/pdf-viewer/PdfSearchBar.svelte';
  import PdfViewer from '$lib/components/pdf-viewer/PdfViewer.svelte';
  import { handleError } from '$lib/utils/handle-error';
  import UserPageLayout from '$lib/components/layouts/user-page-layout.svelte';
  import type { PageData } from './$types';

  interface Props {
    data: PageData;
  }

  let { data }: Props = $props();
  let document = $state(data.document);
  let pages = $state(data.pages);
  let searchQuery = $state('');
  let viewerPage = $state(1);
  let searching = $state(false);
  let searchResults = $state<Array<{ pageNumber: number; snippet: string; matchIndex: number }> | null>(null);
  let reprocessing = $state(false);
  let refreshingDocument = false;

  const normalized = (value: string) => value.trim().toLowerCase();
  const highlightedPages = $derived.by(() => {
    if (searchResults) {
      return searchResults.map((item) => ({
        pageNumber: item.pageNumber,
        text: item.snippet,
      }));
    }

    const needle = normalized(searchQuery);
    if (!needle) {
      return pages;
    }

    return pages.filter((page) => normalized(page.text).includes(needle));
  });

  const handleSearch = async (query: string) => {
    searchQuery = query;
    if (!query.trim()) {
      searchResults = null;
      return;
    }

    searching = true;
    try {
      const response = await fetch(`/api/documents/${document.assetId}/search?query=${encodeURIComponent(query)}`);
      searchResults = response.ok ? await response.json() : [];
    } finally {
      searching = false;
    }
  };

  const refreshDocument = async () => {
    if (refreshingDocument) {
      return;
    }

    refreshingDocument = true;
    try {
      const previousStatus = document.status;
      const response = await fetch(`/api/documents/${document.assetId}`);
      if (!response.ok) {
        return;
      }

      const nextDocument = await response.json();
      document = nextDocument;

      if (previousStatus !== 'ready' && nextDocument.status === 'ready') {
        const pagesResponse = await fetch(`/api/documents/${document.assetId}/pages`);
        pages = pagesResponse.ok ? await pagesResponse.json() : [];
      }
    } finally {
      refreshingDocument = false;
    }
  };

  const shouldPollDocument = () => document.status === 'pending' || document.status === 'processing';

  $effect(() => {
    if (!shouldPollDocument()) {
      return;
    }

    const timer = setInterval(() => void refreshDocument(), 5_000);
    return () => clearInterval(timer);
  });

  const triggerReprocess = async () => {
    if (document.status === 'pending' || document.status === 'processing') {
      toastManager.info('Document processing is already in progress.');
      return;
    }

    reprocessing = true;
    try {
      const response = await fetch(`/api/documents/${document.assetId}/reprocess`, { method: 'POST' });
      if (!response.ok) {
        throw new Error(`Failed to queue reprocessing (${response.status})`);
      }

      document = { ...document, status: 'pending', lastError: null };
      pages = [];
      searchResults = null;
      toastManager.success('Reprocessing has been queued.');
    } finally {
      reprocessing = false;
    }
  };
</script>

<UserPageLayout
  title={document.title || document.originalFileName}
  description={`${document.pageCount} page(s)`}
>
  {#snippet buttons()}
    <div class="flex gap-2">
      <button
        class="rounded-xl border border-gray-300 px-3 py-2 text-xs font-medium hover:border-primary-400 disabled:opacity-50 dark:border-gray-700"
        onclick={() => triggerReprocess().catch((error) => handleError(error, 'Failed to reprocess document'))}
        disabled={reprocessing || document.status === 'pending' || document.status === 'processing'}
      >
        {reprocessing ? 'Reprocessing...' : 'Reprocess'}
      </button>
      <a
        class="rounded-xl border border-gray-300 px-3 py-2 text-xs font-medium hover:border-primary-400 dark:border-gray-700"
        href={`/api/assets/${document.assetId}/original`}
        download={document.originalFileName}
      >
        Download PDF
      </a>
    </div>
  {/snippet}

  <div class="grid gap-4 xl:grid-cols-[2fr_1fr]">
    <div class="space-y-4">
      <PdfViewer assetId={document.assetId} requestedPage={viewerPage} onPageChange={(page) => (viewerPage = page)} />
      <PdfSearchBar query={searchQuery} onSearch={handleSearch} />
    </div>

    <div class="space-y-4">
      <PdfDocumentInfo {document} />
      <div class="rounded-2xl border border-gray-200 p-4 dark:border-gray-700">
      <h2 class="text-sm font-semibold">Indexed pages</h2>
      {#if shouldPollDocument()}
        <p class="mt-2 text-xs text-gray-500 dark:text-gray-300">Indexing status refreshes every 5 seconds.</p>
      {/if}
      {#if searching}
        <p class="mt-3 text-xs text-gray-500 dark:text-gray-300">Searching...</p>
      {:else if highlightedPages.length === 0}
        <p class="mt-3 text-xs text-gray-500 dark:text-gray-300">
          No matching indexed text. Processing may still be running.
        </p>
      {:else}
        <ul class="mt-3 space-y-3">
          {#each highlightedPages as page}
            <button
              class={`w-full rounded-xl border p-3 text-left text-sm transition dark:border-gray-700 ${
                page.pageNumber === viewerPage
                  ? 'border-primary-500 bg-primary-50 dark:bg-primary-950/20'
                  : 'border-gray-200 hover:border-primary-300 dark:border-gray-700'
              }`}
              onclick={() => (viewerPage = page.pageNumber)}
            >
              <p class="font-medium">Page {page.pageNumber}</p>
              <p class="mt-1 line-clamp-4 text-xs text-gray-600 dark:text-gray-300">{page.text || '(empty)'}</p>
            </button>
          {/each}
        </ul>
      {/if}
      </div>
    </div>
  </div>
</UserPageLayout>
