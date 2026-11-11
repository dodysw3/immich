import {
  MAX_VISIBLE_SOUND_TAGS,
  formatSoundTag,
  getAudioEventsAt,
  parseLatestCompletedAudioEventsRun,
  type VideoAudioEvent,
} from '#lib/utils/video-audio-events.ts';

const event = (label: string, startMs: number, endMs: number, score = 0.5): VideoAudioEvent => ({
  label,
  score,
  startMs,
  endMs,
});

const run = (overrides: Record<string, unknown>) => ({
  model: 'yamnet',
  promptVersion: 'video-audio-events-0.1.0',
  status: 'completed',
  trigger: 'auto-interpret',
  requestedAt: '2026-11-10T01:00:00.000Z',
  finishedAt: '2026-11-10T01:00:01.000Z',
  config: { threshold: 0.15 },
  events: [],
  ...overrides,
});

describe('parseLatestCompletedAudioEventsRun', () => {
  it('returns null for malformed documents', () => {
    expect(parseLatestCompletedAudioEventsRun(undefined)).toBeNull();
    expect(parseLatestCompletedAudioEventsRun('nope')).toBeNull();
    expect(parseLatestCompletedAudioEventsRun({ runs: 'nope' })).toBeNull();
    expect(parseLatestCompletedAudioEventsRun({ runs: {} })).toBeNull();
  });

  it('keeps only well-formed events and drops server-only fields', () => {
    const parsed = parseLatestCompletedAudioEventsRun({
      schemaVersion: 1,
      runs: {
        a: run({
          events: [
            { mid: '/m/02fs_r', label: 'Beep, bleep', score: 0.243, startMs: 4320, endMs: 5280 },
            { label: '', score: 0.9, startMs: 0, endMs: 1000 },
            { label: 'Music', score: 0.6, startMs: 2000, endMs: 2000 },
            { label: 'Water', startMs: 0, endMs: 1000 },
            null,
          ],
        }),
      },
    });
    expect(parsed?.events).toEqual([{ label: 'Beep, bleep', score: 0.243, startMs: 4320, endMs: 5280 }]);
  });

  it('prefers the latest completed run and ignores newer failed or in-flight retags', () => {
    const parsed = parseLatestCompletedAudioEventsRun({
      runs: {
        old: run({ finishedAt: '2026-11-09T00:00:00.000Z', events: [event('Water', 0, 1000)] }),
        current: run({ finishedAt: '2026-11-10T00:00:00.000Z', events: [event('Music', 0, 1000)] }),
        retag: run({ status: 'failed', requestedAt: '2026-11-11T00:00:00.000Z', finishedAt: undefined }),
        running: run({ status: 'running', requestedAt: '2026-11-12T00:00:00.000Z', finishedAt: undefined }),
      },
    });
    expect(parsed?.events.map(({ label }) => label)).toEqual(['Music']);
  });

  it('accepts a completed run without events (silent video)', () => {
    expect(parseLatestCompletedAudioEventsRun({ runs: { a: run({}) } })?.events).toEqual([]);
  });
});

describe('getAudioEventsAt', () => {
  const events = [
    event('Beep, bleep', 4320, 5280, 0.243),
    event('Music', 10_560, 12_960, 0.659),
    event('Keys jangling', 2880, 3840, 0.356),
  ];

  it('returns the events whose window covers the time, end-exclusive', () => {
    expect(getAudioEventsAt(events, 4320).map(({ label }) => label)).toEqual(['Beep, bleep']);
    expect(getAudioEventsAt(events, 5279).map(({ label }) => label)).toEqual(['Beep, bleep']);
    expect(getAudioEventsAt(events, 5280)).toEqual([]);
    expect(getAudioEventsAt(events, 0)).toEqual([]);
  });

  it('orders simultaneous events strongest first and caps the visible count', () => {
    const crowded = [
      event('Animal', 22_080, 22_825, 0.277),
      event('Speech', 17_280, 22_825, 0.997),
      event('Sheep', 22_080, 22_825, 0.378),
      event('Livestock, farm animals, working animals', 22_080, 22_825, 0.398),
      event('Goat', 22_080, 22_825, 0.374),
    ];
    const visible = getAudioEventsAt(crowded, 22_500);
    expect(visible).toHaveLength(MAX_VISIBLE_SOUND_TAGS);
    expect(visible.map(({ label }) => label)).toEqual(['Speech', 'Livestock, farm animals, working animals', 'Sheep']);
  });

  it('does not reorder the caller array', () => {
    const input = [event('A', 0, 1000, 0.2), event('B', 0, 1000, 0.9)];
    getAudioEventsAt(input, 500);
    expect(input.map(({ label }) => label)).toEqual(['A', 'B']);
  });
});

describe('formatSoundTag', () => {
  it('wraps the label in brackets like closed-caption sound descriptions', () => {
    expect(formatSoundTag({ label: 'Beep, bleep' })).toBe('[Beep, bleep]');
  });
});
