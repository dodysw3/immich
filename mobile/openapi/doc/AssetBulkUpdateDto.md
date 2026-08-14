# openapi.model.AssetBulkUpdateDto

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**dateTimeOriginal** | **String** | Original date and time | [optional] 
**dateTimeRelative** | **int** | Relative time offset in seconds | [optional] 
**description** | **String** | Asset description | [optional] 
**duplicateId** | **String** | Duplicate ID | [optional] 
**ids** | **List<String>** | Asset IDs to update | [default to const []]
**isFavorite** | **bool** | Mark as favorite | [optional] 
**latitude** | **num** | Latitude coordinate | [optional] 
**longitude** | **num** | Longitude coordinate | [optional] 
**rating** | **int** | Rating in range [1-5], or null for unrated | [optional] 
**timeZone** | **String** | Time zone (IANA timezone) | [optional] 
**visibility** | [**AssetVisibility**](AssetVisibility.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


