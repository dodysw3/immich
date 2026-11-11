## 1. Server

- [ ] 1.1 Create `server/src/dtos/asset-media-metadata.dto.ts`: `AssetMediaMetadataResponseDto` — `exif` (all 25 exif fields incl. `fps`, `profileDescription`, `colorspace`, `bitsPerSample`, `tags`), `video` (16 stream fields, nullish), `audio` (4 fields, nullish); zod schema with `.meta({ id: 'AssetMediaMetadataResponseDto' })`
- [ ] 1.2 Repo: `getFullMediaMetadata(assetId)` in `asset.repository.ts` — three PK selects (`asset_exif` / `asset_video` / `asset_audio`), mapped into the DTO shape (no paths, no keyframes)
- [ ] 1.3 Service: `getMediaMetadata(auth, id)` in `asset.service.ts` — `access.checkOwnerAccess` guard (403 on miss), call repo
- [ ] 1.4 Controller: `GET :id/media-metadata` in `asset.controller.ts` (`@Authenticated`, `@Endpoint` summary/history per house style); route must not collide with upstream `:id/metadata`
- [ ] 1.5 e2e tests: owner image (streams null), owner video (all sections incl. fps + DV-null), non-owner 403, shared-link 403, pre-stream video (sections null, 200)

## 2. SDK / codegen

- [ ] 2.1 Regenerate OpenAPI + SDK (oazapfts pipeline per docs/development.md); confirm `getAssetMediaMetadata` appears in `@immich/sdk`

## 3. Web

- [ ] 3.1 Query: `getAssetMediaMetadataQuery` in `web/src/lib/queries/` (enabled when modal open)
- [ ] 3.2 `web/src/lib/modals/AssetMetadataModal.svelte` — `Modal`/`ModalBody`; sections File / Camera & Exif / Photo·Video / Streams / GPS; omit null fields, hide empty sections; ffmpeg color-enum → name mapping table (bt709/bt2020/smpte2084/…, raw-number fallback); human bitrate; DV line conditional
- [ ] 3.3 Copy-as-JSON button: clipboard = raw endpoint payload (nulls included)
- [ ] 3.4 Wire `DetailPanel.svelte` `(i)` icon → open `AssetMetadataModal` (owner-only, unchanged gate); keep path + `go_to_folder` link inside File section
- [ ] 3.5 Remove inline reveal: `isShowAssetPath`/`toggleAssetPath` from `asset-viewer-manager.svelte.ts` + the slide-transition path block
- [ ] 3.6 i18n: new en.json keys (`full_metadata`, section labels, copy action); all fork keys committed

## 4. Checks

- [ ] 4.1 Server: lint + unit tests pass
- [ ] 4.2 Web: `check:svelte` + `check:typescript` pass
- [ ] 4.3 e2e suite green

## 5. Deploy + verify

- [ ] 5.1 Rebuild + restart via `./build-glm.sh` in CWD; check im-s logs after (per ops guardrail)
- [ ] 5.2 Live API verify: owner curl → 200 full payload on a video id; non-owner curl → 403; image id → streams null
- [ ] 5.3 UI verify: modal on one image (no Streams), one video (Streams incl. codec/fps/bitrate), one pre-stream video (Streams hidden); copy-as-JSON matches curl payload; folder link lands in folders view
