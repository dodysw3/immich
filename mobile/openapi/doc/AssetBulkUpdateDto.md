# openapi.model.AssetBulkUpdateDto

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**dateTimeOriginal** | **String** | Original date and time | [optional] 
**dateTimeRelative** | **int** | Relative time offset in minutes | [optional] 
**description** | **String** | Asset description | [optional] 
**duplicateId** | **String** | Duplicate ID | [optional] 
**ids** | **BuiltList&lt;String&gt;** | Asset IDs to update | 
**isFavorite** | **bool** | Mark as favorite | [optional] 
**latitude** | **double** | Latitude coordinate | [optional] 
**longitude** | **double** | Longitude coordinate | [optional] 
**rating** | **int** | Rating in range [1-5] (starred), -1 (rejected), or null (unrated) | [optional] 
**timeZone** | **String** | Time zone (IANA timezone) | [optional] 
**visibility** | [**AssetVisibility**](AssetVisibility.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


