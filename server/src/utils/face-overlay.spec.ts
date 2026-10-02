import sharp from 'sharp';
import {
  type OverlayFace,
  buildFaceOverlaySvg,
  estimateTextWidth,
  fitLabelFontSize,
  getFaceReferenceLabels,
  isPlaceholderFaceName,
} from 'src/utils/face-overlay.js';

const face = (id: string, x: number, name?: string): OverlayFace => ({
  id,
  imageWidth: 200,
  imageHeight: 200,
  boundingBoxX1: x,
  boundingBoxX2: x + 40,
  boundingBoxY1: 10,
  boundingBoxY2: 50,
  person: name === undefined ? null : { name },
});

describe('face overlay', () => {
  it.each(['', ' ', '...', '…', undefined])('treats %s as a placeholder', (name) => {
    expect(isPlaceholderFaceName(name)).toBe(true);
  });
  it('uses one position-ordered pool and preserves the placeholder suffix convention', () => {
    const faces = [
      face('empty', 100, ''),
      face('dots', 50, '...'),
      face('named', 0, 'Adi'),
      face('none', 25),
      face('ellipsis', 75, '…'),
    ];
    expect([...getFaceReferenceLabels(faces)]).toEqual([
      ['none', '[1]'],
      ['dots', '[2]'],
      ['ellipsis', '[3]'],
      ['empty', '[4*]'],
    ]);
    expect(faces[0].id).toBe('empty');
    expect(isPlaceholderFaceName('Adi')).toBe(false);
  });
  it('fits between the minimum and maximum font sizes and estimates wide glyphs', () => {
    expect(estimateTextWidth('WWW', 9)).toBeGreaterThan(estimateTextWidth('iii', 9));
    expect(fitLabelFontSize('Adi', 100)).toBe(9);
    expect(fitLabelFontSize('Long name', 1)).toBe(6);
    expect(fitLabelFontSize('Long name', 1, 3)).toBe(18);
    expect(fitLabelFontSize('Adi', 1000, 3)).toBe(27);
  });
  it('renders scaled boxes, references and escaped names', () => {
    expect(buildFaceOverlaySvg([face('named', 10, 'A&B <Adi>'), face('none', 100)], 200, 200)).toMatchSnapshot();
    expect(buildFaceOverlaySvg([face('named', 10, 'A&B <Adi>')], 6000, 6000)).toContain('stroke-width="3"');
  });
  it('wraps only when another face does not occupy the clearance below', () => {
    const named = face('name', 10, 'Adi Longname');
    const below = { ...face('below', 10), boundingBoxY1: 55, boundingBoxY2: 95 };
    const wrapped = buildFaceOverlaySvg([named], 200, 200);
    expect(wrapped.match(/<tspan /g)).toHaveLength(2);
    const crowded = buildFaceOverlaySvg([named, below], 200, 200);
    expect(crowded).toContain('Adi Longname</tspan>');
    expect(crowded).toContain('lengthAdjust="spacingAndGlyphs"');
  });
  it('scales each row from its own stored coordinate space', () => {
    const original = face('a', 10, 'Adi');
    const preview = {
      ...original,
      imageWidth: 100,
      imageHeight: 100,
      boundingBoxX1: 5,
      boundingBoxX2: 25,
      boundingBoxY1: 5,
      boundingBoxY2: 25,
    };
    expect(buildFaceOverlaySvg([preview], 200, 200)).toBe(buildFaceOverlaySvg([original], 200, 200));
  });
  it('preserves the viewer reference numbers when hidden people are removed', () => {
    const hidden = { ...face('hidden', 0, ''), person: { name: '', isHidden: true } };
    const visible = face('visible', 100);
    const labels = getFaceReferenceLabels([hidden, visible]);
    const svg = buildFaceOverlaySvg([visible], 200, 200, labels);
    expect(svg).toContain('[2]</tspan>');
    expect(svg).not.toContain('[1*]');
  });
  it('ignores invalid dimensions and boxes', () => {
    expect(buildFaceOverlaySvg([{ ...face('bad', 0), imageWidth: 0 }], 200, 200)).not.toContain('<rect');
  });
  it('rasterizes visible text with the installed fontconfig fonts', async () => {
    const svg =
      '<svg xmlns="http://www.w3.org/2000/svg" width="200" height="60"><rect width="200" height="60" fill="black"/><text x="10" y="40" font-family="DejaVu Sans" font-size="30" fill="white">Adi</text></svg>';
    const stats = await sharp(Buffer.from(svg)).removeAlpha().stats();
    expect(stats.channels[0].stdev).toBeGreaterThan(10);
  });
});
