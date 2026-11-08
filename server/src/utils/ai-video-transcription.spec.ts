import { describe, expect, it } from 'vitest';
import {
  AI_VIDEO_TRANSCRIPTION_PROMPT_VERSION,
  createVideoTranscriptionRunKey,
  isTranscriptionSegmentAudible,
} from 'src/utils/ai-video-transcription.js';

describe('ai-video-transcription utils', () => {
  describe('createVideoTranscriptionRunKey', () => {
    it('should derive a stable 64-hex key that differs per model and recipe version', () => {
      const base = createVideoTranscriptionRunKey('faster-whisper-large-v3', AI_VIDEO_TRANSCRIPTION_PROMPT_VERSION);
      expect(base).toMatch(/^[a-f0-9]{64}$/);
      expect(createVideoTranscriptionRunKey('faster-whisper-medium', AI_VIDEO_TRANSCRIPTION_PROMPT_VERSION)).not.toBe(
        base,
      );
      expect(createVideoTranscriptionRunKey('faster-whisper-large-v3', 'video-transcription-0.3.0')).not.toBe(base);
    });
  });

  describe('isTranscriptionSegmentAudible', () => {
    it('should keep confident speech segments', () => {
      expect(isTranscriptionSegmentAudible({ noSpeechProb: 0.1, avgLogProb: -0.5 })).toBe(true);
    });

    it('should drop low-speech-probability and low-confidence segments (the noise hallucination guard)', () => {
      expect(isTranscriptionSegmentAudible({ noSpeechProb: 0.9, avgLogProb: -1.5 })).toBe(false);
    });

    it('should keep borderline segments that fail only one of the two thresholds', () => {
      // confident log-prob even with elevated no-speech probability
      expect(isTranscriptionSegmentAudible({ noSpeechProb: 0.9, avgLogProb: -0.5 })).toBe(true);
      // low confidence but speech likely present
      expect(isTranscriptionSegmentAudible({ noSpeechProb: 0.1, avgLogProb: -1.5 })).toBe(true);
    });

    it('should treat missing metadata as audible (never silently drop segments)', () => {
      expect(isTranscriptionSegmentAudible({})).toBe(true);
    });
  });
});
