import { render } from '@testing-library/svelte';
import { getIntersectionObserverMock } from '$lib/__mocks__/intersection-observer.mock';
import Thumbnail from '$lib/components/assets/thumbnail/Thumbnail.svelte';
import { showInterpretationTitles } from '$lib/stores/preferences.store';
import { getTabbable } from '$lib/utils/focus-util';
import { assetFactory, timelineAssetFactory } from '@test-data/factories/asset-factory';

vi.mock('$lib/utils/navigation', () => ({
  currentUrlReplaceAssetId: vi.fn(),
  isSharedLinkRoute: vi.fn().mockReturnValue(false),
}));

vi.hoisted(() => {
  Object.defineProperty(globalThis, 'matchMedia', {
    writable: true,
    enumerable: true,
    value: vi.fn().mockImplementation(function (query) {
      return {
        matches: false,
        media: query,
        onchange: null,
        addListener: vi.fn(), // deprecated
        removeListener: vi.fn(), // deprecated
        addEventListener: vi.fn(),
        removeEventListener: vi.fn(),
        dispatchEvent: vi.fn(),
      };
    }),
  });
});

describe('Thumbnail component', () => {
  beforeAll(() => {
    vi.stubGlobal('IntersectionObserver', getIntersectionObserverMock());
  });

  it('should only contain a single tabbable element (the container)', () => {
    const asset = assetFactory.build({ originalPath: 'image.jpg', originalMimeType: 'image/jpeg' });
    const { baseElement } = render(Thumbnail, {
      asset,
      selected: true,
    });

    const container = baseElement.querySelector('[data-thumbnail-focus-container]');
    expect(container).not.toBeNull();
    expect(container!.getAttribute('tabindex')).toBe('0');

    // Guarding against inserting extra tabbable elements in future in <Thumbnail/>
    const tabbables = getTabbable(container!);
    expect(tabbables.length).toBe(0);
  });

  it('shows thumbhash while image is loading', () => {
    const asset = assetFactory.build({ originalPath: 'image.jpg', originalMimeType: 'image/jpeg' });
    const sut = render(Thumbnail, {
      asset,
      selected: true,
    });

    const thumbhash = sut.getByTestId('thumbhash');
    expect(thumbhash).not.toBeFalsy();
  });

  it('hides the interpretation title overlay when the toggle is off', () => {
    showInterpretationTitles.set(false);
    const asset = timelineAssetFactory.build({ aiInterpretationTitle: 'Sunset over the bay' });
    const sut = render(Thumbnail, { asset });

    expect(sut.queryByTestId('interpretation-title')).toBeNull();
    showInterpretationTitles.set(false);
  });

  it('shows the interpretation title overlay when the toggle is on and the asset is interpreted', () => {
    showInterpretationTitles.set(true);
    const asset = timelineAssetFactory.build({ aiInterpretationTitle: 'Sunset over the bay' });
    const sut = render(Thumbnail, { asset });

    expect(sut.getByTestId('interpretation-title').textContent).toContain('Sunset over the bay');
    showInterpretationTitles.set(false);
  });

  it('omits the interpretation title overlay for uninterpreted assets even when enabled', () => {
    showInterpretationTitles.set(true);
    const asset = timelineAssetFactory.build({ aiInterpretationTitle: null });
    const sut = render(Thumbnail, { asset });

    expect(sut.queryByTestId('interpretation-title')).toBeNull();
    showInterpretationTitles.set(false);
  });
});
