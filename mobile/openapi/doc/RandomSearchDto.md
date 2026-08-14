# openapi.model.RandomSearchDto

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**albumIds** | **List<String>** | Filter by album IDs | [optional] [default to const []]
**city** | **String** | Filter by city name | [optional] 
**country** | **String** | Filter by country name | [optional] 
**createdAfter** | [**DateTime**](DateTime.md) | Filter by creation date (after) | [optional] 
**createdBefore** | [**DateTime**](DateTime.md) | Filter by creation date (before) | [optional] 
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
**personIds** | **List<String>** | Filter by person IDs | [optional] [default to const []]
**rating** | **int** | Filter by rating [1-5], or null for unrated | [optional] 
**size** | **int** | Number of results to return | [optional] 
**state** | **String** | Filter by state/province name | [optional] 
**tagIds** | **List<String>** | Filter by tag IDs | [optional] [default to const []]
**takenAfter** | [**DateTime**](DateTime.md) | Filter by taken date (after) | [optional] 
**takenBefore** | [**DateTime**](DateTime.md) | Filter by taken date (before) | [optional] 
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


