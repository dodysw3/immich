# openapi.api.SearchApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to */api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getAssetsByCameraMake**](SearchApi.md#getassetsbycameramake) | **GET** /search/cameras | Retrieve assets by camera make
[**getAssetsByCity**](SearchApi.md#getassetsbycity) | **GET** /search/cities | Retrieve assets by city
[**getExploreCameras**](SearchApi.md#getexplorecameras) | **GET** /search/explore/cameras | Retrieve camera models for explore
[**getExploreData**](SearchApi.md#getexploredata) | **GET** /search/explore | Retrieve explore data
[**getMatchFrame**](SearchApi.md#getmatchframe) | **GET** /search/transcription/frame/{assetId}/{passageId} | Matching frame for a Transcription result
[**getSearchSuggestions**](SearchApi.md#getsearchsuggestions) | **GET** /search/suggestions | Retrieve search suggestions
[**searchAiInterpret**](SearchApi.md#searchaiinterpret) | **POST** /search/ai-interpret | AI interpretation search
[**searchAssetStatistics**](SearchApi.md#searchassetstatistics) | **POST** /search/statistics | Search asset statistics
[**searchAssets**](SearchApi.md#searchassets) | **POST** /search/metadata | Search assets by metadata
[**searchLargeAssets**](SearchApi.md#searchlargeassets) | **POST** /search/large-assets | Search large assets
[**searchMoments**](SearchApi.md#searchmoments) | **POST** /search/transcription/moments | Transcription additional moments
[**searchPerson**](SearchApi.md#searchperson) | **GET** /search/person | Search people
[**searchPlaces**](SearchApi.md#searchplaces) | **GET** /search/places | Search places
[**searchRandom**](SearchApi.md#searchrandom) | **POST** /search/random | Search random assets
[**searchSmart**](SearchApi.md#searchsmart) | **POST** /search/smart | Smart asset search
[**searchTranscription**](SearchApi.md#searchtranscription) | **POST** /search/transcription | Transcription search


# **getAssetsByCameraMake**
> BuiltList<AssetResponseDto> getAssetsByCameraMake()

Retrieve assets by camera make

Retrieve a list of assets with each asset belonging to a different camera make. This endpoint is used on the cameras page to show a single thumbnail for each camera brand the user has assets from.

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

final api = Openapi().getSearchApi();

try {
    final response = api.getAssetsByCameraMake();
    print(response);
} on DioException catch (e) {
    print('Exception when calling SearchApi->getAssetsByCameraMake: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;AssetResponseDto&gt;**](AssetResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAssetsByCity**
> BuiltList<AssetResponseDto> getAssetsByCity()

Retrieve assets by city

Retrieve a list of assets with each asset belonging to a different city. This endpoint is used on the places pages to show a single thumbnail for each city the user has assets in.

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

final api = Openapi().getSearchApi();

try {
    final response = api.getAssetsByCity();
    print(response);
} on DioException catch (e) {
    print('Exception when calling SearchApi->getAssetsByCity: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;AssetResponseDto&gt;**](AssetResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getExploreCameras**
> BuiltList<SearchExploreResponseDto> getExploreCameras(make)

Retrieve camera models for explore

Retrieve explore data for a specific camera make, with a single sample asset for each camera model of that make.

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

final api = Openapi().getSearchApi();
final String make = make_example; // String | Filter by camera make

try {
    final response = api.getExploreCameras(make);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SearchApi->getExploreCameras: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **make** | **String**| Filter by camera make | 

### Return type

[**BuiltList&lt;SearchExploreResponseDto&gt;**](SearchExploreResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getExploreData**
> BuiltList<SearchExploreResponseDto> getExploreData()

Retrieve explore data

Retrieve data for the explore section, such as popular people and places.

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

final api = Openapi().getSearchApi();

try {
    final response = api.getExploreData();
    print(response);
} on DioException catch (e) {
    print('Exception when calling SearchApi->getExploreData: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;SearchExploreResponseDto&gt;**](SearchExploreResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMatchFrame**
> Uint8List getMatchFrame(assetId, passageId)

Matching frame for a Transcription result

Decodes (and privately caches) the frame at the selected passage start. Identity is server-resolved from the opaque passage id; access is enforced on every response, including cached ones.

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

final api = Openapi().getSearchApi();
final String assetId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String passageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getMatchFrame(assetId, passageId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SearchApi->getMatchFrame: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **assetId** | **String**|  | 
 **passageId** | **String**|  | 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/octet-stream

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSearchSuggestions**
> BuiltList<String> getSearchSuggestions(type, country, includeNull, lensModel, make, model, state)

Retrieve search suggestions

Retrieve search suggestions based on partial input. This endpoint is used for typeahead search features.

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

final api = Openapi().getSearchApi();
final SearchSuggestionType type = ; // SearchSuggestionType | 
final String country = country_example; // String | Filter by country
final bool includeNull = true; // bool | Include null values in suggestions
final String lensModel = lensModel_example; // String | Filter by lens model
final String make = make_example; // String | Filter by camera make
final String model = model_example; // String | Filter by camera model
final String state = state_example; // String | Filter by state/province

try {
    final response = api.getSearchSuggestions(type, country, includeNull, lensModel, make, model, state);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SearchApi->getSearchSuggestions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **type** | [**SearchSuggestionType**](.md)|  | 
 **country** | **String**| Filter by country | [optional] 
 **includeNull** | **bool**| Include null values in suggestions | [optional] 
 **lensModel** | **String**| Filter by lens model | [optional] 
 **make** | **String**| Filter by camera make | [optional] 
 **model** | **String**| Filter by camera model | [optional] 
 **state** | **String**| Filter by state/province | [optional] 

### Return type

**BuiltList&lt;String&gt;**

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchAiInterpret**
> AiInterpretSearchResponseDto searchAiInterpret(aiInterpretSearchDto)

AI interpretation search

Search assets by the AI interpretation of their contents. Results are fused from a dense semantic branch and a lexical keyword branch.

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

final api = Openapi().getSearchApi();
final AiInterpretSearchDto aiInterpretSearchDto = ; // AiInterpretSearchDto | 

try {
    final response = api.searchAiInterpret(aiInterpretSearchDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SearchApi->searchAiInterpret: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **aiInterpretSearchDto** | [**AiInterpretSearchDto**](AiInterpretSearchDto.md)|  | 

### Return type

[**AiInterpretSearchResponseDto**](AiInterpretSearchResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchAssetStatistics**
> SearchStatisticsResponseDto searchAssetStatistics(statisticsSearchDto)

Search asset statistics

Retrieve statistical data about assets based on search criteria, such as the total matching count.

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

final api = Openapi().getSearchApi();
final StatisticsSearchDto statisticsSearchDto = ; // StatisticsSearchDto | 

try {
    final response = api.searchAssetStatistics(statisticsSearchDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SearchApi->searchAssetStatistics: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **statisticsSearchDto** | [**StatisticsSearchDto**](StatisticsSearchDto.md)|  | 

### Return type

[**SearchStatisticsResponseDto**](SearchStatisticsResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchAssets**
> SearchResponseDto searchAssets(metadataSearchDto, key, slug)

Search assets by metadata

Search for assets based on various metadata criteria.

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

final api = Openapi().getSearchApi();
final MetadataSearchDto metadataSearchDto = ; // MetadataSearchDto | 
final String key = key_example; // String | 
final String slug = slug_example; // String | 

try {
    final response = api.searchAssets(metadataSearchDto, key, slug);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SearchApi->searchAssets: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **metadataSearchDto** | [**MetadataSearchDto**](MetadataSearchDto.md)|  | 
 **key** | **String**|  | [optional] 
 **slug** | **String**|  | [optional] 

### Return type

[**SearchResponseDto**](SearchResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchLargeAssets**
> BuiltList<AssetResponseDto> searchLargeAssets(albumIds, city, country, createdAfter, createdBefore, hasAiInterpretation, isEncoded, isFavorite, isMotion, isNotInAlbum, isOffline, lensModel, libraryId, make, minFileSize, model, ocr, personIds, rating, size, state, tagIds, takenAfter, takenBefore, trashedAfter, trashedBefore, type, updatedAfter, updatedBefore, visibility, withDeleted, withExif)

Search large assets

Search for assets that are considered large based on specified criteria.

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

final api = Openapi().getSearchApi();
final BuiltList<String> albumIds = ; // BuiltList<String> | Filter by album IDs
final String city = city_example; // String | Filter by city name
final String country = country_example; // String | Filter by country name
final DateTime createdAfter = 2024-01-01T00:00Z; // DateTime | Filter by creation date (after)
final DateTime createdBefore = 2024-01-01T00:00Z; // DateTime | Filter by creation date (before)
final bool hasAiInterpretation = true; // bool | Filter by presence of a completed AI image interpretation
final bool isEncoded = true; // bool | Filter by encoded status
final bool isFavorite = true; // bool | Filter by favorite status
final bool isMotion = true; // bool | Filter by motion photo status
final bool isNotInAlbum = true; // bool | Filter assets not in any album
final bool isOffline = true; // bool | Filter by offline status
final String lensModel = lensModel_example; // String | Filter by lens model
final String libraryId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Library ID to filter by
final String make = make_example; // String | Filter by camera make
final int minFileSize = 56; // int | Minimum file size in bytes
final String model = model_example; // String | Filter by camera model
final String ocr = ocr_example; // String | Filter by OCR text content
final BuiltList<String> personIds = ; // BuiltList<String> | Filter by person IDs
final int rating = 56; // int | Filter by rating [1-5], or null for unrated
final int size = 56; // int | Number of results to return
final String state = state_example; // String | Filter by state/province name
final BuiltList<String> tagIds = ; // BuiltList<String> | Filter by tag IDs
final DateTime takenAfter = 2024-01-01T00:00Z; // DateTime | Filter by taken date (after)
final DateTime takenBefore = 2024-01-01T00:00Z; // DateTime | Filter by taken date (before)
final DateTime trashedAfter = 2024-01-01T00:00Z; // DateTime | Filter by trash date (after)
final DateTime trashedBefore = 2024-01-01T00:00Z; // DateTime | Filter by trash date (before)
final AssetTypeEnum type = ; // AssetTypeEnum | 
final DateTime updatedAfter = 2024-01-01T00:00Z; // DateTime | Filter by update date (after)
final DateTime updatedBefore = 2024-01-01T00:00Z; // DateTime | Filter by update date (before)
final AssetVisibility visibility = ; // AssetVisibility | 
final bool withDeleted = true; // bool | Include deleted assets
final bool withExif = true; // bool | Include EXIF data in response

try {
    final response = api.searchLargeAssets(albumIds, city, country, createdAfter, createdBefore, hasAiInterpretation, isEncoded, isFavorite, isMotion, isNotInAlbum, isOffline, lensModel, libraryId, make, minFileSize, model, ocr, personIds, rating, size, state, tagIds, takenAfter, takenBefore, trashedAfter, trashedBefore, type, updatedAfter, updatedBefore, visibility, withDeleted, withExif);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SearchApi->searchLargeAssets: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **albumIds** | [**BuiltList&lt;String&gt;**](String.md)| Filter by album IDs | [optional] 
 **city** | **String**| Filter by city name | [optional] 
 **country** | **String**| Filter by country name | [optional] 
 **createdAfter** | **DateTime**| Filter by creation date (after) | [optional] 
 **createdBefore** | **DateTime**| Filter by creation date (before) | [optional] 
 **hasAiInterpretation** | **bool**| Filter by presence of a completed AI image interpretation | [optional] 
 **isEncoded** | **bool**| Filter by encoded status | [optional] 
 **isFavorite** | **bool**| Filter by favorite status | [optional] 
 **isMotion** | **bool**| Filter by motion photo status | [optional] 
 **isNotInAlbum** | **bool**| Filter assets not in any album | [optional] 
 **isOffline** | **bool**| Filter by offline status | [optional] 
 **lensModel** | **String**| Filter by lens model | [optional] 
 **libraryId** | **String**| Library ID to filter by | [optional] 
 **make** | **String**| Filter by camera make | [optional] 
 **minFileSize** | **int**| Minimum file size in bytes | [optional] 
 **model** | **String**| Filter by camera model | [optional] 
 **ocr** | **String**| Filter by OCR text content | [optional] 
 **personIds** | [**BuiltList&lt;String&gt;**](String.md)| Filter by person IDs | [optional] 
 **rating** | **int**| Filter by rating [1-5], or null for unrated | [optional] 
 **size** | **int**| Number of results to return | [optional] [default to 250]
 **state** | **String**| Filter by state/province name | [optional] 
 **tagIds** | [**BuiltList&lt;String&gt;**](String.md)| Filter by tag IDs | [optional] 
 **takenAfter** | **DateTime**| Filter by taken date (after) | [optional] 
 **takenBefore** | **DateTime**| Filter by taken date (before) | [optional] 
 **trashedAfter** | **DateTime**| Filter by trash date (after) | [optional] 
 **trashedBefore** | **DateTime**| Filter by trash date (before) | [optional] 
 **type** | [**AssetTypeEnum**](.md)|  | [optional] 
 **updatedAfter** | **DateTime**| Filter by update date (after) | [optional] 
 **updatedBefore** | **DateTime**| Filter by update date (before) | [optional] 
 **visibility** | [**AssetVisibility**](.md)|  | [optional] 
 **withDeleted** | **bool**| Include deleted assets | [optional] 
 **withExif** | **bool**| Include EXIF data in response | [optional] 

### Return type

[**BuiltList&lt;AssetResponseDto&gt;**](AssetResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchMoments**
> TranscriptionMomentsResponseDto searchMoments(transcriptionMomentsDto)

Transcription additional moments

Paginated additional matching moments for one video and query, with the same access rules as the search itself.

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

final api = Openapi().getSearchApi();
final TranscriptionMomentsDto transcriptionMomentsDto = ; // TranscriptionMomentsDto | 

try {
    final response = api.searchMoments(transcriptionMomentsDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SearchApi->searchMoments: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **transcriptionMomentsDto** | [**TranscriptionMomentsDto**](TranscriptionMomentsDto.md)|  | 

### Return type

[**TranscriptionMomentsResponseDto**](TranscriptionMomentsResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchPerson**
> BuiltList<PersonResponseDto> searchPerson(name, withHidden)

Search people

Search for people by name.

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

final api = Openapi().getSearchApi();
final String name = name_example; // String | Person name to search for
final bool withHidden = true; // bool | Include hidden people

try {
    final response = api.searchPerson(name, withHidden);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SearchApi->searchPerson: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**| Person name to search for | 
 **withHidden** | **bool**| Include hidden people | [optional] 

### Return type

[**BuiltList&lt;PersonResponseDto&gt;**](PersonResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchPlaces**
> BuiltList<PlacesResponseDto> searchPlaces(name)

Search places

Search for places by name.

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

final api = Openapi().getSearchApi();
final String name = name_example; // String | Place name to search for

try {
    final response = api.searchPlaces(name);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SearchApi->searchPlaces: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**| Place name to search for | 

### Return type

[**BuiltList&lt;PlacesResponseDto&gt;**](PlacesResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchRandom**
> BuiltList<AssetResponseDto> searchRandom(randomSearchDto)

Search random assets

Retrieve a random selection of assets based on the provided criteria.

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

final api = Openapi().getSearchApi();
final RandomSearchDto randomSearchDto = ; // RandomSearchDto | 

try {
    final response = api.searchRandom(randomSearchDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SearchApi->searchRandom: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **randomSearchDto** | [**RandomSearchDto**](RandomSearchDto.md)|  | 

### Return type

[**BuiltList&lt;AssetResponseDto&gt;**](AssetResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchSmart**
> SearchResponseDto searchSmart(smartSearchDto)

Smart asset search

Perform a smart search for assets by using machine learning vectors to determine relevance.

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

final api = Openapi().getSearchApi();
final SmartSearchDto smartSearchDto = ; // SmartSearchDto | 

try {
    final response = api.searchSmart(smartSearchDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SearchApi->searchSmart: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **smartSearchDto** | [**SmartSearchDto**](SmartSearchDto.md)|  | 

### Return type

[**SearchResponseDto**](SearchResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchTranscription**
> TranscriptionSearchResponseDto searchTranscription(transcriptionSearchDto)

Transcription search

Search videos by words spoken in their audio. Exact phrases outrank exact all-token matches, which outrank spelling variants; timestamps are segment starts, not word-aligned.

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

final api = Openapi().getSearchApi();
final TranscriptionSearchDto transcriptionSearchDto = ; // TranscriptionSearchDto | 

try {
    final response = api.searchTranscription(transcriptionSearchDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SearchApi->searchTranscription: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **transcriptionSearchDto** | [**TranscriptionSearchDto**](TranscriptionSearchDto.md)|  | 

### Return type

[**TranscriptionSearchResponseDto**](TranscriptionSearchResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

