<script lang="ts">
  interface Props {
    assetId: string;
  }

  let { assetId }: Props = $props();
</script>

<div class="overflow-hidden rounded-2xl border border-gray-200 dark:border-gray-700">
  <iframe src={`/api/assets/${assetId}/original`} title="PDF Viewer" class="h-[72vh] w-full" loading="lazy" />
</div>
