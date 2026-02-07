<script lang="ts">
  import UserPageLayout from '$lib/components/layouts/user-page-layout.svelte';
  import PdfDocumentGrid from '$lib/components/pdf-viewer/PdfDocumentGrid.svelte';
  import type { PageData } from './$types';

  interface Props {
    data: PageData;
  }

  let { data }: Props = $props();
</script>

<UserPageLayout title={data.meta.title}>
  <PdfDocumentGrid />
</UserPageLayout>
