<script lang="ts">
  import { Route } from '$lib/route';

  interface DocumentItem {
    assetId: string;
    originalFileName: string;
    title: string | null;
    pageCount: number;
    matchingPages?: number[];
  }

  interface Props {
    items: DocumentItem[];
  }

  let { items }: Props = $props();
</script>

{#if items.length === 0}
  <p class="text-sm text-gray-500 dark:text-gray-300">No PDF documents found yet.</p>
{:else}
  <div class="grid grid-cols-1 gap-3 md:grid-cols-2 xl:grid-cols-3">
    {#each items as item}
      <a
        class="rounded-2xl border border-gray-200 p-4 transition hover:border-primary-400 hover:bg-gray-50 dark:border-gray-700 dark:hover:bg-gray-900"
        href={Route.viewDocument({ id: item.assetId })}
      >
        <p class="line-clamp-2 text-sm font-medium">{item.title || item.originalFileName}</p>
        <p class="mt-2 text-xs text-gray-600 dark:text-gray-300">{item.pageCount} page(s)</p>
        {#if item.matchingPages && item.matchingPages.length > 0}
          <p class="mt-1 text-xs text-primary-700 dark:text-primary-300">
            {item.matchingPages.length} matching page(s)
          </p>
        {/if}
      </a>
    {/each}
  </div>
{/if}
