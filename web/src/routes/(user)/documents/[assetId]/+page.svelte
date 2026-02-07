<script lang="ts">
  import PdfDocumentInfo from '$lib/components/pdf-viewer/PdfDocumentInfo.svelte';
  import PdfSearchBar from '$lib/components/pdf-viewer/PdfSearchBar.svelte';
  import PdfViewer from '$lib/components/pdf-viewer/PdfViewer.svelte';
  import UserPageLayout from '$lib/components/layouts/user-page-layout.svelte';
  import type { PageData } from './$types';

  interface Props {
    data: PageData;
  }

  let { data }: Props = $props();
  let searchQuery = $state('');
  let viewerPage = $state(1);
  let searching = $state(false);
  let searchResults = $state<Array<{ pageNumber: number; snippet: string; matchIndex: number }> | null>(null);

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
      return data.pages;
    }

    return data.pages.filter((page) => normalized(page.text).includes(needle));
  });

  const handleSearch = async (query: string) => {
    searchQuery = query;
    if (!query.trim()) {
      searchResults = null;
      return;
    }

    searching = true;
    try {
      const response = await fetch(`/api/documents/${data.document.assetId}/search?query=${encodeURIComponent(query)}`);
      searchResults = response.ok ? await response.json() : [];
    } finally {
      searching = false;
    }
  };
</script>

<UserPageLayout
  title={data.document.title || data.document.originalFileName}
  description={`${data.document.pageCount} page(s)`}
>
  {#snippet buttons()}
    <a
      class="rounded-xl border border-gray-300 px-3 py-2 text-xs font-medium hover:border-primary-400 dark:border-gray-700"
      href={`/api/assets/${data.document.assetId}/original`}
      download={data.document.originalFileName}
    >
      Download PDF
    </a>
  {/snippet}

  <div class="grid gap-4 xl:grid-cols-[2fr_1fr]">
    <div class="space-y-4">
      <PdfViewer assetId={data.document.assetId} requestedPage={viewerPage} onPageChange={(page) => (viewerPage = page)} />
      <PdfSearchBar query={searchQuery} onSearch={handleSearch} />
    </div>

    <div class="space-y-4">
      <PdfDocumentInfo document={data.document} />
      <div class="rounded-2xl border border-gray-200 p-4 dark:border-gray-700">
      <h2 class="text-sm font-semibold">Indexed pages</h2>
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
