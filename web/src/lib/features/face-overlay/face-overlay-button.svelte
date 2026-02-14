<script lang="ts">
  import { faceOverlayStore } from '$lib/features/face-overlay/face-overlay.store.svelte';
  import { IconButton } from '@immich/ui';
  import { mdiFaceRecognition } from '@mdi/js';
</script>

<IconButton
  title={faceOverlayStore.showOverlay ? 'Hide face recognition' : 'Show face recognition'}
  icon={mdiFaceRecognition}
  class={faceOverlayStore.showOverlay ? 'dark bg-immich-primary text-white' : 'dark'}
  color="secondary"
  variant="ghost"
  shape="round"
  aria-label="Face recognition"
  onclick={() => faceOverlayStore.toggleOverlay()}
/>
