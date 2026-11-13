# openapi.model.PersonResponseDto

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**birthDate** | [**Date**](Date.md) | Person date of birth | 
**color** | **String** | Person color (hex) | [optional] 
**id** | **String** | Person ID | 
**isFavorite** | **bool** | Is favorite | [optional] 
**isHidden** | **bool** | Is hidden | 
**name** | **String** | Person name | 
**otherPeople** | [**BuiltList&lt;PersonOtherResponseDto&gt;**](PersonOtherResponseDto.md) |  | 
**sharedBy** | [**BuiltList&lt;PeopleUserResponseDto&gt;**](PeopleUserResponseDto.md) | Users that gave the current user access to this person | 
**sharedWith** | [**BuiltList&lt;PeopleUserResponseDto&gt;**](PeopleUserResponseDto.md) | Users the current user gave access to this person | 
**thumbnailPath** | **String** | Thumbnail path | 
**updatedAt** | [**DateTime**](DateTime.md) | Last update date | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


