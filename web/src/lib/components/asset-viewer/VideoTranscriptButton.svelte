<script lang="ts">
  import { videoTranscriptManager } from '#lib/stores/video-transcript.svelte.ts';
  import { IconButton } from '@immich/ui';
  import { mdiCommentTextOutline } from '@mdi/js';
  import { t } from 'svelte-i18n';
</script>

<IconButton
  title={videoTranscriptManager.showOverlay ? $t('hide_video_transcription') : $t('show_video_transcription')}
  icon={mdiCommentTextOutline}
  class={videoTranscriptManager.showOverlay ? 'dark bg-immich-primary text-white' : 'dark'}
  color="secondary"
  variant="ghost"
  shape="round"
  aria-label={$t('video_transcription')}
  onclick={() => videoTranscriptManager.toggleOverlay()}
/>
