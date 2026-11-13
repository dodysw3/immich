# openapi.api.AlbumsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to */api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addAssetsToAlbum**](AlbumsApi.md#addassetstoalbum) | **PUT** /albums/{id}/assets | Add assets to an album
[**addAssetsToAlbums**](AlbumsApi.md#addassetstoalbums) | **PUT** /albums/assets | Add assets to albums
[**addUsersToAlbum**](AlbumsApi.md#adduserstoalbum) | **PUT** /albums/{id}/users | Share album with users
[**createAlbum**](AlbumsApi.md#createalbum) | **POST** /albums | Create an album
[**deleteAlbum**](AlbumsApi.md#deletealbum) | **DELETE** /albums/{id} | Delete an album
[**getAlbumInfo**](AlbumsApi.md#getalbuminfo) | **GET** /albums/{id} | Retrieve an album
[**getAlbumMapMarkers**](AlbumsApi.md#getalbummapmarkers) | **GET** /albums/{id}/map-markers | Retrieve album map markers
[**getAlbumStatistics**](AlbumsApi.md#getalbumstatistics) | **GET** /albums/statistics | Retrieve album statistics
[**getAllAlbums**](AlbumsApi.md#getallalbums) | **GET** /albums | List all albums
[**removeAssetFromAlbum**](AlbumsApi.md#removeassetfromalbum) | **DELETE** /albums/{id}/assets | Remove assets from an album
[**removeUserFromAlbum**](AlbumsApi.md#removeuserfromalbum) | **DELETE** /albums/{id}/user/{userId} | Remove user from album
[**updateAlbumInfo**](AlbumsApi.md#updatealbuminfo) | **PATCH** /albums/{id} | Update an album
[**updateAlbumUser**](AlbumsApi.md#updatealbumuser) | **PUT** /albums/{id}/user/{userId} | Update user role


# **addAssetsToAlbum**
> BuiltList<BulkIdResponseDto> addAssetsToAlbum(id, bulkIdsDto)

Add assets to an album

Add multiple assets to a specific album by its ID.

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

final api = Openapi().getAlbumsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final BulkIdsDto bulkIdsDto = ; // BulkIdsDto | 

try {
    final response = api.addAssetsToAlbum(id, bulkIdsDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AlbumsApi->addAssetsToAlbum: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **bulkIdsDto** | [**BulkIdsDto**](BulkIdsDto.md)|  | 

### Return type

[**BuiltList&lt;BulkIdResponseDto&gt;**](BulkIdResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **addAssetsToAlbums**
> AlbumsAddAssetsResponseDto addAssetsToAlbums(albumsAddAssetsDto)

Add assets to albums

Send a list of asset IDs and album IDs to add each asset to each album.

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

final api = Openapi().getAlbumsApi();
final AlbumsAddAssetsDto albumsAddAssetsDto = ; // AlbumsAddAssetsDto | 

try {
    final response = api.addAssetsToAlbums(albumsAddAssetsDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AlbumsApi->addAssetsToAlbums: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **albumsAddAssetsDto** | [**AlbumsAddAssetsDto**](AlbumsAddAssetsDto.md)|  | 

### Return type

[**AlbumsAddAssetsResponseDto**](AlbumsAddAssetsResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **addUsersToAlbum**
> AlbumResponseDto addUsersToAlbum(id, addUsersDto)

Share album with users

Share an album with multiple users. Each user can be given a specific role in the album.

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

final api = Openapi().getAlbumsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AddUsersDto addUsersDto = ; // AddUsersDto | 

try {
    final response = api.addUsersToAlbum(id, addUsersDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AlbumsApi->addUsersToAlbum: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **addUsersDto** | [**AddUsersDto**](AddUsersDto.md)|  | 

### Return type

[**AlbumResponseDto**](AlbumResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createAlbum**
> AlbumResponseDto createAlbum(createAlbumDto)

Create an album

Create a new album. The album can also be created with initial users and assets.

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

final api = Openapi().getAlbumsApi();
final CreateAlbumDto createAlbumDto = ; // CreateAlbumDto | 

try {
    final response = api.createAlbum(createAlbumDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AlbumsApi->createAlbum: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createAlbumDto** | [**CreateAlbumDto**](CreateAlbumDto.md)|  | 

### Return type

[**AlbumResponseDto**](AlbumResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteAlbum**
> deleteAlbum(id)

Delete an album

Delete a specific album by its ID. Note the album is initially trashed and then immediately scheduled for deletion, but relies on a background job to complete the process.

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

final api = Openapi().getAlbumsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.deleteAlbum(id);
} on DioException catch (e) {
    print('Exception when calling AlbumsApi->deleteAlbum: $e\n');
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

# **getAlbumInfo**
> AlbumResponseDto getAlbumInfo(id, key, slug)

Retrieve an album

Retrieve information about a specific album by its ID.

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

final api = Openapi().getAlbumsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String key = key_example; // String | 
final String slug = slug_example; // String | 

try {
    final response = api.getAlbumInfo(id, key, slug);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AlbumsApi->getAlbumInfo: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **key** | **String**|  | [optional] 
 **slug** | **String**|  | [optional] 

### Return type

[**AlbumResponseDto**](AlbumResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAlbumMapMarkers**
> BuiltList<MapMarkerResponseDto> getAlbumMapMarkers(id, key, slug)

Retrieve album map markers

Retrieve map marker information for a specific album by its ID.

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

final api = Openapi().getAlbumsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String key = key_example; // String | 
final String slug = slug_example; // String | 

try {
    final response = api.getAlbumMapMarkers(id, key, slug);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AlbumsApi->getAlbumMapMarkers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **key** | **String**|  | [optional] 
 **slug** | **String**|  | [optional] 

### Return type

[**BuiltList&lt;MapMarkerResponseDto&gt;**](MapMarkerResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAlbumStatistics**
> AlbumStatisticsResponseDto getAlbumStatistics()

Retrieve album statistics

Returns statistics about the albums available to the authenticated user.

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

final api = Openapi().getAlbumsApi();

try {
    final response = api.getAlbumStatistics();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AlbumsApi->getAlbumStatistics: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AlbumStatisticsResponseDto**](AlbumStatisticsResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAllAlbums**
> BuiltList<AlbumResponseDto> getAllAlbums(assetId, id, isOwned, isShared, name)

List all albums

Retrieve a list of albums available to the authenticated user.

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

final api = Openapi().getAlbumsApi();
final String assetId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Filter albums containing this asset ID (ignores other parameters)
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Album ID
final bool isOwned = true; // bool | Filter by ownership: true = only owned, false = only shared-with-me, undefined = no filter
final bool isShared = true; // bool | Filter by shared status: true = only shared, false = not shared, undefined = no filter
final String name = name_example; // String | Album name (exact match)

try {
    final response = api.getAllAlbums(assetId, id, isOwned, isShared, name);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AlbumsApi->getAllAlbums: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **assetId** | **String**| Filter albums containing this asset ID (ignores other parameters) | [optional] 
 **id** | **String**| Album ID | [optional] 
 **isOwned** | **bool**| Filter by ownership: true = only owned, false = only shared-with-me, undefined = no filter | [optional] 
 **isShared** | **bool**| Filter by shared status: true = only shared, false = not shared, undefined = no filter | [optional] 
 **name** | **String**| Album name (exact match) | [optional] 

### Return type

[**BuiltList&lt;AlbumResponseDto&gt;**](AlbumResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeAssetFromAlbum**
> BuiltList<BulkIdResponseDto> removeAssetFromAlbum(id, bulkIdsDto)

Remove assets from an album

Remove multiple assets from a specific album by its ID.

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

final api = Openapi().getAlbumsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final BulkIdsDto bulkIdsDto = ; // BulkIdsDto | 

try {
    final response = api.removeAssetFromAlbum(id, bulkIdsDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AlbumsApi->removeAssetFromAlbum: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **bulkIdsDto** | [**BulkIdsDto**](BulkIdsDto.md)|  | 

### Return type

[**BuiltList&lt;BulkIdResponseDto&gt;**](BulkIdResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeUserFromAlbum**
> removeUserFromAlbum(id, userId)

Remove user from album

Remove a user from an album. Use an ID of \"me\" to leave a shared album.

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

final api = Openapi().getAlbumsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Album ID
final String userId = userId_example; // String | Album user ID, or \"me\" to reference the current user.

try {
    api.removeUserFromAlbum(id, userId);
} on DioException catch (e) {
    print('Exception when calling AlbumsApi->removeUserFromAlbum: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Album ID | 
 **userId** | **String**| Album user ID, or \"me\" to reference the current user. | 

### Return type

void (empty response body)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateAlbumInfo**
> AlbumResponseDto updateAlbumInfo(id, updateAlbumDto)

Update an album

Update the information of a specific album by its ID. This endpoint can be used to update the album name, description, sort order, etc. However, it is not used to add or remove assets or users from the album.

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

final api = Openapi().getAlbumsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final UpdateAlbumDto updateAlbumDto = ; // UpdateAlbumDto | 

try {
    final response = api.updateAlbumInfo(id, updateAlbumDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AlbumsApi->updateAlbumInfo: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **updateAlbumDto** | [**UpdateAlbumDto**](UpdateAlbumDto.md)|  | 

### Return type

[**AlbumResponseDto**](AlbumResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateAlbumUser**
> updateAlbumUser(id, userId, updateAlbumUserDto)

Update user role

Change the role for a specific user in a specific album.

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

final api = Openapi().getAlbumsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Album ID
final String userId = userId_example; // String | Album user ID, or \"me\" to reference the current user.
final UpdateAlbumUserDto updateAlbumUserDto = ; // UpdateAlbumUserDto | 

try {
    api.updateAlbumUser(id, userId, updateAlbumUserDto);
} on DioException catch (e) {
    print('Exception when calling AlbumsApi->updateAlbumUser: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Album ID | 
 **userId** | **String**| Album user ID, or \"me\" to reference the current user. | 
 **updateAlbumUserDto** | [**UpdateAlbumUserDto**](UpdateAlbumUserDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

