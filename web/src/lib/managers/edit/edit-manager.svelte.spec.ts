import type { AssetResponseDto } from '@immich/sdk';
import { beforeEach, describe, expect, it, vi } from 'vitest';

const mocks = vi.hoisted(() => ({
  editAsset: vi.fn(),
  getAssetEdits: vi.fn(),
  getAssetInfo: vi.fn(),
  removeAssetEdits: vi.fn(),
  waitForWebsocketEvent: vi.fn(),
  eventEmit: vi.fn(),
  toastSuccess: vi.fn(),
  toastDanger: vi.fn(),
  formatter: vi.fn((key: string) => key),
}));

vi.mock('$lib/components/asset-viewer/editor/transform-tool/transform-tool.svelte', () => ({
  default: {},
}));

vi.mock('$lib/managers/edit/transform-manager.svelte', () => ({
  transformManager: {
    onActivate: vi.fn(),
    onDeactivate: vi.fn(),
    resetAllChanges: vi.fn(),
    hasChanges: false,
    canReset: false,
    edits: [],
  },
}));

vi.mock('$lib/managers/event-manager.svelte', () => ({
  eventManager: {
    emit: mocks.eventEmit,
  },
}));

vi.mock('$lib/stores/websocket', () => ({
  waitForWebsocketEvent: mocks.waitForWebsocketEvent,
}));

vi.mock('$lib/utils/i18n', async () => {
  const actual = await vi.importActual<typeof import('$lib/utils/i18n')>('$lib/utils/i18n');

  return {
    ...actual,
    getFormatter: vi.fn().mockResolvedValue(mocks.formatter),
  };
});

vi.mock('@immich/ui', () => ({
  ConfirmModal: {},
  modalManager: {
    show: vi.fn(),
  },
  toastManager: {
    success: mocks.toastSuccess,
    danger: mocks.toastDanger,
  },
}));

vi.mock('@immich/sdk', () => ({
  AssetEditAction: {
    Rotate: 'rotate',
  },
  editAsset: mocks.editAsset,
  getAssetEdits: mocks.getAssetEdits,
  getAssetInfo: mocks.getAssetInfo,
  removeAssetEdits: mocks.removeAssetEdits,
}));

import { EditManager } from '$lib/managers/edit/edit-manager.svelte';

const createAsset = (id: string): AssetResponseDto => ({ id }) as AssetResponseDto;

describe('EditManager.applyInstantRotate', () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mocks.waitForWebsocketEvent.mockResolvedValue(undefined);
    mocks.editAsset.mockResolvedValue(undefined);
    mocks.getAssetEdits.mockResolvedValue({ edits: [] });
    mocks.getAssetInfo.mockResolvedValue(createAsset('updated-asset'));
  });

  it('appends a rotate edit, applies it, and emits update events', async () => {
    const asset = createAsset('asset-1');
    const updatedAsset = createAsset(asset.id);

    mocks.getAssetEdits.mockResolvedValue({
      edits: [{ action: 'crop', parameters: { x: 0, y: 0, width: 100, height: 100 } }],
    });
    mocks.getAssetInfo.mockResolvedValue(updatedAsset);

    const manager = new EditManager();
    const result = await manager.applyInstantRotate(asset, -90);

    expect(result).toBe(true);
    expect(mocks.getAssetEdits).toHaveBeenCalledWith({ id: asset.id });
    expect(mocks.editAsset).toHaveBeenCalledWith({
      id: asset.id,
      assetEditActionListDto: {
        edits: [
          { action: 'crop', parameters: { x: 0, y: 0, width: 100, height: 100 } },
          { action: 'rotate', parameters: { angle: 270 } },
        ],
      },
    });
    expect(mocks.waitForWebsocketEvent).toHaveBeenCalledWith('AssetEditReadyV1', expect.any(Function), 10_000);

    const predicate = mocks.waitForWebsocketEvent.mock.calls[0][1] as (event: { asset: { id: string } }) => boolean;
    expect(predicate({ asset: { id: asset.id } })).toBe(true);
    expect(predicate({ asset: { id: 'other' } })).toBe(false);

    expect(mocks.eventEmit).toHaveBeenNthCalledWith(1, 'AssetEditsApplied', asset.id);
    expect(mocks.eventEmit).toHaveBeenNthCalledWith(2, 'AssetUpdate', updatedAsset);
    expect(mocks.toastSuccess).toHaveBeenCalledWith('editor_edits_applied_success');
    expect(manager.hasAppliedEdits).toBe(true);
    expect(manager.isApplyingEdits).toBe(false);
  });

  it('shows an error toast and returns false when edit apply fails', async () => {
    const asset = createAsset('asset-2');
    mocks.editAsset.mockRejectedValue(new Error('edit failed'));

    const manager = new EditManager();
    const result = await manager.applyInstantRotate(asset, 90);

    expect(result).toBe(false);
    expect(mocks.toastDanger).toHaveBeenCalledWith('editor_edits_applied_error');
    expect(mocks.toastSuccess).not.toHaveBeenCalled();
    expect(mocks.eventEmit).not.toHaveBeenCalled();
    expect(manager.isApplyingEdits).toBe(false);
  });

  it('merges with an existing rotate edit instead of appending a duplicate rotate action', async () => {
    const asset = createAsset('asset-3');

    mocks.getAssetEdits.mockResolvedValue({
      edits: [{ action: 'rotate', parameters: { angle: 90 } }],
    });

    const manager = new EditManager();
    const result = await manager.applyInstantRotate(asset, 90);

    expect(result).toBe(true);
    expect(mocks.editAsset).toHaveBeenCalledWith({
      id: asset.id,
      assetEditActionListDto: {
        edits: [{ action: 'rotate', parameters: { angle: 180 } }],
      },
    });
    expect(mocks.removeAssetEdits).not.toHaveBeenCalled();
  });

  it('removes edits when net rotation becomes zero', async () => {
    const asset = createAsset('asset-4');

    mocks.getAssetEdits.mockResolvedValue({
      edits: [{ action: 'rotate', parameters: { angle: 270 } }],
    });

    const manager = new EditManager();
    const result = await manager.applyInstantRotate(asset, 90);

    expect(result).toBe(true);
    expect(mocks.removeAssetEdits).toHaveBeenCalledWith({ id: asset.id });
    expect(mocks.editAsset).not.toHaveBeenCalled();
  });
});
