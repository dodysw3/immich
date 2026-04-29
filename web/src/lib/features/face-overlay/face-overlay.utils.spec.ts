import { getFaceLabelCompensation } from '$lib/features/face-overlay/face-overlay.utils';

describe('getFaceLabelCompensation', () => {
  it('keeps labels at their original size when zooming in', () => {
    expect(getFaceLabelCompensation(2, 4)).toEqual({ scale: 0.5, gap: 2 });
    expect(getFaceLabelCompensation(4, 4)).toEqual({ scale: 0.25, gap: 1 });
  });

  it('does not upscale labels below the base zoom', () => {
    expect(getFaceLabelCompensation(1, 4)).toEqual({ scale: 1, gap: 4 });
    expect(getFaceLabelCompensation(0.5, 4)).toEqual({ scale: 1, gap: 4 });
  });
});
