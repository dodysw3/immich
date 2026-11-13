# openapi.model.SearchFilter

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**albumIds** | [**IdsFilter**](IdsFilter.md) |  | [optional] 
**checksum** | [**StringFilter**](StringFilter.md) |  | [optional] 
**city** | [**StringFilterNullable**](StringFilterNullable.md) |  | [optional] 
**country** | [**StringFilterNullable**](StringFilterNullable.md) |  | [optional] 
**createdAt** | [**DateFilter**](DateFilter.md) |  | [optional] 
**description** | [**StringPatternFilter**](StringPatternFilter.md) |  | [optional] 
**encodedVideoPath** | [**StringFilter**](StringFilter.md) |  | [optional] 
**fileSizeInBytes** | [**NumberFilter**](NumberFilter.md) |  | [optional] 
**hasAiInterpretation** | [**BoolFilter**](BoolFilter.md) |  | [optional] 
**hasAlbums** | [**BoolFilter**](BoolFilter.md) |  | [optional] 
**hasPeople** | [**BoolFilter**](BoolFilter.md) |  | [optional] 
**hasTags** | [**BoolFilter**](BoolFilter.md) |  | [optional] 
**id** | [**IdFilter**](IdFilter.md) |  | [optional] 
**isEncoded** | [**BoolFilter**](BoolFilter.md) |  | [optional] 
**isFavorite** | [**BoolFilter**](BoolFilter.md) |  | [optional] 
**isMotion** | [**BoolFilter**](BoolFilter.md) |  | [optional] 
**isOffline** | [**BoolFilter**](BoolFilter.md) |  | [optional] 
**lensModel** | [**StringFilterNullable**](StringFilterNullable.md) |  | [optional] 
**libraryId** | [**IdFilterNullable**](IdFilterNullable.md) |  | [optional] 
**make** | [**StringFilterNullable**](StringFilterNullable.md) |  | [optional] 
**model** | [**StringFilterNullable**](StringFilterNullable.md) |  | [optional] 
**ocr** | [**StringSimilarityFilter**](StringSimilarityFilter.md) |  | [optional] 
**or** | [**BuiltList&lt;SearchFilterBranch&gt;**](SearchFilterBranch.md) |  | [optional] 
**originalFileName** | [**StringPatternFilter**](StringPatternFilter.md) |  | [optional] 
**originalPath** | [**StringPatternFilter**](StringPatternFilter.md) |  | [optional] 
**personIds** | [**IdsFilter**](IdsFilter.md) |  | [optional] 
**rating** | [**NumberFilterNullable**](NumberFilterNullable.md) |  | [optional] 
**state** | [**StringFilterNullable**](StringFilterNullable.md) |  | [optional] 
**tagIds** | [**IdsFilter**](IdsFilter.md) |  | [optional] 
**takenAt** | [**DateFilter**](DateFilter.md) |  | [optional] 
**trashedAt** | [**DateFilterNullable**](DateFilterNullable.md) |  | [optional] 
**type** | [**EnumFilterAssetType**](EnumFilterAssetType.md) |  | [optional] 
**updatedAt** | [**DateFilter**](DateFilter.md) |  | [optional] 
**visibility** | [**EnumFilterAssetVisibility**](EnumFilterAssetVisibility.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


