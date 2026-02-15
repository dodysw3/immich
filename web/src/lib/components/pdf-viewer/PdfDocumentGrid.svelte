<script lang="ts">
  import Dropdown from '$lib/elements/Dropdown.svelte';
  import { Route } from '$lib/route';
  import {
    PdfDocumentSortBy,
    SortOrder,
    pdfDocumentSortSettings,
  } from '$lib/stores/preferences.store';
  import { mdiArrowDownThin, mdiArrowUpThin } from '@mdi/js';

  interface DocumentItem {
    assetId: string;
    originalFileName: string;
    title: string | null;
    pageCount: number;
    createdAt?: string | null;
    updatedAt?: string | null;
    status?: 'pending' | 'processing' | 'ready' | 'failed';
    lastError?: string | null;
    matchingPages?: number[];
  }

  interface SortOption {
    sortBy: PdfDocumentSortBy;
    sortOrder: SortOrder;
    label: string;
  }

  const SORT_OPTIONS: SortOption[] = [
    {
      sortBy: PdfDocumentSortBy.FileModifiedAt,
      sortOrder: SortOrder.Desc,
      label: 'Date File Updated (Newest First)',
    },
    {
      sortBy: PdfDocumentSortBy.FileModifiedAt,
      sortOrder: SortOrder.Asc,
      label: 'Date File Updated (Oldest First)',
    },
    {
      sortBy: PdfDocumentSortBy.FileCreatedAt,
      sortOrder: SortOrder.Desc,
      label: 'Date File Created (Newest First)',
    },
    {
      sortBy: PdfDocumentSortBy.FileCreatedAt,
      sortOrder: SortOrder.Asc,
      label: 'Date File Created (Oldest First)',
    },
    {
      sortBy: PdfDocumentSortBy.Name,
      sortOrder: SortOrder.Asc,
      label: 'Document Name (A to Z)',
    },
    {
      sortBy: PdfDocumentSortBy.Name,
      sortOrder: SortOrder.Desc,
      label: 'Document Name (Z to A)',
    },
  ];

  interface Props {
    items: DocumentItem[];
  }

  let { items }: Props = $props();
  let failedThumbnails = $state(new Set<string>());

  const timestamp = (value?: string | null) => {
    if (!value) {
      return 0;
    }

    const date = new Date(value);
    return Number.isNaN(date.getTime()) ? 0 : date.getTime();
  };

  const formatFileDate = (value?: string | null) => {
    if (!value) {
      return null;
    }

    const date = new Date(value);
    if (Number.isNaN(date.getTime())) {
      return null;
    }

    return date.toLocaleString(undefined, {
      year: 'numeric',
      month: 'short',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      hour12: false,
    });
  };

  const formatPageCount = (count: number) => `${count} ${count === 1 ? 'page' : 'pages'}`;

  const compareByName = (a: DocumentItem, b: DocumentItem) =>
    (a.title || a.originalFileName).localeCompare(b.title || b.originalFileName, undefined, { sensitivity: 'base' });

  const compareDocuments = (a: DocumentItem, b: DocumentItem) => {
    const direction = $pdfDocumentSortSettings.sortOrder === SortOrder.Desc ? -1 : 1;

    if ($pdfDocumentSortSettings.sortBy === PdfDocumentSortBy.Name) {
      const compare = compareByName(a, b);
      return compare === 0 ? a.assetId.localeCompare(b.assetId) : compare * direction;
    }

    const left =
      $pdfDocumentSortSettings.sortBy === PdfDocumentSortBy.FileModifiedAt
        ? timestamp(a.updatedAt ?? a.createdAt)
        : timestamp(a.createdAt);
    const right =
      $pdfDocumentSortSettings.sortBy === PdfDocumentSortBy.FileModifiedAt
        ? timestamp(b.updatedAt ?? b.createdAt)
        : timestamp(b.createdAt);

    if (left !== right) {
      return (left - right) * direction;
    }

    const compare = compareByName(a, b);
    return compare === 0 ? a.assetId.localeCompare(b.assetId) : compare * direction;
  };

  const handleSelectSort = (option: SortOption) => {
    $pdfDocumentSortSettings = {
      sortBy: option.sortBy,
      sortOrder: option.sortOrder,
    };
  };

  let selectedSortOption = $derived(
    SORT_OPTIONS.find(
      (option) =>
        option.sortBy === $pdfDocumentSortSettings.sortBy && option.sortOrder === $pdfDocumentSortSettings.sortOrder,
    ) || SORT_OPTIONS[0],
  );
  let sortIcon = $derived($pdfDocumentSortSettings.sortOrder === SortOrder.Desc ? mdiArrowDownThin : mdiArrowUpThin);
  let sortedItems = $derived(items.slice().sort(compareDocuments));
</script>

{#if sortedItems.length === 0}
  <p class="text-sm text-gray-500 dark:text-gray-300">No PDF documents found yet.</p>
{:else}
  <div class="mb-3 flex justify-end">
    <Dropdown
      title="Sort documents by"
      options={SORT_OPTIONS}
      selectedOption={selectedSortOption}
      onSelect={handleSelectSort}
      render={(option) => ({
        title: option.label,
        icon: sortIcon,
      })}
    />
  </div>
  <div class="grid grid-cols-[repeat(auto-fill,minmax(220px,350px))] justify-center gap-4 md:justify-start">
    {#each sortedItems as item (item.assetId)}
      {@const createdAt = formatFileDate(item.createdAt)}
      <a
        class="flex w-full max-w-[350px] flex-col rounded-xl border border-gray-200 p-3 transition hover:border-primary-400 hover:bg-gray-50 dark:border-gray-700 dark:hover:bg-gray-900"
        href={Route.viewDocument({ id: item.assetId })}
      >
        <div class="mb-2 overflow-hidden rounded-lg border border-gray-200 bg-gray-100 dark:border-gray-700 dark:bg-gray-900">
          {#if failedThumbnails.has(item.assetId)}
            <div class="flex h-36 w-full items-center justify-center bg-gray-100 text-sm font-semibold text-gray-500 dark:bg-gray-900 dark:text-gray-400">
              PDF
            </div>
          {:else}
            <img
              class="h-36 w-full object-cover"
              src={`/api/assets/${item.assetId}/thumbnail?size=preview`}
              alt={item.title || item.originalFileName}
              loading="lazy"
              onerror={() => {
                const next = new Set(failedThumbnails);
                next.add(item.assetId);
                failedThumbnails = next;
              }}
            />
          {/if}
        </div>
        <p class="line-clamp-2 text-sm font-semibold leading-5 text-gray-900 dark:text-gray-100" title={item.title || item.originalFileName}>
          {item.title || item.originalFileName}
        </p>
        <p class="mt-1 flex items-center gap-1.5 text-xs text-gray-500 dark:text-gray-400">
          {#if createdAt}
            <span class="truncate">{createdAt}</span>
            <span aria-hidden="true" class="h-1 w-1 rounded-full bg-gray-400/80 dark:bg-gray-500"></span>
          {/if}
          <span>{formatPageCount(item.pageCount)}</span>
        </p>
        {#if item.status}
          <p
            class={`mt-1 inline-block rounded px-2 py-0.5 text-[11px] ${
              item.status === 'ready'
                ? 'bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-300'
                : item.status === 'failed'
                  ? 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-300'
                  : 'bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-300'
            }`}
          >
            {item.status}
          </p>
        {/if}
        {#if item.matchingPages && item.matchingPages.length > 0}
          <p class="mt-1 text-xs text-primary-700 dark:text-primary-300">
            {item.matchingPages.length} matching page(s)
          </p>
        {/if}
        {#if item.lastError}
          <p class="mt-1 line-clamp-2 text-xs text-red-600 dark:text-red-400">{item.lastError}</p>
        {/if}
      </a>
    {/each}
  </div>
{/if}
