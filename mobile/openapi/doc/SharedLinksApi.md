# openapi.api.SharedLinksApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to */api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addSharedLinkAssets**](SharedLinksApi.md#addsharedlinkassets) | **PUT** /shared-links/{id}/assets | Add assets to a shared link
[**createSharedLink**](SharedLinksApi.md#createsharedlink) | **POST** /shared-links | Create a shared link
[**getAllSharedLinks**](SharedLinksApi.md#getallsharedlinks) | **GET** /shared-links | Retrieve all shared links
[**getMySharedLink**](SharedLinksApi.md#getmysharedlink) | **GET** /shared-links/me | Retrieve current shared link
[**getSharedLinkById**](SharedLinksApi.md#getsharedlinkbyid) | **GET** /shared-links/{id} | Retrieve a shared link
[**removeSharedLink**](SharedLinksApi.md#removesharedlink) | **DELETE** /shared-links/{id} | Delete a shared link
[**removeSharedLinkAssets**](SharedLinksApi.md#removesharedlinkassets) | **DELETE** /shared-links/{id}/assets | Remove assets from a shared link
[**sharedLinkLogin**](SharedLinksApi.md#sharedlinklogin) | **POST** /shared-links/login | Shared link login
[**updateSharedLink**](SharedLinksApi.md#updatesharedlink) | **PATCH** /shared-links/{id} | Update a shared link


# **addSharedLinkAssets**
> BuiltList<AssetIdsResponseDto> addSharedLinkAssets(id, assetIdsDto)

Add assets to a shared link

Add assets to a specific shared link by its ID. This endpoint is only relevant for shared link of type individual.

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

final api = Openapi().getSharedLinksApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AssetIdsDto assetIdsDto = ; // AssetIdsDto | 

try {
    final response = api.addSharedLinkAssets(id, assetIdsDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SharedLinksApi->addSharedLinkAssets: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **assetIdsDto** | [**AssetIdsDto**](AssetIdsDto.md)|  | 

### Return type

[**BuiltList&lt;AssetIdsResponseDto&gt;**](AssetIdsResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createSharedLink**
> SharedLinkResponseDto createSharedLink(sharedLinkCreateDto)

Create a shared link

Create a new shared link.

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

final api = Openapi().getSharedLinksApi();
final SharedLinkCreateDto sharedLinkCreateDto = ; // SharedLinkCreateDto | 

try {
    final response = api.createSharedLink(sharedLinkCreateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SharedLinksApi->createSharedLink: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **sharedLinkCreateDto** | [**SharedLinkCreateDto**](SharedLinkCreateDto.md)|  | 

### Return type

[**SharedLinkResponseDto**](SharedLinkResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAllSharedLinks**
> BuiltList<SharedLinkResponseDto> getAllSharedLinks(albumId, id)

Retrieve all shared links

Retrieve a list of all shared links.

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

final api = Openapi().getSharedLinksApi();
final String albumId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Filter by album ID
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Filter by shared link ID

try {
    final response = api.getAllSharedLinks(albumId, id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SharedLinksApi->getAllSharedLinks: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **albumId** | **String**| Filter by album ID | [optional] 
 **id** | **String**| Filter by shared link ID | [optional] 

### Return type

[**BuiltList&lt;SharedLinkResponseDto&gt;**](SharedLinkResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMySharedLink**
> SharedLinkResponseDto getMySharedLink(key, slug)

Retrieve current shared link

Retrieve the current shared link associated with authentication method.

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

final api = Openapi().getSharedLinksApi();
final String key = key_example; // String | 
final String slug = slug_example; // String | 

try {
    final response = api.getMySharedLink(key, slug);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SharedLinksApi->getMySharedLink: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **key** | **String**|  | [optional] 
 **slug** | **String**|  | [optional] 

### Return type

[**SharedLinkResponseDto**](SharedLinkResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSharedLinkById**
> SharedLinkResponseDto getSharedLinkById(id)

Retrieve a shared link

Retrieve a specific shared link by its ID.

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

final api = Openapi().getSharedLinksApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getSharedLinkById(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SharedLinksApi->getSharedLinkById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**SharedLinkResponseDto**](SharedLinkResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeSharedLink**
> removeSharedLink(id)

Delete a shared link

Delete a specific shared link by its ID.

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

final api = Openapi().getSharedLinksApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.removeSharedLink(id);
} on DioException catch (e) {
    print('Exception when calling SharedLinksApi->removeSharedLink: $e\n');
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

# **removeSharedLinkAssets**
> BuiltList<AssetIdsResponseDto> removeSharedLinkAssets(id, assetIdsDto)

Remove assets from a shared link

Remove assets from a specific shared link by its ID. This endpoint is only relevant for shared link of type individual.

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

final api = Openapi().getSharedLinksApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AssetIdsDto assetIdsDto = ; // AssetIdsDto | 

try {
    final response = api.removeSharedLinkAssets(id, assetIdsDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SharedLinksApi->removeSharedLinkAssets: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **assetIdsDto** | [**AssetIdsDto**](AssetIdsDto.md)|  | 

### Return type

[**BuiltList&lt;AssetIdsResponseDto&gt;**](AssetIdsResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sharedLinkLogin**
> SharedLinkResponseDto sharedLinkLogin(sharedLinkLoginDto, key, slug)

Shared link login

Login to a password protected shared link

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

final api = Openapi().getSharedLinksApi();
final SharedLinkLoginDto sharedLinkLoginDto = ; // SharedLinkLoginDto | 
final String key = key_example; // String | 
final String slug = slug_example; // String | 

try {
    final response = api.sharedLinkLogin(sharedLinkLoginDto, key, slug);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SharedLinksApi->sharedLinkLogin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **sharedLinkLoginDto** | [**SharedLinkLoginDto**](SharedLinkLoginDto.md)|  | 
 **key** | **String**|  | [optional] 
 **slug** | **String**|  | [optional] 

### Return type

[**SharedLinkResponseDto**](SharedLinkResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateSharedLink**
> SharedLinkResponseDto updateSharedLink(id, sharedLinkEditDto)

Update a shared link

Update an existing shared link by its ID.

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

final api = Openapi().getSharedLinksApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final SharedLinkEditDto sharedLinkEditDto = ; // SharedLinkEditDto | 

try {
    final response = api.updateSharedLink(id, sharedLinkEditDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SharedLinksApi->updateSharedLink: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **sharedLinkEditDto** | [**SharedLinkEditDto**](SharedLinkEditDto.md)|  | 

### Return type

[**SharedLinkResponseDto**](SharedLinkResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

