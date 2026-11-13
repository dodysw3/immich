# openapi.model.TimeBucketAssetResponseDto

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**aiInterpretationTitle** | **BuiltList&lt;String?&gt;** | Array of AI interpretation titles (most recent completed run per asset, null when the asset was never interpreted) | [optional] 
**city** | **BuiltList&lt;String?&gt;** | Array of city names extracted from EXIF GPS data | [optional] 
**country** | **BuiltList&lt;String?&gt;** | Array of country names extracted from EXIF GPS data | [optional] 
**createdAt** | **BuiltList&lt;String&gt;** | Array of UTC timestamps when each asset was originally uploaded to Immich | 
**duration** | **BuiltList&lt;int?&gt;** | Array of video/gif durations in milliseconds (null for static images) | 
**fileCreatedAt** | **BuiltList&lt;String&gt;** | Array of file creation timestamps in UTC | 
**id** | **BuiltList&lt;String&gt;** | Array of asset IDs in the time bucket | 
**isFavorite** | **BuiltList&lt;bool&gt;** | Array indicating whether each asset is favorited | 
**isImage** | **BuiltList&lt;bool&gt;** | Array indicating whether each asset is an image (false for videos) | 
**isTrashed** | **BuiltList&lt;bool&gt;** | Array indicating whether each asset is in the trash | 
**latitude** | **BuiltList&lt;double?&gt;** | Array of latitude coordinates extracted from EXIF GPS data | [optional] 
**livePhotoVideoId** | **BuiltList&lt;String?&gt;** | Array of live photo video asset IDs (null for non-live photos) | 
**localOffsetHours** | **BuiltList&lt;double&gt;** | Array of UTC offset hours at the time each photo was taken. Positive values are east of UTC, negative values are west of UTC. Values may be fractional (e.g., 5.5 for +05:30, -9.75 for -09:45). Applying this offset to 'fileCreatedAt' will give you the time the photo was taken from the photographer's perspective. | 
**longitude** | **BuiltList&lt;double?&gt;** | Array of longitude coordinates extracted from EXIF GPS data | [optional] 
**ownerId** | **BuiltList&lt;String&gt;** | Array of owner IDs for each asset | 
**projectionType** | **BuiltList&lt;String?&gt;** | Array of projection types for 360° content (e.g., \"EQUIRECTANGULAR\", \"CUBEFACE\", \"CYLINDRICAL\") | 
**ratio** | **BuiltList&lt;double&gt;** | Array of aspect ratios (width/height) for each asset | 
**stack** | [**BuiltList&lt;BuiltList&lt;String&gt;?&gt;**](BuiltList.md) | Array of stack information as [stackId, assetCount] tuples (null for non-stacked assets) | [optional] 
**thumbhash** | **BuiltList&lt;String?&gt;** | Array of BlurHash strings for generating asset previews (base64 encoded) | 
**visibility** | [**BuiltList&lt;AssetVisibility&gt;**](AssetVisibility.md) | Array of visibility statuses for each asset (e.g., ARCHIVE, TIMELINE, HIDDEN, LOCKED) | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


