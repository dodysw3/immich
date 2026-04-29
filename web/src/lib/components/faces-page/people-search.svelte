<script lang="ts">
  import { initInput } from '$lib/actions/focus';
  import { maximumLengthSearchPeople, timeBeforeShowLoadingSpinner } from '$lib/constants';
  import SearchBar from '$lib/elements/SearchBar.svelte';
  import { handleError } from '$lib/utils/handle-error';
  import { searchNameLocal } from '$lib/utils/person';
  import { searchPerson, type PersonResponseDto } from '@immich/sdk';
  import { t } from 'svelte-i18n';

  let searchedPeople: PersonResponseDto[] = [];
  let searchWord: string;
  let abortController: AbortController | null = null;
  let timeout: NodeJS.Timeout | null = null;

  const search = () => {
    searchedPeopleLocal = searchNameLocal(searchName, searchedPeople, numberPeopleToSearch);
  };

  const reset = () => {
    searchedPeopleLocal = [];
    cancelPreviousRequest();
    onReset();
  };

  const cancelPreviousRequest = () => {
    if (abortController) {
      abortController.abort();
      abortController = null;
    }
    if (timeout) {
      clearTimeout(timeout);
      timeout = null;
    }
  };

  interface Props {
    searchName: string;
    searchedPeopleLocal: PersonResponseDto[];
    type: 'searchBar' | 'input';
    numberPeopleToSearch?: number;
    inputClass?: string;
    showLoadingSpinner?: boolean;
    placeholder?: string;
    onReset?: () => void;
    onSearch?: () => void;
  }

  let {
    searchName = $bindable(),
    // eslint-disable-next-line no-useless-assignment
    searchedPeopleLocal = $bindable(),
    type,
    numberPeopleToSearch = maximumLengthSearchPeople,
    inputClass = 'w-full gap-2',
    showLoadingSpinner = $bindable(false),
    placeholder = $t('name_or_nickname'),
    onReset = () => {},
    onSearch = () => {},
  }: Props = $props();

  const handleReset = () => {
    reset();
    onReset();
  };

  const API_PERSON_LIMIT = 100;
  let lastApiResultWasComplete = false;

  const canUseLocalSearch = (currentSearch: string, previousSearch: string): boolean => {
    if (!currentSearch.startsWith(previousSearch)) {
      return false;
    }
    if (searchedPeople.length === 0) {
      return false;
    }
    if (!lastApiResultWasComplete) {
      return true;
    }
    if (previousSearch.length < 3) {
      return false;
    }
    return true;
  };

  export async function searchPeople(force?: boolean, name?: string) {
    searchName = name ?? searchName;
    onSearch();
    if (searchName === '') {
      reset();
      return;
    }
    if (!force && canUseLocalSearch(searchName, searchWord)) {
      search();
      return;
    }
    cancelPreviousRequest();
    abortController = new AbortController();
    timeout = setTimeout(() => (showLoadingSpinner = true), timeBeforeShowLoadingSpinner);
    try {
      const data = await searchPerson({ name: searchName }, { signal: abortController?.signal });
      if (abortController) {
        searchedPeople = data;
        searchWord = searchName;
        lastApiResultWasComplete = data.length >= API_PERSON_LIMIT;
      }
    } catch (error) {
      if (abortController) {
        handleError(error, $t('errors.cant_search_people'));
      }
    } finally {
      clearTimeout(timeout);
      timeout = null;
      if (abortController) {
        search();
      }
      abortController = null;
      showLoadingSpinner = false;
    }
  }
</script>

{#if type === 'searchBar'}
  <SearchBar
    bind:name={searchName}
    {showLoadingSpinner}
    {placeholder}
    onReset={handleReset}
    onSearch={({ force }) => searchPeople(force ?? false)}
  />
{:else}
  <input
    class={inputClass}
    type="text"
    {placeholder}
    bind:value={searchName}
    oninput={() => searchPeople(false)}
    use:initInput
  />
{/if}
