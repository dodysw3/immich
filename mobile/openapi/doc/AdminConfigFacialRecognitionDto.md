# openapi.model.AdminConfigFacialRecognitionDto

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**enabled** | **bool** | Whether the task is enabled | 
**importNamesFromOtherAccounts** | **bool** | Import person names from other accounts in the same recognition cluster | 
**maxDistance** | **double** | Maximum distance threshold for face recognition | 
**minFaceSize** | **int** | Minimum bounding box pixel dimension for face recognition | 
**minFaces** | **int** | Minimum number of faces required for recognition | 
**minScore** | **double** | Minimum confidence score for face detection | 
**minVerifyScore** | **double** | Minimum detector score when each face is re-checked on a standard crop around it (0 disables the re-check) | 
**modelName** | **String** | Name of the model to use | 
**tiling** | [**AdminConfigTilingDto**](AdminConfigTilingDto.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


