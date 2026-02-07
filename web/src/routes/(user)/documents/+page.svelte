<script lang="ts">
  import PdfDocumentGrid from '$lib/components/pdf-viewer/PdfDocumentGrid.svelte';
  import PdfSearchBar from '$lib/components/pdf-viewer/PdfSearchBar.svelte';
  import UserPageLayout from '$lib/components/layouts/user-page-layout.svelte';
  import type { PageData } from './$types';
  import { goto } from '$app/navigation';
  import { Route } from '$lib/route';

  interface Props {
    data: PageData;
  }

  let { data }: Props = $props();
  let items = $state(data.items);
  let nextPage = $state(data.nextPage);
  let summary = $state(data.summary);
  let query = $state(data.query ?? '');
  let refreshing = false;

  const handleSearch = (value: string, page = 1) => {
    const params = new URLSearchParams();
    if (value) {
      params.set('query', value);
    }
    if (page > 1) {
      params.set('page', `${page}`);
    }
    const queryString = params.toString();
    const suffix = queryString ? `?${queryString}` : '';
    void goto(`${Route.documents()}${suffix}`);
  };

  const gotoPage = (page: number) => {
    if (page < 1) {
      return;
    }
    handleSearch(query, page);
  };

  const resetSearch = () => {
    query = '';
    void goto(Route.documents());
  };

  const shouldPollDocuments = () =>
    items.some((item) => item.status === 'pending' || item.status === 'processing') && !query;

  const refreshDocuments = async () => {
    if (refreshing) {
      return;
    }

    refreshing = true;
    try {
      const response = await fetch(`/api/documents?page=${data.page}`);
      if (!response.ok) {
        return;
      }

      const payload = await response.json();
      items = payload.items || [];
      nextPage = payload.nextPage || null;
      summary = payload.summary || { total: 0, pending: 0, processing: 0, ready: 0, failed: 0 };
    } finally {
      refreshing = false;
    }
  };

  $effect(() => {
    if (!shouldPollDocuments()) {
      return;
    }

    const timer = setInterval(() => void refreshDocuments(), 5_000);
    return () => clearInterval(timer);
  });
</script>

<UserPageLayout title="Documents" description={`(${query ? items.length : summary.total})`}>
  <div class="mb-4">
    {#if !query}
      <div class="mb-3 flex flex-wrap gap-2 text-xs">
        <span class="rounded-full bg-gray-100 px-2 py-1 dark:bg-gray-800">Total: {summary.total}</span>
        <span class="rounded-full bg-amber-100 px-2 py-1 text-amber-800 dark:bg-amber-900/30 dark:text-amber-300">
          Pending: {summary.pending}
        </span>
        <span class="rounded-full bg-blue-100 px-2 py-1 text-blue-800 dark:bg-blue-900/30 dark:text-blue-300">
          Processing: {summary.processing}
        </span>
        <span class="rounded-full bg-green-100 px-2 py-1 text-green-800 dark:bg-green-900/30 dark:text-green-300">
          Ready: {summary.ready}
        </span>
        <span class="rounded-full bg-red-100 px-2 py-1 text-red-800 dark:bg-red-900/30 dark:text-red-300">
          Failed: {summary.failed}
        </span>
      </div>
    {/if}
    <PdfSearchBar {query} onSearch={handleSearch} />
    {#if shouldPollDocuments()}
      <p class="mt-2 text-xs text-gray-500 dark:text-gray-300">Refreshing processing status every 5 seconds.</p>
    {/if}
    {#if query}
      <button class="mt-2 text-xs text-primary-700 dark:text-primary-300" onclick={resetSearch}>Clear search</button>
    {/if}
  </div>
  <PdfDocumentGrid {items} />
  <div class="mt-4 flex items-center justify-between text-sm">
    <button class="rounded border px-3 py-1 disabled:opacity-40" onclick={() => gotoPage(data.page - 1)} disabled={data.page <= 1}>
      Previous
    </button>
    <span>Page {data.page}</span>
    <button
      class="rounded border px-3 py-1 disabled:opacity-40"
      onclick={() => gotoPage(data.page + 1)}
      disabled={!nextPage}
    >
      Next
    </button>
  </div>
</UserPageLayout>
