# openapi.api.AssetsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to */api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**checkBulkUpload**](AssetsApi.md#checkbulkupload) | **POST** /assets/bulk-upload-check | Check bulk upload
[**copyAsset**](AssetsApi.md#copyasset) | **PUT** /assets/copy | Copy asset
[**deleteAssetMetadata**](AssetsApi.md#deleteassetmetadata) | **DELETE** /assets/{id}/metadata/{key} | Delete asset metadata by key
[**deleteAssets**](AssetsApi.md#deleteassets) | **DELETE** /assets | Delete assets
[**deleteBulkAssetMetadata**](AssetsApi.md#deletebulkassetmetadata) | **DELETE** /assets/metadata | Delete asset metadata
[**downloadAsset**](AssetsApi.md#downloadasset) | **GET** /assets/{id}/original | Download original asset
[**downloadAssetAnnotated**](AssetsApi.md#downloadassetannotated) | **GET** /assets/{id}/annotated-original | Download asset with face labels
[**editAsset**](AssetsApi.md#editasset) | **PUT** /assets/{id}/edits | Apply edits to an existing asset
[**endSession**](AssetsApi.md#endsession) | **DELETE** /assets/{id}/video/stream/{sessionId} | End HLS streaming session
[**getAssetAvMetadata**](AssetsApi.md#getassetavmetadata) | **GET** /assets/{id}/av-metadata | Retrieve audio/video stream metadata
[**getAssetEdits**](AssetsApi.md#getassetedits) | **GET** /assets/{id}/edits | Retrieve edits for an existing asset
[**getAssetInfo**](AssetsApi.md#getassetinfo) | **GET** /assets/{id} | Retrieve an asset
[**getAssetMetadata**](AssetsApi.md#getassetmetadata) | **GET** /assets/{id}/metadata | Get asset metadata
[**getAssetMetadataByKey**](AssetsApi.md#getassetmetadatabykey) | **GET** /assets/{id}/metadata/{key} | Retrieve asset metadata by key
[**getAssetOcr**](AssetsApi.md#getassetocr) | **GET** /assets/{id}/ocr | Retrieve asset OCR data
[**getAssetStatistics**](AssetsApi.md#getassetstatistics) | **GET** /assets/statistics | Get asset statistics
[**getFaceThumbnail**](AssetsApi.md#getfacethumbnail) | **GET** /assets/{id}/video-faces/{faceId}/thumbnail | Face crop from its representative frame
[**getMainPlaylist**](AssetsApi.md#getmainplaylist) | **GET** /assets/{id}/video/stream/main.m3u8 | Get HLS main playlist
[**getMediaPlaylist**](AssetsApi.md#getmediaplaylist) | **GET** /assets/{id}/video/stream/{sessionId}/{variantIndex}/playlist.m3u8 | Get HLS media playlist
[**getSegment**](AssetsApi.md#getsegment) | **GET** /assets/{id}/video/stream/{sessionId}/{variantIndex}/{filename} | Get HLS segment or init file
[**getVideoFaces**](AssetsApi.md#getvideofaces) | **GET** /assets/{id}/video-faces | List faces discovered in a video
[**playAssetVideo**](AssetsApi.md#playassetvideo) | **GET** /assets/{id}/video/playback | Play asset video
[**removeAssetEdits**](AssetsApi.md#removeassetedits) | **DELETE** /assets/{id}/edits | Remove edits from an existing asset
[**reportFailure**](AssetsApi.md#reportfailure) | **PUT** /external-ocr/assets/{id}/failure | Report external OCR failure
[**runAssetJobs**](AssetsApi.md#runassetjobs) | **POST** /assets/jobs | Run an asset job
[**updateAsset**](AssetsApi.md#updateasset) | **PUT** /assets/{id} | Update an asset
[**updateAssetMetadata**](AssetsApi.md#updateassetmetadata) | **PUT** /assets/{id}/metadata | Update asset metadata
[**updateAssets**](AssetsApi.md#updateassets) | **PUT** /assets | Update assets
[**updateBulkAssetMetadata**](AssetsApi.md#updatebulkassetmetadata) | **PUT** /assets/metadata | Upsert asset metadata
[**uploadAsset**](AssetsApi.md#uploadasset) | **POST** /assets | Upload asset
[**viewAsset**](AssetsApi.md#viewasset) | **GET** /assets/{id}/thumbnail | View asset thumbnail
[**writeResult**](AssetsApi.md#writeresult) | **PUT** /external-ocr/assets/{id}/result | Write external OCR result


# **checkBulkUpload**
> AssetBulkUploadCheckResponseDto checkBulkUpload(assetBulkUploadCheckDto)

Check bulk upload

Determine which assets have already been uploaded to the server based on their SHA1 checksums.

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

final api = Openapi().getAssetsApi();
final AssetBulkUploadCheckDto assetBulkUploadCheckDto = ; // AssetBulkUploadCheckDto | 

try {
    final response = api.checkBulkUpload(assetBulkUploadCheckDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->checkBulkUpload: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **assetBulkUploadCheckDto** | [**AssetBulkUploadCheckDto**](AssetBulkUploadCheckDto.md)|  | 

### Return type

[**AssetBulkUploadCheckResponseDto**](AssetBulkUploadCheckResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **copyAsset**
> copyAsset(assetCopyDto)

Copy asset

Copy asset information like albums, tags, etc. from one asset to another.

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

final api = Openapi().getAssetsApi();
final AssetCopyDto assetCopyDto = ; // AssetCopyDto | 

try {
    api.copyAsset(assetCopyDto);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->copyAsset: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **assetCopyDto** | [**AssetCopyDto**](AssetCopyDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteAssetMetadata**
> deleteAssetMetadata(id, key)

Delete asset metadata by key

Delete a specific metadata key-value pair associated with the specified asset.

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

final api = Openapi().getAssetsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Asset ID
final String key = key_example; // String | Metadata key

try {
    api.deleteAssetMetadata(id, key);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->deleteAssetMetadata: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Asset ID | 
 **key** | **String**| Metadata key | 

### Return type

void (empty response body)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteAssets**
> deleteAssets(assetBulkDeleteDto)

Delete assets

Deletes multiple assets at the same time.

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

final api = Openapi().getAssetsApi();
final AssetBulkDeleteDto assetBulkDeleteDto = ; // AssetBulkDeleteDto | 

try {
    api.deleteAssets(assetBulkDeleteDto);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->deleteAssets: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **assetBulkDeleteDto** | [**AssetBulkDeleteDto**](AssetBulkDeleteDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteBulkAssetMetadata**
> deleteBulkAssetMetadata(assetMetadataBulkDeleteDto)

Delete asset metadata

Delete metadata key-value pairs for multiple assets.

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

final api = Openapi().getAssetsApi();
final AssetMetadataBulkDeleteDto assetMetadataBulkDeleteDto = ; // AssetMetadataBulkDeleteDto | 

try {
    api.deleteBulkAssetMetadata(assetMetadataBulkDeleteDto);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->deleteBulkAssetMetadata: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **assetMetadataBulkDeleteDto** | [**AssetMetadataBulkDeleteDto**](AssetMetadataBulkDeleteDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **downloadAsset**
> Uint8List downloadAsset(id, edited, key, slug)

Download original asset

Downloads the original file of the specified asset.

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

final api = Openapi().getAssetsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final bool edited = true; // bool | Return edited asset if available
final String key = key_example; // String | 
final String slug = slug_example; // String | 

try {
    final response = api.downloadAsset(id, edited, key, slug);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->downloadAsset: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **edited** | **bool**| Return edited asset if available | [optional] 
 **key** | **String**|  | [optional] 
 **slug** | **String**|  | [optional] 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/octet-stream

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **downloadAssetAnnotated**
> Uint8List downloadAssetAnnotated(id, layers)

Download asset with face labels

Renders face boxes and labels onto the original or edited image.

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

final api = Openapi().getAssetsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final DownloadAssetAnnotatedLayersParameter layers = ; // DownloadAssetAnnotatedLayersParameter | Annotation layers to render

try {
    final response = api.downloadAssetAnnotated(id, layers);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->downloadAssetAnnotated: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **layers** | [**DownloadAssetAnnotatedLayersParameter**](.md)| Annotation layers to render | [optional] 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/octet-stream

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **editAsset**
> AssetEditsResponseDto editAsset(id, assetEditsCreateDto)

Apply edits to an existing asset

Apply a series of edit actions (crop, rotate, mirror) to the specified asset.

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

final api = Openapi().getAssetsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AssetEditsCreateDto assetEditsCreateDto = ; // AssetEditsCreateDto | 

try {
    final response = api.editAsset(id, assetEditsCreateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->editAsset: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **assetEditsCreateDto** | [**AssetEditsCreateDto**](AssetEditsCreateDto.md)|  | 

### Return type

[**AssetEditsResponseDto**](AssetEditsResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **endSession**
> endSession(id, sessionId, key, slug)

End HLS streaming session

Releases server resources for the streaming session.

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

final api = Openapi().getAssetsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String sessionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String key = key_example; // String | 
final String slug = slug_example; // String | 

try {
    api.endSession(id, sessionId, key, slug);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->endSession: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **sessionId** | **String**|  | 
 **key** | **String**|  | [optional] 
 **slug** | **String**|  | [optional] 

### Return type

void (empty response body)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAssetAvMetadata**
> AvMetadataResponseDto getAssetAvMetadata(id, key, slug)

Retrieve audio/video stream metadata

Retrieve the probed stream metadata (codec, bitrate, etc.) of a specific asset.

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

final api = Openapi().getAssetsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String key = key_example; // String | 
final String slug = slug_example; // String | 

try {
    final response = api.getAssetAvMetadata(id, key, slug);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->getAssetAvMetadata: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **key** | **String**|  | [optional] 
 **slug** | **String**|  | [optional] 

### Return type

[**AvMetadataResponseDto**](AvMetadataResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAssetEdits**
> AssetEditsResponseDto getAssetEdits(id)

Retrieve edits for an existing asset

Retrieve a series of edit actions (crop, rotate, mirror) associated with the specified asset.

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

final api = Openapi().getAssetsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getAssetEdits(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->getAssetEdits: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**AssetEditsResponseDto**](AssetEditsResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAssetInfo**
> AssetResponseDto getAssetInfo(id, key, slug)

Retrieve an asset

Retrieve detailed information about a specific asset.

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

final api = Openapi().getAssetsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String key = key_example; // String | 
final String slug = slug_example; // String | 

try {
    final response = api.getAssetInfo(id, key, slug);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->getAssetInfo: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **key** | **String**|  | [optional] 
 **slug** | **String**|  | [optional] 

### Return type

[**AssetResponseDto**](AssetResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAssetMetadata**
> BuiltList<AssetMetadataResponseDto> getAssetMetadata(id)

Get asset metadata

Retrieve all metadata key-value pairs associated with the specified asset.

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

final api = Openapi().getAssetsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getAssetMetadata(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->getAssetMetadata: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**BuiltList&lt;AssetMetadataResponseDto&gt;**](AssetMetadataResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAssetMetadataByKey**
> AssetMetadataResponseDto getAssetMetadataByKey(id, key)

Retrieve asset metadata by key

Retrieve the value of a specific metadata key associated with the specified asset.

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

final api = Openapi().getAssetsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Asset ID
final String key = key_example; // String | Metadata key

try {
    final response = api.getAssetMetadataByKey(id, key);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->getAssetMetadataByKey: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Asset ID | 
 **key** | **String**| Metadata key | 

### Return type

[**AssetMetadataResponseDto**](AssetMetadataResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAssetOcr**
> BuiltList<AssetOcrResponseDto> getAssetOcr(id)

Retrieve asset OCR data

Retrieve all OCR (Optical Character Recognition) data associated with the specified asset.

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

final api = Openapi().getAssetsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getAssetOcr(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->getAssetOcr: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**BuiltList&lt;AssetOcrResponseDto&gt;**](AssetOcrResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAssetStatistics**
> AssetStatsResponseDto getAssetStatistics(isFavorite, isTrashed, visibility)

Get asset statistics

Retrieve various statistics about the assets owned by the authenticated user.

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

final api = Openapi().getAssetsApi();
final bool isFavorite = true; // bool | Filter by favorite status
final bool isTrashed = true; // bool | Filter by trash status
final AssetVisibility visibility = ; // AssetVisibility | 

try {
    final response = api.getAssetStatistics(isFavorite, isTrashed, visibility);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->getAssetStatistics: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
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

# **getFaceThumbnail**
> Uint8List getFaceThumbnail(faceId, id)

Face crop from its representative frame

Crops the identity representative frame at its timestamp. WebP, cacheable per face until re-scan.

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

final api = Openapi().getAssetsApi();
final String faceId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getFaceThumbnail(faceId, id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->getFaceThumbnail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **faceId** | **String**|  | 
 **id** | **String**|  | 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/octet-stream

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMainPlaylist**
> String getMainPlaylist(id, key, slug)

Get HLS main playlist

Returns an HLS main playlist with all available variants for the asset.

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

final api = Openapi().getAssetsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String key = key_example; // String | 
final String slug = slug_example; // String | 

try {
    final response = api.getMainPlaylist(id, key, slug);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->getMainPlaylist: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **key** | **String**|  | [optional] 
 **slug** | **String**|  | [optional] 

### Return type

**String**

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.apple.mpegurl

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMediaPlaylist**
> String getMediaPlaylist(id, sessionId, variantIndex, key, slug, xImmichHlsPos)

Get HLS media playlist

Returns an HLS media playlist for one variant of the streaming session.

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

final api = Openapi().getAssetsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String sessionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final int variantIndex = 56; // int | 
final String key = key_example; // String | 
final String slug = slug_example; // String | 
final num xImmichHlsPos = 8.14; // num | 

try {
    final response = api.getMediaPlaylist(id, sessionId, variantIndex, key, slug, xImmichHlsPos);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->getMediaPlaylist: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **sessionId** | **String**|  | 
 **variantIndex** | **int**|  | 
 **key** | **String**|  | [optional] 
 **slug** | **String**|  | [optional] 
 **xImmichHlsPos** | **num**|  | [optional] 

### Return type

**String**

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.apple.mpegurl

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSegment**
> Uint8List getSegment(filename, id, sessionId, variantIndex, key, slug, xImmichHlsMsn)

Get HLS segment or init file

Streams an HLS init segment (init.mp4) or media segment (seg_N.m4s).

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

final api = Openapi().getAssetsApi();
final String filename = filename_example; // String | 
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String sessionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final int variantIndex = 56; // int | 
final String key = key_example; // String | 
final String slug = slug_example; // String | 
final int xImmichHlsMsn = 56; // int | 

try {
    final response = api.getSegment(filename, id, sessionId, variantIndex, key, slug, xImmichHlsMsn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->getSegment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filename** | **String**|  | 
 **id** | **String**|  | 
 **sessionId** | **String**|  | 
 **variantIndex** | **int**|  | 
 **key** | **String**|  | [optional] 
 **slug** | **String**|  | [optional] 
 **xImmichHlsMsn** | **int**|  | [optional] 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/octet-stream

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVideoFaces**
> VideoFacesResponseDto getVideoFaces(id)

List faces discovered in a video

Per-identity faces from the multi-frame video scan: first observed, sightings, and the latest run outcome for coverage display.

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

final api = Openapi().getAssetsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getVideoFaces(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->getVideoFaces: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**VideoFacesResponseDto**](VideoFacesResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playAssetVideo**
> Uint8List playAssetVideo(id, key, slug)

Play asset video

Streams the video file for the specified asset. This endpoint also supports byte range requests.

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

final api = Openapi().getAssetsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String key = key_example; // String | 
final String slug = slug_example; // String | 

try {
    final response = api.playAssetVideo(id, key, slug);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->playAssetVideo: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **key** | **String**|  | [optional] 
 **slug** | **String**|  | [optional] 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/octet-stream

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeAssetEdits**
> removeAssetEdits(id)

Remove edits from an existing asset

Removes all edit actions (crop, rotate, mirror) associated with the specified asset.

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

final api = Openapi().getAssetsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.removeAssetEdits(id);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->removeAssetEdits: $e\n');
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

# **reportFailure**
> reportFailure(id, externalOcrFailureDto)

Report external OCR failure

Store failure details from external OCR processing.

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

final api = Openapi().getAssetsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ExternalOcrFailureDto externalOcrFailureDto = ; // ExternalOcrFailureDto | 

try {
    api.reportFailure(id, externalOcrFailureDto);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->reportFailure: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **externalOcrFailureDto** | [**ExternalOcrFailureDto**](ExternalOcrFailureDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **runAssetJobs**
> runAssetJobs(assetJobsDto)

Run an asset job

Run a specific job on a set of assets.

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

final api = Openapi().getAssetsApi();
final AssetJobsDto assetJobsDto = ; // AssetJobsDto | 

try {
    api.runAssetJobs(assetJobsDto);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->runAssetJobs: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **assetJobsDto** | [**AssetJobsDto**](AssetJobsDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateAsset**
> AssetResponseDto updateAsset(id, updateAssetDto)

Update an asset

Update information of a specific asset.

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

final api = Openapi().getAssetsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final UpdateAssetDto updateAssetDto = ; // UpdateAssetDto | 

try {
    final response = api.updateAsset(id, updateAssetDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->updateAsset: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **updateAssetDto** | [**UpdateAssetDto**](UpdateAssetDto.md)|  | 

### Return type

[**AssetResponseDto**](AssetResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateAssetMetadata**
> BuiltList<AssetMetadataResponseDto> updateAssetMetadata(id, assetMetadataUpsertDto)

Update asset metadata

Update or add metadata key-value pairs for the specified asset.

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

final api = Openapi().getAssetsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AssetMetadataUpsertDto assetMetadataUpsertDto = ; // AssetMetadataUpsertDto | 

try {
    final response = api.updateAssetMetadata(id, assetMetadataUpsertDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->updateAssetMetadata: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **assetMetadataUpsertDto** | [**AssetMetadataUpsertDto**](AssetMetadataUpsertDto.md)|  | 

### Return type

[**BuiltList&lt;AssetMetadataResponseDto&gt;**](AssetMetadataResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateAssets**
> updateAssets(assetBulkUpdateDto)

Update assets

Updates multiple assets at the same time.

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

final api = Openapi().getAssetsApi();
final AssetBulkUpdateDto assetBulkUpdateDto = ; // AssetBulkUpdateDto | 

try {
    api.updateAssets(assetBulkUpdateDto);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->updateAssets: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **assetBulkUpdateDto** | [**AssetBulkUpdateDto**](AssetBulkUpdateDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateBulkAssetMetadata**
> BuiltList<AssetMetadataBulkResponseDto> updateBulkAssetMetadata(assetMetadataBulkUpsertDto)

Upsert asset metadata

Upsert metadata key-value pairs for multiple assets.

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

final api = Openapi().getAssetsApi();
final AssetMetadataBulkUpsertDto assetMetadataBulkUpsertDto = ; // AssetMetadataBulkUpsertDto | 

try {
    final response = api.updateBulkAssetMetadata(assetMetadataBulkUpsertDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->updateBulkAssetMetadata: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **assetMetadataBulkUpsertDto** | [**AssetMetadataBulkUpsertDto**](AssetMetadataBulkUpsertDto.md)|  | 

### Return type

[**BuiltList&lt;AssetMetadataBulkResponseDto&gt;**](AssetMetadataBulkResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadAsset**
> AssetMediaResponseDto uploadAsset(assetData, fileCreatedAt, fileModifiedAt, key, slug, xImmichChecksum, duration, filename, isFavorite, livePhotoVideoId, metadata, sidecarData, visibility)

Upload asset

Uploads a new asset to the server.

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

final api = Openapi().getAssetsApi();
final MultipartFile assetData = BINARY_DATA_HERE; // MultipartFile | Asset file data
final DateTime fileCreatedAt = 2013-10-20T19:20:30+01:00; // DateTime | File creation date
final DateTime fileModifiedAt = 2013-10-20T19:20:30+01:00; // DateTime | File modification date
final String key = key_example; // String | 
final String slug = slug_example; // String | 
final String xImmichChecksum = xImmichChecksum_example; // String | sha1 checksum that can be used for duplicate detection before the file is uploaded
final int duration = 56; // int | Duration in milliseconds (for videos)
final String filename = filename_example; // String | Filename
final bool isFavorite = true; // bool | Mark as favorite
final String livePhotoVideoId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Live photo video ID
final BuiltList<AssetMetadataUpsertItemDto> metadata = ; // BuiltList<AssetMetadataUpsertItemDto> | Asset metadata items
final MultipartFile sidecarData = BINARY_DATA_HERE; // MultipartFile | Sidecar file data
final AssetVisibility visibility = ; // AssetVisibility | 

try {
    final response = api.uploadAsset(assetData, fileCreatedAt, fileModifiedAt, key, slug, xImmichChecksum, duration, filename, isFavorite, livePhotoVideoId, metadata, sidecarData, visibility);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->uploadAsset: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **assetData** | **MultipartFile**| Asset file data | 
 **fileCreatedAt** | **DateTime**| File creation date | 
 **fileModifiedAt** | **DateTime**| File modification date | 
 **key** | **String**|  | [optional] 
 **slug** | **String**|  | [optional] 
 **xImmichChecksum** | **String**| sha1 checksum that can be used for duplicate detection before the file is uploaded | [optional] 
 **duration** | **int**| Duration in milliseconds (for videos) | [optional] 
 **filename** | **String**| Filename | [optional] 
 **isFavorite** | **bool**| Mark as favorite | [optional] 
 **livePhotoVideoId** | **String**| Live photo video ID | [optional] 
 **metadata** | [**BuiltList&lt;AssetMetadataUpsertItemDto&gt;**](AssetMetadataUpsertItemDto.md)| Asset metadata items | [optional] 
 **sidecarData** | **MultipartFile**| Sidecar file data | [optional] 
 **visibility** | [**AssetVisibility**](AssetVisibility.md)|  | [optional] 

### Return type

[**AssetMediaResponseDto**](AssetMediaResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **viewAsset**
> Uint8List viewAsset(id, edited, key, size, slug)

View asset thumbnail

Retrieve the thumbnail image for the specified asset. Viewing the fullsize thumbnail might redirect to downloadAsset, which requires a different permission.

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

final api = Openapi().getAssetsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final bool edited = true; // bool | Return edited asset if available
final String key = key_example; // String | 
final AssetMediaSize size = ; // AssetMediaSize | 
final String slug = slug_example; // String | 

try {
    final response = api.viewAsset(id, edited, key, size, slug);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->viewAsset: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **edited** | **bool**| Return edited asset if available | [optional] 
 **key** | **String**|  | [optional] 
 **size** | [**AssetMediaSize**](.md)|  | [optional] 
 **slug** | **String**|  | [optional] 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/octet-stream

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **writeResult**
> ExternalOcrWriteResponseDto writeResult(id, externalOcrResultDto)

Write external OCR result

Write external OCR result and searchable text through Immich repositories.

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

final api = Openapi().getAssetsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ExternalOcrResultDto externalOcrResultDto = ; // ExternalOcrResultDto | 

try {
    final response = api.writeResult(id, externalOcrResultDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AssetsApi->writeResult: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **externalOcrResultDto** | [**ExternalOcrResultDto**](ExternalOcrResultDto.md)|  | 

### Return type

[**ExternalOcrWriteResponseDto**](ExternalOcrWriteResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

