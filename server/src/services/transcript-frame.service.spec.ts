import { BadRequestException } from '@nestjs/common';
import { createHash } from 'node:crypto';
import { describe, expect, it, vi } from 'vitest';
import { StorageCore } from 'src/cores/storage.core.js';
import { AssetType } from 'src/enum.js';
import { TranscriptFrameService } from 'src/services/transcript-frame.service.js';

const auth = { user: { id: 'user-a' } } as never;

const asset = (overrides: Record<string, unknown> = {}) => ({
  id: 'asset-1',
  type: AssetType.Video,
  originalPath: '/media/car.mp4',
  checksum: Buffer.from('checksum'),
  duration: '0:00:30.00000',
  ...overrides,
});

const passage = (overrides: Record<string, unknown> = {}) => ({
  id: 'passage-1',
  assetId: 'asset-1',
  revision: 'a'.repeat(64),
  startMs: 5000,
  endMs: 8000,
  ...overrides,
});

StorageCore.setMediaLocation('/tmp/immich-transcript-frame-test');

const makeService = () => {
  const dependencies = {
    logger: { setContext: vi.fn(), debug: vi.fn(), log: vi.fn(), warn: vi.fn() },
    accessRepository: {
      asset: {
        checkOwnerAccess: vi.fn().mockResolvedValue(new Set(['asset-1'])),
        checkAlbumAccess: vi.fn().mockResolvedValue(new Set()),
        checkPartnerAccess: vi.fn().mockResolvedValue(new Set()),
        checkSharedLinkAccess: vi.fn().mockResolvedValue(new Set()),
      },
    },
    assetRepository: {
      getByIds: vi.fn().mockResolvedValue([asset()]),
    },
    mediaRepository: {
      grabVideoFrame: vi.fn().mockImplementation(() => Promise.resolve(5)),
    },
    storageRepository: {
      checkFileExists: vi.fn().mockResolvedValue(false),
      mkdirSync: vi.fn(),
      readdirWithTypes: vi.fn().mockResolvedValue([]),
      stat: vi.fn().mockResolvedValue({ mtimeMs: 1 }),
      unlink: vi.fn(() => Promise.resolve()),
    },
    searchRepository: {
      getPassage: vi.fn().mockResolvedValue(passage()),
    },
  };
  const service = new TranscriptFrameService(
    dependencies.logger as never,
    dependencies.accessRepository as never,
    dependencies.assetRepository as never,
    dependencies.mediaRepository as never,
    dependencies.storageRepository as never,
    dependencies.searchRepository as never,
  );
  return { service, dependencies };
};

describe(TranscriptFrameService.name, () => {
  it('resolves and decodes a frame for an authorized passage', async () => {
    const { service, dependencies } = makeService();

    const response = await service.resolveFrame(auth, 'asset-1', 'passage-1');

    expect(dependencies.mediaRepository.grabVideoFrame).toHaveBeenCalledWith(
      '/media/car.mp4',
      5,
      expect.any(String),
      720,
    );
    expect(response.path).toMatch(/\.jpg$/);
    expect(response.cacheControl).toBeDefined();
  });

  it('revalidates access before serving cached frames', async () => {
    const { service, dependencies } = makeService();
    dependencies.storageRepository.checkFileExists.mockResolvedValue(true);

    await service.resolveFrame(auth, 'asset-1', 'passage-1');

    // No decode: the cached entry was served after the access check.
    expect(dependencies.mediaRepository.grabVideoFrame).not.toHaveBeenCalled();
    expect(dependencies.accessRepository.asset.checkOwnerAccess).toHaveBeenCalledWith(
      'user-a',
      new Set(['asset-1']),
      undefined,
    );
  });

  it('stale revisions miss the cache by key and never serve old content', async () => {
    const { service, dependencies } = makeService();
    dependencies.storageRepository.checkFileExists.mockResolvedValue(true);

    await service.resolveFrame(auth, 'asset-1', 'passage-1');

    const first = await service.resolveFrame(auth, 'asset-1', 'passage-1');
    // A new revision changes the key: the old cached file cannot be returned.
    dependencies.searchRepository.getPassage.mockResolvedValue(passage({ revision: 'b'.repeat(64) }));
    const second = await service.resolveFrame(auth, 'asset-1', 'passage-1');
    const firstPath = first.path;
    const secondPath = second.path;
    expect(firstPath).not.toBe(secondPath);
  });

  it('deduplicates concurrent same-key requests into one decode', async () => {
    const { service, dependencies } = makeService();
    let release!: () => void;
    const gate = new Promise<number>((resolve) => (release = () => resolve(5)));
    dependencies.mediaRepository.grabVideoFrame.mockImplementation(() => gate);

    const pending = Promise.all([
      service.resolveFrame(auth, 'asset-1', 'passage-1'),
      service.resolveFrame(auth, 'asset-1', 'passage-1'),
    ]);
    await vi.waitFor(() => expect(dependencies.mediaRepository.grabVideoFrame).toHaveBeenCalledTimes(1));
    release();
    const resolved = await pending;
    const a = resolved[0]!;
    const b = resolved[1]!;

    expect(a.path).toBe(b.path);
    expect(dependencies.mediaRepository.grabVideoFrame).toHaveBeenCalledTimes(1);
  });

  it('rejects non-video assets, unknown passages, and out-of-bounds timestamps', async () => {
    const { service, dependencies } = makeService();
    dependencies.assetRepository.getByIds.mockResolvedValue([asset({ type: AssetType.Image })]);
    await expect(service.resolveFrame(auth, 'asset-1', 'passage-1')).rejects.toBeInstanceOf(BadRequestException);

    dependencies.assetRepository.getByIds.mockResolvedValue([asset()]);
    dependencies.searchRepository.getPassage.mockResolvedValue(undefined);
    await expect(service.resolveFrame(auth, 'asset-1', 'passage-1')).rejects.toBeInstanceOf(BadRequestException);

    dependencies.searchRepository.getPassage.mockResolvedValue(passage({ startMs: 60_000 }));
    await expect(service.resolveFrame(auth, 'asset-1', 'passage-1')).rejects.toBeInstanceOf(BadRequestException);

    // Timestamp zero is valid.
    dependencies.searchRepository.getPassage.mockResolvedValue(passage({ startMs: 0 }));
    await expect(service.resolveFrame(auth, 'asset-1', 'passage-1')).resolves.toBeDefined();
  });

  it('denies access before any frame resolution', async () => {
    const { service, dependencies } = makeService();
    dependencies.accessRepository.asset.checkOwnerAccess.mockResolvedValue(new Set());

    await expect(service.resolveFrame(auth, 'asset-1', 'passage-1')).rejects.toBeDefined();

    expect(dependencies.searchRepository.getPassage).not.toHaveBeenCalled();
    expect(dependencies.mediaRepository.grabVideoFrame).not.toHaveBeenCalled();
  });

  it('invalidates every cached frame for one asset on revision/deletion cleanup', async () => {
    const { service, dependencies } = makeService();
    const prefix = createHash('sha256').update('asset-1').digest('hex').slice(0, 16);
    dependencies.storageRepository.readdirWithTypes.mockResolvedValue([
      { isFile: () => true, name: `${prefix}-abc.jpg` },
      { isFile: () => true, name: `other-def.jpg` },
      { isFile: () => false, name: `${prefix}-dir` },
    ]);
    dependencies.storageRepository.unlink.mockReturnValue(Promise.resolve());

    await service.invalidate('asset-1');

    expect(dependencies.storageRepository.unlink).toHaveBeenCalledTimes(1);
    const unlinkPath = (dependencies.storageRepository.unlink.mock.calls as unknown as Array<[string]>)[0]![0];
    expect(unlinkPath).toMatch(/abc\.jpg$/);
  });
});
