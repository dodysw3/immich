# openapi.model.SharedLinkEditDto

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**allowDownload** | **bool** | Allow downloads | [optional] 
**allowUpload** | **bool** | Allow uploads | [optional] 
**changeExpiryTime** | **bool** | Whether to change the expiry time. Few clients cannot send null to set the expiryTime to never. Setting this flag and not sending expiryAt is considered as null instead. Clients that can send null values can ignore this. | [optional] 
**description** | **String** | Link description | [optional] 
**expiresAt** | [**DateTime**](DateTime.md) | Expiration date | [optional] 
**password** | **String** | Link password | [optional] 
**showMetadata** | **bool** | Show metadata | [optional] 
**slug** | **String** | Custom URL slug | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


