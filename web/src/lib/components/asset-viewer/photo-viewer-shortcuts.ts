import type { ShortcutOptions } from '$lib/actions/shortcut';

export interface PhotoViewerShortcutHandlers {
  onZoom: () => void;
  onPlaySlideshow: () => void;
  onCopyShortcut: (event: KeyboardEvent) => void;
}

export interface FeatureShortcutHandlers {
  toggleFaceBoxes: () => void;
  toggleOcrBoxes: () => void;
}

/**
 * Core shortcuts for photo viewer (zoom, slideshow, copy)
 */
export const getCoreShortcuts = (handlers: PhotoViewerShortcutHandlers): ShortcutOptions[] => [
  { shortcut: { key: 'z' }, onShortcut: handlers.onZoom, preventDefault: true },
  { shortcut: { key: 's' }, onShortcut: handlers.onPlaySlideshow, preventDefault: true },
  { shortcut: { key: 'c', ctrl: true }, onShortcut: handlers.onCopyShortcut, preventDefault: false },
  { shortcut: { key: 'c', meta: true }, onShortcut: handlers.onCopyShortcut, preventDefault: false },
];

/**
 * Feature-specific shortcuts for face and OCR bounding boxes
 * Extracted to reduce merge conflicts when adding new feature shortcuts
 */
export const getFeatureShortcuts = (handlers: FeatureShortcutHandlers): ShortcutOptions[] => [
  { shortcut: { key: 'f', shift: true }, onShortcut: handlers.toggleFaceBoxes, preventDefault: true },
  { shortcut: { key: 't', shift: true }, onShortcut: handlers.toggleOcrBoxes, preventDefault: true },
];
