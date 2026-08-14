# openapi.api.MaintenanceAdminApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to */api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**detectPriorInstall**](MaintenanceAdminApi.md#detectpriorinstall) | **GET** /admin/maintenance/detect-install | Detect existing install
[**getMaintenanceStatus**](MaintenanceAdminApi.md#getmaintenancestatus) | **GET** /admin/maintenance/status | Get maintenance mode status
[**maintenanceLogin**](MaintenanceAdminApi.md#maintenancelogin) | **POST** /admin/maintenance/login | Log into maintenance mode
[**setMaintenanceMode**](MaintenanceAdminApi.md#setmaintenancemode) | **POST** /admin/maintenance | Set maintenance mode


# **detectPriorInstall**
> MaintenanceDetectInstallResponseDto detectPriorInstall()

Detect existing install

Collect integrity checks and other heuristics about local data.

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
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = MaintenanceAdminApi();

try {
    final result = api_instance.detectPriorInstall();
    print(result);
} catch (e) {
    print('Exception when calling MaintenanceAdminApi->detectPriorInstall: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**MaintenanceDetectInstallResponseDto**](MaintenanceDetectInstallResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMaintenanceStatus**
> MaintenanceStatusResponseDto getMaintenanceStatus()

Get maintenance mode status

Fetch information about the currently running maintenance action.

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = MaintenanceAdminApi();

try {
    final result = api_instance.getMaintenanceStatus();
    print(result);
} catch (e) {
    print('Exception when calling MaintenanceAdminApi->getMaintenanceStatus: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**MaintenanceStatusResponseDto**](MaintenanceStatusResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **maintenanceLogin**
> MaintenanceAuthDto maintenanceLogin(maintenanceLoginDto)

Log into maintenance mode

Login with maintenance token or cookie to receive current information and perform further actions.

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = MaintenanceAdminApi();
final maintenanceLoginDto = MaintenanceLoginDto(); // MaintenanceLoginDto | 

try {
    final result = api_instance.maintenanceLogin(maintenanceLoginDto);
    print(result);
} catch (e) {
    print('Exception when calling MaintenanceAdminApi->maintenanceLogin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **maintenanceLoginDto** | [**MaintenanceLoginDto**](MaintenanceLoginDto.md)|  | 

### Return type

[**MaintenanceAuthDto**](MaintenanceAuthDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setMaintenanceMode**
> setMaintenanceMode(setMaintenanceModeDto)

Set maintenance mode

Put Immich into or take it out of maintenance mode

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
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = MaintenanceAdminApi();
final setMaintenanceModeDto = SetMaintenanceModeDto(); // SetMaintenanceModeDto | 

try {
    api_instance.setMaintenanceMode(setMaintenanceModeDto);
} catch (e) {
    print('Exception when calling MaintenanceAdminApi->setMaintenanceMode: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **setMaintenanceModeDto** | [**SetMaintenanceModeDto**](SetMaintenanceModeDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

