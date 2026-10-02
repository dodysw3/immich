export interface OverlayFace {
  id: string;
  imageWidth: number;
  imageHeight: number;
  boundingBoxX1: number;
  boundingBoxX2: number;
  boundingBoxY1: number;
  boundingBoxY2: number;
  person?: { name: string; isHidden?: boolean } | null;
}

export const isPlaceholderFaceName = (name: string | undefined): boolean =>
  new Set(['', '...', '…']).has(name?.trim() ?? '');

export const getFaceReferenceLabels = (faces: OverlayFace[]): Map<string, string> => {
  const labels = new Map<string, string>();
  const numbered = faces
    .filter((face) => !face.person || isPlaceholderFaceName(face.person.name))
    .sort((a, b) => a.boundingBoxX1 - b.boundingBoxX1 || a.boundingBoxY1 - b.boundingBoxY1);
  let counter = 0;
  for (const face of numbered) {
    counter += 1;
    const suffix = face.person && face.person.name.trim() === '' ? '*' : '';
    labels.set(face.id, `[${counter}${suffix}]`);
  }
  return labels;
};

// DejaVu Sans advance widths in em; unknown glyphs use the average advance.
const widths: Record<string, number> = {};
for (const [characters, width] of [
  [' ilI.,!:;|', 0.28],
  ['fjrt()[]', 0.39],
  ['abcdeghknopqsuvxyz0123456789', 0.61],
  ['mw', 0.88],
  ['ABCDEFGHKNOPQRSTUVXYZ', 0.69],
  ['MW', 0.94],
  ['L', 0.56],
  ['…', 1],
] as const) {
  for (const character of characters) {
    widths[character] = width;
  }
}
export const estimateTextWidth = (text: string, fontSize: number): number =>
  [...text].reduce((sum, character) => sum + (widths[character] ?? 0.54), 0) * fontSize;

export const fitLabelFontSize = (text: string, width: number, scale = 1): number => {
  const max = 9 * scale;
  const min = 6 * scale;
  const measured = estimateTextWidth(text, max);
  return measured <= width ? max : Math.max(min, Math.floor((max * Math.max(0, width)) / measured));
};
const escapeXml = (text: string): string =>
  text.replaceAll(
    /[&<>"']/g,
    (character) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&apos;' })[character]!,
  );

export const buildFaceOverlaySvg = (
  faces: OverlayFace[],
  renderedWidth: number,
  renderedHeight: number,
  labels = getFaceReferenceLabels(faces),
): string => {
  const scale = Math.max(1, Math.min(10, renderedWidth / 2000));
  const boxes = faces
    .filter((face) => face.imageWidth > 0 && face.imageHeight > 0)
    .map((face) => ({
      face,
      x: (face.boundingBoxX1 * renderedWidth) / face.imageWidth,
      y: (face.boundingBoxY1 * renderedHeight) / face.imageHeight,
      width: ((face.boundingBoxX2 - face.boundingBoxX1) * renderedWidth) / face.imageWidth,
      height: ((face.boundingBoxY2 - face.boundingBoxY1) * renderedHeight) / face.imageHeight,
    }))
    .filter((box) => box.width > 0 && box.height > 0);
  const elements = boxes.map((box) => {
    const { face, x, y, width, height } = box;
    const bottom = y + height;
    const text = (isPlaceholderFaceName(face.person?.name) ? (labels.get(face.id) ?? '…') : face.person!.name).trim();
    const available = Math.max(1, width - 8 * scale);
    const words = text.split(/\s+/);
    const hasFaceBelow = boxes.some(
      (other) =>
        other !== box &&
        other.y >= bottom &&
        other.y <= bottom + 40 * scale &&
        other.x + other.width > x &&
        other.x < x + width,
    );
    const wrap = words.length > 1 && !hasFaceBelow;
    let widest = text;
    if (wrap) {
      widest = '';
      for (const word of words) {
        if (estimateTextWidth(word, 1) > estimateTextWidth(widest, 1)) {
          widest = word;
        }
      }
    }
    const fontSize = fitLabelFontSize(widest, available, scale);
    const lines: string[] = [];
    if (wrap) {
      let line = '';
      for (const word of words) {
        const next = line ? `${line} ${word}` : word;
        if (line && estimateTextWidth(next, fontSize) > available) {
          lines.push(line);
          line = word;
        } else {
          line = next;
        }
      }
      lines.push(line);
    } else {
      lines.push(text);
    }
    const lineHeight = fontSize * 1.25;
    const chipHeight = lines.length * lineHeight + 4 * scale;
    const spans = lines
      .map((line, index) => {
        const fit =
          estimateTextWidth(line, fontSize) > available
            ? ` textLength="${available}" lengthAdjust="spacingAndGlyphs"`
            : '';
        return `<tspan x="${x + width / 2}" y="${bottom + 2 * scale + fontSize + index * lineHeight}"${fit}>${escapeXml(line)}</tspan>`;
      })
      .join('');
    return (
      `<rect x="${x}" y="${y}" width="${width}" height="${height}" rx="${8 * scale}" fill="none" stroke="#22c55e" stroke-width="${scale}"/>` +
      `<rect x="${x}" y="${bottom}" width="${width}" height="${chipHeight}" fill="black" fill-opacity="0.5"/>` +
      `<text font-family="DejaVu Sans" font-size="${fontSize}" fill="white" text-anchor="middle">${spans}</text>`
    );
  });
  return `<svg xmlns="http://www.w3.org/2000/svg" width="${renderedWidth}" height="${renderedHeight}">${elements.join('')}</svg>`;
};
