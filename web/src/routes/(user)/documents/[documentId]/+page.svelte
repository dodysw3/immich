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
  let refreshFailures = $state(0);
  const MAX_REFRESH_FAILURES = 3;

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
        refreshFailures += 1;
        return;
      }

      const nextDocument = await response.json();
      document = nextDocument;
      refreshFailures = 0;

      if (previousStatus !== 'ready' && nextDocument.status === 'ready') {
        const pagesResponse = await fetch(`/api/documents/${document.assetId}/pages`);
        if (pagesResponse.ok) {
          pages = await pagesResponse.json();
        } else {
          refreshFailures += 1;
        }
      }
    } finally {
      refreshingDocument = false;
    }
  };

  const shouldPollDocument = () =>
    (document.status === 'pending' || document.status === 'processing') && refreshFailures < MAX_REFRESH_FAILURES;

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
      refreshFailures = 0;
      toastManager.success('Reprocessing has been queued.');
    } finally {
      reprocessing = false;
    }
  };

  const selectIndexedPage = (pageNumber: number) => {
    const target = Number(pageNumber);
    if (!Number.isFinite(target) || target < 1) {
      return;
    }

    viewerPage = Math.floor(target);
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
    <div class="min-w-0 space-y-4">
      <PdfViewer assetId={document.assetId} requestedPage={viewerPage} onPageChange={(page) => (viewerPage = page)} />
      <PdfSearchBar query={searchQuery} onSearch={handleSearch} />
    </div>

    <div class="space-y-4 xl:sticky xl:top-4 xl:self-start">
      <PdfDocumentInfo {document} />
      <div class="rounded-2xl border border-gray-200 p-4 dark:border-gray-700">
        <h2 class="text-sm font-semibold">Indexed pages</h2>
        {#if shouldPollDocument()}
          <p class="mt-2 text-xs text-gray-500 dark:text-gray-300">Indexing status refreshes every 5 seconds.</p>
        {:else if (document.status === 'pending' || document.status === 'processing') && refreshFailures >= MAX_REFRESH_FAILURES}
          <p class="mt-2 text-xs text-amber-700 dark:text-amber-300">
            Auto-refresh paused after repeated request failures. Use browser refresh to retry.
          </p>
        {/if}
        {#if searching}
          <p class="mt-3 text-xs text-gray-500 dark:text-gray-300">Searching...</p>
        {:else if highlightedPages.length === 0}
          <p class="mt-3 text-xs text-gray-500 dark:text-gray-300">
            No matching indexed text. Processing may still be running.
          </p>
        {:else}
          <ul class="mt-3 space-y-3 overflow-y-auto pr-1 max-h-[min(22rem,45vh)] xl:max-h-[calc(100vh-32rem)]">
            {#each highlightedPages as page}
              <li>
                <button
                  class={`w-full rounded-xl border p-3 text-left text-sm transition dark:border-gray-700 ${
                    page.pageNumber === viewerPage
                      ? 'border-primary-500 bg-primary-50 dark:bg-primary-950/20'
                      : 'border-gray-200 hover:border-primary-300 dark:border-gray-700'
                  }`}
                  onclick={() => selectIndexedPage(page.pageNumber)}
                >
                  <p class="font-medium">Page {page.pageNumber}</p>
                  <p class="mt-1 line-clamp-2 text-xs text-gray-600 dark:text-gray-300">{page.text || '(empty)'}</p>
                </button>
              </li>
            {/each}
          </ul>
        {/if}
      </div>
    </div>
  </div>
</UserPageLayout>
