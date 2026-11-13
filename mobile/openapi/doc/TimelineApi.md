# openapi.api.TimelineApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to */api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getTimeBucket**](TimelineApi.md#gettimebucket) | **GET** /timeline/bucket | Get time bucket
[**getTimeBuckets**](TimelineApi.md#gettimebuckets) | **GET** /timeline/buckets | Get time buckets


# **getTimeBucket**
> TimeBucketAssetResponseDto getTimeBucket(timeBucket, albumId, bbox, isFavorite, isTrashed, key, order, orderBy, personId, slug, tagId, userId, visibility, withCoordinates, withPartners, withStacked)

Get time bucket

Retrieve a string of all asset ids in a given time bucket.

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

final api = Openapi().getTimelineApi();
final String timeBucket = 2024-01-01T00:00:00.000Z; // String | Time bucket identifier in YYYY-MM-DDT00:00:00.000Z format
final String albumId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Filter assets belonging to a specific album
final String bbox = 11.075683,49.416711,11.117589,49.454875; // String | Bounding box coordinates as west,south,east,north (WGS84)
final bool isFavorite = true; // bool | Filter by favorite status (true for favorites only, false for non-favorites only)
final bool isTrashed = true; // bool | Filter by trash status (true for trashed assets only, false for non-trashed only)
final String key = key_example; // String | 
final AssetOrder order = ; // AssetOrder | Sort order for assets within time buckets (ASC for oldest first, DESC for newest first)
final AssetOrderBy orderBy = ; // AssetOrderBy | Date to group and order assets by (takenAt for date taken, createdAt for date added to Immich)
final String personId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Filter assets containing a specific person (face recognition)
final String slug = slug_example; // String | 
final String tagId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Filter assets with a specific tag
final String userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Filter assets by specific user ID
final AssetVisibility visibility = ; // AssetVisibility | Filter by asset visibility status (ARCHIVE, TIMELINE, HIDDEN, LOCKED)
final bool withCoordinates = true; // bool | Include location data in the response
final bool withPartners = true; // bool | Include assets shared by partners
final bool withStacked = true; // bool | Include stacked assets in the response. When true, only primary assets from stacks are returned.

try {
    final response = api.getTimeBucket(timeBucket, albumId, bbox, isFavorite, isTrashed, key, order, orderBy, personId, slug, tagId, userId, visibility, withCoordinates, withPartners, withStacked);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TimelineApi->getTimeBucket: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **timeBucket** | **String**| Time bucket identifier in YYYY-MM-DDT00:00:00.000Z format | 
 **albumId** | **String**| Filter assets belonging to a specific album | [optional] 
 **bbox** | **String**| Bounding box coordinates as west,south,east,north (WGS84) | [optional] 
 **isFavorite** | **bool**| Filter by favorite status (true for favorites only, false for non-favorites only) | [optional] 
 **isTrashed** | **bool**| Filter by trash status (true for trashed assets only, false for non-trashed only) | [optional] 
 **key** | **String**|  | [optional] 
 **order** | [**AssetOrder**](.md)| Sort order for assets within time buckets (ASC for oldest first, DESC for newest first) | [optional] 
 **orderBy** | [**AssetOrderBy**](.md)| Date to group and order assets by (takenAt for date taken, createdAt for date added to Immich) | [optional] 
 **personId** | **String**| Filter assets containing a specific person (face recognition) | [optional] 
 **slug** | **String**|  | [optional] 
 **tagId** | **String**| Filter assets with a specific tag | [optional] 
 **userId** | **String**| Filter assets by specific user ID | [optional] 
 **visibility** | [**AssetVisibility**](.md)| Filter by asset visibility status (ARCHIVE, TIMELINE, HIDDEN, LOCKED) | [optional] 
 **withCoordinates** | **bool**| Include location data in the response | [optional] 
 **withPartners** | **bool**| Include assets shared by partners | [optional] 
 **withStacked** | **bool**| Include stacked assets in the response. When true, only primary assets from stacks are returned. | [optional] 

### Return type

[**TimeBucketAssetResponseDto**](TimeBucketAssetResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTimeBuckets**
> BuiltList<TimeBucketsResponseDto> getTimeBuckets(albumId, bbox, isFavorite, isTrashed, key, order, orderBy, personId, slug, tagId, userId, visibility, withCoordinates, withPartners, withStacked)

Get time buckets

Retrieve a list of all minimal time buckets.

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

final api = Openapi().getTimelineApi();
final String albumId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Filter assets belonging to a specific album
final String bbox = 11.075683,49.416711,11.117589,49.454875; // String | Bounding box coordinates as west,south,east,north (WGS84)
final bool isFavorite = true; // bool | Filter by favorite status (true for favorites only, false for non-favorites only)
final bool isTrashed = true; // bool | Filter by trash status (true for trashed assets only, false for non-trashed only)
final String key = key_example; // String | 
final AssetOrder order = ; // AssetOrder | Sort order for assets within time buckets (ASC for oldest first, DESC for newest first)
final AssetOrderBy orderBy = ; // AssetOrderBy | Date to group and order assets by (takenAt for date taken, createdAt for date added to Immich)
final String personId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Filter assets containing a specific person (face recognition)
final String slug = slug_example; // String | 
final String tagId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Filter assets with a specific tag
final String userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Filter assets by specific user ID
final AssetVisibility visibility = ; // AssetVisibility | Filter by asset visibility status (ARCHIVE, TIMELINE, HIDDEN, LOCKED)
final bool withCoordinates = true; // bool | Include location data in the response
final bool withPartners = true; // bool | Include assets shared by partners
final bool withStacked = true; // bool | Include stacked assets in the response. When true, only primary assets from stacks are returned.

try {
    final response = api.getTimeBuckets(albumId, bbox, isFavorite, isTrashed, key, order, orderBy, personId, slug, tagId, userId, visibility, withCoordinates, withPartners, withStacked);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TimelineApi->getTimeBuckets: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **albumId** | **String**| Filter assets belonging to a specific album | [optional] 
 **bbox** | **String**| Bounding box coordinates as west,south,east,north (WGS84) | [optional] 
 **isFavorite** | **bool**| Filter by favorite status (true for favorites only, false for non-favorites only) | [optional] 
 **isTrashed** | **bool**| Filter by trash status (true for trashed assets only, false for non-trashed only) | [optional] 
 **key** | **String**|  | [optional] 
 **order** | [**AssetOrder**](.md)| Sort order for assets within time buckets (ASC for oldest first, DESC for newest first) | [optional] 
 **orderBy** | [**AssetOrderBy**](.md)| Date to group and order assets by (takenAt for date taken, createdAt for date added to Immich) | [optional] 
 **personId** | **String**| Filter assets containing a specific person (face recognition) | [optional] 
 **slug** | **String**|  | [optional] 
 **tagId** | **String**| Filter assets with a specific tag | [optional] 
 **userId** | **String**| Filter assets by specific user ID | [optional] 
 **visibility** | [**AssetVisibility**](.md)| Filter by asset visibility status (ARCHIVE, TIMELINE, HIDDEN, LOCKED) | [optional] 
 **withCoordinates** | **bool**| Include location data in the response | [optional] 
 **withPartners** | **bool**| Include assets shared by partners | [optional] 
 **withStacked** | **bool**| Include stacked assets in the response. When true, only primary assets from stacks are returned. | [optional] 

### Return type

[**BuiltList&lt;TimeBucketsResponseDto&gt;**](TimeBucketsResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

