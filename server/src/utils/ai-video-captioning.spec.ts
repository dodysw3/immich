import {
  AI_VIDEO_CAPTIONING_PROMPT_VERSION,
  adaptiveSegmentationKey,
  buildCaptionPrompt,
  captionLanguageName,
  createVideoCaptionRunKey,
  fixedSegmentationKey,
  foldCaptionSegment,
  groupFramesBySegment,
  isNoChangeCaption,
  planAdaptiveSegments,
  planCaptionSegments,
  selectWindowFrames,
  stripCaptionOpener,
  stripCaptionThinking,
} from 'src/utils/ai-video-captioning.js';

const seg = (startMs: number, endMs: number, caption: string) => ({ startMs, endMs, caption });

/** 2 fps probe grid: frames every 500ms. */
const times2fps = (count: number) => Array.from({ length: count }, (_, i) => i * 500);

describe('ai-video-captioning utils', () => {
  describe('createVideoCaptionRunKey', () => {
    it('should differ per model, segmentation, and prompt version', () => {
      const base = createVideoCaptionRunKey(
        'lfm3-omni-2b',
        fixedSegmentationKey(5, 3),
        AI_VIDEO_CAPTIONING_PROMPT_VERSION,
      );
      expect(base).toMatch(/^[a-f0-9]{64}$/);
      expect(
        createVideoCaptionRunKey('lfm3-vl-2b', fixedSegmentationKey(5, 3), AI_VIDEO_CAPTIONING_PROMPT_VERSION),
      ).not.toBe(base);
      expect(
        createVideoCaptionRunKey('lfm3-omni-2b', fixedSegmentationKey(3, 2), AI_VIDEO_CAPTIONING_PROMPT_VERSION),
      ).not.toBe(base);
      // adaptive runs key separately from the fixed grid they replace
      expect(
        createVideoCaptionRunKey(
          'lfm3-omni-2b',
          adaptiveSegmentationKey(2, 2, 20, 40),
          AI_VIDEO_CAPTIONING_PROMPT_VERSION,
        ),
      ).not.toBe(base);
    });
  });

  describe('planCaptionSegments', () => {
    it('should produce fixed-width windows', () => {
      const { segments, truncated } = planCaptionSegments(12_000, 5, 300);
      expect(truncated).toBe(false);
      expect(segments).toEqual([
        { startMs: 0, endMs: 5000 },
        { startMs: 5000, endMs: 10_000 },
        { startMs: 10_000, endMs: 12_000 },
      ]);
    });

    it('should drop a trailing sliver shorter than 20% of a segment', () => {
      const { segments } = planCaptionSegments(10_900, 5, 300);
      expect(segments).toEqual([
        { startMs: 0, endMs: 5000 },
        { startMs: 5000, endMs: 10_000 },
      ]);
    });

    it('should cap at maxDurationSec and mark truncation', () => {
      const { segments, truncated } = planCaptionSegments(400_000, 10, 300);
      expect(truncated).toBe(true);
      expect(segments).toHaveLength(30);
      expect(segments.at(-1)).toEqual({ startMs: 290_000, endMs: 300_000 });
    });

    it('should handle zero-duration videos', () => {
      const { segments, truncated } = planCaptionSegments(0, 5, 300);
      expect(truncated).toBe(false);
      expect(segments).toEqual([]);
    });
  });

  describe('groupFramesBySegment', () => {
    it('should place frames at index/fps into their covering segment', () => {
      const fps = 0.6; // ~1.667s between frames
      const framePaths = ['f1', 'f2', 'f3', 'f4'].map((n) => `/tmp/${n}.jpg`);
      const grouped = groupFramesBySegment(framePaths, fps, [
        { startMs: 0, endMs: 5000 },
        { startMs: 5000, endMs: 10_000 },
      ]);
      // frames at 0s, 1.67s, 3.33s, 5s
      expect(grouped[0].framePaths).toEqual(['f1', 'f2', 'f3'].map((n) => `/tmp/${n}.jpg`));
      expect(grouped[0].frameTimesMs).toEqual([0, 1667, 3333]);
      expect(grouped[1].framePaths).toEqual(['/tmp/f4.jpg']);
      expect(grouped[1].frameTimesMs).toEqual([5000]);
    });

    it('should leave segments without frames empty', () => {
      const grouped = groupFramesBySegment(['/tmp/f1.jpg'], 0.6, [
        { startMs: 0, endMs: 5000 },
        { startMs: 5000, endMs: 10_000 },
      ]);
      expect(grouped[1].framePaths).toEqual([]);
    });
  });

  describe('planAdaptiveSegments', () => {
    // scores[i] = change entering frame i (0 for the first frame).
    const defaults = { minSegmentMs: 2000, maxSegmentMs: 20_000, changeBudget: 40, cutThreshold: 35, maxCalls: 27 };

    it('should merge a static video into maxSegmentMs windows', () => {
      const windows = planAdaptiveSegments(
        times2fps(120),
        times2fps(120).map(() => 1),
        defaults,
      );
      expect(windows).toEqual([
        { startMs: 0, endMs: 20_000 },
        { startMs: 20_000, endMs: 40_000 },
        { startMs: 40_000, endMs: 59_501 },
      ]);
    });

    it('should split at a hard cut (score >= cutThreshold)', () => {
      const scores = times2fps(120).map(() => 1);
      scores[20] = 100; // cut entering the 10.0s frame
      const windows = planAdaptiveSegments(times2fps(120), scores, defaults);
      expect(windows[0]).toEqual({ startMs: 0, endMs: 10_000 });
      // the static stretch after the cut runs to its next natural close
      // (budget and maxSegmentMs both trip at the 20s mark)
      expect(windows[1]).toEqual({ startMs: 10_000, endMs: 30_000 });
    });

    it('should split when accumulated change busts the budget', () => {
      const scores = times2fps(120).map(() => 1);
      for (let i = 1; i <= 40; i++) {
        scores[i] = 2; // 40 frames x 2 = 80 accumulated within the first 20s
      }
      const windows = planAdaptiveSegments(times2fps(120), scores, defaults);
      expect(windows[0].endMs).toBeLessThan(20_000);
    });

    it('should tile contiguously and cover through the last frame', () => {
      const scores = times2fps(120).map((_, i) => (i % 30 === 0 ? 60 : 3));
      const windows = planAdaptiveSegments(times2fps(120), scores, defaults);
      for (const [k, window] of windows.entries()) {
        expect(window.endMs).toBeGreaterThan(window.startMs);
        if (k > 0) {
          expect(window.startMs).toBe(windows[k - 1].endMs);
        }
      }
      expect(windows[0].startMs).toBe(0);
      expect(windows.at(-1)!.endMs).toBe(59_500 + 1);
    });

    it('should merge a degenerate final window into its predecessor', () => {
      // cut at 9.5s (frame 19) leaves a 0.5s tail — below minSegmentMs
      const scores = times2fps(20).map(() => 1);
      scores[19] = 100;
      const windows = planAdaptiveSegments(times2fps(20), scores, defaults);
      expect(windows).toEqual([{ startMs: 0, endMs: 9500 + 1 }]);
    });

    it('should cap the call count by merging the least-changed boundaries', () => {
      // bursts every 5s would make 12 windows; cap at 4
      const scores = times2fps(120).map((_, i) => (i % 10 === 0 && i > 0 ? 100 : 1));
      const windows = planAdaptiveSegments(times2fps(120), scores, { ...defaults, maxCalls: 4 });
      expect(windows).toHaveLength(4);
      expect(windows[0].startMs).toBe(0);
      expect(windows.at(-1)!.endMs).toBe(59_501);
    });

    it('should handle empty and single-frame inputs', () => {
      expect(planAdaptiveSegments([], [], defaults)).toEqual([]);
      expect(planAdaptiveSegments([0], [0], defaults)).toEqual([{ startMs: 0, endMs: 1 }]);
    });
  });

  describe('selectWindowFrames', () => {
    const times = Array.from({ length: 80 }, (_, i) => i * 500); // 2 fps, 40s

    it('should keep all frames when the window has at most three', () => {
      const indices = selectWindowFrames(
        times,
        times.map(() => 1),
        { startMs: 0, endMs: 1000 },
      );
      expect(indices).toEqual([0, 1]);
    });

    it('should pick first, max-diff, and last for wide windows', () => {
      const scores = times.map(() => 1);
      scores[30] = 90; // peak change entering the 15.0s frame
      const indices = selectWindowFrames(times, scores, { startMs: 10_000, endMs: 20_000 });
      expect(indices).toEqual([20, 30, 39]); // 10.0s, 15.0s, 19.5s
    });

    it('should dedupe when the peak coincides with the last frame (never the first — peak candidates start at the second frame)', () => {
      const scores = times.map(() => 1);
      scores[39] = 90;
      const indices = selectWindowFrames(times, scores, { startMs: 10_000, endMs: 20_000 });
      expect(indices).toEqual([20, 39]);
    });

    it('should return only frames inside the window', () => {
      const indices = selectWindowFrames(
        times,
        times.map(() => 50),
        { startMs: 5000, endMs: 6000 },
      );
      expect(indices).toEqual([10, 11]);
    });
  });

  describe('buildCaptionPrompt', () => {
    it('should name the language and the segment window', () => {
      const prompt = buildCaptionPrompt({ startMs: 0, endMs: 5000 }, 'en');
      expect(prompt).toContain('0.0s to 5.0s');
      expect(prompt).toContain('English');
      expect(prompt).toContain('Start directly with the subject');
      expect(prompt).not.toContain('audio');
    });

    it('should map language codes to names', () => {
      expect(captionLanguageName('id')).toBe('Indonesian');
      expect(captionLanguageName('xx')).toBe('English');
    });

    it('should build the delta prompt when a previous caption exists (v0.4.1)', () => {
      const prompt = buildCaptionPrompt({ startMs: 15_000, endMs: 20_000 }, 'en', {
        ordinal: 4,
        previous: { caption: 'A woman holds a phone. Text now shows "SAYA?".', startMs: 5000, endMs: 10_000 },
      });
      expect(prompt).toContain('15.0s to 20.0s');
      expect(prompt).toContain('segment 4 of a longer video');
      expect(prompt).toContain('previous described segment (5s-10s) was captioned as: "A woman holds a phone.');
      expect(prompt).toContain('ONLY what is new or changed');
      expect(prompt).toContain('"No change."');
      expect(prompt).toContain('English');
      // v0.4.1: text phrasing is conditional — a false "on-screen text"
      // prefix on non-text changes was the live regression on a market video.
      expect(prompt).toContain('When text actually appears on screen');
      expect(prompt).toContain('do not mention "on-screen text" or "text overlay"');
      expect(prompt).toContain('never write that something is absent');
      expect(prompt).toContain('never refer to "the previous segment"');
      expect(prompt).not.toContain('most important change');
      // The delta prompt replaces the full scene-establishing opener.
      expect(prompt).not.toContain('Start directly with the subject');
      expect(prompt).not.toContain('1-3 sentences');
    });

    it('should keep the full prompt when no previous caption exists', () => {
      const full = buildCaptionPrompt({ startMs: 0, endMs: 5000 }, 'en', { ordinal: 1 });
      expect(full).toContain('1-3 sentences');
      expect(full).toContain('quote it exactly if present');
      expect(full).toContain('do not write absence statements');
      expect(full).not.toContain('ONLY what is new or changed');
    });
  });

  describe('isNoChangeCaption', () => {
    it('should match the delta prompt escape-hatch answer', () => {
      expect(isNoChangeCaption('No change.')).toBe(true);
      expect(isNoChangeCaption('No change')).toBe(true);
      expect(isNoChangeCaption('  no change.  ')).toBe(true);
      expect(isNoChangeCaption('Nothing changed.')).toBe(false);
      expect(isNoChangeCaption('New on-screen text overlay: "SAYA?".')).toBe(false);
      expect(isNoChangeCaption('')).toBe(false);
    });
  });

  describe('foldCaptionSegment', () => {
    it('should append informative captions', () => {
      const folded = foldCaptionSegment([seg(0, 5000, 'A man enters.')], seg(5000, 10_000, 'He sits down.'));
      expect(folded.foldedIntoPrevious).toBe(false);
      expect(folded.segments).toEqual([seg(0, 5000, 'A man enters.'), seg(5000, 10_000, 'He sits down.')]);
    });

    it('should extend the previous window on "No change." instead of storing a no-op row', () => {
      const folded = foldCaptionSegment([seg(0, 5000, 'A man enters.')], seg(5000, 15_000, 'No change.'));
      expect(folded.foldedIntoPrevious).toBe(true);
      expect(folded.segments).toEqual([seg(0, 15_000, 'A man enters.')]);
    });

    it('should fold a verbatim repeat of the previous caption (the model copy failure)', () => {
      const folded = foldCaptionSegment([seg(0, 5000, 'A man enters.')], seg(5000, 10_000, 'A man enters.'));
      expect(folded.foldedIntoPrevious).toBe(true);
      expect(folded.segments).toEqual([seg(0, 10_000, 'A man enters.')]);
    });

    it('should not fold a near-duplicate with different wording', () => {
      const folded = foldCaptionSegment([seg(0, 5000, 'A man enters.')], seg(5000, 10_000, 'The man enters.'));
      expect(folded.foldedIntoPrevious).toBe(false);
      expect(folded.segments).toHaveLength(2);
    });

    it('should store a defensive first-segment "No change." verbatim (nothing to fold into)', () => {
      const folded = foldCaptionSegment([], seg(0, 5000, 'No change.'));
      expect(folded.foldedIntoPrevious).toBe(false);
      expect(folded.segments).toEqual([seg(0, 5000, 'No change.')]);
    });
  });

  describe('stripCaptionOpener', () => {
    it('should strip "The video shows" and capitalize the remainder', () => {
      expect(stripCaptionOpener('The video shows a busy city street under an elevated track.')).toBe(
        'A busy city street under an elevated track.',
      );
    });

    it('should strip frame/clip/footage opener variants', () => {
      expect(stripCaptionOpener('The frames show a man walking.')).toBe('A man walking.');
      expect(stripCaptionOpener('This clip depicts traffic in Jakarta.')).toBe('Traffic in Jakarta.');
    });

    it('should strip "In this/a … scene" scene-setting openers', () => {
      expect(
        stripCaptionOpener(
          'In this busy urban street scene, a man in a blue plaid shirt stands beside a motorcyclist.',
        ),
      ).toBe('A man in a blue plaid shirt stands beside a motorcyclist.');
      expect(
        stripCaptionOpener('In a busy urban street scene, a man in a blue plaid shirt stands beside a motorcyclist.'),
      ).toBe('A man in a blue plaid shirt stands beside a motorcyclist.');
      expect(stripCaptionOpener('In this video the man walks.')).toBe('The man walks.');
    });

    it('should keep "In the foreground," and subject-first captions intact', () => {
      expect(stripCaptionOpener('In the foreground, a man stands.')).toBe('In the foreground, a man stands.');
      expect(stripCaptionOpener('A cat sleeps on a sofa.')).toBe('A cat sleeps on a sofa.');
    });

    it('should leave captions that already start with the subject alone', () => {
      expect(stripCaptionOpener('A cat sleeps on a sofa.')).toBe('A cat sleeps on a sofa.');
      expect(stripCaptionOpener('The man wears a blue shirt.')).toBe('The man wears a blue shirt.');
    });
  });

  describe('stripCaptionThinking', () => {
    it('should remove closed think blocks', () => {
      expect(stripCaptionThinking('<think>reasoning</think>A dog runs.')).toBe('A dog runs.');
    });

    it('should drop an unterminated think block entirely', () => {
      expect(stripCaptionThinking('<think>partial reasoning...')).toBe('');
    });

    it('should pass plain captions through', () => {
      expect(stripCaptionThinking('A cat sleeps on a sofa.')).toBe('A cat sleeps on a sofa.');
    });
  });
});
