import { describe, expect, it } from 'vitest';
import type { AiInterpretationDocument, MuseInterpretationResult } from 'src/dtos/ai-image-interpretation.dto.js';
import {
  buildAiInterpretDenseDoc,
  buildAiInterpretLexicalDoc,
  findLatestCompletedRun,
} from 'src/utils/ai-interpret-search.js';

const interpretResult: MuseInterpretationResult = {
  title: 'Children playing on the floor',
  literal_description: 'Two children play with wooden blocks on a laminate floor.',
  interpretation: 'A family moment: kids play while adults watch television nearby.',
  notable_details: [
    {
      detail: 'Wooden blocks scattered mid-build',
      significance: 'Suggests play was interrupted recently.',
      confidence: 'high',
    },
    {
      detail: 'Sofa visible in the background',
      significance: 'Anchors the scene to a living room.',
      confidence: 'medium',
    },
  ],
  identifications: [
    { name: 'Sofa', type: 'object', confidence: 'high', basis: 'Distinct shape and fabric texture.' },
    { name: 'Ria', type: 'person', confidence: 'low', basis: 'Partially visible profile.' },
  ],
  archive_summary: 'Family living-room scene with children playing.',
  search_keywords: ['family', 'children playing', 'living room', 'blocks'],
};

const run = (over: Partial<AiInterpretationDocument['runs'][string]>) => ({
  model: 'm',
  quant: 'q',
  promptVersion: 'p',
  status: 'completed' as const,
  trigger: 'upload' as const,
  requestedAt: '2026-09-01T00:00:00.000Z',
  ...over,
});

describe('buildAiInterpretDenseDoc', () => {
  it('includes all grounded fields', () => {
    const doc = buildAiInterpretDenseDoc(interpretResult);

    expect(doc.split('\n')).toEqual([
      'Children playing on the floor',
      'Two children play with wooden blocks on a laminate floor.',
      'A family moment: kids play while adults watch television nearby.',
      'Wooden blocks scattered mid-build',
      'Suggests play was interrupted recently.',
      'Sofa visible in the background',
      'Anchors the scene to a living room.',
      'family',
      'children playing',
      'living room',
      'blocks',
    ]);
  });

  it('excludes speculative fields', () => {
    const doc = buildAiInterpretDenseDoc(interpretResult);

    expect(doc).not.toContain('Documents everyday family life at home');
    expect(doc).not.toContain('daycare rather than home');
    expect(doc).not.toContain('relationship between the people');
    expect(doc).not.toContain('Warm indoor lighting');
  });

  it('skips empty parts instead of emitting blank lines', () => {
    const doc = buildAiInterpretDenseDoc({
      ...interpretResult,
      title: '',
      notable_details: [],
      search_keywords: [],
    });

    expect(doc).toBe(
      'Two children play with wooden blocks on a laminate floor.\nA family moment: kids play while adults watch television nearby.',
    );
  });
});

describe('buildAiInterpretLexicalDoc', () => {
  it('joins title, keywords, and identification names with spaces', () => {
    expect(buildAiInterpretLexicalDoc(interpretResult)).toBe(
      'Children playing on the floor family children playing living room blocks Sofa Ria',
    );
  });

  it('excludes prose fields so trigram hits stay on named entities', () => {
    const doc = buildAiInterpretLexicalDoc(interpretResult);

    expect(doc).not.toContain('laminate floor');
    expect(doc).not.toContain('family moment');
  });
});

describe('findLatestCompletedRun', () => {
  it('returns the latest completed run by finishedAt', () => {
    const document: AiInterpretationDocument = {
      schemaVersion: 1,
      runs: {
        aaa: run({ finishedAt: '2026-09-02T00:00:00.000Z', result: interpretResult }),
        bbb: run({ finishedAt: '2026-09-03T00:00:00.000Z', result: interpretResult }),
        ccc: run({ status: 'failed', error: { code: 'x', message: 'x' }, finishedAt: '2026-09-04T00:00:00.000Z' }),
      },
    };

    expect(findLatestCompletedRun(document)?.runKey).toBe('bbb');
  });

  it('ignores documents without a completed run', () => {
    expect(findLatestCompletedRun(null)).toBeNull();
    expect(findLatestCompletedRun({ schemaVersion: 1, runs: {} })).toBeNull();
    expect(findLatestCompletedRun({ schemaVersion: 1, runs: { aaa: run({ status: 'running' }) } })).toBeNull();
  });
});
