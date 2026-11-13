# openapi.api.DocumentsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to */api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getDocument**](DocumentsApi.md#getdocument) | **GET** /documents/{id} | Get PDF document metadata
[**getDocuments**](DocumentsApi.md#getdocuments) | **GET** /documents | List PDF documents
[**getPage**](DocumentsApi.md#getpage) | **GET** /documents/{id}/pages/{pageNumber} | Get PDF page
[**getPages**](DocumentsApi.md#getpages) | **GET** /documents/{id}/pages | Get PDF pages
[**reprocessDocument**](DocumentsApi.md#reprocessdocument) | **POST** /documents/{id}/reprocess | Reprocess a PDF document
[**searchDocuments**](DocumentsApi.md#searchdocuments) | **GET** /documents/search | Search PDF documents
[**searchInDocument**](DocumentsApi.md#searchindocument) | **GET** /documents/{id}/search | Search inside a PDF document


# **getDocument**
> JsonObject getDocument(id)

Get PDF document metadata

Get metadata for a single PDF document.

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

final api = Openapi().getDocumentsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | PDF document asset ID

try {
    final response = api.getDocument(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DocumentsApi->getDocument: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| PDF document asset ID | 

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getDocuments**
> JsonObject getDocuments(page, size, status)

List PDF documents

List PDF documents owned by the authenticated user.

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

final api = Openapi().getDocumentsApi();
final int page = 56; // int | Page number
final int size = 56; // int | Number of items per page
final String status = status_example; // String | Filter documents by processing status

try {
    final response = api.getDocuments(page, size, status);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DocumentsApi->getDocuments: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**| Page number | [optional] [default to 1]
 **size** | **int**| Number of items per page | [optional] [default to 50]
 **status** | **String**| Filter documents by processing status | [optional] 

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPage**
> JsonObject getPage(id, pageNumber)

Get PDF page

Get one indexed page for a PDF document.

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

final api = Openapi().getDocumentsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | PDF document asset ID
final int pageNumber = 56; // int | Page number

try {
    final response = api.getPage(id, pageNumber);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DocumentsApi->getPage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| PDF document asset ID | 
 **pageNumber** | **int**| Page number | 

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPages**
> BuiltList<JsonObject> getPages(id)

Get PDF pages

Get all indexed pages for a PDF document.

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

final api = Openapi().getDocumentsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | PDF document asset ID

try {
    final response = api.getPages(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DocumentsApi->getPages: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| PDF document asset ID | 

### Return type

[**BuiltList&lt;JsonObject&gt;**](JsonObject.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reprocessDocument**
> reprocessDocument(id)

Reprocess a PDF document

Queue PDF text extraction and OCR processing for a specific document again.

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

final api = Openapi().getDocumentsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | PDF document asset ID

try {
    api.reprocessDocument(id);
} on DioException catch (e) {
    print('Exception when calling DocumentsApi->reprocessDocument: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| PDF document asset ID | 

### Return type

void (empty response body)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchDocuments**
> JsonObject searchDocuments(query, page, size, status)

Search PDF documents

Search PDF text and return matching documents with matching page numbers.

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

final api = Openapi().getDocumentsApi();
final String query = query_example; // String | Search phrase
final int page = 56; // int | Page number
final int size = 56; // int | Number of items per page
final String status = status_example; // String | Filter documents by processing status

try {
    final response = api.searchDocuments(query, page, size, status);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DocumentsApi->searchDocuments: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **query** | **String**| Search phrase | 
 **page** | **int**| Page number | [optional] [default to 1]
 **size** | **int**| Number of items per page | [optional] [default to 50]
 **status** | **String**| Filter documents by processing status | [optional] 

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchInDocument**
> BuiltList<JsonObject> searchInDocument(id, query, size)

Search inside a PDF document

Search indexed page text for a specific PDF and return snippets per matching page.

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

final api = Openapi().getDocumentsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | PDF document asset ID
final String query = query_example; // String | Search phrase
final int size = 56; // int | Max matched pages to return

try {
    final response = api.searchInDocument(id, query, size);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DocumentsApi->searchInDocument: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| PDF document asset ID | 
 **query** | **String**| Search phrase | 
 **size** | **int**| Max matched pages to return | [optional] [default to 100]

### Return type

[**BuiltList&lt;JsonObject&gt;**](JsonObject.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

