import { createZoomImageWheel } from '@zoom-image/core';
import { assetViewerManager } from '$lib/managers/asset-viewer-manager.svelte';

type ZoomImageActionOptions = {
  zoomTarget?: HTMLElement;
  disabled?: boolean;
  ignoreSelector?: string;
};

// Minimal touch shape — avoids importing DOM TouchEvent which isn't available in all TS targets.
type TouchEventLike = {
  touches: Iterable<{ clientX: number; clientY: number }> & { length: number };
  targetTouches: ArrayLike<unknown>;
};

const asTouchEvent = (event: Event) => event as unknown as TouchEventLike;

const matchesIgnoreSelector = (target: EventTarget | Element | null, options?: ZoomImageActionOptions) => {
  if (!options?.ignoreSelector || !(target instanceof Element)) {
    return false;
  }

  return !!target.closest(options.ignoreSelector);
};

export const zoomImageAction = (node: HTMLElement, options?: ZoomImageActionOptions) => {
  const zoomInstance = createZoomImageWheel(node, {
    maxZoom: 10,
    initialState: assetViewerManager.zoomState,
    zoomTarget: options?.zoomTarget,
  });

  const unsubscribes = [
    assetViewerManager.on({ ZoomChange: (state) => zoomInstance.setState(state) }),
    zoomInstance.subscribe(({ state }) => assetViewerManager.onZoomChange(state)),
  ];

  const controller = new AbortController();
  const { signal } = controller;

  node.addEventListener('pointerdown', () => assetViewerManager.cancelZoomAnimation(), { capture: true, signal });

  const isOverlayEvent = (event: Event) =>
    !!(event.target as HTMLElement).closest('[data-overlay-interactive]') || matchesIgnoreSelector(event.target, options);
  const isOverlayAtPoint = (x: number, y: number) => {
    const target = document.elementFromPoint(x, y);
    return !!target?.closest('[data-overlay-interactive]') || matchesIgnoreSelector(target, options);
  };

  const overlayPointers = new Set<number>();
  const interceptedPointers = new Set<number>();
  const interceptOverlayPointerDown = (event: PointerEvent) => {
    if (options?.disabled) {
      interceptedPointers.add(event.pointerId);
      event.stopImmediatePropagation();
      return;
    }

    if (isOverlayEvent(event) || isOverlayAtPoint(event.clientX, event.clientY)) {
      overlayPointers.add(event.pointerId);
      interceptedPointers.add(event.pointerId);
      event.stopPropagation();
    } else if (overlayPointers.size > 0) {
      interceptedPointers.add(event.pointerId);
      event.stopPropagation();
    }
  };
  const interceptOverlayPointerEvent = (event: PointerEvent) => {
    if (interceptedPointers.has(event.pointerId)) {
      event.stopPropagation();
    }
  };
  const interceptOverlayPointerEnd = (event: PointerEvent) => {
    overlayPointers.delete(event.pointerId);
    if (interceptedPointers.delete(event.pointerId)) {
      event.stopPropagation();
    }
  };
  node.addEventListener('pointerdown', interceptOverlayPointerDown, { capture: true, signal });
  node.addEventListener('pointermove', interceptOverlayPointerEvent, { capture: true, signal });
  node.addEventListener('pointerup', interceptOverlayPointerEnd, { capture: true, signal });
  node.addEventListener('pointerleave', interceptOverlayPointerEnd, { capture: true, signal });

  let touchGestureIntercepted = false;
  const interceptOverlayTouchEvent = (event: Event) => {
    if (options?.disabled) {
      touchGestureIntercepted = true;
      event.stopImmediatePropagation();
      return;
    }

    if (touchGestureIntercepted) {
      event.stopPropagation();
      return;
    }

    const { touches, targetTouches } = asTouchEvent(event);
    if (touches && targetTouches) {
      if (touches.length > targetTouches.length) {
        touchGestureIntercepted = true;
        event.stopPropagation();
        return;
      }
      for (const touch of touches) {
        if (isOverlayAtPoint(touch.clientX, touch.clientY)) {
          touchGestureIntercepted = true;
          event.stopPropagation();
          return;
        }
      }
    } else if (isOverlayEvent(event)) {
      event.stopPropagation();
    }
  };
  const resetTouchGesture = (event: Event) => {
    const { touches } = asTouchEvent(event);
    if (touches.length === 0) {
      touchGestureIntercepted = false;
    }
  };
  node.addEventListener('touchstart', interceptOverlayTouchEvent, { capture: true, signal });
  node.addEventListener('touchmove', interceptOverlayTouchEvent, { capture: true, signal });
  node.addEventListener('touchend', resetTouchGesture, { capture: true, signal });

  let lastPointerWasTouch = false;
  node.addEventListener('pointerdown', (event) => (lastPointerWasTouch = event.pointerType === 'touch'), {
    capture: true,
    signal,
  });
  node.addEventListener(
    'wheel',
    (event) => {
      if (options?.disabled) {
        event.stopImmediatePropagation();
        return;
      }

      if (isOverlayEvent(event)) {
        event.stopPropagation();
      }
    },
    { capture: true, signal },
  );
  node.addEventListener(
    'dblclick',
    (event) => {
      if (lastPointerWasTouch || isOverlayEvent(event)) {
        event.stopImmediatePropagation();
      }
    },
    { capture: true, signal },
  );

  node.style.overflow = 'visible';
  node.style.touchAction = 'none';
  return {
    update(newOptions?: ZoomImageActionOptions) {
      options = newOptions;
      if (newOptions?.zoomTarget !== undefined) {
        zoomInstance.setState({ zoomTarget: newOptions.zoomTarget });
      }
    },
    destroy() {
      controller.abort();
      for (const unsubscribe of unsubscribes) {
        unsubscribe();
      }
      zoomInstance.cleanup();
    },
  };
};
