# openapi.model.AdminConfigVideoNearDupDto

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**durationRelTol** | **double** | Relative duration tolerance as a fraction of the longer video | 
**enabled** | **bool** | Group near-duplicate videos via frame, audio, and metadata fingerprints when CLIP preview similarity finds none | 
**groupThreshold** | **double** | Minimum composite similarity before two videos are grouped as near-duplicates | 
**maxDurationDeltaMs** | **int** | Absolute duration tolerance in milliseconds for video near-duplicate candidates | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


