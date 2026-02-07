<script lang="ts">
  import { getBaseUrl } from '@immich/sdk';
  import { Route } from '$lib/route';
  import { mdiFileDocumentOutline, mdiMagnify } from '@mdi/js';
  import Icon from '$lib/components/elements/icon.svelte';
  import { onMount } from 'svelte';

  interface PdfDocument {
    assetId: string;
    pageCount: number;
    title: string | null;
    author: string | null;
    processedAt: string | null;
    originalFileName: string;
    createdAt: string;
  }

  let documents: PdfDocument[] = $state([]);
  let searchQuery = $state('');
  let loading = $state(true);
  let error = $state('');

  onMount(async () => {
    await loadDocuments();
  });

  async function loadDocuments() {
    loading = true;
    error = '';
    try {
      const response = await fetch(`${getBaseUrl()}/documents`, { credentials: 'include' });
      if (!response.ok) {
        throw new Error(`Failed to load documents: ${response.statusText}`);
      }
      documents = await response.json();
    } catch (e) {
      error = e instanceof Error ? e.message : 'Failed to load documents';
    } finally {
      loading = false;
    }
  }

  async function searchDocuments() {
    if (!searchQuery.trim()) {
      await loadDocuments();
      return;
    }

    loading = true;
    error = '';
    try {
      const response = await fetch(
        `${getBaseUrl()}/documents/search?query=${encodeURIComponent(searchQuery)}`,
        { credentials: 'include' },
      );
      if (!response.ok) {
        throw new Error(`Search failed: ${response.statusText}`);
      }
      documents = await response.json();
    } catch (e) {
      error = e instanceof Error ? e.message : 'Search failed';
    } finally {
      loading = false;
    }
  }

  function handleKeydown(event: KeyboardEvent) {
    if (event.key === 'Enter') {
      searchDocuments();
    }
  }
</script>

<div class="flex flex-col gap-4 p-4">
  <div class="flex items-center gap-2">
    <div class="relative flex-1 max-w-md">
      <input
        type="text"
        bind:value={searchQuery}
        onkeydown={handleKeydown}
        placeholder="Search documents..."
        class="w-full rounded-lg border border-gray-300 bg-white px-4 py-2 pr-10 text-sm dark:border-gray-600 dark:bg-gray-800 dark:text-white"
      />
      <button
        onclick={searchDocuments}
        class="absolute right-2 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
      >
        <Icon path={mdiMagnify} size="20" />
      </button>
    </div>
  </div>

  {#if loading}
    <div class="flex items-center justify-center py-12">
      <div class="text-gray-500 dark:text-gray-400">Loading documents...</div>
    </div>
  {:else if error}
    <div class="flex items-center justify-center py-12">
      <div class="text-red-500">{error}</div>
    </div>
  {:else if documents.length === 0}
    <div class="flex flex-col items-center justify-center py-12 gap-2">
      <Icon path={mdiFileDocumentOutline} size="48" class="text-gray-400" />
      <div class="text-gray-500 dark:text-gray-400">
        {searchQuery ? 'No documents found' : 'No PDF documents uploaded yet'}
      </div>
    </div>
  {:else}
    <div class="grid grid-cols-2 gap-4 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6">
      {#each documents as doc (doc.assetId)}
        <a
          href={Route.viewDocument({ id: doc.assetId })}
          class="group flex flex-col overflow-hidden rounded-lg border border-gray-200 bg-white shadow-sm transition-shadow hover:shadow-md dark:border-gray-700 dark:bg-gray-800"
        >
          <div class="relative aspect-[3/4] bg-gray-100 dark:bg-gray-700">
            <img
              src={`${getBaseUrl()}/assets/${doc.assetId}/thumbnail`}
              alt={doc.title || doc.originalFileName}
              class="h-full w-full object-cover"
              onerror={(e) => {
                const target = e.currentTarget as HTMLImageElement;
                target.style.display = 'none';
              }}
            />
            <div class="absolute inset-0 flex items-center justify-center">
              <Icon path={mdiFileDocumentOutline} size="48" class="text-gray-300 dark:text-gray-600" />
            </div>
          </div>
          <div class="flex flex-col gap-1 p-2">
            <div class="truncate text-sm font-medium text-gray-900 dark:text-white">
              {doc.title || doc.originalFileName}
            </div>
            <div class="text-xs text-gray-500 dark:text-gray-400">
              {doc.pageCount} {doc.pageCount === 1 ? 'page' : 'pages'}
            </div>
          </div>
        </a>
      {/each}
    </div>
  {/if}
</div>
