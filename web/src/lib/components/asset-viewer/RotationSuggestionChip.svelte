<script lang="ts">
  import { editManager } from '#lib/managers/edit/edit-manager.svelte.ts';
  import {
    AssetTypeEnum,
    getRotationSuggestion,
    type AssetResponseDto,
    type RotationSuggestionResponseDto,
  } from '@immich/sdk';
  import { Button, Icon, IconButton } from '@immich/ui';
  import { mdiClose, mdiRotateLeft, mdiRotateRight } from '@mdi/js';
  import { onDestroy } from 'svelte';
  import { t } from 'svelte-i18n';

  interface Props {
    asset: AssetResponseDto;
    buttonBottom: number;
  }

  let { asset, buttonBottom }: Props = $props();

  let suggestion = $state<RotationSuggestionResponseDto | null>(null);
  let isBusy = $state(false);
  let requestId = 0;

  const fetchSuggestion = (assetId: string, currentRequest: number) => {
    void getRotationSuggestion({ id: assetId })
      .then((value) => {
        if (currentRequest === requestId) {
          suggestion = value;
        }
      })
      .catch(() => {
        // Missing or inaccessible suggestion metadata should not disrupt the viewer.
        if (currentRequest === requestId) {
          suggestion = null;
        }
      });
  };

  $effect(() => {
    const assetId = asset.id;
    const currentRequest = ++requestId;
    suggestion = null;

    if (asset.type !== AssetTypeEnum.Image) {
      return;
    }

    fetchSuggestion(assetId, currentRequest);
  });

  onDestroy(() => {
    requestId += 1;
  });

  // Only actionable suggestions surface here: a confident, non-abstaining run
  // proposing an actual rotation, still pending (the server reconciles the
  // status against the asset's current edit list on every read).
  const isActionable = $derived(
    suggestion !== null &&
      suggestion.status === 'pending' &&
      !suggestion.abstain &&
      suggestion.predictedRotation !== null &&
      suggestion.predictedRotation > 0,
  );

  const confidencePercent = $derived(Math.round((suggestion?.confidence ?? 0) * 100));

  // Match the editor's rotation-symbol convention (TransformTool): 90° CW shows
  // the clockwise icon, 270° CW (= one counter-clockwise quarter turn) shows the
  // counter-clockwise icon.
  const rotationIcon = $derived(suggestion?.predictedRotation === 270 ? mdiRotateLeft : mdiRotateRight);

  const handleApply = async () => {
    if (!suggestion || isBusy) {
      return;
    }

    isBusy = true;
    try {
      await editManager.applySuggestedRotation(asset.id);
      fetchSuggestion(asset.id, ++requestId);
    } finally {
      isBusy = false;
    }
  };

  const handleDismiss = async () => {
    if (!suggestion || isBusy) {
      return;
    }

    isBusy = true;
    try {
      const dismissed = await editManager.dismissRotationSuggestion(asset.id);
      if (dismissed) {
        suggestion = null;
      }
    } finally {
      isBusy = false;
    }
  };
</script>

{#if isActionable && suggestion}
  <div class="pointer-events-none absolute inset-0">
    <div
      class="pointer-events-auto absolute inset-e-0 me-6 flex items-center gap-2 rounded-2xl border border-white/20 bg-black/70 px-3 py-2 text-white shadow-lg backdrop-blur"
      style="bottom: {buttonBottom}px;"
      data-testid="rotation-suggestion-chip"
    >
      <span
        class="flex items-center gap-2 text-sm"
        title={$t('rotation_suggestion_title', { values: { angle: suggestion.predictedRotation, confidence: confidencePercent } })}
      >
        <Icon icon={rotationIcon} size="18" />
        <span>{suggestion.predictedRotation}°</span>
      </span>
      <Button size="small" onclick={handleApply} disabled={isBusy || editManager.isApplyingEdits}>
        {$t('rotation_suggestion_apply')}
      </Button>
      <IconButton
        title={$t('rotation_suggestion_dismiss')}
        icon={mdiClose}
        size="small"
        variant="ghost"
        aria-label={$t('rotation_suggestion_dismiss')}
        onclick={handleDismiss}
        disabled={isBusy}
      />
    </div>
  </div>
{/if}
