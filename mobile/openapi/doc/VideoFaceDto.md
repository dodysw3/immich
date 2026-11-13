# openapi.model.VideoFaceDto

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**assetFaceId** | **String** |  | 
**bestFrameMs** | **int** | Timestamp of the representative frame | 
**firstObservedMs** | **int** | Earliest sighting timestamp | 
**flagged** | **bool** | Single sighting below the stricter quality bar | 
**id** | **String** |  | 
**lastObservedMs** | **int** | Latest sighting timestamp | 
**personGroupId** | **String** |  | 
**personName** | **String** | Owner's person name, if assigned or matched | 
**sightingCount** | **int** |  | 
**sightings** | [**BuiltList&lt;VideoFaceDtoSightingsInner&gt;**](VideoFaceDtoSightingsInner.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


