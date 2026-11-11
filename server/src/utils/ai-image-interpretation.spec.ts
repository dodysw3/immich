import { DateTime } from 'luxon';
import { describe, expect, it } from 'vitest';
import {
  AI_IMAGE_INTERPRETATION_MODEL,
  AI_IMAGE_INTERPRETATION_PROMPT,
  AI_IMAGE_INTERPRETATION_PROMPT_VERSION,
  AI_IMAGE_INTERPRETATION_QUANT,
  AI_INTERPRETATION_RATE_WINDOW_MS,
  AI_INTERPRETATION_RETRY_MAX_MS,
  composeVideoInterpretationContext,
  createAiInterpretationRunKey,
  formatAiInterpretationQueueEta,
  interpretationRetryDelayMs,
} from 'src/utils/ai-image-interpretation.js';

const audioEvent = (label: string, mid: string, startMs: number, endMs: number, score = 0.5) => ({
  mid,
  label,
  score,
  startMs,
  endMs,
});
const audioEventsRun = (events: ReturnType<typeof audioEvent>[]) => ({ events }) as never;

describe('AI image interpretation contract', () => {
  it('derives a stable run key from the exact tuple', () => {
    expect(
      createAiInterpretationRunKey(
        AI_IMAGE_INTERPRETATION_MODEL,
        AI_IMAGE_INTERPRETATION_QUANT,
        AI_IMAGE_INTERPRETATION_PROMPT_VERSION,
      ),
    ).toBe('dd8bdc1429792264d54303fea88700d502d68053a9d6c2b10ad7fffa66a5e182');
    expect(
      createAiInterpretationRunKey(
        AI_IMAGE_INTERPRETATION_MODEL,
        AI_IMAGE_INTERPRETATION_QUANT,
        'image-interpretation-1.0.1',
      ),
    ).not.toBe(
      createAiInterpretationRunKey(
        AI_IMAGE_INTERPRETATION_MODEL,
        AI_IMAGE_INTERPRETATION_QUANT,
        AI_IMAGE_INTERPRETATION_PROMPT_VERSION,
      ),
    );
  });

  it('keeps the initial prompt deliberate and privacy-scoped', () => {
    expect(AI_IMAGE_INTERPRETATION_PROMPT).toMatchInlineSnapshot(`
      "You are an archival image interpreter. Analyze only evidence visible in the supplied image. Distinguish direct observation from interpretation and from uncertain contextual inference. Explain not only what is present, but how composition, gesture, light, setting, and relationships may shape the image's meaning.

      No Immich face matches, person IDs, or associated names are provided. Do not guess or invent a person's identity. You may name someone only when they are a widely known public figure and you have great confidence from clear, distinctive visual evidence in this image. Otherwise use a generic description such as "a person" and note the identity limitation briefly within interpretation. A name is a model claim, not a verified fact. Do not infer sensitive personal traits. Do not infer exact places, dates, authorship, brands, or events unless visible evidence strongly supports them.

      Return only the requested output representation. Keep literal_description observational. Put hypotheses in interpretation together with their evidence, and briefly note meaningful alternatives and uncertainties there. Never promote a low-confidence identification into title, archive_summary, or search_keywords."
    `);
    expect(AI_IMAGE_INTERPRETATION_PROMPT).not.toContain('filename');
    expect(AI_IMAGE_INTERPRETATION_PROMPT).not.toContain('GPS');
    expect(AI_IMAGE_INTERPRETATION_PROMPT_VERSION).toBe('image-interpretation-1.2.0');
  });

  it('doubles retry delays from two minutes and caps them at one day', () => {
    expect(interpretationRetryDelayMs(1)).toBe(2 * 60_000);
    expect(interpretationRetryDelayMs(2)).toBe(4 * 60_000);
    expect(interpretationRetryDelayMs(3)).toBe(8 * 60_000);
    expect(interpretationRetryDelayMs(0)).toBe(2 * 60_000);
    expect(interpretationRetryDelayMs(9)).toBe(512 * 60_000);
    expect(interpretationRetryDelayMs(10)).toBe(1024 * 60_000);
    expect(interpretationRetryDelayMs(11)).toBe(AI_INTERPRETATION_RETRY_MAX_MS);
    expect(interpretationRetryDelayMs(25)).toBe(AI_INTERPRETATION_RETRY_MAX_MS);
    expect(AI_INTERPRETATION_RETRY_MAX_MS).toBe(24 * 60 * 60_000);
  });

  describe('formatAiInterpretationQueueEta', () => {
    // Fixed clock in a named zone so the "around" timestamp is deterministic
    // regardless of the test runner's TZ (vitest runs with TZ=UTC).
    const now = DateTime.fromISO('2026-09-26T23:00:00', { zone: 'Asia/Jakarta' });

    it('reports a drained queue without consulting the rate', () => {
      expect(formatAiInterpretationQueueEta(0, 3.4, now)).toBe('queue drained');
      expect(formatAiInterpretationQueueEta(-5, 0, now)).toBe('queue drained');
    });

    it('reports an unknown ETA when the window has no completions', () => {
      expect(formatAiInterpretationQueueEta(37, 0, now)).toBe('unknown (no completions in the last 5 minutes)');
    });

    it('divides the remaining count by the per-minute completion rate', () => {
      expect(formatAiInterpretationQueueEta(37, 3.4, now)).toBe('~11m (around Sep 26, 11:10 PM GMT+7)');
      expect(formatAiInterpretationQueueEta(3010, 1, now)).toBe('~2d 2h 10m (around Sep 29, 1:10 AM GMT+7)');
      expect(formatAiInterpretationQueueEta(1, 120, now)).toBe('<1m (around Sep 26, 11:00 PM GMT+7)');
    });
  });

  it('uses a five-minute completion-rate window', () => {
    expect(AI_INTERPRETATION_RATE_WINDOW_MS).toBe(5 * 60_000);
  });
});

describe('composeVideoInterpretationContext', () => {
  const captionRun = (overrides: Partial<Record<string, unknown>> = {}) =>
    ({
      segments: [{ startMs: 0, endMs: 5000, caption: 'A train pulls into a night station.' }],
      config: { segmentSeconds: 5, framesPerSegment: 3, frameEdge: 672, maxDurationSec: 300, language: 'en' },
      ...overrides,
    }) as never;

  const transcriptRun = (overrides: Partial<Record<string, unknown>> = {}) =>
    ({
      segments: [{ startMs: 24_400, endMs: 26_400, text: 'selamat datang di LRT Jabodetai' }],
      ...overrides,
    }) as never;

  it('returns undefined when neither lane produced a completed run', () => {
    expect(composeVideoInterpretationContext({})).toBeUndefined();
  });

  it('frames captions as full-video evidence with the video duration in the header', () => {
    const context = composeVideoInterpretationContext({ durationMs: 32_391, captions: captionRun() })!;
    expect(context).toContain('preview thumbnail of a video (32.4s long)');
    expect(context).toContain('[0.0-5.0s] A train pulls into a night station.');
    expect(context).toContain('direct observation alongside the thumbnail');
  });

  it('lists the transcript with its detected language', () => {
    const context = composeVideoInterpretationContext({
      captions: captionRun(),
      transcripts: transcriptRun({ language: 'id' }),
    })!;
    expect(context).toContain('Speech transcript (detected language: id):');
    expect(context).toContain('[24.4-26.4s] selamat datang di LRT Jabodetai');
  });

  it('collapses consecutive No-change delta captions into one spanning line', () => {
    const context = composeVideoInterpretationContext({
      captions: captionRun({
        segments: [
          { startMs: 0, endMs: 5000, caption: 'A woman holds a silver smartphone.' },
          { startMs: 5000, endMs: 10_000, caption: 'No change.' },
          { startMs: 10_000, endMs: 15_000, caption: 'no change' },
          { startMs: 15_000, endMs: 20_000, caption: 'Text now shows "KITA".' },
          { startMs: 20_000, endMs: 25_000, caption: 'No change.' },
        ],
      }),
    })!;
    expect(context).toContain('[0.0-5.0s] A woman holds a silver smartphone.');
    // Both static segments fold into a single line with the merged window.
    expect(context).toContain('[5.0-15.0s] No change.');
    expect(context).toContain('[15.0-20.0s] Text now shows "KITA".');
    expect(context).toContain('[20.0-25.0s] No change.');
    expect(context).not.toContain('[5.0-10.0s]');
    expect(context).not.toContain('[10.0-15.0s]');
  });

  it('states the audio conclusion for a completed transcript run without segments', () => {
    const noAudio = composeVideoInterpretationContext({
      captions: captionRun(),
      transcripts: transcriptRun({ segments: [], noAudio: true }),
    })!;
    expect(noAudio).toContain('The video has no audio track.');
    const silent = composeVideoInterpretationContext({
      captions: captionRun(),
      transcripts: transcriptRun({ segments: [] }),
    })!;
    expect(silent).toContain('No speech was detected in the video.');
  });

  it('stays silent about audio when the transcript run is missing entirely', () => {
    const context = composeVideoInterpretationContext({ captions: captionRun() })!;
    expect(context).not.toContain('audio');
  });

  it('notes truncated caption coverage', () => {
    const context = composeVideoInterpretationContext({ captions: captionRun({ truncated: true }) })!;
    expect(context).toContain('[Captions cover only the head of a longer video.]');
  });

  it('caps each section and marks the omission', () => {
    const longCaption = 'x'.repeat(4000);
    const context = composeVideoInterpretationContext({
      captions: captionRun({
        segments: [
          { startMs: 0, endMs: 5000, caption: longCaption },
          { startMs: 5000, endMs: 10_000, caption: longCaption },
        ],
      }),
    })!;
    expect(context).toContain('[… additional segments omitted]');
    expect(context).not.toContain('[5.0-10.0s]');
    expect(context.indexOf('… additional segments omitted')).toBeGreaterThan(context.lastIndexOf('xxxx'));
  });

  describe('audio events', () => {
    const beep = audioEvent('Beep, bleep', '/m/02fs_r', 4320, 5280);
    const childSpeech = audioEvent('Child speech, kid speaking', '/m/0ytgt', 6240, 14_400);

    it('renders events as timed natural sentences without scores, after the transcript section', () => {
      const context = composeVideoInterpretationContext({
        captions: captionRun(),
        transcripts: transcriptRun(),
        audioEvents: audioEventsRun([beep]),
      })!;
      expect(context).toContain('Other sounds detected in the audio:\n[4.3-5.3s] An electronic beep is heard.');
      expect(context).not.toContain('0.5');
      expect(context.indexOf('Other sounds detected')).toBeGreaterThan(context.indexOf('Speech transcript'));
      expect(context.endsWith('[4.3-5.3s] An electronic beep is heard.')).toBe(true);
    });

    it('keeps strong voice events as presence evidence when the transcript has no words', () => {
      const context = composeVideoInterpretationContext({
        captions: captionRun(),
        transcripts: transcriptRun({ segments: [], noSpeech: true }),
        audioEvents: audioEventsRun([audioEvent('Child speech, kid speaking', '/m/0ytgt', 6240, 14_400, 0.86)]),
      })!;
      expect(context).toContain('No speech was detected in the video.');
      expect(context).toContain("[6.2-14.4s] A child's voice is heard.");
    });

    it('drops weak voice events on a no-speech transcript (river-style noise fragments)', () => {
      const context = composeVideoInterpretationContext({
        captions: captionRun(),
        transcripts: transcriptRun({ segments: [], noSpeech: true }),
        audioEvents: audioEventsRun([audioEvent('Speech', '/m/09x0r', 112_320, 114_240, 0.47)]),
      })!;
      expect(context).not.toContain('Other sounds');
    });

    it('drops speech-family events when the transcript carries the words', () => {
      const context = composeVideoInterpretationContext({
        captions: captionRun(),
        transcripts: transcriptRun(),
        audioEvents: audioEventsRun([childSpeech, beep]),
      })!;
      expect(context).not.toContain('Child speech');
      expect(context).toContain('An electronic beep is heard.');
    });

    it('adds no section when only suppressed speech events remain', () => {
      const withoutRun = composeVideoInterpretationContext({ captions: captionRun(), transcripts: transcriptRun() });
      const withSpeechOnly = composeVideoInterpretationContext({
        captions: captionRun(),
        transcripts: transcriptRun(),
        audioEvents: audioEventsRun([childSpeech]),
      });
      expect(withSpeechOnly).toBe(withoutRun);
    });

    it('is byte-identical to the pre-events output when the run is missing or empty', () => {
      // Literal pre-change rendering of captions + transcript: the events lane
      // must not move a single byte when it has nothing to add.
      const preEvents = [
        'The attached image is only the preview thumbnail of a video. Evidence captured from the full video follows; treat it as direct observation alongside the thumbnail, distinguish it from inference, and include what is said or heard when it matters.',
        'Visual captions per 5-second segment:\n[0.0-5.0s] A train pulls into a night station.',
        'Speech transcript (detected language: id):\n[24.4-26.4s] selamat datang di LRT Jabodetai',
      ].join('\n\n');
      const base = { captions: captionRun(), transcripts: transcriptRun({ language: 'id' }) };
      expect(composeVideoInterpretationContext(base)).toBe(preEvents);
      expect(composeVideoInterpretationContext({ ...base, audioEvents: audioEventsRun([]) })).toBe(preEvents);

      const inputs = [
        { captions: captionRun() },
        { captions: captionRun(), transcripts: transcriptRun({ segments: [], noAudio: true }) },
        { transcripts: transcriptRun() },
      ];
      for (const input of inputs) {
        const before = composeVideoInterpretationContext(input);
        expect(composeVideoInterpretationContext({ ...input, audioEvents: undefined })).toBe(before);
        expect(composeVideoInterpretationContext({ ...input, audioEvents: audioEventsRun([]) })).toBe(before);
      }
      expect(composeVideoInterpretationContext({ audioEvents: audioEventsRun([]) })).toBeUndefined();
    });

    it('composes an events-only context when the caption and transcript lanes produced nothing', () => {
      const context = composeVideoInterpretationContext({ durationMs: 14_805, audioEvents: audioEventsRun([beep]) })!;
      expect(context).toContain('preview thumbnail of a video (14.8s long)');
      expect(context).toContain('Other sounds detected in the audio:\n[4.3-5.3s] An electronic beep is heard.');
      expect(context).not.toContain('Visual captions');
    });

    it('caps the section like the other evidence sections', () => {
      const longLabel = 'y'.repeat(4000);
      const context = composeVideoInterpretationContext({
        captions: captionRun(),
        audioEvents: audioEventsRun([
          audioEvent(longLabel, '/m/test', 0, 1000),
          audioEvent(longLabel, '/m/test', 5000, 6000),
        ]),
      })!;
      // same fallback sentence, spans 4 s apart (past the 2 s render merge gap)
      // -> two over-cap lines, the second omitted
      expect(context).toContain('[0.0-1.0s] A sound like');
      expect(context).not.toContain('[5.0-6.0s]');
      expect(context.endsWith('[… additional segments omitted]')).toBe(true);
    });
  });
});
