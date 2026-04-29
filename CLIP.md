# CLIP Finding

## Summary

In this repository, CLIP is used for **embedding generation** (image/text vectors) to power smart search.  
It does **not** generate or assign asset tags.

## Evidence

- CLIP visual/text models return serialized embeddings:
  - `machine-learning/immich_ml/models/clip/visual.py:29`
  - `machine-learning/immich_ml/models/clip/textual.py:22`
- Server ML repository only exposes CLIP as `encodeImage`/`encodeText`:
  - `server/src/repositories/machine-learning.repository.ts:209`
  - `server/src/repositories/machine-learning.repository.ts:215`
- Smart-search flow stores embedding into `smart_search` and searches by vector distance:
  - `server/src/services/smart-info.service.ts:111`
  - `server/src/repositories/search.repository.ts:448`
  - `server/src/repositories/search.repository.ts:303`
- Tagging is separate (user-defined and metadata-derived), not CLIP-generated:
  - `server/src/services/metadata.service.ts:545`
  - `server/src/services/metadata.service.ts:571`
  - `server/src/constants.ts:192`
