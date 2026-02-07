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

  const normalized = (value: string) => value.trim().toLowerCase();
  const highlightedPages = $derived.by(() => {
    const needle = normalized(searchQuery);
    if (!needle) {
      return data.pages;
    }

    return data.pages.filter((page) => normalized(page.text).includes(needle));
  });
</script>

<UserPageLayout
  title={data.document.title || data.document.originalFileName}
  description={`${data.document.pageCount} page(s)`}
>
  <div class="grid gap-4 xl:grid-cols-[2fr_1fr]">
    <div class="space-y-4">
      <PdfViewer assetId={data.document.assetId} />
      <PdfSearchBar query={searchQuery} onSearch={(query) => (searchQuery = query)} />
    </div>

    <div class="space-y-4">
      <PdfDocumentInfo document={data.document} />
      <div class="rounded-2xl border border-gray-200 p-4 dark:border-gray-700">
      <h2 class="text-sm font-semibold">Indexed pages</h2>
      {#if highlightedPages.length === 0}
        <p class="mt-3 text-xs text-gray-500 dark:text-gray-300">
          No matching indexed text. Processing may still be running.
        </p>
      {:else}
        <ul class="mt-3 space-y-3">
          {#each highlightedPages as page}
            <li class="rounded-xl border border-gray-200 p-3 text-sm dark:border-gray-700">
              <p class="font-medium">Page {page.pageNumber}</p>
              <p class="mt-1 line-clamp-4 text-xs text-gray-600 dark:text-gray-300">{page.text || '(empty)'}</p>
            </li>
          {/each}
        </ul>
      {/if}
      </div>
    </div>
  </div>
</UserPageLayout>
