import { assetViewerManager } from '$lib/managers/asset-viewer-manager.svelte';
import { zoomImageAction } from '$lib/actions/zoom-image';
import { beforeEach, describe, expect, it, vi } from 'vitest';

const zoomHandlerState = {
  pointerDownCalls: 0,
  touchStartCalls: 0,
};

vi.mock('@zoom-image/core', () => ({
  createZoomImageWheel: (node: HTMLElement) => {
    node.addEventListener('pointerdown', () => {
      zoomHandlerState.pointerDownCalls++;
    });
    node.addEventListener('touchstart', () => {
      zoomHandlerState.touchStartCalls++;
    });

    return {
      cleanup: vi.fn(),
      setState: vi.fn(),
      subscribe: vi.fn(() => vi.fn()),
    };
  },
}));

describe('zoomImageAction', () => {
  beforeEach(() => {
    zoomHandlerState.pointerDownCalls = 0;
    zoomHandlerState.touchStartCalls = 0;
    assetViewerManager.cancelZoomAnimation = vi.fn();
  });

  it('stops zoom pointer handling for ignored descendants', () => {
    const node = document.createElement('div');
    const ignoredChild = document.createElement('button');
    ignoredChild.dataset.zoomImageIgnore = 'true';
    node.append(ignoredChild);

    const action = zoomImageAction(node, { ignoreSelector: '[data-zoom-image-ignore]' });

    ignoredChild.dispatchEvent(new PointerEvent('pointerdown', { bubbles: true }));

    expect(zoomHandlerState.pointerDownCalls).toBe(0);
    expect(assetViewerManager.cancelZoomAnimation).toHaveBeenCalledOnce();

    action.destroy();
  });

  it('still lets normal viewer pointer interactions reach the zoom handler', () => {
    const node = document.createElement('div');
    const child = document.createElement('div');
    node.append(child);

    const action = zoomImageAction(node, { ignoreSelector: '[data-zoom-image-ignore]' });

    child.dispatchEvent(new PointerEvent('pointerdown', { bubbles: true }));

    expect(zoomHandlerState.pointerDownCalls).toBe(1);
    expect(assetViewerManager.cancelZoomAnimation).toHaveBeenCalledOnce();

    action.destroy();
  });

  it('stops zoom touch handling for ignored descendants', () => {
    const node = document.createElement('div');
    const ignoredChild = document.createElement('button');
    ignoredChild.dataset.zoomImageIgnore = 'true';
    node.append(ignoredChild);

    const action = zoomImageAction(node, { ignoreSelector: '[data-zoom-image-ignore]' });

    ignoredChild.dispatchEvent(new Event('touchstart', { bubbles: true }));

    expect(zoomHandlerState.touchStartCalls).toBe(0);
    expect(assetViewerManager.cancelZoomAnimation).toHaveBeenCalledOnce();

    action.destroy();
  });
});
