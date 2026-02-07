<script lang="ts">
  import UserPageLayout from '$lib/components/layouts/user-page-layout.svelte';
  import PdfViewer from '$lib/components/pdf-viewer/PdfViewer.svelte';
  import type { PageData } from './$types';

  interface Props {
    data: PageData;
  }

  let { data }: Props = $props();
</script>

<UserPageLayout title={data.meta.title}>
  <PdfViewer assetId={data.assetId} />
</UserPageLayout>
