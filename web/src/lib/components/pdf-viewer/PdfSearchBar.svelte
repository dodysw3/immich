<script lang="ts">
  import { getBaseUrl } from '@immich/sdk';
  import Icon from '$lib/components/elements/icon.svelte';
  import { mdiMagnify } from '@mdi/js';

  interface Props {
    assetId: string;
  }

  let { assetId }: Props = $props();
  let query = $state('');
  let results: Array<{ pageNumber: number; text: string }> = $state([]);
  let searching = $state(false);
  let showResults = $state(false);

  async function search() {
    if (!query.trim()) {
      results = [];
      showResults = false;
      return;
    }

    searching = true;
    try {
      const response = await fetch(`${getBaseUrl()}/documents/${assetId}/pages`, { credentials: 'include' });
      if (!response.ok) return;

      const pages: Array<{ pageNumber: number; text: string }> = await response.json();
      const lowerQuery = query.toLowerCase();

      results = pages
        .filter((page) => page.text.toLowerCase().includes(lowerQuery))
        .map((page) => {
          const idx = page.text.toLowerCase().indexOf(lowerQuery);
          const start = Math.max(0, idx - 40);
          const end = Math.min(page.text.length, idx + query.length + 40);
          const snippet = (start > 0 ? '...' : '') + page.text.slice(start, end) + (end < page.text.length ? '...' : '');
          return { pageNumber: page.pageNumber, text: snippet };
        });

      showResults = true;
    } catch {
      // ignore
    } finally {
      searching = false;
    }
  }

  function handleKeydown(event: KeyboardEvent) {
    if (event.key === 'Enter') {
      search();
    }
    if (event.key === 'Escape') {
      showResults = false;
    }
  }
</script>

<div class="relative">
  <div class="flex items-center gap-1">
    <input
      type="text"
      bind:value={query}
      onkeydown={handleKeydown}
      placeholder="Search in document..."
      class="w-48 rounded border border-gray-300 px-2 py-1 text-sm dark:border-gray-600 dark:bg-gray-800 dark:text-white"
    />
    <button onclick={search} class="rounded p-1 hover:bg-gray-100 dark:hover:bg-gray-700">
      <Icon path={mdiMagnify} size="18" />
    </button>
  </div>

  {#if showResults && results.length > 0}
    <div class="absolute right-0 top-full z-50 mt-1 max-h-64 w-80 overflow-y-auto rounded-lg border border-gray-200 bg-white shadow-lg dark:border-gray-700 dark:bg-gray-800">
      {#each results as result}
        <div class="border-b border-gray-100 p-2 text-xs dark:border-gray-700">
          <div class="font-medium text-gray-700 dark:text-gray-300">Page {result.pageNumber}</div>
          <div class="mt-1 text-gray-500 dark:text-gray-400">{result.text}</div>
        </div>
      {/each}
    </div>
  {:else if showResults && results.length === 0 && !searching}
    <div class="absolute right-0 top-full z-50 mt-1 w-80 rounded-lg border border-gray-200 bg-white p-3 shadow-lg dark:border-gray-700 dark:bg-gray-800">
      <div class="text-sm text-gray-500">No matches found</div>
    </div>
  {/if}
</div>
