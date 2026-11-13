import { DateTime } from 'luxon';
import { describe, expect, it } from 'vitest';
import {
  AI_IMAGE_INTERPRETATION_MODEL,
  AI_IMAGE_INTERPRETATION_PROMPT,
  AI_IMAGE_INTERPRETATION_PROMPT_VERSION,
  AI_IMAGE_INTERPRETATION_QUANT,
  AI_INTERPRETATION_RATE_WINDOW_MS,
  AI_INTERPRETATION_RETRY_MAX_MS,
  VIDEO_CONTEXT_SECTION_BUDGET_CHARS,
  composeVideoInterpretationContext,
  createAiInterpretationRunKey,
  formatAiInterpretationQueueEta,
  interpretationRetryDelayMs,
  sampleEvidenceLines,
  type EvidenceLine,
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

describe('composeVideoInterpretationContext', () => {
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

  it('samples an overflowing section across the whole timeline instead of truncating at the head', () => {
    // 40 realistic caption lines (~110 chars each ≈ 5.4k chars rendered) vs
    // the 4500 budget: head stays detailed, the middle is strided, the tail
    // is kept, gaps marked.
    const segments = Array.from({ length: 40 }, (_, i) => ({
      startMs: i * 5000,
      endMs: (i + 1) * 5000,
      caption: `Segment ${i}: a man walks slowly past a crowded warung while a motorbike idles noisily near the gate.`,
    }));
    const context = composeVideoInterpretationContext({ captions: captionRun({ segments }) })!;
    const captionsSection = context.split('\n\n').find((section) => section.includes('Visual captions'))!;
    expect(context).toContain('The evidence is sampled across the whole timeline; gaps are explicitly marked.');
    expect(captionsSection).toMatch(/\[… \d+ segments \(\d+\.\ds-\d+\.\ds\) omitted\]/);
    expect(captionsSection).toContain('[0.0-5.0s] Segment 0:');
    expect(captionsSection).toContain('[195.0-200.0s] Segment 39:');
    // Stride keeps the timeline represented, not just the head.
    const kept = captionsSection.split('\n').filter((line) => line.startsWith('[') && !line.startsWith('[…'));
    expect(kept.length).toBeGreaterThan(10);
    expect(kept.length).toBeLessThan(40);
    expect(captionsSection.length).toBeLessThan(5200);
  });

  it('renders under-budget sections without sampling notes', () => {
    const segments = Array.from({ length: 10 }, (_, i) => ({
      startMs: i * 5000,
      endMs: (i + 1) * 5000,
      caption: `Segment ${i}: a quiet kitchen scene.`,
    }));
    const context = composeVideoInterpretationContext({ captions: captionRun({ segments }) })!;
    expect(context).not.toContain('sampled');
    expect(context).not.toContain('omitted]');
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

    it('samples the sound section within its smaller budget', () => {
      // The renderer caps at 12 lines, so overflow needs long sentences:
      // 12 distinct ~90-char sentences ≈ 1.4k chars vs the 1000 budget.
      const labels = Array.from(
        { length: 12 },
        (_, i) => `Sound class number ${i} renders into a fairly long descriptive sentence about the noise`,
      );
      const events = labels.map((label, i) => audioEvent(label, `/m/test${i}`, i * 60_000, i * 60_000 + 4000));
      const context = composeVideoInterpretationContext({
        captions: captionRun(),
        audioEvents: audioEventsRun(events),
      })!;
      const soundsSection = context.split('\n\n').find((section) => section.includes('Other sounds'))!;
      expect(soundsSection).toMatch(/\[… \d+ segments \(\d+\.\ds-\d+\.\ds\) omitted\]/);
      expect(soundsSection).toContain('[0.0-4.0s] A sound like');
      expect(soundsSection.length).toBeLessThan(1300);
    });
  });
});

describe('sampleEvidenceLines', () => {
  const filler = 'with a longer filler text so the rendered line spans many chars';
  const line = (i: number, text = `evidence item number ${i} ${filler}`): EvidenceLine => ({
    startMs: i * 10_000,
    endMs: i * 10_000 + 8000,
    text,
  });

  it('passes short evidence through untouched', () => {
    const lines = [line(0), line(1), line(2)];
    const sampled = sampleEvidenceLines(lines, 4000);
    expect(sampled.sampled).toBe(false);
    expect(sampled.lines).toHaveLength(3);
    expect(sampled.lines[0]).toContain('evidence item number 0');
  });

  it('keeps the head in detail, strides the middle, and always keeps the tail', () => {
    const lines = Array.from({ length: 60 }, (_, i) => line(i));
    const sampled = sampleEvidenceLines(lines, VIDEO_CONTEXT_SECTION_BUDGET_CHARS.transcripts);
    expect(sampled.sampled).toBe(true);
    expect(sampled.lines[0]).toContain('number 0');
    expect(sampled.lines.at(-1)).toContain('number 59');
    const markers = sampled.lines.filter((text) => text.includes('omitted]'));
    // Stride sampling: gaps are stated, kept lines spread across the timeline.
    expect(markers.length).toBeGreaterThanOrEqual(1);
    const keptIdxs = sampled.lines
      .filter((text) => !text.includes('omitted]'))
      .map((text) => Number(text.match(/number (\d+)/)![1]));
    // Not everything survives, but the stride reaches deep into the timeline.
    expect(keptIdxs.length).toBeLessThan(60);
    expect(Math.max(...keptIdxs.filter((index) => index !== 59))).toBeGreaterThan(30);
    // The rendered block stays within its budget.
    const totalChars = sampled.lines.reduce((sum, text) => sum + text.length + 1, 0) - 1;
    expect(totalChars).toBeLessThanOrEqual(VIDEO_CONTEXT_SECTION_BUDGET_CHARS.transcripts + 120);
  });

  it('states each dropped stretch once, with its full span', () => {
    const lines = Array.from({ length: 20 }, (_, i) =>
      line(i, `row ${i} with filler text to grow the rendered evidence line size`),
    );
    const sampled = sampleEvidenceLines(lines, 900);
    expect(sampled.sampled).toBe(true);
    const markers = sampled.lines.filter((text) => text.includes('omitted]'));
    for (const marker of markers) {
      const match = marker.match(/\[… (\d+) segments \((\d+\.\d)s-(\d+\.\d)s\) omitted\]/)!;
      expect(Number(match[1])).toBeGreaterThanOrEqual(1);
      expect(Number(match[3])).toBeGreaterThan(Number(match[2]));
    }
    // First and last evidence lines survive no matter what.
    expect(sampled.lines[0]).toContain('row 0');
    expect(sampled.lines.at(-1)).toContain('row 19');
  });

  it('keeps a single over-budget line whole rather than dropping all evidence', () => {
    const sampled = sampleEvidenceLines([line(0, 'x'.repeat(5000))], 1000);
    expect(sampled.lines).toHaveLength(1);
    expect(sampled.sampled).toBe(false);
  });
});
