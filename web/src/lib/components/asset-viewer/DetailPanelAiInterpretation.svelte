<script lang="ts">
  import { getAssetMetadataByKey, type AssetMetadataResponseDto, type AssetResponseDto } from '@immich/sdk';
  import { Icon } from '@immich/ui';
  import { mdiChevronDown, mdiChevronUp } from '@mdi/js';
  import { DateTime } from 'luxon';
  import { onDestroy } from 'svelte';
  import { slide } from 'svelte/transition';
  import { t } from 'svelte-i18n';
  import { locale } from '$lib/stores/preferences.store';

  const AI_INTERPRETATION_KEY = 'ai-interpretation-v1';

  type JsonObject = Record<string, unknown>;

  type Confidence = 'high' | 'medium' | 'low';

  interface NotableDetail {
    detail: string;
    significance?: string;
    confidence: Confidence;
  }

  interface Identification {
    name: string;
    type?: string;
    confidence?: Confidence;
    basis?: string;
  }

  interface InterpretationResult {
    title?: string;
    archiveSummary?: string;
    interpretation?: string;
    literalDescription?: string;
    visualAnalysis?: string;
    contextAndSignificance?: string;
    uncertainties: string[];
    alternativeInterpretations: string[];
    searchKeywords: string[];
    notableDetails: NotableDetail[];
    identifications: Identification[];
  }

  interface InterpretationRun {
    runKey: string;
    status?: string;
    model?: string;
    quant?: string;
    promptVersion?: string;
    trigger?: string;
    requestedAt?: string;
    startedAt?: string;
    finishedAt?: string;
    attempts?: number;
    nextAttemptAt?: string;
    input?: { source?: string; width?: number; height?: number; mimeType?: string };
    metrics?: { durationMs?: number; promptTokens?: number; completionTokens?: number };
    error?: { code?: string; message?: string };
    result?: InterpretationResult;
  }

  interface TechRow {
    label: string;
    value: string;
  }

  interface Props {
    asset: AssetResponseDto;
  }

  let { asset }: Props = $props();
  let metadata = $state<AssetMetadataResponseDto | null>(null);
  let open = $state({
    uncertainties: false,
    alternatives: false,
    literal: false,
    visual: false,
    context: false,
    identifications: false,
    technical: false,
    raw: false,
  });
  let requestId = 0;

  $effect(() => {
    const assetId = asset.id;
    const currentRequest = ++requestId;
    metadata = null;
    open = {
      uncertainties: false,
      alternatives: false,
      literal: false,
      visual: false,
      context: false,
      identifications: false,
      technical: false,
      raw: false,
    };

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

  const isObject = (value: unknown): value is JsonObject => typeof value === 'object' && value !== null;

  const getString = (value: unknown): string | undefined =>
    typeof value === 'string' && value.trim() ? value : undefined;

  const getNumber = (value: unknown): number | undefined =>
    typeof value === 'number' && Number.isFinite(value) ? value : undefined;

  const getStringList = (value: unknown): string[] =>
    Array.isArray(value) ? value.filter((item): item is string => typeof item === 'string' && !!item.trim()) : [];

  const isConfidence = (value: unknown): value is Confidence =>
    typeof value === 'string' && ['high', 'medium', 'low'].includes(value);

  const confidenceLabels: Record<Confidence, string> = { high: 'HIGH', medium: 'MED', low: 'LOW' };
  const confidenceClasses: Record<Confidence, string> = {
    high: 'text-green-600 dark:text-green-400',
    medium: 'text-amber-600 dark:text-amber-400',
    low: 'text-red-600 dark:text-red-400',
  };

  const parseResult = (value: unknown): InterpretationResult | undefined => {
    if (!isObject(value)) {
      return undefined;
    }

    const notableDetails = Array.isArray(value.notable_details)
      ? value.notable_details.flatMap((item): NotableDetail[] => {
          if (!isObject(item)) {
            return [];
          }

          const detail = getString(item.detail);
          const confidence = item.confidence;
          if (!detail || !isConfidence(confidence)) {
            return [];
          }

          return [{ detail, significance: getString(item.significance), confidence }];
        })
      : [];

    const identifications = Array.isArray(value.identifications)
      ? value.identifications.flatMap((item): Identification[] => {
          if (!isObject(item)) {
            return [];
          }

          const name = getString(item.name);
          if (!name) {
            return [];
          }

          const confidence = item.confidence;
          return [
            {
              name,
              type: getString(item.type),
              confidence: isConfidence(confidence) ? confidence : undefined,
              basis: getString(item.basis),
            },
          ];
        })
      : [];

    return {
      title: getString(value.title),
      archiveSummary: getString(value.archive_summary),
      interpretation: getString(value.interpretation),
      literalDescription: getString(value.literal_description),
      visualAnalysis: getString(value.visual_analysis),
      contextAndSignificance: getString(value.context_and_significance),
      uncertainties: getStringList(value.uncertainties),
      alternativeInterpretations: getStringList(value.alternative_interpretations),
      searchKeywords: getStringList(value.search_keywords),
      notableDetails,
      identifications,
    };
  };

  const parseRun = (runKey: string, value: unknown): InterpretationRun | undefined => {
    if (!isObject(value)) {
      return undefined;
    }

    const input = isObject(value.input)
      ? {
          source: getString(value.input.source),
          width: getNumber(value.input.width),
          height: getNumber(value.input.height),
          mimeType: getString(value.input.mimeType),
        }
      : undefined;
    const metrics = isObject(value.metrics)
      ? {
          durationMs: getNumber(value.metrics.durationMs),
          promptTokens: getNumber(value.metrics.promptTokens),
          completionTokens: getNumber(value.metrics.completionTokens),
        }
      : undefined;
    const error = isObject(value.error)
      ? { code: getString(value.error.code), message: getString(value.error.message) }
      : undefined;

    return {
      runKey,
      status: getString(value.status),
      model: getString(value.model),
      quant: getString(value.quant),
      promptVersion: getString(value.promptVersion),
      trigger: getString(value.trigger),
      requestedAt: getString(value.requestedAt),
      startedAt: getString(value.startedAt),
      finishedAt: getString(value.finishedAt),
      attempts: getNumber(value.attempts),
      nextAttemptAt: getString(value.nextAttemptAt),
      input,
      metrics,
      error,
      result: parseResult(value.result),
    };
  };

  // The latest completed run wins; `finishedAt` is the primary sort, with
  // `requestedAt` (then runKey) as fallback — mirroring the server's own
  // run selection in ai-interpret-search.ts.
  const runTimestamp = (run: InterpretationRun, key: 'finishedAt' | 'requestedAt'): number => {
    const parsed = Date.parse(run[key] ?? '');
    return Number.isNaN(parsed) ? 0 : parsed;
  };

  const runs = $derived.by(() => {
    const value = metadata?.value;
    if (!isObject(value) || !isObject(value.runs)) {
      return [];
    }

    return Object.entries(value.runs).flatMap(([runKey, run]) => {
      const parsed = parseRun(runKey, run);
      return parsed ? [parsed] : [];
    });
  });

  const activeRun = $derived.by(() => {
    const completed = runs
      .filter((run) => run.status === 'completed' && run.result)
      .sort(
        (left, right) =>
          runTimestamp(right, 'finishedAt') - runTimestamp(left, 'finishedAt') ||
          runTimestamp(right, 'requestedAt') - runTimestamp(left, 'requestedAt') ||
          (left.runKey < right.runKey ? 1 : -1),
      );

    if (completed.length > 0) {
      return completed[0];
    }

    return [...runs].sort((left, right) => runTimestamp(right, 'requestedAt') - runTimestamp(left, 'requestedAt'))[0];
  });

  const result = $derived(activeRun?.status === 'completed' ? activeRun.result : undefined);

  const statusClass = $derived.by(() => {
    switch (activeRun?.status) {
      case 'failed': {
        return 'text-red-600 dark:text-red-400';
      }
      default: {
        return 'text-immich-fg-muted dark:text-immich-dark-fg-muted';
      }
    }
  });

  const statusLabel = $derived.by(() => {
    switch (activeRun?.status) {
      case 'queued': {
        return $t('queued');
      }
      case 'running': {
        return $t('running');
      }
      case 'completed': {
        return $t('completed');
      }
      case 'failed': {
        return $t('failed');
      }
      default: {
        return activeRun?.status;
      }
    }
  });

  const formatDuration = (ms: number): string => {
    const seconds = ms / 1000;
    if (seconds < 60) {
      return `${seconds.toFixed(seconds < 10 ? 1 : 0)}s`;
    }

    const minutes = Math.floor(seconds / 60);
    const rest = Math.round(seconds % 60);
    return rest > 0 ? `${minutes}m ${rest}s` : `${minutes}m`;
  };

  const formatTimestamp = (iso: string): string => {
    const parsed = DateTime.fromISO(iso);
    return parsed.isValid ? parsed.toLocaleString(DateTime.DATETIME_MED_WITH_SECONDS, { locale: $locale }) : iso;
  };

  const formatCount = (value: number): string => value.toLocaleString($locale);

  // "unsloth/Muse-Glimmer-30B-GGUF" -> "Muse-Glimmer-30B"
  const displayModelName = (model: string): string => model.replace(/^[^/]+\//, '').replace(/-GGUF$/i, '') || model;

  const inferenceLine = $derived.by(() => {
    const run = activeRun;
    if (!run) {
      return [];
    }

    const model = [run.model && displayModelName(run.model), run.quant].filter((part): part is string => !!part);
    const usage = [
      run.metrics?.durationMs === undefined ? undefined : formatDuration(run.metrics.durationMs),
      (() => {
        const prompt = run.metrics?.promptTokens;
        const completion = run.metrics?.completionTokens;
        if (prompt !== undefined && completion !== undefined) {
          return `${formatCount(prompt)} → ${formatCount(completion)} tokens`;
        }

        if (completion !== undefined) {
          return `${formatCount(completion)} tokens`;
        }

        return undefined;
      })(),
    ].filter((part): part is string => !!part);

    return [model.join(' · '), usage.join(' · ')].filter((line) => !!line);
  });

  const inputLine = $derived.by(() => {
    const input = activeRun?.input;
    if (!input) {
      return undefined;
    }

    const parts = [
      input.width !== undefined && input.height !== undefined ? `${input.width} × ${input.height}` : undefined,
      input.source,
      input.mimeType,
    ].filter((part): part is string => !!part);

    return parts.length > 0 ? parts.join(' · ') : undefined;
  });

  const techRows = $derived.by(() => {
    const run = activeRun;
    if (!run) {
      return [];
    }

    const rows: TechRow[] = [];
    if (run.model) {
      rows.push({ label: $t('ai_model'), value: run.model });
    }
    if (run.quant) {
      rows.push({ label: $t('quantization'), value: run.quant });
    }
    if (run.promptVersion) {
      rows.push({ label: $t('prompt_version'), value: run.promptVersion });
    }
    if (inputLine) {
      rows.push({ label: $t('input'), value: inputLine });
    }
    if (run.trigger) {
      rows.push({ label: $t('trigger'), value: run.trigger });
    }
    for (const [key, value] of [
      ['requested_at', run.requestedAt],
      ['started_at', run.startedAt],
      ['finished_at', run.finishedAt],
    ] as const) {
      if (value) {
        rows.push({ label: $t(key), value: formatTimestamp(value) });
      }
    }
    if (run.metrics?.promptTokens !== undefined) {
      rows.push({ label: $t('prompt_tokens'), value: formatCount(run.metrics.promptTokens) });
    }
    if (run.metrics?.completionTokens !== undefined) {
      rows.push({ label: $t('completion_tokens'), value: formatCount(run.metrics.completionTokens) });
    }
    if (run.metrics?.durationMs !== undefined) {
      rows.push({ label: $t('duration'), value: formatDuration(run.metrics.durationMs) });
    }
    if (run.attempts !== undefined) {
      rows.push({ label: $t('attempts'), value: String(run.attempts) });
    }
    if (run.nextAttemptAt) {
      rows.push({ label: $t('next_attempt_at'), value: formatTimestamp(run.nextAttemptAt) });
    }
    rows.push({ label: $t('run_id'), value: run.runKey });
    const schemaVersion = isObject(metadata?.value) ? getNumber(metadata.value.schemaVersion) : undefined;
    if (schemaVersion !== undefined) {
      rows.push({ label: $t('schema_version'), value: String(schemaVersion) });
    }

    return rows;
  });

  const formatMetadata = (value: JsonObject) => JSON.stringify(value, null, 2);

  const toggle = (key: keyof typeof open) => {
    open[key] = !open[key];
  };
</script>

{#snippet sectionHeader(id: string, label: string, expanded: boolean, onToggle: () => void)}
  <button
    type="button"
    class="flex w-full items-center justify-between gap-2 py-1.5 text-start"
    aria-expanded={expanded}
    aria-controls={id}
    onclick={onToggle}
  >
    <span class="text-immich-fg-muted dark:text-immich-dark-fg-muted text-sm">{label}</span>
    <Icon icon={expanded ? mdiChevronUp : mdiChevronDown} size="18" aria-hidden={true} />
  </button>
{/snippet}

{#if metadata && activeRun}
  <section class="mt-6 px-4" data-testid="ai-interpretation">
    <div class="flex items-baseline justify-between gap-2 pb-2">
      <p class="text-immich-fg-muted dark:text-immich-dark-fg-muted text-sm">{$t('ai_generated_interpretation')}</p>
      {#if statusLabel}
        <span class="shrink-0 text-xs {statusClass}" data-testid="ai-interpretation-status">{statusLabel}</span>
      {/if}
    </div>

    {#if activeRun.status === 'failed' && (activeRun.error?.code || activeRun.error?.message)}
      <p class="text-immich-fg-muted dark:text-immich-dark-fg-muted pb-2 text-xs wrap-break-word">
        {[activeRun.error?.code, activeRun.error?.message].filter((part): part is string => !!part).join(': ')}
      </p>
    {/if}

    {#if result}
      {#if result.title}
        <p class="pb-1 font-medium wrap-break-word" data-testid="ai-interpretation-title">{result.title}</p>
      {/if}

      {#if result.archiveSummary}
        <p class="pb-2 text-sm wrap-break-word">{result.archiveSummary}</p>
      {/if}

      {#if result.interpretation}
        <p class="pb-3 text-sm wrap-break-word whitespace-pre-line" data-testid="ai-interpretation-summary">
          {result.interpretation}
        </p>
      {/if}

      {#if result.notableDetails.length > 0}
        <p class="text-immich-fg-muted dark:text-immich-dark-fg-muted pb-1 text-sm">{$t('notable_details')}</p>
        <div class="flex flex-col gap-2 pb-3" data-testid="ai-interpretation-notable-details">
          {#each result.notableDetails as detail, index (index)}
            <div>
              <p class="text-sm wrap-break-word">
                <span
                  class="me-1.5 align-middle text-xs font-semibold tracking-wide {confidenceClasses[detail.confidence]}"
                  data-testid="ai-interpretation-confidence">{confidenceLabels[detail.confidence]}</span
                >{detail.detail}
              </p>
              {#if detail.significance}
                <p class="text-immich-fg-muted dark:text-immich-dark-fg-muted text-xs wrap-break-word">
                  {detail.significance}
                </p>
              {/if}
            </div>
          {/each}
        </div>
      {/if}

      {#if result.searchKeywords.length > 0}
        <p class="text-immich-fg-muted dark:text-immich-dark-fg-muted pb-1 text-sm">{$t('search_keywords')}</p>
        <p class="text-immich-fg-muted dark:text-immich-dark-fg-muted pb-3 text-sm wrap-break-word">
          {result.searchKeywords.join(' · ')}
        </p>
      {/if}
    {/if}

    {#if result && result.uncertainties.length > 0}
      {@render sectionHeader(
        'ai-interpretation-uncertainties',
        $t('uncertainties_with_count', { values: { count: result.uncertainties.length } }),
        open.uncertainties,
        () => toggle('uncertainties'),
      )}
      {#if open.uncertainties}
        <ul
          id="ai-interpretation-uncertainties"
          class="list-inside list-disc pb-2 text-sm"
          transition:slide={{ duration: 200 }}
        >
          {#each result.uncertainties as uncertainty, index (index)}
            <li class="wrap-break-word">{uncertainty}</li>
          {/each}
        </ul>
      {/if}
    {/if}

    {#if result && result.alternativeInterpretations.length > 0}
      {@render sectionHeader(
        'ai-interpretation-alternatives',
        $t('alternative_interpretations_with_count', {
          values: { count: result.alternativeInterpretations.length },
        }),
        open.alternatives,
        () => toggle('alternatives'),
      )}
      {#if open.alternatives}
        <ul
          id="ai-interpretation-alternatives"
          class="list-inside list-disc pb-2 text-sm"
          transition:slide={{ duration: 200 }}
        >
          {#each result.alternativeInterpretations as alternative, index (index)}
            <li class="wrap-break-word">{alternative}</li>
          {/each}
        </ul>
      {/if}
    {/if}

    {#if result?.literalDescription}
      {@render sectionHeader('ai-interpretation-literal', $t('literal_description'), open.literal, () =>
        toggle('literal'),
      )}
      {#if open.literal}
        <p
          id="ai-interpretation-literal"
          class="pb-2 text-sm wrap-break-word whitespace-pre-line"
          transition:slide={{ duration: 200 }}
        >
          {result.literalDescription}
        </p>
      {/if}
    {/if}

    {#if result?.visualAnalysis}
      {@render sectionHeader('ai-interpretation-visual', $t('visual_analysis'), open.visual, () => toggle('visual'))}
      {#if open.visual}
        <p
          id="ai-interpretation-visual"
          class="pb-2 text-sm wrap-break-word whitespace-pre-line"
          transition:slide={{ duration: 200 }}
        >
          {result.visualAnalysis}
        </p>
      {/if}
    {/if}

    {#if result?.contextAndSignificance}
      {@render sectionHeader('ai-interpretation-context', $t('context_and_significance'), open.context, () =>
        toggle('context'),
      )}
      {#if open.context}
        <p
          id="ai-interpretation-context"
          class="pb-2 text-sm wrap-break-word whitespace-pre-line"
          transition:slide={{ duration: 200 }}
        >
          {result.contextAndSignificance}
        </p>
      {/if}
    {/if}

    {#if result && result.identifications.length > 0}
      {@render sectionHeader(
        'ai-interpretation-identifications',
        $t('identifications_with_count', { values: { count: result.identifications.length } }),
        open.identifications,
        () => toggle('identifications'),
      )}
      {#if open.identifications}
        <div
          id="ai-interpretation-identifications"
          class="flex flex-col gap-2 pb-2"
          transition:slide={{ duration: 200 }}
        >
          {#each result.identifications as identification, index (index)}
            <div>
              <p class="text-sm wrap-break-word">{identification.name}</p>
              {#if identification.type || identification.confidence}
                <p class="text-immich-fg-muted dark:text-immich-dark-fg-muted text-xs">
                  {[identification.type, identification.confidence && confidenceLabels[identification.confidence]]
                    .filter((part): part is string => !!part)
                    .join(' · ')}
                </p>
              {/if}
              {#if identification.basis}
                <p class="text-immich-fg-muted dark:text-immich-dark-fg-muted text-xs wrap-break-word">
                  {identification.basis}
                </p>
              {/if}
            </div>
          {/each}
        </div>
      {/if}
    {/if}

    <div class="my-3 h-px w-full bg-light-200 dark:bg-dark-600"></div>

    {#if inferenceLine.length > 0}
      <div class="pb-1" data-testid="ai-interpretation-inference">
        {#each inferenceLine as line, index (index)}
          <p class="text-immich-fg-muted dark:text-immich-dark-fg-muted text-xs wrap-break-word">{line}</p>
        {/each}
      </div>
    {/if}

    {#if techRows.length > 0}
      {@render sectionHeader('ai-interpretation-technical', $t('technical_details'), open.technical, () =>
        toggle('technical'),
      )}
      {#if open.technical}
        <dl id="ai-interpretation-technical" class="pb-2 text-xs" transition:slide={{ duration: 200 }}>
          {#each techRows as row (row.label + row.value)}
            <div class="flex gap-2 py-0.5">
              <dt class="text-immich-fg-muted dark:text-immich-dark-fg-muted w-24 shrink-0">{row.label}</dt>
              <dd class="min-w-0 flex-1 wrap-break-word">{row.value}</dd>
            </div>
          {/each}
        </dl>
      {/if}
    {/if}

    {@render sectionHeader('ai-interpretation-raw', $t('raw_json'), open.raw, () => toggle('raw'))}
    {#if open.raw}
      <div id="ai-interpretation-raw" transition:slide={{ duration: 200 }}>
        <pre
          class="max-h-96 overflow-auto rounded-lg bg-gray-100 p-3 text-xs wrap-break-word whitespace-pre-wrap text-gray-800 dark:bg-gray-900 dark:text-gray-100">{formatMetadata(
            metadata.value,
          )}</pre>
      </div>
    {/if}
  </section>
{/if}
