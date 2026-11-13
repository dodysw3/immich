# openapi.api.ConfigAdminApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to */api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getAdminConfig**](ConfigAdminApi.md#getadminconfig) | **GET** /admin/config | Get the admin configuration
[**getAdminConfigDefaults**](ConfigAdminApi.md#getadminconfigdefaults) | **GET** /admin/config/defaults | Get the system configuration defaults
[**updateAdminConfig**](ConfigAdminApi.md#updateadminconfig) | **PUT** /admin/config | Update the system configuration


# **getAdminConfig**
> AdminConfigDto getAdminConfig()

Get the admin configuration

Retrieve admin configuration.

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

final api = Openapi().getConfigAdminApi();

try {
    final response = api.getAdminConfig();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ConfigAdminApi->getAdminConfig: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AdminConfigDto**](AdminConfigDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAdminConfigDefaults**
> AdminConfigDto getAdminConfigDefaults()

Get the system configuration defaults

Retrieve the default value of every system configuration property.

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

final api = Openapi().getConfigAdminApi();

try {
    final response = api.getAdminConfigDefaults();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ConfigAdminApi->getAdminConfigDefaults: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AdminConfigDto**](AdminConfigDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateAdminConfig**
> AdminConfigDto updateAdminConfig(adminConfigDto)

Update the system configuration

Update the system configuration with a new system configuration.

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

final api = Openapi().getConfigAdminApi();
final AdminConfigDto adminConfigDto = ; // AdminConfigDto | 

try {
    final response = api.updateAdminConfig(adminConfigDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ConfigAdminApi->updateAdminConfig: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adminConfigDto** | [**AdminConfigDto**](AdminConfigDto.md)|  | 

### Return type

[**AdminConfigDto**](AdminConfigDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

