import { describe, expect, it } from 'vitest';
import {
  AI_IMAGE_INTERPRETATION_MODEL,
  AI_IMAGE_INTERPRETATION_PROMPT,
  AI_IMAGE_INTERPRETATION_PROMPT_VERSION,
  AI_IMAGE_INTERPRETATION_QUANT,
  AI_INTERPRETATION_RETRY_MAX_MS,
  createAiInterpretationRunKey,
  interpretationRetryDelayMs,
} from 'src/utils/ai-image-interpretation.js';

describe('AI image interpretation contract', () => {
  it('derives a stable run key from the exact tuple', () => {
    expect(
      createAiInterpretationRunKey(
        AI_IMAGE_INTERPRETATION_MODEL,
        AI_IMAGE_INTERPRETATION_QUANT,
        AI_IMAGE_INTERPRETATION_PROMPT_VERSION,
      ),
    ).toBe('a6bb4076501b5e5f7cf7b69d0631f6dfc50ebdfb07c9c708e497ed58b10f44d2');
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

      No Immich face matches, person IDs, or associated names are provided. Do not guess or invent a person's identity. You may name someone only when they are a widely known public figure and you have great confidence from clear, distinctive visual evidence in this image. Otherwise use a generic description such as "a person" and put the identity limitation in uncertainties. A name is a model claim, not a verified fact. Do not infer sensitive personal traits. Do not infer exact places, dates, authorship, brands, or events unless visible evidence strongly supports them.

      Return only JSON matching the supplied schema. Keep literal_description observational. Put hypotheses in interpretation or alternative_interpretations, state their evidence, and include meaningful uncertainty. Never promote a low-confidence identification into title, archive_summary, or search_keywords."
    `);
    expect(AI_IMAGE_INTERPRETATION_PROMPT).not.toContain('filename');
    expect(AI_IMAGE_INTERPRETATION_PROMPT).not.toContain('GPS');
    expect(AI_IMAGE_INTERPRETATION_PROMPT_VERSION).toBe('image-interpretation-1.0.0');
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
});
