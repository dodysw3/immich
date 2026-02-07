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

<UserPageLayout title="Documents" description={`(${items.length})`}>
  <div class="mb-4">
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
