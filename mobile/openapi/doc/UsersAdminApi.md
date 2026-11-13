# openapi.api.UsersAdminApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to */api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createUserAdmin**](UsersAdminApi.md#createuseradmin) | **POST** /admin/users | Create a user
[**deleteUserAdmin**](UsersAdminApi.md#deleteuseradmin) | **DELETE** /admin/users/{id} | Delete a user
[**getUserAdmin**](UsersAdminApi.md#getuseradmin) | **GET** /admin/users/{id} | Retrieve a user
[**getUserCalendarHeatmapAdmin**](UsersAdminApi.md#getusercalendarheatmapadmin) | **GET** /admin/users/{id}/calendar-heatmap | Retrieve calendar heatmap activity
[**getUserPreferencesAdmin**](UsersAdminApi.md#getuserpreferencesadmin) | **GET** /admin/users/{id}/preferences | Retrieve user preferences
[**getUserSessionsAdmin**](UsersAdminApi.md#getusersessionsadmin) | **GET** /admin/users/{id}/sessions | Retrieve user sessions
[**getUserStatisticsAdmin**](UsersAdminApi.md#getuserstatisticsadmin) | **GET** /admin/users/{id}/statistics | Retrieve user statistics
[**restoreUserAdmin**](UsersAdminApi.md#restoreuseradmin) | **POST** /admin/users/{id}/restore | Restore a deleted user
[**searchUsersAdmin**](UsersAdminApi.md#searchusersadmin) | **GET** /admin/users | Search users
[**updateUserAdmin**](UsersAdminApi.md#updateuseradmin) | **PUT** /admin/users/{id} | Update a user
[**updateUserPreferencesAdmin**](UsersAdminApi.md#updateuserpreferencesadmin) | **PUT** /admin/users/{id}/preferences | Update user preferences


# **createUserAdmin**
> UserAdminResponseDto createUserAdmin(userAdminCreateDto)

Create a user

Create a new user.

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

final api = Openapi().getUsersAdminApi();
final UserAdminCreateDto userAdminCreateDto = ; // UserAdminCreateDto | 

try {
    final response = api.createUserAdmin(userAdminCreateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersAdminApi->createUserAdmin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userAdminCreateDto** | [**UserAdminCreateDto**](UserAdminCreateDto.md)|  | 

### Return type

[**UserAdminResponseDto**](UserAdminResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteUserAdmin**
> UserAdminResponseDto deleteUserAdmin(id, userAdminDeleteDto)

Delete a user

Delete a user.

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

final api = Openapi().getUsersAdminApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final UserAdminDeleteDto userAdminDeleteDto = ; // UserAdminDeleteDto | 

try {
    final response = api.deleteUserAdmin(id, userAdminDeleteDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersAdminApi->deleteUserAdmin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **userAdminDeleteDto** | [**UserAdminDeleteDto**](UserAdminDeleteDto.md)|  | 

### Return type

[**UserAdminResponseDto**](UserAdminResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserAdmin**
> UserAdminResponseDto getUserAdmin(id)

Retrieve a user

Retrieve  a specific user by their ID.

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

final api = Openapi().getUsersAdminApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getUserAdmin(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersAdminApi->getUserAdmin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**UserAdminResponseDto**](UserAdminResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserCalendarHeatmapAdmin**
> CalendarHeatmapResponseDto getUserCalendarHeatmapAdmin(id, from, to, type)

Retrieve calendar heatmap activity

Retrieve activity counts for a specified period, in a calendar heatmap format.

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

final api = Openapi().getUsersAdminApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final Date from = Mon Jan 01 07:00:00 WIB 2024; // Date | Start date in UTC
final Date to = Mon Jan 01 07:00:00 WIB 2024; // Date | End date in UTC
final CalendarHeatmapType type = ; // CalendarHeatmapType | 

try {
    final response = api.getUserCalendarHeatmapAdmin(id, from, to, type);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersAdminApi->getUserCalendarHeatmapAdmin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **from** | **Date**| Start date in UTC | [optional] 
 **to** | **Date**| End date in UTC | [optional] 
 **type** | [**CalendarHeatmapType**](.md)|  | [optional] 

### Return type

[**CalendarHeatmapResponseDto**](CalendarHeatmapResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserPreferencesAdmin**
> UserPreferencesResponseDto getUserPreferencesAdmin(id)

Retrieve user preferences

Retrieve the preferences of a specific user.

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

final api = Openapi().getUsersAdminApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getUserPreferencesAdmin(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersAdminApi->getUserPreferencesAdmin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**UserPreferencesResponseDto**](UserPreferencesResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserSessionsAdmin**
> BuiltList<SessionResponseDto> getUserSessionsAdmin(id)

Retrieve user sessions

Retrieve all sessions for a specific user.

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

final api = Openapi().getUsersAdminApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getUserSessionsAdmin(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersAdminApi->getUserSessionsAdmin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**BuiltList&lt;SessionResponseDto&gt;**](SessionResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserStatisticsAdmin**
> AssetStatsResponseDto getUserStatisticsAdmin(id, isFavorite, isTrashed, visibility)

Retrieve user statistics

Retrieve asset statistics for a specific user.

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

final api = Openapi().getUsersAdminApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final bool isFavorite = true; // bool | Filter by favorite status
final bool isTrashed = true; // bool | Filter by trash status
final AssetVisibility visibility = ; // AssetVisibility | 

try {
    final response = api.getUserStatisticsAdmin(id, isFavorite, isTrashed, visibility);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersAdminApi->getUserStatisticsAdmin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **isFavorite** | **bool**| Filter by favorite status | [optional] 
 **isTrashed** | **bool**| Filter by trash status | [optional] 
 **visibility** | [**AssetVisibility**](.md)|  | [optional] 

### Return type

[**AssetStatsResponseDto**](AssetStatsResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **restoreUserAdmin**
> UserAdminResponseDto restoreUserAdmin(id)

Restore a deleted user

Restore a previously deleted user.

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

final api = Openapi().getUsersAdminApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.restoreUserAdmin(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersAdminApi->restoreUserAdmin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**UserAdminResponseDto**](UserAdminResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchUsersAdmin**
> BuiltList<UserAdminResponseDto> searchUsersAdmin(id, withDeleted)

Search users

Search for users.

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

final api = Openapi().getUsersAdminApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | User ID filter
final bool withDeleted = true; // bool | Include deleted users

try {
    final response = api.searchUsersAdmin(id, withDeleted);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersAdminApi->searchUsersAdmin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| User ID filter | [optional] 
 **withDeleted** | **bool**| Include deleted users | [optional] 

### Return type

[**BuiltList&lt;UserAdminResponseDto&gt;**](UserAdminResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateUserAdmin**
> UserAdminResponseDto updateUserAdmin(id, userAdminUpdateDto)

Update a user

Update an existing user.

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

final api = Openapi().getUsersAdminApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final UserAdminUpdateDto userAdminUpdateDto = ; // UserAdminUpdateDto | 

try {
    final response = api.updateUserAdmin(id, userAdminUpdateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersAdminApi->updateUserAdmin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **userAdminUpdateDto** | [**UserAdminUpdateDto**](UserAdminUpdateDto.md)|  | 

### Return type

[**UserAdminResponseDto**](UserAdminResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateUserPreferencesAdmin**
> UserPreferencesResponseDto updateUserPreferencesAdmin(id, userPreferencesUpdateDto)

Update user preferences

Update the preferences of a specific user.

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

final api = Openapi().getUsersAdminApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final UserPreferencesUpdateDto userPreferencesUpdateDto = ; // UserPreferencesUpdateDto | 

try {
    final response = api.updateUserPreferencesAdmin(id, userPreferencesUpdateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersAdminApi->updateUserPreferencesAdmin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **userPreferencesUpdateDto** | [**UserPreferencesUpdateDto**](UserPreferencesUpdateDto.md)|  | 

### Return type

[**UserPreferencesResponseDto**](UserPreferencesResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

