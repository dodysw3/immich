import { createHash } from 'node:crypto';
import { AssetType } from 'src/enum.js';
import { getDimensions, isPanorama } from 'src/utils/asset.util.js';

/**
Identity of the orientation-suggestion pipeline. The model name is the
provenance record of what produced the suggestion (RightWayUp ONNX, served
by the ML container); `pipelineVersion` plays the role the interpretation
promptVersion plays there: bumping it forks the runKey so a changed pipeline
re-suggests instead of silently overwriting prior runs.
*/
export const ROTATION_SUGGESTION_MODEL = 'rightwayup';
export const ROTATION_SUGGESTION_PIPELINE_VERSION = 'orientation-1.0.0';

/**
Suggestions at or above this snapped-class confidence are surfaced to the
user; anything below is recorded as an abstention (no rotation class).
Benchmark τ-sweep (orient-bench/REPORT.md) showed 0.7 costs nothing but 0.5
keeps recall on borderline cases while the FP rate is governed by the model's
own abstention.
*/
export const ROTATION_SUGGESTION_DEFAULT_THRESHOLD = 0.5;

export type RotationModelTier = 'fast' | 'balanced';

export const createRotationSuggestionRunKey = (model: string, tier: string, pipelineVersion: string): string =>
  createHash('sha256').update(`${model}\n${tier}\n${pipelineVersion}`, 'utf8').digest('hex');

export const snapToQuarterTurn = (angleCw: number): 0 | 90 | 180 | 270 =>
  (((Math.round(angleCw / 90) % 4) + 4) % 4) * 90 as 0 | 90 | 180 | 270;

// Same guard set as AssetService.editAsset: the apply path goes through that
// API, so anything it would reject must never get a suggestion in the first
// place (videos, live photos, panoramas, GIF/SVG, undecodable dimensions).
export const isOrientationSuggestionEligible = (asset: {
  type: AssetType;
  livePhotoVideoId: string | null;
  originalPath: string | null;
  originalFileName: string | null;
  projectionType: string | null;
  orientation: string | null;
  exifImageWidth: number | null;
  exifImageHeight: number | null;
}): boolean => {
  if (asset.type !== AssetType.Image) {
    return false;
  }

  if (asset.livePhotoVideoId) {
    return false;
  }

  if (isPanorama({ projectionType: asset.projectionType, originalFileName: asset.originalFileName ?? '' })) {
    return false;
  }

  const path = asset.originalPath?.toLowerCase() ?? '';
  if (path.endsWith('.gif') || path.endsWith('.svg')) {
    return false;
  }

  const { width, height } = getDimensions({
    exifImageHeight: asset.exifImageHeight,
    exifImageWidth: asset.exifImageWidth,
    orientation: asset.orientation,
  });
  return width > 0 && height > 0;
};
