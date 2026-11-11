<script lang="ts">
  import { videoAudioEventsManager } from '#lib/stores/video-audio-events.svelte.ts';
  import { IconButton } from '@immich/ui';
  import { mdiWaveform } from '@mdi/js';
  import { t } from 'svelte-i18n';
</script>

<IconButton
  title={videoAudioEventsManager.showOverlay ? $t('hide_video_sound_events') : $t('show_video_sound_events')}
  icon={mdiWaveform}
  class={videoAudioEventsManager.showOverlay ? 'dark bg-immich-primary text-white' : 'dark'}
  color="secondary"
  variant="ghost"
  shape="round"
  aria-label={$t('video_sound_events')}
  onclick={() => videoAudioEventsManager.toggleOverlay()}
/>
