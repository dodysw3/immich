<script lang="ts">
  interface DocumentInfo {
    originalFileName: string;
    title: string | null;
    author: string | null;
    pageCount: number;
    processedAt: string | null;
    status: 'pending' | 'processing' | 'ready' | 'failed';
    lastError: string | null;
  }

  interface Props {
    document: DocumentInfo;
  }

  let { document }: Props = $props();
</script>

<div class="space-y-2 rounded-2xl border border-gray-200 p-4 text-sm dark:border-gray-700">
  <h2 class="font-semibold">Document Info</h2>
  <p><span class="font-medium">File:</span> {document.originalFileName}</p>
  <p><span class="font-medium">Title:</span> {document.title || '-'}</p>
  <p><span class="font-medium">Author:</span> {document.author || '-'}</p>
  <p><span class="font-medium">Pages:</span> {document.pageCount}</p>
  <p><span class="font-medium">Status:</span> {document.status}</p>
  <p><span class="font-medium">Processed:</span> {document.processedAt || 'pending'}</p>
  {#if document.lastError}
    <p class="text-red-600 dark:text-red-400"><span class="font-medium">Last error:</span> {document.lastError}</p>
  {/if}
</div>
