<script lang="ts">
  interface Props {
    query: string;
    onSearch: (query: string) => void;
  }

  let { query = '', onSearch }: Props = $props();

  const submit = (event: SubmitEvent) => {
    event.preventDefault();
    onSearch(query.trim());
  };
</script>

<form class="flex gap-2" onsubmit={submit}>
  <input
    class="w-full rounded-xl border border-gray-300 px-3 py-2 text-sm dark:border-gray-700 dark:bg-gray-900"
    placeholder="Search in indexed text"
    bind:value={query}
  />
  <button
    class="rounded-xl border border-primary-500 px-3 py-2 text-sm font-medium text-primary-700 dark:text-primary-300"
    type="submit"
  >
    Search
  </button>
</form>
