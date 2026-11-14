import { RotationSuggestionDocumentSchema } from 'src/dtos/rotation-suggestion.dto.js';
import { createRotationSuggestionRunKey } from 'src/utils/rotation-suggestion.js';

const runKey = 'a'.repeat(64);

const baseRun = {
  model: 'rightwayup',
  tier: 'fast' as const,
  confidence: 0.93,
  status: 'pending' as const,
  startedAt: '2026-11-14T00:00:00.000Z',
  finishedAt: '2026-11-14T00:00:00.050Z',
};

describe('RotationSuggestionDocumentSchema', () => {
  it('accepts a document with a confident pending run', () => {
    const document = {
      schemaVersion: 1,
      runs: { [runKey]: { ...baseRun, predictedRotation: 90, abstain: false } },
    };

    expect(RotationSuggestionDocumentSchema.parse(document)).toEqual(document);
  });

  it('accepts an abstaining run with no rotation class', () => {
    const document = {
      schemaVersion: 1,
      runs: { [runKey]: { ...baseRun, predictedRotation: null, abstain: true, confidence: 0.21 } },
    };

    expect(RotationSuggestionDocumentSchema.parse(document)).toEqual(document);
  });

  it('rejects an abstaining run that carries a rotation class', () => {
    const document = {
      schemaVersion: 1,
      runs: { [runKey]: { ...baseRun, predictedRotation: 180, abstain: true } },
    };

    expect(() => RotationSuggestionDocumentSchema.parse(document)).toThrowError(/must not carry a rotation class/);
  });

  it('rejects a non-abstaining run without a rotation class', () => {
    const document = {
      schemaVersion: 1,
      runs: { [runKey]: { ...baseRun, predictedRotation: null, abstain: false } },
    };

    expect(() => RotationSuggestionDocumentSchema.parse(document)).toThrowError(/must carry a rotation class/);
  });

  it('rejects rotation values outside the 90° grid', () => {
    const document = {
      schemaVersion: 1,
      runs: { [runKey]: { ...baseRun, predictedRotation: 45, abstain: false } },
    };

    expect(() => RotationSuggestionDocumentSchema.parse(document)).toThrowError();
  });

  it('rejects run keys that are not 64-hex', () => {
    const document = {
      schemaVersion: 1,
      runs: { 'not-a-runkey': { ...baseRun, predictedRotation: 0, abstain: false } },
    };

    expect(() => RotationSuggestionDocumentSchema.parse(document)).toThrowError();
  });
});

describe('createRotationSuggestionRunKey', () => {
  it('is a 64-hex digest that changes with each identity component', () => {
    const base = createRotationSuggestionRunKey('rightwayup', 'fast', 'orientation-1.0.0');
    expect(base).toMatch(/^[a-f0-9]{64}$/);
    expect(createRotationSuggestionRunKey('rightwayup', 'balanced', 'orientation-1.0.0')).not.toBe(base);
    expect(createRotationSuggestionRunKey('rightwayup', 'fast', 'orientation-1.0.1')).not.toBe(base);
    expect(createRotationSuggestionRunKey('other-model', 'fast', 'orientation-1.0.0')).not.toBe(base);
  });
});
