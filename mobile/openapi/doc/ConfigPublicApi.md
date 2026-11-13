# openapi.api.ConfigPublicApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to */api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getPublicConfig**](ConfigPublicApi.md#getpublicconfig) | **GET** /public/config | Get the public configuration
[**getPublicConfigDefaults**](ConfigPublicApi.md#getpublicconfigdefaults) | **GET** /public/config/defaults | Get the public configuration defaults


# **getPublicConfig**
> PublicConfigDto getPublicConfig()

Get the public configuration

Retrieve the system configuration properties that are visible to everyone.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getConfigPublicApi();

try {
    final response = api.getPublicConfig();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ConfigPublicApi->getPublicConfig: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PublicConfigDto**](PublicConfigDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPublicConfigDefaults**
> PublicConfigDto getPublicConfigDefaults()

Get the public configuration defaults

Retrieve the default value of the configuration properties that are visible to everyone.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getConfigPublicApi();

try {
    final response = api.getPublicConfigDefaults();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ConfigPublicApi->getPublicConfigDefaults: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PublicConfigDto**](PublicConfigDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

