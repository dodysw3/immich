<script lang="ts">
  import { faceManager } from '$lib/stores/face-manager.svelte';
  import { IconButton } from '@immich/ui';
  import { mdiFaceRecognition } from '@mdi/js';
  import { t } from 'svelte-i18n';
</script>

<IconButton
  title={faceManager.showOverlay ? $t('hide_face_recognition') : $t('show_face_recognition')}
  icon={mdiFaceRecognition}
  class={"dark {faceManager.showOverlay ? 'bg-immich-primary text-white dark' : 'dark'}"}
  color="secondary"
  variant="ghost"
  shape="round"
  aria-label={$t('face_recognition')}
  onclick={() => faceManager.toggleFaceBoundingBox()}
/>
