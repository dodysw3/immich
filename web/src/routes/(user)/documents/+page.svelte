<script lang="ts">
  import UserPageLayout from '$lib/components/layouts/user-page-layout.svelte';
  import { Route } from '$lib/route';
  import type { PageData } from './$types';

  interface Props {
    data: PageData;
  }

  let { data }: Props = $props();
</script>

<UserPageLayout title="Documents" description={`(${data.items.length})`}>
  {#if data.items.length === 0}
    <p class="text-sm text-gray-500 dark:text-gray-300">No PDF documents found yet.</p>
  {:else}
    <div class="grid grid-cols-1 gap-3 md:grid-cols-2 xl:grid-cols-3">
      {#each data.items as item}
        <a
          class="rounded-2xl border border-gray-200 p-4 transition hover:border-primary-400 hover:bg-gray-50 dark:border-gray-700 dark:hover:bg-gray-900"
          href={Route.viewDocument({ id: item.assetId })}
        >
          <p class="line-clamp-2 text-sm font-medium">{item.title || item.originalFileName}</p>
          <p class="mt-2 text-xs text-gray-600 dark:text-gray-300">{item.pageCount} page(s)</p>
        </a>
      {/each}
    </div>
  {/if}
</UserPageLayout>
