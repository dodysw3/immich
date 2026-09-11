<script lang="ts">
  import { getAssetMetadataByKey, type AssetMetadataResponseDto, type AssetResponseDto } from '@immich/sdk';
  import { onDestroy } from 'svelte';
  import { t } from 'svelte-i18n';

  const AI_INTERPRETATION_KEY = 'ai-interpretation-v1';

  interface Props {
    asset: AssetResponseDto;
  }

  let { asset }: Props = $props();
  let metadata = $state<AssetMetadataResponseDto | null>(null);
  let requestId = 0;

  $effect(() => {
    const assetId = asset.id;
    const currentRequest = ++requestId;
    metadata = null;

    void getAssetMetadataByKey({ id: assetId, key: AI_INTERPRETATION_KEY })
      .then((value) => {
        if (currentRequest === requestId) {
          metadata = value;
        }
      })
      .catch(() => {
        // A missing or inaccessible interpretation should not disrupt the Info panel.
      });
  });

  onDestroy(() => {
    requestId += 1;
  });

  const formatMetadata = (value: Record<string, unknown>) => JSON.stringify(value, null, 2);
</script>

{#if metadata}
  <section class="mt-6 px-4" data-testid="ai-interpretation">
    <p class="text-immich-fg-muted dark:text-immich-dark-fg-muted pb-3 text-sm">
      {$t('ai_generated_interpretation')}
    </p>
    <pre
      class="max-h-96 overflow-auto rounded-lg bg-gray-100 p-3 text-xs wrap-break-word whitespace-pre-wrap text-gray-800 dark:bg-gray-900 dark:text-gray-100">{formatMetadata(
        metadata.value,
      )}</pre>
  </section>
{/if}
