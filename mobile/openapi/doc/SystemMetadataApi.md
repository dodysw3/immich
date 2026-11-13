# openapi.api.SystemMetadataApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to */api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getAdminOnboarding**](SystemMetadataApi.md#getadminonboarding) | **GET** /system-metadata/admin-onboarding | Retrieve admin onboarding
[**getReverseGeocodingState**](SystemMetadataApi.md#getreversegeocodingstate) | **GET** /system-metadata/reverse-geocoding-state | Retrieve reverse geocoding state
[**getVersionCheckState**](SystemMetadataApi.md#getversioncheckstate) | **GET** /system-metadata/version-check-state | Retrieve version check state
[**updateAdminOnboarding**](SystemMetadataApi.md#updateadminonboarding) | **POST** /system-metadata/admin-onboarding | Update admin onboarding


# **getAdminOnboarding**
> AdminOnboardingUpdateDto getAdminOnboarding()

Retrieve admin onboarding

Retrieve the current admin onboarding status.

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

final api = Openapi().getSystemMetadataApi();

try {
    final response = api.getAdminOnboarding();
    print(response);
} on DioException catch (e) {
    print('Exception when calling SystemMetadataApi->getAdminOnboarding: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AdminOnboardingUpdateDto**](AdminOnboardingUpdateDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getReverseGeocodingState**
> ReverseGeocodingStateResponseDto getReverseGeocodingState()

Retrieve reverse geocoding state

Retrieve the current state of the reverse geocoding import.

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

final api = Openapi().getSystemMetadataApi();

try {
    final response = api.getReverseGeocodingState();
    print(response);
} on DioException catch (e) {
    print('Exception when calling SystemMetadataApi->getReverseGeocodingState: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ReverseGeocodingStateResponseDto**](ReverseGeocodingStateResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVersionCheckState**
> VersionCheckStateResponseDto getVersionCheckState()

Retrieve version check state

Retrieve the current state of the version check process.

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

final api = Openapi().getSystemMetadataApi();

try {
    final response = api.getVersionCheckState();
    print(response);
} on DioException catch (e) {
    print('Exception when calling SystemMetadataApi->getVersionCheckState: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**VersionCheckStateResponseDto**](VersionCheckStateResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateAdminOnboarding**
> updateAdminOnboarding(adminOnboardingUpdateDto)

Update admin onboarding

Update the admin onboarding status.

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

final api = Openapi().getSystemMetadataApi();
final AdminOnboardingUpdateDto adminOnboardingUpdateDto = ; // AdminOnboardingUpdateDto | 

try {
    api.updateAdminOnboarding(adminOnboardingUpdateDto);
} on DioException catch (e) {
    print('Exception when calling SystemMetadataApi->updateAdminOnboarding: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adminOnboardingUpdateDto** | [**AdminOnboardingUpdateDto**](AdminOnboardingUpdateDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

