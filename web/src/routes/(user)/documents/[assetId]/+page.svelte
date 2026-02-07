<script lang="ts">
  import UserPageLayout from '$lib/components/layouts/user-page-layout.svelte';
  import type { PageData } from './$types';

  interface Props {
    data: PageData;
  }

  let { data }: Props = $props();
</script>

<UserPageLayout
  title={data.document.title || data.document.originalFileName}
  description={`${data.document.pageCount} page(s)`}
>
  <div class="grid gap-4 xl:grid-cols-[2fr_1fr]">
    <div class="overflow-hidden rounded-2xl border border-gray-200 dark:border-gray-700">
      <iframe
        src={`/api/assets/${data.document.assetId}/original`}
        title="PDF Viewer"
        class="h-[72vh] w-full"
        loading="lazy"
      />
    </div>

    <div class="rounded-2xl border border-gray-200 p-4 dark:border-gray-700">
      <h2 class="text-sm font-semibold">Indexed pages</h2>
      {#if data.pages.length === 0}
        <p class="mt-3 text-xs text-gray-500 dark:text-gray-300">
          No indexed text yet. Processing may still be running.
        </p>
      {:else}
        <ul class="mt-3 space-y-3">
          {#each data.pages as page}
            <li class="rounded-xl border border-gray-200 p-3 text-sm dark:border-gray-700">
              <p class="font-medium">Page {page.pageNumber}</p>
              <p class="mt-1 line-clamp-4 text-xs text-gray-600 dark:text-gray-300">{page.text || '(empty)'}</p>
            </li>
          {/each}
        </ul>
      {/if}
    </div>
  </div>
</UserPageLayout>
