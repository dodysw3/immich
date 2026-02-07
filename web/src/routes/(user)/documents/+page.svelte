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

  const handleSearch = (value: string) => {
    const params = value ? `?query=${encodeURIComponent(value)}` : '';
    void goto(`${Route.documents()}${params}`);
  };
</script>

<UserPageLayout title="Documents" description={`(${data.items.length})`}>
  <div class="mb-4">
    <PdfSearchBar {query} onSearch={handleSearch} />
  </div>
  <PdfDocumentGrid items={data.items} />
</UserPageLayout>
