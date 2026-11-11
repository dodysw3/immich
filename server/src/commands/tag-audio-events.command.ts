import { Command, CommandRunner } from 'nest-commander';
import { AiAudioEventsService } from 'src/services/ai-audio-events.service.js';

/**
Tag environmental sounds for specific videos without re-interpreting them.
The interpretation job only tags while it delivers, and skip-if-interpreted
stops deliveries for videos that already carry a current-version
interpretation, so this is how those videos get `video-audio-events-v1`
(viewer sound tags) — same lane, same run identity, idempotent per runKey.
*/
@Command({
  name: 'tag-audio-events',
  description: 'Run the YAMNet audio-events lane for the given video asset ids (skips already-tagged runs)',
  arguments: '<assetIds...>',
})
export class TagAudioEventsCommand extends CommandRunner {
  constructor(private audioEventsService: AiAudioEventsService) {
    super();
  }

  async run(assetIds: string[]): Promise<void> {
    let failures = 0;
    for (const assetId of assetIds) {
      const run = await this.audioEventsService.tagIfMissing(assetId, 'manual');
      if (!run) {
        failures++;
        console.log(`${assetId}: no completed run (not a video, lane disabled, or tagging failed — see logs)`);
        continue;
      }
      const labels = run.events.map((event) => event.label);
      console.log(
        `${assetId}: ${run.events.length} events${run.noAudio ? ' (no audio)' : ''}${labels.length > 0 ? ` — ${labels.join(' | ')}` : ''}`,
      );
    }
    // CLI command: the BullMQ connections of the admin module keep the event
    // loop alive, and the exit code is the result contract for wrapper scripts.
    // eslint-disable-next-line unicorn/no-process-exit
    process.exit(failures > 0 ? 1 : 0);
  }
}
