# openapi.api.PeopleApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to */api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createPerson**](PeopleApi.md#createperson) | **POST** /people | Create a person
[**deletePeople**](PeopleApi.md#deletepeople) | **DELETE** /people | Delete people
[**deletePerson**](PeopleApi.md#deleteperson) | **DELETE** /people/{id} | Delete person
[**getAllPeople**](PeopleApi.md#getallpeople) | **GET** /people | Get all people
[**getPerson**](PeopleApi.md#getperson) | **GET** /people/{id} | Get a person
[**getPersonAssets**](PeopleApi.md#getpersonassets) | **GET** /people/{id}/assets | Get person assets
[**getPersonStatistics**](PeopleApi.md#getpersonstatistics) | **GET** /people/{id}/statistics | Get person statistics
[**getPersonThumbnail**](PeopleApi.md#getpersonthumbnail) | **GET** /people/{id}/thumbnail | Get person thumbnail
[**getRecentlyMatched**](PeopleApi.md#getrecentlymatched) | **GET** /people/recently-matched | Get recently matched faces
[**getUsersForPeople**](PeopleApi.md#getusersforpeople) | **GET** /people/users | Get people access
[**mergePeople**](PeopleApi.md#mergepeople) | **POST** /people/merge | Merge people
[**mergePersonLegacy**](PeopleApi.md#mergepersonlegacy) | **POST** /people/{id}/merge | Merge people
[**reassignFaces**](PeopleApi.md#reassignfaces) | **PUT** /people/{id}/reassign | Reassign faces
[**removeUsersFromPeople**](PeopleApi.md#removeusersfrompeople) | **DELETE** /people/users | Remove users from people
[**updatePeople**](PeopleApi.md#updatepeople) | **PUT** /people | Update people
[**updatePerson**](PeopleApi.md#updateperson) | **PUT** /people/{id} | Update person
[**upsertPeopleUsers**](PeopleApi.md#upsertpeopleusers) | **PUT** /people/users | Upsert user access


# **createPerson**
> PersonResponseDto createPerson(personCreateDto)

Create a person

Create a new person that can have multiple faces assigned to them.

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

final api = Openapi().getPeopleApi();
final PersonCreateDto personCreateDto = ; // PersonCreateDto | 

try {
    final response = api.createPerson(personCreateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PeopleApi->createPerson: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **personCreateDto** | [**PersonCreateDto**](PersonCreateDto.md)|  | 

### Return type

[**PersonResponseDto**](PersonResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deletePeople**
> deletePeople(peopleDeleteDto)

Delete people

Bulk delete a list of people at once.

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

final api = Openapi().getPeopleApi();
final PeopleDeleteDto peopleDeleteDto = ; // PeopleDeleteDto | 

try {
    api.deletePeople(peopleDeleteDto);
} on DioException catch (e) {
    print('Exception when calling PeopleApi->deletePeople: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **peopleDeleteDto** | [**PeopleDeleteDto**](PeopleDeleteDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deletePerson**
> deletePerson(id, personDeleteDto)

Delete person

Delete an individual person.

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

final api = Openapi().getPeopleApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final PersonDeleteDto personDeleteDto = ; // PersonDeleteDto | 

try {
    api.deletePerson(id, personDeleteDto);
} on DioException catch (e) {
    print('Exception when calling PeopleApi->deletePerson: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **personDeleteDto** | [**PersonDeleteDto**](PersonDeleteDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAllPeople**
> PeopleResponseDto getAllPeople(closestAssetId, closestPersonId, isFavorite, isHidden, name, page, sharedById, sharedWithId, size, withHidden)

Get all people

Retrieve a list of all people.

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

final api = Openapi().getPeopleApi();
final String closestAssetId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Closest asset ID for similarity search
final String closestPersonId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Closest person ID for similarity search
final bool isFavorite = true; // bool | Filter by favorite status
final bool isHidden = true; // bool | Filter by hidden status
final String name = name_example; // String | Filter by person name
final int page = 56; // int | Page number for pagination
final String sharedById = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Only include people to which the user gave access
final String sharedWithId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Only include people to which the user was given access
final int size = 56; // int | Number of items per page
final bool withHidden = true; // bool | Include hidden people

try {
    final response = api.getAllPeople(closestAssetId, closestPersonId, isFavorite, isHidden, name, page, sharedById, sharedWithId, size, withHidden);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PeopleApi->getAllPeople: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **closestAssetId** | **String**| Closest asset ID for similarity search | [optional] 
 **closestPersonId** | **String**| Closest person ID for similarity search | [optional] 
 **isFavorite** | **bool**| Filter by favorite status | [optional] 
 **isHidden** | **bool**| Filter by hidden status | [optional] 
 **name** | **String**| Filter by person name | [optional] 
 **page** | **int**| Page number for pagination | [optional] [default to 1]
 **sharedById** | **String**| Only include people to which the user gave access | [optional] 
 **sharedWithId** | **String**| Only include people to which the user was given access | [optional] 
 **size** | **int**| Number of items per page | [optional] [default to 500]
 **withHidden** | **bool**| Include hidden people | [optional] 

### Return type

[**PeopleResponseDto**](PeopleResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPerson**
> PersonResponseDto getPerson(id)

Get a person

Retrieve a person by id.

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

final api = Openapi().getPeopleApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getPerson(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PeopleApi->getPerson: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**PersonResponseDto**](PersonResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPersonAssets**
> PersonAssetsResponseDto getPersonAssets(id, limit, order, page)

Get person assets

Retrieve a paginated list of a person's assets sorted by face recognition time.

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

final api = Openapi().getPeopleApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final int limit = 56; // int | Items per page
final String order = order_example; // String | Sort direction by recognition time
final int page = 56; // int | Page number

try {
    final response = api.getPersonAssets(id, limit, order, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PeopleApi->getPersonAssets: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **limit** | **int**| Items per page | [optional] [default to 20]
 **order** | **String**| Sort direction by recognition time | [optional] [default to 'desc']
 **page** | **int**| Page number | [optional] [default to 1]

### Return type

[**PersonAssetsResponseDto**](PersonAssetsResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPersonStatistics**
> PersonStatisticsResponseDto getPersonStatistics(id)

Get person statistics

Retrieve statistics about a specific person.

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

final api = Openapi().getPeopleApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getPersonStatistics(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PeopleApi->getPersonStatistics: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**PersonStatisticsResponseDto**](PersonStatisticsResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPersonThumbnail**
> Uint8List getPersonThumbnail(id)

Get person thumbnail

Retrieve the thumbnail file for a person.

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

final api = Openapi().getPeopleApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getPersonThumbnail(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PeopleApi->getPersonThumbnail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/octet-stream

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getRecentlyMatched**
> RecentlyMatchedResponseDto getRecentlyMatched(limit, offset)

Get recently matched faces

Retrieve the most recent face-recognition matches across all of the user's people, one item per asset-person pair, newest first.

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

final api = Openapi().getPeopleApi();
final int limit = 56; // int | Number of items to return
final int offset = 56; // int | Number of items to skip

try {
    final response = api.getRecentlyMatched(limit, offset);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PeopleApi->getRecentlyMatched: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Number of items to return | [optional] [default to 50]
 **offset** | **int**| Number of items to skip | [optional] [default to 0]

### Return type

[**RecentlyMatchedResponseDto**](RecentlyMatchedResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUsersForPeople**
> BuiltList<PersonUsersResponseDtoInner> getUsersForPeople(direction, personId, role, sharedById, sharedWithId)

Get people access

Retrieve a list of users and the people to which they have been given access

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

final api = Openapi().getPeopleApi();
final SharingDirection direction = ; // SharingDirection | 
final String personId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Person ID
final PersonUserRole role = ; // PersonUserRole | Role of user
final String sharedById = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | User ID of the user that gave access
final String sharedWithId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | User ID of the user that was given access

try {
    final response = api.getUsersForPeople(direction, personId, role, sharedById, sharedWithId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PeopleApi->getUsersForPeople: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **direction** | [**SharingDirection**](.md)|  | [optional] 
 **personId** | **String**| Person ID | [optional] 
 **role** | [**PersonUserRole**](.md)| Role of user | [optional] 
 **sharedById** | **String**| User ID of the user that gave access | [optional] 
 **sharedWithId** | **String**| User ID of the user that was given access | [optional] 

### Return type

[**BuiltList&lt;PersonUsersResponseDtoInner&gt;**](PersonUsersResponseDtoInner.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mergePeople**
> BuiltList<BulkIdResponseDto> mergePeople(mergePersonDto)

Merge people

Merge an ordered list of people together into a single person. The final name and birth date are always the first defined value, following the order. Also automatically merges people for other users in the cluster group, skipping people that would result in overriding a previously set name or birth date.

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

final api = Openapi().getPeopleApi();
final MergePersonDto mergePersonDto = ; // MergePersonDto | 

try {
    final response = api.mergePeople(mergePersonDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PeopleApi->mergePeople: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **mergePersonDto** | [**MergePersonDto**](MergePersonDto.md)|  | 

### Return type

[**BuiltList&lt;BulkIdResponseDto&gt;**](BulkIdResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mergePersonLegacy**
> BuiltList<BulkIdResponseDto> mergePersonLegacy(id, mergePersonDto)

Merge people

Merge a list of people into the person specified in the path parameter.

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

final api = Openapi().getPeopleApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final MergePersonDto mergePersonDto = ; // MergePersonDto | 

try {
    final response = api.mergePersonLegacy(id, mergePersonDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PeopleApi->mergePersonLegacy: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **mergePersonDto** | [**MergePersonDto**](MergePersonDto.md)|  | 

### Return type

[**BuiltList&lt;BulkIdResponseDto&gt;**](BulkIdResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reassignFaces**
> BuiltList<PersonResponseDto> reassignFaces(id, assetFaceUpdateDto)

Reassign faces

Bulk reassign a list of faces to a different person.

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

final api = Openapi().getPeopleApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AssetFaceUpdateDto assetFaceUpdateDto = ; // AssetFaceUpdateDto | 

try {
    final response = api.reassignFaces(id, assetFaceUpdateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PeopleApi->reassignFaces: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **assetFaceUpdateDto** | [**AssetFaceUpdateDto**](AssetFaceUpdateDto.md)|  | 

### Return type

[**BuiltList&lt;PersonResponseDto&gt;**](PersonResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeUsersFromPeople**
> removeUsersFromPeople(personUsersDeleteDtoInner)

Remove users from people

Remove user access to people

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

final api = Openapi().getPeopleApi();
final BuiltList<PersonUsersDeleteDtoInner> personUsersDeleteDtoInner = ; // BuiltList<PersonUsersDeleteDtoInner> | 

try {
    api.removeUsersFromPeople(personUsersDeleteDtoInner);
} on DioException catch (e) {
    print('Exception when calling PeopleApi->removeUsersFromPeople: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **personUsersDeleteDtoInner** | [**BuiltList&lt;PersonUsersDeleteDtoInner&gt;**](PersonUsersDeleteDtoInner.md)|  | 

### Return type

void (empty response body)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updatePeople**
> BuiltList<BulkIdResponseDto> updatePeople(peopleUpdateDto)

Update people

Bulk update multiple people at once.

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

final api = Openapi().getPeopleApi();
final PeopleUpdateDto peopleUpdateDto = ; // PeopleUpdateDto | 

try {
    final response = api.updatePeople(peopleUpdateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PeopleApi->updatePeople: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **peopleUpdateDto** | [**PeopleUpdateDto**](PeopleUpdateDto.md)|  | 

### Return type

[**BuiltList&lt;BulkIdResponseDto&gt;**](BulkIdResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updatePerson**
> PersonResponseDto updatePerson(id, personUpdateDto)

Update person

Update an individual person.

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

final api = Openapi().getPeopleApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final PersonUpdateDto personUpdateDto = ; // PersonUpdateDto | 

try {
    final response = api.updatePerson(id, personUpdateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PeopleApi->updatePerson: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **personUpdateDto** | [**PersonUpdateDto**](PersonUpdateDto.md)|  | 

### Return type

[**PersonResponseDto**](PersonResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **upsertPeopleUsers**
> upsertPeopleUsers(peopleUsersUpsertDto)

Upsert user access

Give users access to people

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

final api = Openapi().getPeopleApi();
final PeopleUsersUpsertDto peopleUsersUpsertDto = ; // PeopleUsersUpsertDto | 

try {
    api.upsertPeopleUsers(peopleUsersUpsertDto);
} on DioException catch (e) {
    print('Exception when calling PeopleApi->upsertPeopleUsers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **peopleUsersUpsertDto** | [**PeopleUsersUpsertDto**](PeopleUsersUpsertDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

