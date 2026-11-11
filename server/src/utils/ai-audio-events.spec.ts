import { describe, expect, it } from 'vitest';
import { AUDIOSET_CLASS_MAP } from 'src/constants/audioset-class-map.js';
import {
  AI_AUDIO_EVENTS_MODEL,
  AI_AUDIO_EVENTS_PROMPT_VERSION,
  AudioTagFrame,
  assembleAudioEvents,
  createAudioEventsRunKey,
  isSpeechFamilyAudioEvent,
  renderAudioEventSentences,
} from 'src/utils/ai-audio-events.js';

const indexOf = (label: string) => {
  const index = AUDIOSET_CLASS_MAP.findIndex((entry) => entry.label === label);
  expect(index).toBeGreaterThanOrEqual(0);
  return index;
};

const SPEECH = indexOf('Speech');
const CHILD_SPEECH = indexOf('Child speech, kid speaking');
const BEEP = indexOf('Beep, bleep');
const WATER = indexOf('Water');
const SILENCE = indexOf('Silence');

// YAMNet framing: frame i covers [i * 480, i * 480 + 960] ms, centered at i * 480 + 480.
const frame = (index: number, hits: Array<[number, number]>): AudioTagFrame => ({
  t: index * 480 + 480,
  hits: hits.map(([classIndex, score]) => ({ classIndex, score })),
});

const assemble = (frames: AudioTagFrame[], overrides: Partial<Parameters<typeof assembleAudioEvents>[1]> = {}) =>
  assembleAudioEvents(frames, {
    threshold: 0.15,
    windowMs: 960,
    durationMs: 600_000,
    suppressSpeech: false,
    ...overrides,
  });

describe('ai-audio-events utils', () => {
  describe('createAudioEventsRunKey', () => {
    it('should derive a stable 64-hex key that forks per model, threshold, and policy version', () => {
      const base = createAudioEventsRunKey(AI_AUDIO_EVENTS_MODEL, { threshold: 0.15 }, AI_AUDIO_EVENTS_PROMPT_VERSION);
      expect(base).toMatch(/^[a-f0-9]{64}$/);
      expect(createAudioEventsRunKey(AI_AUDIO_EVENTS_MODEL, { threshold: 0.15 }, AI_AUDIO_EVENTS_PROMPT_VERSION)).toBe(
        base,
      );
      expect(createAudioEventsRunKey('panns-cnn14', { threshold: 0.15 }, AI_AUDIO_EVENTS_PROMPT_VERSION)).not.toBe(
        base,
      );
      expect(
        createAudioEventsRunKey(AI_AUDIO_EVENTS_MODEL, { threshold: 0.2 }, AI_AUDIO_EVENTS_PROMPT_VERSION),
      ).not.toBe(base);
      expect(createAudioEventsRunKey(AI_AUDIO_EVENTS_MODEL, { threshold: 0.15 }, 'video-audio-events-0.2.0')).not.toBe(
        base,
      );
    });
  });

  describe('assembleAudioEvents', () => {
    it('should keep a single above-threshold frame as an event over its full window (bench car beep)', () => {
      const { events } = assemble([frame(9, [[BEEP, 0.2429]]), frame(10, [[BEEP, 0.1396]])]);
      expect(events).toEqual([{ mid: '/m/02fs_r', label: 'Beep, bleep', score: 0.243, startMs: 4320, endMs: 5280 }]);
    });

    it('should merge adjacent frames, bridge gaps up to 0.6 s, and keep the max score', () => {
      const { events } = assemble([
        frame(0, [[WATER, 0.9]]),
        frame(1, [[WATER, 0.98]]),
        // frames 2-3 missing: frame 4 starts 480 ms after frame 1 ends -> bridged
        frame(4, [[WATER, 0.5]]),
        // frames 5-8 missing: frame 9 starts 1440 ms after frame 4 ends -> separate event
        frame(9, [[WATER, 0.7]]),
      ]);
      expect(events).toEqual([
        { mid: AUDIOSET_CLASS_MAP[WATER].mid, label: 'Water', score: 0.98, startMs: 0, endMs: 2880 },
        { mid: AUDIOSET_CLASS_MAP[WATER].mid, label: 'Water', score: 0.7, startMs: 4320, endMs: 5280 },
      ]);
    });

    it('should apply the threshold inclusively', () => {
      const { events } = assemble([frame(0, [[BEEP, 0.15]]), frame(10, [[WATER, 0.149]])]);
      expect(events.map((event) => event.label)).toEqual(['Beep, bleep']);
    });

    it('should clamp spans to the audio duration and drop spans shorter than 0.3 s', () => {
      // last frame of a 14.6 s clip runs 14400-15360 ms; clamped it is 200 ms long
      expect(assemble([frame(30, [[BEEP, 0.5]])], { durationMs: 14_600 }).events).toEqual([]);
      // a 14.805 s clip leaves 405 ms of the same frame
      expect(assemble([frame(30, [[BEEP, 0.5]])], { durationMs: 14_805 }).events).toEqual([
        expect.objectContaining({ startMs: 14_400, endMs: 14_805 }),
      ]);
    });

    it('should drop speech-family events only when told the transcript carries the words', () => {
      const frames = [
        frame(13, [
          [SPEECH, 0.99],
          [CHILD_SPEECH, 0.86],
        ]),
        frame(20, [[BEEP, 0.3]]),
      ];

      const withTranscript = assemble(frames, { suppressSpeech: true });
      expect(withTranscript.events.map((event) => event.label)).toEqual(['Beep, bleep']);
      expect(withTranscript.speechSuppressed).toBe(true);

      const withoutTranscript = assemble(frames, { suppressSpeech: false });
      expect(withoutTranscript.events.map((event) => event.label)).toEqual([
        'Speech',
        'Child speech, kid speaking',
        'Beep, bleep',
      ]);
      expect(withoutTranscript.speechSuppressed).toBe(false);
    });

    it('should not report suppression when no speech event was dropped', () => {
      expect(assemble([frame(1, [[BEEP, 0.3]])], { suppressSpeech: true }).speechSuppressed).toBe(false);
    });

    it('should never turn silence into an event, so a silent video stores an empty list', () => {
      const { events } = assemble([frame(0, [[SILENCE, 0.98]]), frame(1, [[SILENCE, 0.97]])]);
      expect(events).toEqual([]);
    });

    it('should drop recording descriptors (rooms, noise types) but keep sound sources like a TV', () => {
      const { events } = assemble([
        frame(3, [
          [indexOf('Inside, small room'), 0.28],
          [indexOf('Outside, rural or natural'), 0.21],
          [indexOf('Pink noise'), 0.63],
          [indexOf('Field recording'), 0.5],
          [indexOf('Television'), 0.4],
        ]),
      ]);
      expect(events.map((event) => event.label)).toEqual(['Television']);
    });

    it('should ignore class indices outside the class map', () => {
      expect(assemble([frame(0, [[9999, 0.9]])]).events).toEqual([]);
    });

    it('should keep the 20 strongest spans, in time order', () => {
      // 25 isolated beeps (2.4 s apart) with rising scores: the 5 earliest are the weakest.
      const frames = Array.from({ length: 25 }, (_, i) => frame(i * 5, [[BEEP, 0.2 + i * 0.01]]));
      const { events } = assemble(frames);
      expect(events).toHaveLength(20);
      expect(events[0].startMs).toBe(5 * 2400);
      const starts = events.map((event) => event.startMs);
      expect(starts).toEqual(starts.toSorted((a, b) => a - b));
    });

    it('should suppress speech before capping so speech never takes a sound event slot', () => {
      const frames = [
        ...Array.from({ length: 20 }, (_, i) => frame(i * 5, [[SPEECH, 0.99]])),
        frame(200, [[BEEP, 0.2]]),
      ];
      const { events } = assemble(frames, { suppressSpeech: true });
      expect(events.map((event) => event.label)).toEqual(['Beep, bleep']);
    });
  });

  describe('isSpeechFamilyAudioEvent', () => {
    it('should cover the AudioSet speech subtree but not other human sounds', () => {
      expect(isSpeechFamilyAudioEvent({ mid: AUDIOSET_CLASS_MAP[SPEECH].mid })).toBe(true);
      expect(isSpeechFamilyAudioEvent({ mid: AUDIOSET_CLASS_MAP[CHILD_SPEECH].mid })).toBe(true);
      expect(isSpeechFamilyAudioEvent({ mid: AUDIOSET_CLASS_MAP[indexOf('Babbling')].mid })).toBe(true);
      expect(isSpeechFamilyAudioEvent({ mid: AUDIOSET_CLASS_MAP[indexOf('Whispering')].mid })).toBe(false);
      expect(
        isSpeechFamilyAudioEvent({ mid: AUDIOSET_CLASS_MAP[indexOf('Hubbub, speech noise, speech babble')].mid }),
      ).toBe(false);
      expect(isSpeechFamilyAudioEvent({ mid: AUDIOSET_CLASS_MAP[BEEP].mid })).toBe(false);
    });
  });
});

const rendererEvent = (label: string, mid: string, startMs: number, endMs: number, score = 0.5) => ({
  label,
  mid,
  score,
  startMs,
  endMs,
});

describe('renderAudioEventSentences', () => {
  const WATER_MID = AUDIOSET_CLASS_MAP[indexOf('Water')].mid;
  const OCEAN_MID = AUDIOSET_CLASS_MAP[indexOf('Ocean')].mid;
  const WAVES_MID = AUDIOSET_CLASS_MAP[indexOf('Waves, surf')].mid;
  const FAN_MID = AUDIOSET_CLASS_MAP[indexOf('Mechanical fan')].mid;

  it('maps classes to natural sentences', () => {
    const lines = renderAudioEventSentences([rendererEvent('Beep, bleep', '/m/02fs_r', 4320, 5280, 0.24)], {
      transcriptHasWords: true,
    });
    expect(lines).toEqual([{ startMs: 4320, endMs: 5280, sentence: 'An electronic beep is heard.' }]);
  });

  it('falls back to a generic sentence for unlisted classes', () => {
    const lines = renderAudioEventSentences([rendererEvent('Tambourine', '/m/0mkgx', 11_040, 12_000)], {
      transcriptHasWords: false,
    });
    expect(lines[0].sentence).toBe('A sound like tambourine is heard.');
  });

  it('merges sibling classes sharing a sentence into one spanning line (river water family)', () => {
    const lines = renderAudioEventSentences(
      [
        rendererEvent('Ocean', OCEAN_MID, 0, 81_120, 0.98),
        rendererEvent('Water', WATER_MID, 0, 81_120, 0.98),
        rendererEvent('Waves, surf', WAVES_MID, 0, 81_120, 0.96),
        rendererEvent('Ocean', OCEAN_MID, 82_560, 118_080, 0.88), // 1.4 s gap: still bridged
        rendererEvent('Ocean', OCEAN_MID, 119_040, 135_509, 0.92), // 1 s gap after: still bridged
      ],
      { transcriptHasWords: false },
    );
    expect(lines).toEqual([{ startMs: 0, endMs: 135_509, sentence: 'Rushing or flowing water is heard.' }]);
  });

  it('keeps separate spans of the same sentence apart past the render merge gap', () => {
    const lines = renderAudioEventSentences(
      [rendererEvent('Music', '/m/04wxj', 480, 6240, 0.84), rendererEvent('Music', '/m/04wxj', 14_400, 15_360, 0.18)],
      { transcriptHasWords: true },
    );
    expect(lines.map(({ startMs, endMs }) => [startMs, endMs])).toEqual([
      [480, 6240],
      [14_400, 15_360],
    ]);
  });

  it('keeps at most two spans per sentence, the strongest', () => {
    const frames = Array.from({ length: 10 }, (_, i) =>
      rendererEvent('Beep, bleep', '/m/02fs_r', i * 10_000, i * 10_000 + 960, 0.2 + i * 0.01),
    );
    const lines = renderAudioEventSentences(frames, { transcriptHasWords: true });
    // the two highest-scoring spans (i = 8, 9), back in time order
    expect(lines.map(({ startMs }) => startMs)).toEqual([80_000, 90_000]);
  });

  it('drops weak voice events on a no-speech transcript but keeps strong ones', () => {
    const lines = renderAudioEventSentences(
      [
        rendererEvent('Speech', '/m/09x0r', 112_320, 114_240, 0.47),
        rendererEvent('Child speech, kid speaking', '/m/0ytgt', 6720, 11_040, 0.86),
      ],
      { transcriptHasWords: false },
    );
    expect(lines).toEqual([{ startMs: 6720, endMs: 11_040, sentence: "A child's voice is heard." }]);
  });

  it('drops all voice events when the transcript carries the words', () => {
    const lines = renderAudioEventSentences(
      [
        rendererEvent('Speech', '/m/09x0r', 2880, 14_400, 0.95),
        rendererEvent('Beep, bleep', '/m/02fs_r', 4320, 5280, 0.24),
      ],
      { transcriptHasWords: true },
    );
    expect(lines).toEqual([{ startMs: 4320, endMs: 5280, sentence: 'An electronic beep is heard.' }]);
  });

  it('caps the total lines at 12, strongest first, then re-sorts in time order', () => {
    // 14 distinct fallback sentences (unique labels) + one strong fan: 15 lines -> 12 kept
    const many = [
      ...Array.from({ length: 14 }, (_, i) =>
        rendererEvent(`Thing ${i}`, `/x/${i}`, i * 10_000, i * 10_000 + 960, 0.2 + i * 0.01),
      ),
      rendererEvent('Mechanical fan', FAN_MID, 500, 3000, 0.9),
    ];
    const lines = renderAudioEventSentences(many, { transcriptHasWords: true });
    expect(lines).toHaveLength(12);
    expect(lines[0]).toMatchObject({ sentence: 'A fan is running.', startMs: 500 });
    expect(lines.map(({ startMs }) => startMs)).toEqual(lines.map(({ startMs }) => startMs).toSorted((a, b) => a - b));
    // the weakest things (the earliest ones) lost their slots
    expect(lines.some(({ sentence }) => sentence === 'A sound like thing 0 is heard.')).toBe(false);
    expect(lines.some(({ sentence }) => sentence === 'A sound like thing 13 is heard.')).toBe(true);
  });
});
