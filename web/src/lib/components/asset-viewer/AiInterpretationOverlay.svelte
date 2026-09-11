<script lang="ts">
  import { browser } from '$app/environment';
  import { assetViewerManager } from '$lib/managers/asset-viewer-manager.svelte';
  import { AssetTypeEnum, getAssetMetadataByKey, type AssetResponseDto } from '@immich/sdk';
  import { IconButton, Tooltip } from '@immich/ui';
  import { mdiBrain } from '@mdi/js';
  import { onDestroy } from 'svelte';
  import { t } from 'svelte-i18n';

  const AI_INTERPRETATION_KEY = 'ai-interpretation-v1';
  const SESSION_STORAGE_KEY = 'immich-ai-interpretation-overlay-enabled';
  const TEXT_SHADOW = 'text-shadow: 0 2px 4px rgb(0 0 0 / 0.95), 0 0 8px rgb(0 0 0 / 0.8);';

  type JsonObject = Record<string, unknown>;

  interface InterpretationRun extends JsonObject {
    requestedAt?: unknown;
    status?: unknown;
    result?: unknown;
  }

  type Confidence = 'high' | 'medium' | 'low';

  interface NotableDetail {
    index: number;
    detail: string;
    significance?: string;
    confidence: Confidence;
  }

  interface Props {
    asset: AssetResponseDto;
    buttonBottom: number;
  }

  let { asset, buttonBottom }: Props = $props();
  let metadata = $state<JsonObject | null>(null);
  let showOverlay = $state(
    browser &&
      (() => {
        try {
          return sessionStorage.getItem(SESSION_STORAGE_KEY) === 'true';
        } catch {
          return false;
        }
      })(),
  );
  let requestId = 0;

  const setShowOverlay = (value: boolean) => {
    showOverlay = value;
    if (!browser) {
      return;
    }

    try {
      sessionStorage.setItem(SESSION_STORAGE_KEY, String(value));
    } catch {
      // A blocked session storage should not prevent the viewer from working.
    }
  };

  const isObject = (value: unknown): value is JsonObject => typeof value === 'object' && value !== null;

  const getRunTimestamp = (run: InterpretationRun) => {
    if (typeof run.requestedAt !== 'string') {
      return 0;
    }

    const timestamp = Date.parse(run.requestedAt);
    return Number.isNaN(timestamp) ? 0 : timestamp;
  };

  const getLatestRun = (value: JsonObject | null): InterpretationRun | undefined => {
    if (!value || !isObject(value.runs)) {
      return undefined;
    }

    const runs = Object.values(value.runs).filter(isObject) as InterpretationRun[];
    return runs.sort((left, right) => getRunTimestamp(right) - getRunTimestamp(left))[0];
  };

  $effect(() => {
    const assetId = asset.id;
    const isImage = asset.type === AssetTypeEnum.Image;
    const currentRequest = ++requestId;
    metadata = null;

    if (!isImage) {
      return;
    }

    void getAssetMetadataByKey({ id: assetId, key: AI_INTERPRETATION_KEY })
      .then((value) => {
        if (currentRequest === requestId) {
          metadata = value.value;
        }
      })
      .catch(() => {
        // Missing or inaccessible interpretation metadata should not disrupt the viewer.
      });
  });

  onDestroy(() => {
    requestId += 1;
  });

  const latestRun = $derived(getLatestRun(metadata));
  const latestResult = $derived(
    latestRun?.status === 'completed' && isObject(latestRun.result) ? latestRun.result : undefined,
  );
  const title = $derived.by(() => {
    const value = latestResult?.title;
    return typeof value === 'string' && value.trim() ? value : undefined;
  });
  const archiveSummary = $derived.by(() => {
    const value = latestResult?.archive_summary;
    return typeof value === 'string' && value.trim() ? value : undefined;
  });
  const interpretation = $derived.by(() => {
    const value = latestResult?.interpretation;
    return typeof value === 'string' && value.trim() ? value : undefined;
  });
  const summary = $derived.by(() => {
    const parts = [interpretation && `[I] ${interpretation}`, archiveSummary && `[S] ${archiveSummary}`].filter(
      (part): part is string => !!part,
    );
    return parts.length > 0 ? parts.join(' // ') : undefined;
  });
  const confidenceRank: Record<Confidence, number> = { high: 3, medium: 2, low: 1 };
  const notableDetailClasses: Record<Confidence, string> = {
    high: 'bg-green-600/90 text-white',
    medium: 'bg-amber-500/90 text-black',
    low: 'bg-red-600/90 text-white',
  };
  const isConfidence = (value: unknown): value is Confidence =>
    typeof value === 'string' && ['high', 'medium', 'low'].includes(value);
  const notableDetails = $derived.by(() => {
    const values = latestResult?.notable_details;
    if (!Array.isArray(values)) {
      return [];
    }

    return values
      .map((value, index): NotableDetail | undefined => {
        if (
          !isObject(value) ||
          typeof value.detail !== 'string' ||
          !value.detail.trim() ||
          !isConfidence(value.confidence)
        ) {
          return undefined;
        }

        return {
          index,
          detail: value.detail,
          significance:
            typeof value.significance === 'string' && value.significance.trim() ? value.significance : undefined,
          confidence: value.confidence,
        };
      })
      .filter((value): value is NotableDetail => !!value)
      .sort(
        (left, right) => confidenceRank[right.confidence] - confidenceRank[left.confidence] || left.index - right.index,
      );
  });
  const hasOverlayContent = $derived(!!title || !!summary || notableDetails.length > 0);
  const panelInset = $derived(
    assetViewerManager.isShowActivityPanel ? '30rem' : assetViewerManager.isShowDetailPanel ? '24rem' : '5rem',
  );
</script>

{#if metadata}
  <div class="pointer-events-none absolute inset-0">
    <div class="pointer-events-auto absolute inset-e-0 me-6" style="bottom: {buttonBottom}px;">
      <IconButton
        title={showOverlay ? $t('hide_ai_interpretation') : $t('show_ai_interpretation')}
        icon={mdiBrain}
        class={showOverlay ? 'dark bg-immich-primary text-white' : 'dark'}
        color="secondary"
        variant="ghost"
        shape="round"
        aria-label={$t('ai_interpretation')}
        aria-pressed={showOverlay}
        onclick={() => setShowOverlay(!showOverlay)}
      />
    </div>
  </div>
{/if}

{#if metadata && showOverlay && hasOverlayContent}
  <div class="pointer-events-none fixed inset-0 z-20" data-testid="ai-interpretation-overlay">
    {#if title}
      <div
        class="absolute max-h-[20vh] overflow-y-auto text-left text-xl/tight font-bold wrap-break-word text-white"
        style="inset-inline-start: 1.5rem; inset-inline-end: {panelInset}; top: 5.5rem; {TEXT_SHADOW}"
        data-testid="ai-interpretation-title"
      >
        {title}
      </div>
    {/if}

    {#if notableDetails.length > 0 || summary}
      <div
        class="absolute max-h-[40vh] overflow-y-auto text-left wrap-break-word"
        style="inset-inline-start: 1.5rem; inset-inline-end: {panelInset}; bottom: 5rem;"
        data-testid="ai-interpretation-bottom"
      >
        {#if notableDetails.length > 0}
          <div class="mb-2 flex flex-col items-start gap-1" data-testid="ai-interpretation-notable-details">
            {#each notableDetails as notableDetail (notableDetail.index)}
              {#if notableDetail.significance}
                <Tooltip text={notableDetail.significance}>
                  {#snippet child({ props })}
                    <span
                      {...props}
                      class="pointer-events-auto inline-block max-w-full rounded-full px-3 py-1 text-sm wrap-break-word shadow-md {notableDetailClasses[
                        notableDetail.confidence
                      ]}"
                      data-testid="ai-interpretation-notable-detail"
                    >
                      {notableDetail.detail}
                    </span>
                  {/snippet}
                </Tooltip>
              {:else}
                <span
                  class="pointer-events-auto inline-block max-w-full rounded-full px-3 py-1 text-sm wrap-break-word shadow-md {notableDetailClasses[
                    notableDetail.confidence
                  ]}"
                  data-testid="ai-interpretation-notable-detail"
                >
                  {notableDetail.detail}
                </span>
              {/if}
            {/each}
          </div>
        {/if}

        {#if summary}
          <div
            class="text-left text-sm/snug wrap-break-word text-white"
            style={TEXT_SHADOW}
            data-testid="ai-interpretation-summary"
          >
            {summary}
          </div>
        {/if}
      </div>
    {/if}
  </div>
{/if}
