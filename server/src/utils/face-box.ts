export interface Box {
  x1: number;
  y1: number;
  x2: number;
  y2: number;
}

const area = (box: Box): number => Math.max(0, box.x2 - box.x1) * Math.max(0, box.y2 - box.y1);

// intersection over the smaller box's area — 1.0 when one box fully wraps the other
export const boxesIoMin = (a: Box, b: Box): number => {
  const x1 = Math.max(a.x1, b.x1);
  const y1 = Math.max(a.y1, b.y1);
  const x2 = Math.min(a.x2, b.x2);
  const y2 = Math.min(a.y2, b.y2);
  const intersection = Math.max(0, x2 - x1) * Math.max(0, y2 - y1);
  const smaller = Math.min(area(a), area(b));
  return smaller > 0 ? intersection / smaller : 0;
};

// the same face seen at two box scales (a loose box fully around a tight one, e.g. a
// metadata region vs an ML detection) — plain IoU misses these pairs whenever the loose
// box is much larger. A different face merely sitting inside a big box (background or
// adjacent person) has a shifted center and/or a much smaller area, and must not count.
export const isWrappedDuplicate = (a: Box, b: Box): boolean => {
  if (boxesIoMin(a, b) < 0.9) {
    return false;
  }

  const outer = area(a) >= area(b) ? a : b;
  const inner = outer === a ? b : a;
  const outerArea = area(outer);
  if (outerArea <= 0 || outer.x2 <= outer.x1 || outer.y2 <= outer.y1) {
    return false;
  }

  // centers must nearly coincide, relative to the outer box's dimensions
  const centerOffsetX = Math.abs((a.x1 + a.x2) / 2 - (b.x1 + b.x2) / 2) / (outer.x2 - outer.x1);
  const centerOffsetY = Math.abs((a.y1 + a.y2) / 2 - (b.y1 + b.y2) / 2) / (outer.y2 - outer.y1);
  if (Math.max(centerOffsetX, centerOffsetY) > 0.2) {
    return false;
  }

  // and the inner box must be a substantial fraction of the outer one
  return area(inner) / outerArea >= 0.2;
};
