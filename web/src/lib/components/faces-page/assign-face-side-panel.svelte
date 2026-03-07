<script lang="ts">
  import SearchPeople from '$lib/components/faces-page/people-search.svelte';
  import { timeBeforeShowLoadingSpinner } from '$lib/constants';
  import { assetViewerManager } from '$lib/managers/asset-viewer-manager.svelte';
  import { getPeopleThumbnailUrl, handlePromiseError } from '$lib/utils';
  import { handleError } from '$lib/utils/handle-error';
  import { zoomImageToBase64 } from '$lib/utils/people-utils';
  import { getPersonNameWithHiddenValue } from '$lib/utils/person';
  import {
    AssetTypeEnum,
    createPerson,
    getAllPeople,
    reassignFacesById,
    type AssetFaceResponseDto,
    type PersonResponseDto,
  } from '@immich/sdk';
  import { IconButton, LoadingSpinner } from '@immich/ui';
  import { mdiArrowLeftThin, mdiClose, mdiMagnify, mdiPlus } from '@mdi/js';
  import { onMount } from 'svelte';
  import { t } from 'svelte-i18n';
  import { linear } from 'svelte/easing';
  import { fly } from 'svelte/transition';
  import ImageThumbnail from '../assets/thumbnail/image-thumbnail.svelte';

  interface Props {
    editedFace: AssetFaceResponseDto;
    assetId: string;
    assetType: AssetTypeEnum;
    startInCreateMode?: boolean;
    onClose: () => void;
    onCreatePerson: (person: PersonResponseDto) => void;
    onReassign: (person: PersonResponseDto) => void;
  }

  let { editedFace, assetId, assetType, startInCreateMode = false, onClose, onCreatePerson, onReassign }: Props =
    $props();

  let allPeople: PersonResponseDto[] = $state([]);

  let isShowLoadingPeople = $state(false);

  async function loadPeople() {
    const timeout = setTimeout(() => (isShowLoadingPeople = true), timeBeforeShowLoadingSpinner);
    try {
      const { people } = await getAllPeople({ withHidden: true, closestAssetId: editedFace.id });
      allPeople = people;
    } catch (error) {
      handleError(error, $t('errors.cant_get_faces'));
    } finally {
      clearTimeout(timeout);
    }
    isShowLoadingPeople = false;
  }

  // loading spinners
  let isShowLoadingSearch = $state(false);

  // search people
  let searchedPeople: PersonResponseDto[] = $state([]);
  let searchFaces = $state(false);
  let searchName = $state('');

  // create person mode
  let createPersonMode = $state(startInCreateMode);
  let newPersonName = $state('');
  let isCreatingPerson = $state(false);

  let showPeople = $derived(searchName ? searchedPeople : allPeople.filter((person) => !person.isHidden));

  onMount(() => {
    handlePromiseError(loadPeople());
  });

  const waitForThumbnail = async (url: string, maxAttempts = 10, intervalMs = 1000): Promise<void> => {
    for (let i = 0; i < maxAttempts; i++) {
      try {
        const response = await fetch(url, { method: 'HEAD' });
        if (response.ok) return;
      } catch {
        // network error, keep retrying
      }
      await new Promise<void>((resolve) => setTimeout(resolve, intervalMs));
    }
  };

  const handleCreatePerson = async () => {
    isCreatingPerson = true;
    const timeout = setTimeout(() => {}, timeBeforeShowLoadingSpinner);
    try {
      const person = await createPerson({ personCreateDto: { name: newPersonName } });
      await reassignFacesById({ id: person.id, faceDto: { id: editedFace.id } });
      await waitForThumbnail(getPeopleThumbnailUrl(person));
      onCreatePerson(person);
    } catch (error) {
      handleError(error, $t('errors.cant_apply_changes'));
    } finally {
      clearTimeout(timeout);
      isCreatingPerson = false;
    }
  };
</script>

<section
  transition:fly={{ x: 360, duration: 100, easing: linear }}
  class="absolute top-0 h-full w-90 overflow-x-hidden p-2 dark:text-immich-dark-fg bg-light"
>
  {#if createPersonMode}
    <div class="flex place-items-center justify-between gap-2">
      <div class="flex items-center gap-2">
        <IconButton
          color="secondary"
          variant="ghost"
          shape="round"
          icon={mdiArrowLeftThin}
          aria-label={$t('back')}
          onclick={() => (createPersonMode = false)}
        />
        <p class="flex text-lg text-immich-fg dark:text-immich-dark-fg">{$t('create_new_person')}</p>
      </div>
      {#if !isCreatingPerson}
        <button
          type="button"
          class="justify-self-end rounded-lg p-2 hover:bg-immich-dark-primary hover:dark:bg-immich-dark-primary/50"
          onclick={handleCreatePerson}
        >
          {$t('done')}
        </button>
      {:else}
        <LoadingSpinner />
      {/if}
    </div>
    <div class="px-4 py-8">
      <label class="block text-sm font-medium mb-2 text-immich-fg dark:text-immich-dark-fg" for="new-person-name">
        {$t('name')}
      </label>
      <!-- svelte-ignore a11y_autofocus -->
      <input
        id="new-person-name"
        type="text"
        bind:value={newPersonName}
        autofocus
        class="w-full rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 px-3 py-2 text-sm text-immich-fg dark:text-immich-dark-fg focus:outline-none focus:ring-2 focus:ring-immich-primary"
        onkeydown={(e) => e.key === 'Enter' && handleCreatePerson()}
      />
    </div>
  {:else}
    <div class="flex place-items-center justify-between gap-2">
      {#if !searchFaces}
        <div class="flex items-center gap-2">
          <IconButton
            color="secondary"
            variant="ghost"
            shape="round"
            icon={mdiArrowLeftThin}
            aria-label={$t('back')}
            onclick={onClose}
          />
          <p class="flex text-lg text-immich-fg dark:text-immich-dark-fg">{$t('select_face')}</p>
        </div>
        <div class="flex justify-end gap-2">
          <IconButton
            color="secondary"
            variant="ghost"
            shape="round"
            icon={mdiMagnify}
            aria-label={$t('search_for_existing_person')}
            onclick={() => {
              searchFaces = true;
            }}
          />
          <IconButton
            color="secondary"
            variant="ghost"
            shape="round"
            icon={mdiPlus}
            aria-label={$t('create_new_person')}
            onclick={() => {
              newPersonName = '';
              createPersonMode = true;
            }}
          />
        </div>
      {:else}
        <IconButton
          color="secondary"
          variant="ghost"
          shape="round"
          icon={mdiArrowLeftThin}
          aria-label={$t('back')}
          onclick={onClose}
        />
        <div class="w-full flex">
          <SearchPeople
            type="input"
            bind:searchName
            bind:showLoadingSpinner={isShowLoadingSearch}
            bind:searchedPeopleLocal={searchedPeople}
          />
          {#if isShowLoadingSearch}
            <div>
              <LoadingSpinner />
            </div>
          {/if}
        </div>
        <IconButton
          color="secondary"
          variant="ghost"
          shape="round"
          icon={mdiClose}
          aria-label={$t('cancel_search')}
          onclick={() => (searchFaces = false)}
        />
      {/if}
    </div>
    <div class="px-4 py-4 text-sm">
      <h2 class="mb-8 mt-4">{$t('all_people')}</h2>
      {#if isShowLoadingPeople}
        <div class="flex w-full justify-center">
          <LoadingSpinner />
        </div>
      {:else}
        <div class="immich-scrollbar mt-4 flex flex-wrap gap-2 overflow-y-auto">
          {#each showPeople as person (person.id)}
            {#if !editedFace.person || person.id !== editedFace.person.id}
              <div class="w-fit">
                <button type="button" class="w-22.5" onclick={() => onReassign(person)}>
                  <div class="relative">
                    <ImageThumbnail
                      curve
                      shadow
                      url={getPeopleThumbnailUrl(person)}
                      altText={$getPersonNameWithHiddenValue(person.name, person.isHidden)}
                      title={$getPersonNameWithHiddenValue(person.name, person.isHidden)}
                      widthStyle="90px"
                      heightStyle="90px"
                      hidden={person.isHidden}
                    />
                  </div>

                  <p
                    class="mt-1 truncate font-medium"
                    title={$getPersonNameWithHiddenValue(person.name, person.isHidden)}
                  >
                    {person.name}
                  </p>
                </button>
              </div>
            {/if}
          {/each}
        </div>
      {/if}
    </div>
  {/if}
</section>
