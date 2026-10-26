import { boxesIoMin, isWrappedDuplicate } from 'src/utils/face-box.js';

describe('boxesIoMin', () => {
  it('should return 1 when one box fully wraps the other', () => {
    expect(boxesIoMin({ x1: 0, y1: 0, x2: 100, y2: 100 }, { x1: 25, y1: 25, x2: 75, y2: 75 })).toBe(1);
  });

  it('should return partial overlap for boxes sticking out', () => {
    expect(boxesIoMin({ x1: 0, y1: 0, x2: 100, y2: 100 }, { x1: 10, y1: 10, x2: 95, y2: 120 })).toBeCloseTo(0.82, 2);
  });

  it('should return 0 for disjoint boxes', () => {
    expect(boxesIoMin({ x1: 0, y1: 0, x2: 10, y2: 10 }, { x1: 50, y1: 50, x2: 60, y2: 60 })).toBe(0);
  });
});

describe('isWrappedDuplicate', () => {
  it('should detect a loose box wrapping a tight box of the same face', () => {
    const loose = { x1: 953, y1: 1380, x2: 1237, y2: 1722 };
    const tight = { x1: 962, y1: 1455, x2: 1162, y2: 1690 };
    expect(isWrappedDuplicate(loose, tight)).toBe(true);
    expect(isWrappedDuplicate(tight, loose)).toBe(true);
  });

  it('should not count a small face near the edge of a big box', () => {
    const big = { x1: 0, y1: 0, x2: 100, y2: 100 };
    const corner = { x1: 0, y1: 0, x2: 6, y2: 6 };
    expect(isWrappedDuplicate(big, corner)).toBe(false);
  });

  it('should not count a tiny box in the middle of a big box', () => {
    const big = { x1: 0, y1: 0, x2: 100, y2: 100 };
    const tiny = { x1: 45, y1: 45, x2: 55, y2: 55 };
    expect(isWrappedDuplicate(big, tiny)).toBe(false);
  });

  it('should not count partially overlapping boxes', () => {
    expect(isWrappedDuplicate({ x1: 0, y1: 0, x2: 100, y2: 100 }, { x1: 50, y1: 50, x2: 150, y2: 150 })).toBe(false);
  });

  it('should handle degenerate boxes', () => {
    expect(isWrappedDuplicate({ x1: 0, y1: 0, x2: 0, y2: 0 }, { x1: 0, y1: 0, x2: 0, y2: 0 })).toBe(false);
  });
});
