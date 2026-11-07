<script lang="ts">
  import { videoCaptionManager } from '#lib/stores/video-caption.svelte.ts';
  import { IconButton } from '@immich/ui';
  import { mdiSubtitles } from '@mdi/js';
  import { t } from 'svelte-i18n';
</script>

<IconButton
  title={videoCaptionManager.showOverlay ? $t('hide_video_captions') : $t('show_video_captions')}
  icon={mdiSubtitles}
  class={videoCaptionManager.showOverlay ? 'dark bg-immich-primary text-white' : 'dark'}
  color="secondary"
  variant="ghost"
  shape="round"
  aria-label={$t('video_captions')}
  onclick={() => videoCaptionManager.toggleOverlay()}
/>
