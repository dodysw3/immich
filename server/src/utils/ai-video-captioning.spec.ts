import {
  AI_VIDEO_CAPTIONING_PROMPT_VERSION,
  buildCaptionPrompt,
  captionLanguageName,
  createVideoCaptionRunKey,
  groupFramesBySegment,
  isNoChangeCaption,
  planCaptionSegments,
  stripCaptionOpener,
  stripCaptionThinking,
} from 'src/utils/ai-video-captioning.js';

describe('ai-video-captioning utils', () => {
  describe('createVideoCaptionRunKey', () => {
    it('should differ per model, segmentation, and prompt version', () => {
      const base = createVideoCaptionRunKey('lfm3-omni-2b', 5, 3, AI_VIDEO_CAPTIONING_PROMPT_VERSION);
      expect(base).toMatch(/^[a-f0-9]{64}$/);
      expect(createVideoCaptionRunKey('lfm3-vl-2b', 5, 3, AI_VIDEO_CAPTIONING_PROMPT_VERSION)).not.toBe(base);
      expect(createVideoCaptionRunKey('lfm3-omni-2b', 3, 2, AI_VIDEO_CAPTIONING_PROMPT_VERSION)).not.toBe(base);
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

    it('should build the delta prompt when a previous caption exists (v0.4.0)', () => {
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
      // The delta prompt replaces the full scene-establishing opener.
      expect(prompt).not.toContain('Start directly with the subject');
      expect(prompt).not.toContain('1-3 sentences');
    });

    it('should keep the full prompt when no previous caption exists', () => {
      const full = buildCaptionPrompt({ startMs: 0, endMs: 5000 }, 'en', { ordinal: 1 });
      expect(full).toContain('1-3 sentences');
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
