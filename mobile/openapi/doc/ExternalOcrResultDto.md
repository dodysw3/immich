# openapi.model.ExternalOcrResultDto

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**language** | **String** | Language hint | [optional] 
**lines** | [**List<ExternalOcrLineDto>**](ExternalOcrLineDto.md) | OCR result lines | [default to const []]
**mode** | **String** | OCR write mode | 
**model** | **String** | Model family/name | 
**modelRevision** | **String** | Model revision for reprocessing control | 
**processedAt** | **String** | External OCR completion timestamp (ISO 8601) | 
**provider** | **String** | External OCR provider identifier | 
**searchText** | **String** | Pre-tokenized search text | [optional] 
**sourceChecksum** | **String** | SHA256 of original source bytes | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


