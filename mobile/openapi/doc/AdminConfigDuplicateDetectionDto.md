# openapi.model.AdminConfigDuplicateDetectionDto

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**enabled** | **bool** | Whether the task is enabled | 
**maxDistance** | **double** | Maximum distance threshold for duplicate detection | 
**ocrVeto** | **bool** | Exclude duplicate candidates whose OCR text differs materially from the source asset | 
**ocrVetoMaxTokenDiff** | **int** | Maximum OCR token-bag symmetric difference before a duplicate candidate is vetoed | 
**pdfVeto** | **bool** | Exclude duplicate PDF candidates whose page count or whole-document text differs from the source asset | 
**pdfVetoMaxTokenDiff** | **int** | Maximum whole-document PDF text token-bag symmetric difference before a candidate is vetoed | 
**videoNearDup** | [**AdminConfigVideoNearDupDto**](AdminConfigVideoNearDupDto.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


