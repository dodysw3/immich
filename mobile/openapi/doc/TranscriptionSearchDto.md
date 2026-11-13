# openapi.model.TranscriptionSearchDto

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**city** | **String** | Filter by city name (null = no city) | [optional] 
**country** | **String** | Filter by country name (null = no country) | [optional] 
**cursor** | **String** | Opaque pagination cursor from a previous page | [optional] 
**explain** | **bool** | Include score components and scoped coverage counts (diagnostics) | [optional] 
**isFavorite** | **bool** | Filter by favorite status | [optional] 
**isNotInAlbum** | **bool** | Filter assets not in any album | [optional] 
**lensModel** | **String** | Filter by lens model (null = no lens) | [optional] 
**make** | **String** | Filter by camera make (null = no make) | [optional] 
**model** | **String** | Filter by camera model (null = no model) | [optional] 
**personIds** | **BuiltList&lt;String&gt;** | Filter by person IDs (all must match) | [optional] 
**q** | **String** | Spoken words to search for (exact-first, spelling fallback) | 
**rating** | **int** | Filter by rating (null = unrated) | [optional] 
**size** | **int** | Videos per page | [optional] [default to 20]
**state** | **String** | Filter by state/province name (null = no state) | [optional] 
**tagIds** | **BuiltList&lt;String&gt;** | Filter by tag IDs (all must match; null = untagged) | [optional] 
**takenAfter** | [**DateTime**](DateTime.md) | Filter by taken date (after) | [optional] 
**takenBefore** | [**DateTime**](DateTime.md) | Filter by taken date (before) | [optional] 
**visibility** | [**AssetVisibility**](AssetVisibility.md) |  | [optional] 
**withStacked** | **bool** | Include stacked assets | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


