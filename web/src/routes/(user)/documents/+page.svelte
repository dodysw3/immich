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
  let query = $state(data.query ?? '');

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
</script>

<UserPageLayout title="Documents" description={`(${data.items.length})`}>
  <div class="mb-4">
    <PdfSearchBar {query} onSearch={handleSearch} />
    {#if query}
      <button class="mt-2 text-xs text-primary-700 dark:text-primary-300" onclick={resetSearch}>Clear search</button>
    {/if}
  </div>
  <PdfDocumentGrid items={data.items} />
  <div class="mt-4 flex items-center justify-between text-sm">
    <button class="rounded border px-3 py-1 disabled:opacity-40" onclick={() => gotoPage(data.page - 1)} disabled={data.page <= 1}>
      Previous
    </button>
    <span>Page {data.page}</span>
    <button
      class="rounded border px-3 py-1 disabled:opacity-40"
      onclick={() => gotoPage(data.page + 1)}
      disabled={!data.nextPage}
    >
      Next
    </button>
  </div>
</UserPageLayout>
