/**
 * OCR-assisted duplicate veto.
 *
 * CLIP embeddings cannot separate visually-identical document templates that
 * differ only in small text (dates, reference numbers, amounts) — such pairs
 * sit at smaller embedding distances than true re-copies of the same document.
 * OCR text separates them: same template with different values produces a
 * materially different token bag, while re-copies differ only by OCR jitter.
 *
 * The comparator is a bag of whitespace tokens because PaddleOCR returns
 * boxes in detection order, so the same document can OCR to the same tokens
 * in a different order.
 */

// Collapse runs of the same repeated punctuation character ("…………9365" → "…9365",
// "--" → "-"). OCR dot-leaders and dashes are read with inconsistent counts
// between passes of the same document.
const PUNCTUATION_RUN = /([^\p{L}\p{N}])\1+/gu;

export const ocrTokenBag = (text: string): Set<string> => {
  const bag = new Set<string>();
  for (const token of text.toLowerCase().split(/\s+/)) {
    if (!token) {
      continue;
    }
    bag.add(token.replaceAll(PUNCTUATION_RUN, '$1'));
  }
  return bag;
};

export const ocrTokenBagDiff = (a: string, b: string): number => {
  const bagA = ocrTokenBag(a);
  const bagB = ocrTokenBag(b);

  let diff = 0;
  for (const token of bagA) {
    if (!bagB.has(token)) {
      diff++;
    }
  }
  for (const token of bagB) {
    if (!bagA.has(token)) {
      diff++;
    }
  }
  return diff;
};
