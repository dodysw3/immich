<script lang="ts">
  interface PdfInfo {
    assetId: string;
    pageCount: number;
    title: string | null;
    author: string | null;
    subject: string | null;
    creator: string | null;
    producer: string | null;
    creationDate: string | null;
    processedAt: string | null;
  }

  interface Props {
    info: PdfInfo;
  }

  let { info }: Props = $props();

  function formatDate(dateStr: string | null): string {
    if (!dateStr) return '';
    try {
      return new Date(dateStr).toLocaleDateString(undefined, {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
      });
    } catch {
      return dateStr;
    }
  }

  const fields = $derived(
    [
      { label: 'Title', value: info.title },
      { label: 'Author', value: info.author },
      { label: 'Subject', value: info.subject },
      { label: 'Creator', value: info.creator },
      { label: 'Producer', value: info.producer },
      { label: 'Pages', value: String(info.pageCount) },
      { label: 'Created', value: formatDate(info.creationDate) },
      { label: 'Processed', value: formatDate(info.processedAt) },
    ].filter((f) => f.value),
  );
</script>

<div class="flex flex-col gap-3">
  <h3 class="text-sm font-semibold text-gray-900 dark:text-white">Document Info</h3>

  {#each fields as field}
    <div>
      <div class="text-xs font-medium text-gray-500 dark:text-gray-400">{field.label}</div>
      <div class="text-sm text-gray-900 dark:text-white">{field.value}</div>
    </div>
  {/each}
</div>
