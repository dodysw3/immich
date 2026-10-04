import {
  AiInterpretationDocumentSchema,
  MuseInterpretationResultSchema,
} from 'src/dtos/ai-image-interpretation.dto.js';

const runKey = 'a'.repeat(64);

const result = {
  title: 'A morning market scene',
  literal_description: 'Two people walk between market stalls.',
  interpretation: 'Everyday commerce in a tropical town.',
  notable_details: [{ detail: 'Woven baskets', significance: 'Local craft', confidence: 'high' as const }],
  identifications: [],
  archive_summary: 'Market documentation',
  search_keywords: ['market'],
};

const baseRun = {
  model: 'model-a',
  quant: 'quant-a',
  promptVersion: 'prompt-a',
  trigger: 'upload' as const,
  requestedAt: '2026-10-04T00:00:00.000Z',
};

describe('AiInterpretationDocumentSchema', () => {
  it('accepts a document with a completed run', () => {
    const document = {
      schemaVersion: 1,
      runs: { [runKey]: { ...baseRun, status: 'completed', finishedAt: '2026-10-04T00:01:00.000Z', result } },
    };

    expect(AiInterpretationDocumentSchema.parse(document)).toEqual(document);
  });

  it('accepts and preserves a run annotated with copiedFrom provenance', () => {
    const document = {
      schemaVersion: 1,
      runs: {
        [runKey]: {
          ...baseRun,
          status: 'completed',
          finishedAt: '2026-10-04T00:01:00.000Z',
          result,
          copiedFrom: {
            assetId: '0b249b2c-3f4e-4c5d-8a9b-0c1d2e3f4a5b',
            runKey: 'b'.repeat(64),
            model: 'model-b',
            quant: 'quant-b',
            promptVersion: 'prompt-b',
            copiedAt: '2026-10-04T00:02:00.000Z',
          },
        },
      },
    };

    // The annotation must survive a read/write cycle: zod strips unknown keys,
    // so an undeclared field would silently vanish from the stored document.
    expect(AiInterpretationDocumentSchema.parse(document)).toEqual(document);
  });

  it('rejects an invalid copiedFrom annotation', () => {
    const document = {
      schemaVersion: 1,
      runs: {
        [runKey]: {
          ...baseRun,
          status: 'completed',
          result,
          copiedFrom: { assetId: 'not-a-uuid', copiedAt: '2026-10-04T00:02:00.000Z' },
        },
      },
    };

    expect(AiInterpretationDocumentSchema.safeParse(document).success).toBe(false);
  });

  it('keeps requiring a result for completed runs', () => {
    const document = { schemaVersion: 1, runs: { [runKey]: { ...baseRun, status: 'completed' } } };

    expect(AiInterpretationDocumentSchema.safeParse(document).success).toBe(false);
  });

  it('validates model outputs against the canonical result shape', () => {
    expect(MuseInterpretationResultSchema.safeParse(result).success).toBe(true);
    expect(MuseInterpretationResultSchema.safeParse({ ...result, title: undefined }).success).toBe(false);
  });
});
