# openapi.model.TranscriptionMatchDto

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**components** | [**TranscriptionMatchDtoComponents**](TranscriptionMatchDtoComponents.md) |  | [optional] 
**endMs** | **int** |  | 
**firstSegment** | **int** |  | 
**lastSegment** | **int** |  | 
**passageId** | **String** | Opaque passage id (used for moment retrieval and frame resolution) | 
**revision** | **String** | Source transcript content revision | 
**runKey** | **String** | Source transcription run identity | 
**score** | **double** | Normalized within-tier score | 
**snippet** | **String** | Original transcript text of the passage | 
**spans** | [**BuiltList&lt;TranscriptionSearchSpanDto&gt;**](TranscriptionSearchSpanDto.md) | Matched text spans within the snippet (never HTML) | 
**startMs** | **int** | Match moment: the start of the first matched segment (segment precision, not word alignment) | 
**tier** | **String** |  | 
**windowId** | **String** | Contributing segment range (first:last) | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


