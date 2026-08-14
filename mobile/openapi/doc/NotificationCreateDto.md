# openapi.model.NotificationCreateDto

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**data** | [**Map<String, Object>**](Object.md) | Additional notification data | [optional] [default to const {}]
**description** | **String** | Notification description | [optional] 
**level** | [**NotificationLevel**](NotificationLevel.md) |  | [optional] 
**readAt** | [**DateTime**](DateTime.md) | Date when notification was read | [optional] 
**title** | **String** | Notification title | 
**type** | [**NotificationType**](NotificationType.md) |  | [optional] 
**userId** | **String** | User ID to send notification to | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


