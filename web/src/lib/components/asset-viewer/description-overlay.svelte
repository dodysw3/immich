<script lang="ts">
  export let description: string;
</script>

{#if description}
  <div class="absolute top-4 left-16 z-10 max-w-md rounded-md bg-black/60 px-3 py-2 text-white backdrop-blur-sm">
    <p class="text-sm">{description}</p>
  </div>
{/if}
