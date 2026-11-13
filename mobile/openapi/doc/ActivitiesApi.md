# openapi.api.ActivitiesApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to */api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createActivity**](ActivitiesApi.md#createactivity) | **POST** /activities | Create an activity
[**deleteActivity**](ActivitiesApi.md#deleteactivity) | **DELETE** /activities/{id} | Delete an activity
[**getActivities**](ActivitiesApi.md#getactivities) | **GET** /activities | List all activities
[**getActivityStatistics**](ActivitiesApi.md#getactivitystatistics) | **GET** /activities/statistics | Retrieve activity statistics


# **createActivity**
> ActivityResponseDto createActivity(activityCreateDto)

Create an activity

Create a like or a comment for an album, or an asset in an album.

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure API key authorization: cookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: api_key
//defaultApiClient.getAuthentication<ApiKeyAuth>('api_key').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('api_key').apiKeyPrefix = 'Bearer';

final api = Openapi().getActivitiesApi();
final ActivityCreateDto activityCreateDto = ; // ActivityCreateDto | 

try {
    final response = api.createActivity(activityCreateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ActivitiesApi->createActivity: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **activityCreateDto** | [**ActivityCreateDto**](ActivityCreateDto.md)|  | 

### Return type

[**ActivityResponseDto**](ActivityResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteActivity**
> deleteActivity(id)

Delete an activity

Removes a like or comment from a given album or asset in an album.

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure API key authorization: cookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: api_key
//defaultApiClient.getAuthentication<ApiKeyAuth>('api_key').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('api_key').apiKeyPrefix = 'Bearer';

final api = Openapi().getActivitiesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.deleteActivity(id);
} on DioException catch (e) {
    print('Exception when calling ActivitiesApi->deleteActivity: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getActivities**
> BuiltList<ActivityResponseDto> getActivities(albumId, assetId, level, type, userId)

List all activities

Returns a list of activities for the selected asset or album. The activities are returned in sorted order, with the oldest activities appearing first.

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure API key authorization: cookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: api_key
//defaultApiClient.getAuthentication<ApiKeyAuth>('api_key').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('api_key').apiKeyPrefix = 'Bearer';

final api = Openapi().getActivitiesApi();
final String albumId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Album ID
final String assetId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Asset ID (if activity is for an asset)
final ReactionLevel level = ; // ReactionLevel | 
final ReactionType type = ; // ReactionType | 
final String userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Filter by user ID

try {
    final response = api.getActivities(albumId, assetId, level, type, userId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ActivitiesApi->getActivities: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **albumId** | **String**| Album ID | 
 **assetId** | **String**| Asset ID (if activity is for an asset) | [optional] 
 **level** | [**ReactionLevel**](.md)|  | [optional] 
 **type** | [**ReactionType**](.md)|  | [optional] 
 **userId** | **String**| Filter by user ID | [optional] 

### Return type

[**BuiltList&lt;ActivityResponseDto&gt;**](ActivityResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getActivityStatistics**
> ActivityStatisticsResponseDto getActivityStatistics(albumId, assetId)

Retrieve activity statistics

Returns the number of likes and comments for a given album or asset in an album.

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure API key authorization: cookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: api_key
//defaultApiClient.getAuthentication<ApiKeyAuth>('api_key').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('api_key').apiKeyPrefix = 'Bearer';

final api = Openapi().getActivitiesApi();
final String albumId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Album ID
final String assetId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Asset ID (if activity is for an asset)

try {
    final response = api.getActivityStatistics(albumId, assetId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ActivitiesApi->getActivityStatistics: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **albumId** | **String**| Album ID | 
 **assetId** | **String**| Asset ID (if activity is for an asset) | [optional] 

### Return type

[**ActivityStatisticsResponseDto**](ActivityStatisticsResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

