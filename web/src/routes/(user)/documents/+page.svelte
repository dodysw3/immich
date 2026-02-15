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
  let status = $state(data.status ?? '');
  let loading = $state(false);
  let refreshing = false;
  let refreshFailures = $state(0);
  const MAX_REFRESH_FAILURES = 3;

  let sentinel: HTMLElement | undefined = $state();

  $effect(() => {
    items = data.items;
    nextPage = data.nextPage;
    summary = data.summary;
    query = data.query ?? '';
    status = data.status ?? '';
  });

  const navigateDocuments = (next: { query?: string; status?: string }) => {
    const nextQuery = next.query ?? query;
    const nextStatus = next.status ?? status;
    const params = new URLSearchParams();
    if (nextQuery) {
      params.set('query', nextQuery);
    }
    if (nextStatus) {
      params.set('status', nextStatus);
    }
    const queryString = params.toString();
    const suffix = queryString ? `?${queryString}` : '';
    void goto(`${Route.documents()}${suffix}`);
  };

  const handleSearch = (value: string) => {
    query = value;
    navigateDocuments({ query: value, status });
  };

  const resetSearch = () => {
    query = '';
    navigateDocuments({ query: '', status });
  };

  const setStatus = (value: string) => {
    status = value;
    query = '';
    navigateDocuments({ query: '', status: value });
  };

  const loadNextPage = async () => {
    if (loading || !nextPage) {
      return;
    }

    loading = true;
    try {
      const endpoint = query
        ? `/api/documents/search?query=${encodeURIComponent(query)}&page=${nextPage}${status ? `&status=${encodeURIComponent(status)}` : ''}`
        : `/api/documents?page=${nextPage}${status ? `&status=${encodeURIComponent(status)}` : ''}`;
      const response = await fetch(endpoint);
      if (!response.ok) {
        return;
      }

      const payload = await response.json();
      items = [...items, ...(payload.items || [])];
      nextPage = payload.nextPage || null;
      if (payload.summary) {
        summary = payload.summary;
      }
    } finally {
      loading = false;
    }
  };

  $effect(() => {
    if (!sentinel) {
      return;
    }

    const observer = new IntersectionObserver((entries) => {
      if (entries[0]?.isIntersecting) {
        void loadNextPage();
      }
    });

    observer.observe(sentinel);
    return () => observer.disconnect();
  });

  const shouldPollDocuments = () =>
    items.some((item) => item.status === 'pending' || item.status === 'processing') && !query && refreshFailures < MAX_REFRESH_FAILURES;

  const refreshDocuments = async () => {
    if (refreshing) {
      return;
    }

    refreshing = true;
    try {
      const response = await fetch(
        `/api/documents?page=1${status ? `&status=${encodeURIComponent(status)}` : ''}`,
      );
      if (!response.ok) {
        refreshFailures += 1;
        return;
      }

      const payload = await response.json();
      const refreshedItems = payload.items || [];
      // Update only the first page worth of items, keep the rest
      items = [...refreshedItems, ...items.slice(refreshedItems.length)];
      summary = payload.summary || { total: 0, pending: 0, processing: 0, ready: 0, failed: 0 };
      refreshFailures = 0;
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
    <div class="mb-3 flex flex-wrap gap-2 text-xs">
      <button
        class={`rounded-full px-2 py-1 ${!status ? 'bg-gray-200 dark:bg-gray-700' : 'bg-gray-100 dark:bg-gray-800'}`}
        onclick={() => setStatus('')}
      >
        Total: {summary.total}
      </button>
      <button
        class={`rounded-full px-2 py-1 text-amber-800 dark:text-amber-300 ${
          status === 'pending' ? 'bg-amber-200 dark:bg-amber-900/50' : 'bg-amber-100 dark:bg-amber-900/30'
        }`}
        onclick={() => setStatus('pending')}
      >
        Pending: {summary.pending}
      </button>
      <button
        class={`rounded-full px-2 py-1 text-blue-800 dark:text-blue-300 ${
          status === 'processing' ? 'bg-blue-200 dark:bg-blue-900/50' : 'bg-blue-100 dark:bg-blue-900/30'
        }`}
        onclick={() => setStatus('processing')}
      >
        Processing: {summary.processing}
      </button>
      <button
        class={`rounded-full px-2 py-1 text-green-800 dark:text-green-300 ${
          status === 'ready' ? 'bg-green-200 dark:bg-green-900/50' : 'bg-green-100 dark:bg-green-900/30'
        }`}
        onclick={() => setStatus('ready')}
      >
        Ready: {summary.ready}
      </button>
      <button
        class={`rounded-full px-2 py-1 text-red-800 dark:text-red-300 ${
          status === 'failed' ? 'bg-red-200 dark:bg-red-900/50' : 'bg-red-100 dark:bg-red-900/30'
        }`}
        onclick={() => setStatus('failed')}
      >
        Failed: {summary.failed}
      </button>
    </div>
    <PdfSearchBar {query} onSearch={handleSearch} />
    {#if shouldPollDocuments()}
      <p class="mt-2 text-xs text-gray-500 dark:text-gray-300">Refreshing processing status every 5 seconds.</p>
    {:else if !query && refreshFailures >= MAX_REFRESH_FAILURES}
      <p class="mt-2 text-xs text-amber-700 dark:text-amber-300">
        Auto-refresh paused after repeated request failures. Use browser refresh to retry.
      </p>
    {/if}
    {#if query}
      <button class="mt-2 text-xs text-primary-700 dark:text-primary-300" onclick={resetSearch}>Clear search</button>
    {/if}
  </div>
  <PdfDocumentGrid {items} />
  {#if nextPage}
    <div bind:this={sentinel} class="flex justify-center py-8">
      {#if loading}
        <div class="h-6 w-6 animate-spin rounded-full border-2 border-gray-300 border-t-gray-600 dark:border-gray-600 dark:border-t-gray-300"></div>
      {/if}
    </div>
  {/if}
</UserPageLayout>
