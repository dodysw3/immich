# openapi.api.ConfigUserApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to */api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getUserConfig**](ConfigUserApi.md#getuserconfig) | **GET** /config | Get the configuration with user visibility
[**getUserConfigDefaults**](ConfigUserApi.md#getuserconfigdefaults) | **GET** /config/defaults | Get the default configuration with user visibility


# **getUserConfig**
> UserConfigDto getUserConfig()

Get the configuration with user visibility

Retrieve the system configuration properties that are visible to logged in users.

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

final api = Openapi().getConfigUserApi();

try {
    final response = api.getUserConfig();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ConfigUserApi->getUserConfig: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserConfigDto**](UserConfigDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserConfigDefaults**
> UserConfigDto getUserConfigDefaults()

Get the default configuration with user visibility

Retrieve the default value of the configuration properties that are visible to logged in users.

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

final api = Openapi().getConfigUserApi();

try {
    final response = api.getUserConfigDefaults();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ConfigUserApi->getUserConfigDefaults: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserConfigDto**](UserConfigDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

