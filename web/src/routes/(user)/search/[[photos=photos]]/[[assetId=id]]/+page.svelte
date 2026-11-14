<script lang="ts">
  import ActionMenuItem from '#lib/components/ActionMenuItem.svelte';
  import OnEvents from '#lib/components/OnEvents.svelte';
  import ControlAppBar from '#lib/components/shared-components/ControlAppBar.svelte';
  import ButtonContextMenu from '#lib/components/shared-components/context-menu/ButtonContextMenu.svelte';
  import GalleryViewer from '#lib/components/shared-components/gallery-viewer/GalleryViewer.svelte';
  import SearchBar from '#lib/components/shared-components/search-bar/SearchBar.svelte';
  import AssetSelectControlBar from '#lib/components/timeline/AssetSelectControlBar.svelte';
  import ChangeDate from '#lib/components/timeline/actions/ChangeDateAction.svelte';
  import ChangeDescription from '#lib/components/timeline/actions/ChangeDescriptionAction.svelte';
  import ChangeLocation from '#lib/components/timeline/actions/ChangeLocationAction.svelte';
  import DeleteAssets from '#lib/components/timeline/actions/DeleteAssetsAction.svelte';
  import DownloadAction from '#lib/components/timeline/actions/DownloadAction.svelte';
  import FavoriteAction from '#lib/components/timeline/actions/FavoriteAction.svelte';
  import SetVisibilityAction from '#lib/components/timeline/actions/SetVisibilityAction.svelte';
  import { QueryParameter } from '#lib/constants.ts';
  import { assetMultiSelectManager } from '#lib/managers/asset-multi-select-manager.svelte.ts';
  import { searchManager } from '#lib/managers/search-manager.svelte.ts';
  import type { TimelineAsset, Viewport } from '#lib/managers/timeline-manager/types.ts';
  import { TranscriptionPresentationManager } from '#lib/managers/transcription-presentation-manager.svelte.ts';
  import { createPreloadedQuery } from '#lib/queries/client.ts';
  import { getUserConfigQuery } from '#lib/queries/config-user.query.ts';
  import { Route } from '#lib/route.ts';
  import { getAssetBulkActions } from '#lib/services/asset.service.ts';
  import { lang, locale } from '#lib/stores/preferences.store.ts';
  import { handlePromiseError } from '#lib/utils.ts';
  import { parseUtcDate } from '#lib/utils/date-time.ts';
  import { handleError } from '#lib/utils/handle-error.ts';
  import { isAlbumsRoute, isPeopleRoute, navigate } from '#lib/utils/navigation.ts';
  import { toTimelineAsset } from '#lib/utils/timeline-util.ts';
  import {
    AssetVisibility,
    getPerson,
    getTagById,
    searchAiInterpret,
    searchAssets,
    searchMoments,
    searchSmart,
    searchTranscription,
    type AlbumResponseDto,
    type AssetResponseDto,
    type MetadataSearchDto,
    type SmartSearchDto,
    type TranscriptionCoverageDto,
    type TranscriptionMatchDto,
  } from '@immich/sdk';
  import { ActionButton, CommandPaletteDefaultProvider, Icon, IconButton, LoadingSpinner } from '@immich/ui';
  import { mdiArrowLeft, mdiClose, mdiDotsVertical, mdiImageOffOutline, mdiSelectAll } from '@mdi/js';
  import { onMount, tick, untrack } from 'svelte';
  import { t } from 'svelte-i18n';
  import { afterNavigate, goto } from '$app/navigation';
  import { page } from '$app/state';

  const query = createPreloadedQuery(getUserConfigQuery);
  const config = $derived(query.data);

  const viewport: Viewport = $state({ width: 0, height: 0 });
  let searchResultsElement: HTMLElement | undefined = $state();

  // The GalleryViewer pushes it's own history state, which causes weird
  // behavior for history.back(). To prevent that we store the previous page
  // manually and navigate back to that.
  let previousRoute = $state<string>(Route.explore());

  let nextPage = $state(1);
  let searchResultAlbums: AlbumResponseDto[] = $state([]);
  let searchResultAssets: AssetResponseDto[] = $state([]);
  let isLoading = $state(true);
  let scrollY = $state(0);
  let scrollYHistory = 0;

  // Transcription search keeps its match presentation keyed by asset id next to
  // the asset-only gallery list, so cards can show frames/snippets and the
  // viewer can seek to the selected moment without mutating AssetResponseDto.
  const transcriptionPresentation = new TranscriptionPresentationManager();
  let nextTranscriptionCursor = $state<string | null>(null);
  let transcriptionCoverage = $state<TranscriptionCoverageDto | undefined>(undefined);

  type SearchTerms = MetadataSearchDto &
    Pick<SmartSearchDto, 'query' | 'queryAssetId'> & { ai?: string; transcription?: string };
  let searchQuery = $derived(page.url.searchParams.get(QueryParameter.QUERY));
  let terms = $derived<SearchTerms>(searchQuery ? JSON.parse(searchQuery) : {});
  let searchTermKeys = $derived(getObjectKeys(terms));

  $effect(() => {
    // we want this to *only* be reactive on `terms`
    // eslint-disable-next-line @typescript-eslint/no-unused-expressions
    terms;
    untrack(() => handlePromiseError(onSearchQueryUpdate()));
  });

  $effect(() => {
    if (scrollY) {
      scrollYHistory = scrollY;
    }
  });

  afterNavigate(({ from, shallow, type }) => {
    if (shallow && type === 'goto') return;

    // Prevent setting previousRoute to the current page.
    if (from?.url && from.route.id !== page.route.id) {
      previousRoute = from.url.href;
    }
    const route = from?.route?.id;

    if (isPeopleRoute(route)) {
      previousRoute = Route.photos();
    }

    if (isAlbumsRoute(route)) {
      previousRoute = Route.explore();
    }

    tick()
      .then(() => {
        window.scrollTo(0, scrollYHistory);
      })
      .catch(() => {
        // do nothing
      });
  });

  const onAssetDelete = (assetIds: string[]) => {
    const assetIdSet = new Set(assetIds);
    searchResultAssets = searchResultAssets.filter((asset: AssetResponseDto) => !assetIdSet.has(asset.id));
    transcriptionPresentation.removeAssets(assetIdSet);
  };

  const handleSetVisibility = (assetIds: string[]) => {
    assetMultiSelectManager.clear();
    onAssetDelete(assetIds);
  };

  const handleSelectAll = () => {
    assetMultiSelectManager.selectAssets(searchResultAssets.map((asset) => toTimelineAsset(asset)));
  };

  async function onSearchQueryUpdate() {
    nextPage = 1;
    searchResultAssets = [];
    searchResultAlbums = [];
    transcriptionPresentation.clear();
    nextTranscriptionCursor = null;
    transcriptionCoverage = undefined;
    await loadNextPage(true);
  }

  // eslint-disable-next-line svelte/valid-prop-names-in-kit-pages
  export const loadNextPage = async (force?: boolean) => {
    if (!nextPage || (isLoading && !force)) {
      return;
    }
    isLoading = true;

    const searchDto: SearchTerms = {
      page: nextPage,
      withExif: true,
      ...terms,
    };

    try {
      const { albums, assets } = await (async () => {
        if (searchDto.transcription && !('query' in searchDto || 'queryAssetId' in searchDto)) {
          // Transcription search has a dedicated endpoint; one result per video
          // with its match presentation kept in a side map, not on the asset.
          const response = await searchTranscription({
            transcriptionSearchDto: {
              q: searchDto.transcription,
              visibility: searchDto.visibility,
              withStacked: searchDto.withStacked,
              isFavorite: searchDto.isFavorite,
              rating: searchDto.rating,
              city: searchDto.city,
              state: searchDto.state,
              country: searchDto.country,
              make: searchDto.make,
              model: searchDto.model,
              lensModel: searchDto.lensModel,
              personIds: searchDto.personIds,
              tagIds: searchDto.tagIds,
              isNotInAlbum: searchDto.isNotInAlbum,
              takenAfter: searchDto.takenAfter,
              takenBefore: searchDto.takenBefore,
              // endpoint cap is 50 (Zod max) — larger pages 400
              size: 50,
              cursor: nextTranscriptionCursor ?? undefined,
              explain: !nextTranscriptionCursor,
            },
          });
          transcriptionPresentation.loadPage(response.items);
          if (response.coverage) {
            transcriptionCoverage = response.coverage;
          }
          nextTranscriptionCursor = response.nextCursor;
          return {
            albums: { items: [] as AlbumResponseDto[] },
            assets: {
              ...response,
              items: response.items.map((item) => item.asset),
              nextPage: response.nextCursor ? 1 : 0,
            },
          };
        }
        if (searchDto.ai && !('query' in searchDto || 'queryAssetId' in searchDto)) {
          // AI interpretation search has a dedicated endpoint and result shape
          const response = await searchAiInterpret({
            aiInterpretSearchDto: {
              visibility: searchDto.visibility,
              q: searchDto.ai,
              withStacked: searchDto.withStacked,
              type: searchDto.type,
              isFavorite: searchDto.isFavorite,
              rating: searchDto.rating,
              city: searchDto.city,
              state: searchDto.state,
              country: searchDto.country,
              make: searchDto.make,
              model: searchDto.model,
              lensModel: searchDto.lensModel,
              personIds: searchDto.personIds,
              tagIds: searchDto.tagIds,
              isNotInAlbum: searchDto.isNotInAlbum,
              hasAiInterpretation: searchDto.hasAiInterpretation,
              takenAfter: searchDto.takenAfter,
              takenBefore: searchDto.takenBefore,
              size: 100,
              page: searchDto.page,
            },
          });
          return {
            albums: { items: [] as AlbumResponseDto[] },
            assets: { ...response, items: response.items.map((item) => item.asset) },
          };
        }
        if (('query' in searchDto || 'queryAssetId' in searchDto) && config.machineLearning.clip.enabled) {
          return await searchSmart({
            smartSearchDto: { ...searchDto, language: $lang },
          });
        }
        return await searchAssets({ metadataSearchDto: { ...searchDto } });
      })();

      searchResultAlbums.push(...albums.items);
      searchResultAssets.push(...assets.items);

      nextPage = Number(assets.nextPage) || 0;
    } catch (error) {
      handleError(error, $t('loading_search_results_failed'));
    } finally {
      isLoading = false;
    }
  };

  function getHumanReadableDate(dateString: string) {
    const date = parseUtcDate(dateString).startOf('day');
    return date.toLocaleString(
      {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
      },
      { locale: $locale },
    );
  }

  function getHumanReadableSearchKey(key: keyof SearchTerms): string {
    const keyMap: Partial<Record<keyof SearchTerms, string>> = {
      takenAfter: $t('start_date'),
      takenBefore: $t('end_date'),
      visibility: $t('in_archive'),
      isFavorite: $t('favorite'),
      isNotInAlbum: $t('not_in_any_album'),
      type: $t('media_type'),
      query: $t('context'),
      city: $t('city'),
      country: $t('country'),
      state: $t('state'),
      make: $t('camera_brand'),
      model: $t('camera_model'),
      lensModel: $t('lens_model'),
      personIds: $t('people'),
      tagIds: $t('tags'),
      originalFileName: $t('file_name_text'),
      originalPath: $t('full_path_or_folder'),
      description: $t('description'),
      queryAssetId: $t('query_asset_id'),
      ocr: $t('ocr'),
      ai: $t('ai'),
      hasAiInterpretation: $t('ai_interpretation'),
      withStacked: $t('include_stacked_images'),
    };
    return keyMap[key] || key;
  }

  async function getPersonName(personIds: string[]) {
    const personNames = await Promise.all(
      personIds.map(async (personId) => {
        const person = await getPerson({ id: personId });

        if (person.name === '') {
          return $t('no_name');
        }

        return person.name;
      }),
    );

    return personNames.join(', ');
  }

  async function getTagNames(tagIds: string[] | null) {
    if (tagIds === null) {
      return $t('untagged');
    }
    const tagNames = await Promise.all(
      tagIds.map(async (tagId) => {
        const tag = await getTagById({ id: tagId });

        return tag.value;
      }),
    );

    return tagNames.join(', ');
  }

  const onAlbumAddAssets = ({ assetIds }: { assetIds: string[] }) => {
    assetMultiSelectManager.clear();

    if (terms.isNotInAlbum) {
      const assetIdSet = new Set(assetIds);
      searchResultAssets = searchResultAssets.filter((asset) => !assetIdSet.has(asset.id));
    }
  };

  const onAssetsArchive = (assetIds: string[]) => {
    if (terms.visibility === AssetVisibility.Timeline) {
      const assetIdSet = new Set(assetIds);
      searchResultAssets = searchResultAssets.filter((asset) => !assetIdSet.has(asset.id));
    }
  };

  // TODO: add back in opposite case
  const onAssetsUnarchive = (assets: TimelineAsset[]) => {
    if (terms.visibility === AssetVisibility.Archive) {
      const assetIdSet = new Set(assets.map((asset) => asset.id));
      searchResultAssets = searchResultAssets.filter((asset) => !assetIdSet.has(asset.id));
    }
  };

  const onSelectTranscriptionMoment = (assetId: string, match: TranscriptionMatchDto) => {
    transcriptionPresentation.selectMoment(assetId, match);
  };

  // Opens the viewer at the selected moment; the match identity travels in the
  // URL so refresh/back/forward restore the same seek target (asset-scoped).
  const openTranscriptionMatch = (assetId: string, match: TranscriptionMatchDto) => {
    void navigate({
      targetRoute: 'current',
      assetId,
      match: { passageId: match.passageId, revision: match.revision, startMs: match.startMs },
    });
  };

  const transcriptionEmptyHint = $derived.by(() => {
    const coverage = transcriptionCoverage;
    if (coverage && coverage.totalVideos > 0 && coverage.indexedVideos === 0) {
      return $t('transcription_search_unindexed_hint');
    }
    if (coverage && coverage.indexedVideos > 0 && coverage.pendingIndex > 0) {
      return $t('transcription_search_partial_hint');
    }
    return $t('transcription_search_no_results_hint');
  });

  /**
  Loads further distinct moments for one video, merging pages through the
  presentation manager until the server reports the list complete (or a page
  yields nothing new). Returns the newly merged moments so cards can render
  them without re-reading the map.
  */
  const loadTranscriptionMoments = async (
    assetId: string,
  ): Promise<{ moments: TranscriptionMatchDto[]; nextCursor: string | null }> => {
    if (!transcriptionPresentation.get(assetId)) {
      return { moments: [], nextCursor: null };
    }
    const merged: TranscriptionMatchDto[] = [];
    let cursor: string | undefined = undefined;
    let nextCursor: string | null = null;
    // The server pages the full ranked moment list for this video; keep going
    // while a cursor remains and stop early once a page yields nothing new.
    for (let page = 0; page < 5; page++) {
      const response = await searchMoments({
        transcriptionMomentsDto: { assetId, q: terms.transcription ?? '', cursor, size: 20 },
      });
      const addedNow = transcriptionPresentation.mergeMoments(assetId, response);
      merged.push(...addedNow);
      nextCursor = response.nextCursor;
      // Stop at the end of the ranked list, or when a whole page was already
      // known (the pages are disjoint slices, so we have caught up).
      if (!nextCursor || addedNow.length === 0) {
        break;
      }
      cursor = nextCursor;
    }
    return { moments: merged, nextCursor };
  };

  function getObjectKeys<T extends object>(obj: T): (keyof T)[] {
    return Object.keys(obj) as (keyof T)[];
  }

  function removeFilter(key: keyof SearchTerms) {
    delete terms[key];
    assetMultiSelectManager.clear();
    void goto(Route.search(terms));
    searchManager.setQuery(terms);
  }

  onMount(() => searchManager.setQuery(terms));
</script>

<svelte:window bind:scrollY />
<OnEvents {onAlbumAddAssets} {onAssetsArchive} {onAssetsUnarchive} />

{#if searchTermKeys.length > 0}
  <section id="search-chips" class="mx-auto mt-24 w-full max-w-7xl px-4 sm:px-8 lg:px-12">
    <div class="flex w-full flex-wrap place-content-center place-items-center gap-2.5 sm:gap-3">
      {#each searchTermKeys as searchKey (searchKey)}
        {const value = terms[searchKey]}
        <div
          class="inline-flex max-w-full items-center rounded-full bg-primary/10 py-1 ps-1 pe-1 text-xs text-primary ring-1 ring-primary/15 transition-shadow hover:ring-primary/25 dark:bg-immich-dark-primary/15 dark:text-immich-dark-primary dark:ring-immich-dark-primary/20 dark:hover:ring-immich-dark-primary/30"
        >
          <span
            class="shrink-0 rounded-full bg-primary px-3 py-1.5 font-medium text-light dark:bg-immich-dark-primary dark:text-immich-dark-gray"
          >
            {getHumanReadableSearchKey(searchKey as keyof SearchTerms)}
          </span>

          {#if value !== true}
            <span class="max-w-[min(36rem,55vw)] min-w-0 truncate px-3 py-1.5 text-immich-fg dark:text-immich-dark-fg">
              {#if (searchKey === 'takenAfter' || searchKey === 'takenBefore') && typeof value === 'string'}
                {getHumanReadableDate(value)}
              {:else if searchKey === 'personIds' && Array.isArray(value)}
                {#await getPersonName(value) then personName}
                  {personName}
                {/await}
              {:else if searchKey === 'tagIds' && (Array.isArray(value) || value === null)}
                {#await getTagNames(value) then tagNames}
                  {tagNames}
                {/await}
              {:else if searchKey === 'hasAiInterpretation'}
                {value ? $t('completed') : $t('without_ai_interpretation')}
              {:else if searchKey === 'rating'}
                {$t('rating_count', { values: { count: value ?? 0 } })}
              {:else if value === null || value === ''}
                {$t('unknown')}
              {:else}
                {value}
              {/if}
            </span>
          {/if}

          <button
            type="button"
            class="ms-0.5 flex size-7 shrink-0 items-center justify-center rounded-full text-primary outline-offset-2 outline-immich-primary transition-colors hover:bg-primary/15 focus-visible:outline-2 dark:text-immich-dark-primary dark:outline-immich-dark-primary dark:hover:bg-immich-dark-primary/20"
            aria-label={$t('remove_filter')}
            title={$t('remove_filter')}
            onclick={() => removeFilter(searchKey)}
          >
            <Icon icon={mdiClose} size="14" />
          </button>
        </div>
      {/each}
    </div>
  </section>
{/if}

<section
  class="m-4 mb-12 max-h-screen bg-immich-bg dark:bg-immich-dark-bg"
  bind:clientHeight={viewport.height}
  bind:clientWidth={viewport.width}
  bind:this={searchResultsElement}
>
  <section id="search-content">
    {#if searchResultAssets.length > 0}
      <GalleryViewer
        assets={searchResultAssets}
        assetInteraction={assetMultiSelectManager}
        onEndReached={loadNextPage}
        showArchiveIcon={true}
        {viewport}
        onReload={onSearchQueryUpdate}
        slidingWindowOffset={searchResultsElement.offsetTop}
        transcriptionMatches={terms.transcription ? transcriptionPresentation.matches : undefined}
        {onSelectTranscriptionMoment}
        onLoadTranscriptionMoments={loadTranscriptionMoments}
        onOpenTranscriptionMatch={openTranscriptionMatch}
      />
    {:else if !isLoading}
      <div class="flex min-h-[calc(66vh-11rem)] w-full place-content-center items-center dark:text-white">
        <div class="flex flex-col content-center items-center text-center">
          <Icon icon={mdiImageOffOutline} size="3.5em" />
          <p class="mt-5 text-3xl font-medium">{$t('no_results')}</p>
          {#if terms.ai}
            <p class="text-base font-normal">{$t('ai_search_no_results_hint')}</p>
          {:else if terms.transcription}
            <p class="text-base font-normal">{transcriptionEmptyHint}</p>
          {:else}
            <p class="text-base font-normal">{$t('no_results_description')}</p>
          {/if}
        </div>
      </div>
    {/if}

    {#if isLoading}
      <div class="flex items-center justify-center py-16">
        <LoadingSpinner size="giant" />
      </div>
    {/if}
  </section>

  <section>
    {#if assetMultiSelectManager.selectionActive}
      <div class="fixed inset-s-0 top-0 z-2 w-full">
        <AssetSelectControlBar>
          {const Actions = $derived(getAssetBulkActions($t))}
          <CommandPaletteDefaultProvider name={$t('assets')} actions={Object.values(Actions)} />

          <ActionButton action={Actions.CreateSharedLink} />
          <IconButton
            shape="round"
            color="secondary"
            variant="ghost"
            aria-label={$t('select_all')}
            icon={mdiSelectAll}
            onclick={handleSelectAll}
          />
          <ActionButton action={Actions.AddToAlbum} />
          {#if assetMultiSelectManager.isAllUserOwned}
            <FavoriteAction
              removeFavorite={assetMultiSelectManager.isAllFavorite}
              onFavorite={(ids, isFavorite) => {
                for (const id of ids) {
                  const asset = searchResultAssets.find((asset) => asset.id === id);
                  if (asset) {
                    asset.isFavorite = isFavorite;
                  }
                }
              }}
            />

            <ButtonContextMenu icon={mdiDotsVertical} title={$t('menu')}>
              <ActionMenuItem action={Actions.AddToAlbum} />
              <DownloadAction menuItem />
              <ChangeDate menuItem />
              <ChangeDescription menuItem />
              <ChangeLocation menuItem />
              <ActionMenuItem action={Actions.Archive} />
              <ActionMenuItem action={Actions.Unarchive} />
              <SetVisibilityAction menuItem onVisibilitySet={handleSetVisibility} />
              <ActionMenuItem action={Actions.Tag} />

              <DeleteAssets menuItem {onAssetDelete} onUndoDelete={onSearchQueryUpdate} />

              <hr />
              <ActionMenuItem action={Actions.RefreshFacesJob} />
              <ActionMenuItem action={Actions.RegenerateThumbnailJob} />
              <ActionMenuItem action={Actions.InterpretImageJob} />
        <ActionMenuItem action={Actions.ApplyRotationSuggestions} />
              <ActionMenuItem action={Actions.InterpretImagePublicJob} />
              <ActionMenuItem action={Actions.RefreshMetadataJob} />
              <ActionMenuItem action={Actions.TranscodeVideoJob} />
            </ButtonContextMenu>
          {:else}
            <DownloadAction />
          {/if}
        </AssetSelectControlBar>
      </div>
    {:else}
      <div class="fixed inset-s-0 top-0 z-2 w-full">
        <ControlAppBar onClose={() => goto(previousRoute)} backIcon={mdiArrowLeft}>
          <div class="mx-auto w-full max-w-2xl pe-2">
            <SearchBar grayTheme={false} />
          </div>
        </ControlAppBar>
      </div>
    {/if}
  </section>
</section>
