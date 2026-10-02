import { BadRequestException } from '@nestjs/common';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import sharp from 'sharp';
import { AssetAnnotatedOriginalDto } from 'src/dtos/asset.dto.js';
import { AssetEditAction } from 'src/dtos/editing.dto.js';
import { CacheControl } from 'src/enum.js';
import { AssetMediaService } from 'src/services/asset-media.service.js';
import { AssetFaceFactory } from 'test/factories/asset-face.factory.js';
import { AuthFactory } from 'test/factories/auth.factory.js';
import { authStub } from 'test/fixtures/auth.stub.js';
import { getForAssetFace } from 'test/mappers.js';
import { newTestService } from 'test/utils.js';

let folder: string;
beforeAll(async () => {
  folder = await mkdtemp(join(tmpdir(), 'immich-annotated-'));
  await sharp({ create: { width: 200, height: 200, channels: 3, background: 'white' } })
    .png()
    .toFile(join(folder, 'original.png'));
  await sharp({ create: { width: 100, height: 100, channels: 3, background: 'black' } })
    .png()
    .toFile(join(folder, 'edited.png'));
  await sharp({ create: { width: 200, height: 200, channels: 3, background: 'white' } })
    .tiff()
    .toFile(join(folder, 'original.tiff'));
});
afterAll(async () => {
  await rm(folder, { recursive: true, force: true });
});

const setup = () => {
  const { sut, mocks } = newTestService(AssetMediaService);
  mocks.access.asset.checkOwnerAccess.mockResolvedValue(new Set(['asset-1']));
  mocks.asset.getForOriginal.mockResolvedValue({
    id: 'asset-1',
    originalPath: join(folder, 'original.png'),
    originalFileName: 'Group.png',
    editedPath: null,
  });
  mocks.asset.getForFaces.mockResolvedValue({ exifImageWidth: 200, exifImageHeight: 200, orientation: '1', edits: [] });
  mocks.person.getFaces.mockResolvedValue([]);
  return { sut, mocks };
};

describe('downloadAnnotatedOriginal', () => {
  it('requires download access before reading files or faces', async () => {
    const { sut, mocks } = setup();
    mocks.access.asset.checkOwnerAccess.mockResolvedValue(new Set());
    await expect(
      sut.downloadAnnotatedOriginal(authStub.admin, 'asset-1', { layers: ['faces'] }),
    ).rejects.toBeInstanceOf(BadRequestException);
    expect(mocks.asset.getForOriginal).not.toHaveBeenCalled();
  });
  it('rejects shared links even when they otherwise have access', async () => {
    const { sut, mocks } = setup();
    await expect(
      sut.downloadAnnotatedOriginal(AuthFactory.from().sharedLink().build(), 'asset-1', { layers: ['faces'] }),
    ).rejects.toBeInstanceOf(BadRequestException);
    expect(mocks.asset.getForOriginal).not.toHaveBeenCalled();
  });
  it('returns a correctly encoded download with zero faces', async () => {
    const { sut, mocks } = setup();
    const response = await sut.downloadAnnotatedOriginal(authStub.admin, 'asset-1', { layers: ['faces'] });
    expect(response.fileName).toBe('Group (faces).png');
    expect(response.contentType).toBe('image/png');
    expect(response.cacheControl).toBe(CacheControl.PrivateWithCache);
    const metadata = await sharp(response.buffer).metadata();
    expect(metadata.width).toBe(200);
    expect(mocks.person.getFaces).toHaveBeenCalledWith('asset-1', {
      viewingUserId: authStub.admin.user.id,
      isVisible: true,
    });
  });
  it('excludes hidden people from the rendered pixels', async () => {
    const { sut, mocks } = setup();
    const hidden = AssetFaceFactory.from({
      imageWidth: 200,
      imageHeight: 200,
      boundingBoxX1: 10,
      boundingBoxX2: 50,
      boundingBoxY1: 10,
      boundingBoxY2: 50,
    })
      .person({ name: 'Hidden', isHidden: true })
      .build();
    const blank = await sut.downloadAnnotatedOriginal(authStub.admin, 'asset-1', { layers: ['faces'] });
    mocks.person.getFaces.mockResolvedValue([getForAssetFace(hidden)]);
    const filtered = await sut.downloadAnnotatedOriginal(authStub.admin, 'asset-1', { layers: ['faces'] });
    expect(filtered.buffer).toEqual(blank.buffer);
    mocks.person.getFaces.mockResolvedValue([{ ...hidden, person: null }]);
    const visible = await sut.downloadAnnotatedOriginal(authStub.admin, 'asset-1', { layers: ['faces'] });
    expect(visible.buffer).not.toEqual(blank.buffer);
  });
  it('uses the edited file and maps boxes through crop edits', async () => {
    const { sut, mocks } = setup();
    mocks.asset.getForOriginal.mockResolvedValue({
      id: 'asset-1',
      originalPath: '/missing.png',
      originalFileName: 'Group.png',
      editedPath: join(folder, 'edited.png'),
    });
    mocks.asset.getForFaces.mockResolvedValue({
      exifImageWidth: 200,
      exifImageHeight: 200,
      orientation: '1',
      edits: [{ action: AssetEditAction.Crop, parameters: { x: 50, y: 50, width: 100, height: 100 } }],
    });
    mocks.person.getFaces.mockResolvedValue([
      getForAssetFace(
        AssetFaceFactory.create({
          imageWidth: 200,
          imageHeight: 200,
          boundingBoxX1: 60,
          boundingBoxX2: 90,
          boundingBoxY1: 60,
          boundingBoxY2: 90,
        }),
      ),
    ]);
    const response = await sut.downloadAnnotatedOriginal(authStub.admin, 'asset-1', { layers: ['faces'] });
    const { data, info } = await sharp(response.buffer).removeAlpha().raw().toBuffer({ resolveWithObject: true });
    expect(info.width).toBe(100);
    expect(data[(10 * info.width + 15) * info.channels + 1]).toBeGreaterThan(50);
    expect(data[(60 * info.width + 65) * info.channels + 1]).toBe(0);
    expect(mocks.asset.getForOriginal).toHaveBeenCalledWith('asset-1', true);
  });
  it('falls back to JPEG for non-preserved containers and uses the actual output extension', async () => {
    const { sut, mocks } = setup();
    mocks.asset.getForOriginal.mockResolvedValue({
      id: 'asset-1',
      originalPath: join(folder, 'original.tiff'),
      originalFileName: 'Group.HEIC',
      editedPath: null,
    });
    const response = await sut.downloadAnnotatedOriginal(authStub.admin, 'asset-1', { layers: ['faces'] });
    expect(response.fileName).toBe('Group (faces).jpg');
    expect(response.contentType).toBe('image/jpeg');
    const metadata = await sharp(response.buffer).metadata();
    expect(metadata.format).toBe('jpeg');
  });
});

describe('AssetAnnotatedOriginalDto', () => {
  it('defaults to faces and normalizes single query values', () => {
    expect(AssetAnnotatedOriginalDto.schema.parse({})).toEqual({ layers: ['faces'] });
    expect(AssetAnnotatedOriginalDto.schema.parse({ layers: 'faces' })).toEqual({ layers: ['faces'] });
    expect(AssetAnnotatedOriginalDto.schema.parse({ layers: ['faces'] })).toEqual({ layers: ['faces'] });
  });
  it('rejects unknown layers', () => {
    expect(AssetAnnotatedOriginalDto.schema.safeParse({ layers: 'ocr' }).success).toBe(false);
  });
});
