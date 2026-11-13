# openapi.model.MetadataSearchDto

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**albumIds** | **BuiltList&lt;String&gt;** | Filter by album IDs | [optional] 
**checksum** | **String** | Filter by file checksum | [optional] 
**city** | **String** | Filter by city name | [optional] 
**country** | **String** | Filter by country name | [optional] 
**createdAfter** | [**DateTime**](DateTime.md) | Filter by creation date (after) | [optional] 
**createdBefore** | [**DateTime**](DateTime.md) | Filter by creation date (before) | [optional] 
**cursor** | **String** | Cursor for the next page of results | [optional] 
**description** | **String** | Filter by description text | [optional] 
**encodedVideoPath** | **String** | Filter by encoded video file path | [optional] 
**filter** | [**SearchFilter**](SearchFilter.md) |  | [optional] 
**hasAiInterpretation** | **bool** | Filter by presence of a completed AI image interpretation | [optional] 
**id** | **String** | Filter by asset ID | [optional] 
**isEncoded** | **bool** | Filter by encoded status | [optional] 
**isFavorite** | **bool** | Filter by favorite status | [optional] 
**isMotion** | **bool** | Filter by motion photo status | [optional] 
**isNotInAlbum** | **bool** | Filter assets not in any album | [optional] 
**isOffline** | **bool** | Filter by offline status | [optional] 
**lensModel** | **String** | Filter by lens model | [optional] 
**libraryId** | **String** | Library ID to filter by | [optional] 
**make** | **String** | Filter by camera make | [optional] 
**model** | **String** | Filter by camera model | [optional] 
**ocr** | **String** | Filter by OCR text content | [optional] 
**order** | [**AssetOrder**](AssetOrder.md) |  | [optional] 
**orderBy** | [**SearchOrder**](SearchOrder.md) |  | [optional] 
**originalFileName** | **String** | Filter by original file name | [optional] 
**originalPath** | **String** | Filter by original file path | [optional] 
**page** | **int** | Page number | [optional] 
**personIds** | **BuiltList&lt;String&gt;** | Filter by person IDs | [optional] 
**previewPath** | **String** | Filter by preview file path | [optional] 
**rating** | **int** | Filter by rating [1-5], or null for unrated | [optional] 
**size** | **int** | Number of results to return | [optional] [default to 250]
**state** | **String** | Filter by state/province name | [optional] 
**tagIds** | **BuiltList&lt;String&gt;** | Filter by tag IDs | [optional] 
**takenAfter** | [**DateTime**](DateTime.md) | Filter by taken date (after) | [optional] 
**takenBefore** | [**DateTime**](DateTime.md) | Filter by taken date (before) | [optional] 
**thumbnailPath** | **String** | Filter by thumbnail file path | [optional] 
**trashedAfter** | [**DateTime**](DateTime.md) | Filter by trash date (after) | [optional] 
**trashedBefore** | [**DateTime**](DateTime.md) | Filter by trash date (before) | [optional] 
**type** | [**AssetTypeEnum**](AssetTypeEnum.md) |  | [optional] 
**updatedAfter** | [**DateTime**](DateTime.md) | Filter by update date (after) | [optional] 
**updatedBefore** | [**DateTime**](DateTime.md) | Filter by update date (before) | [optional] 
**visibility** | [**AssetVisibility**](AssetVisibility.md) |  | [optional] 
**withDeleted** | **bool** | Include deleted assets | [optional] 
**withExif** | **bool** | Include EXIF data in response | [optional] 
**withPeople** | **bool** | Include people data in response | [optional] 
**withStacked** | **bool** | Include stacked assets | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


