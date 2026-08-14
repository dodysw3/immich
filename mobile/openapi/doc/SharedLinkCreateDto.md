# openapi.model.SharedLinkCreateDto

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**albumId** | **String** | Album ID (for album sharing) | [optional] 
**allowDownload** | **bool** | Allow downloads | [optional] [default to true]
**allowUpload** | **bool** | Allow uploads | [optional] 
**assetIds** | **List<String>** | Asset IDs (for individual assets) | [optional] [default to const []]
**description** | **String** | Link description | [optional] 
**expiresAt** | [**DateTime**](DateTime.md) | Expiration date | [optional] 
**password** | **String** | Link password | [optional] 
**showMetadata** | **bool** | Show metadata | [optional] [default to true]
**slug** | **String** | Custom URL slug | [optional] 
**type** | [**SharedLinkType**](SharedLinkType.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


