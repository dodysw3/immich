# openapi.api.WorkflowsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to */api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createWorkflow**](WorkflowsApi.md#createworkflow) | **POST** /workflows | Create a workflow
[**deleteWorkflow**](WorkflowsApi.md#deleteworkflow) | **DELETE** /workflows/{id} | Delete a workflow
[**getWorkflow**](WorkflowsApi.md#getworkflow) | **GET** /workflows/{id} | Retrieve a workflow
[**getWorkflowForShare**](WorkflowsApi.md#getworkflowforshare) | **GET** /workflows/{id}/share | Retrieve a workflow
[**getWorkflowLogs**](WorkflowsApi.md#getworkflowlogs) | **GET** /workflows/{id}/logs | Retrieve workflow logs
[**getWorkflowTriggers**](WorkflowsApi.md#getworkflowtriggers) | **GET** /workflows/triggers | List all workflow triggers
[**searchWorkflows**](WorkflowsApi.md#searchworkflows) | **GET** /workflows | List all workflows
[**updateWorkflow**](WorkflowsApi.md#updateworkflow) | **PUT** /workflows/{id} | Update a workflow


# **createWorkflow**
> WorkflowResponseDto createWorkflow(workflowCreateDto)

Create a workflow

Create a new workflow, the workflow can also be created with empty filters and actions.

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

final api = Openapi().getWorkflowsApi();
final WorkflowCreateDto workflowCreateDto = ; // WorkflowCreateDto | 

try {
    final response = api.createWorkflow(workflowCreateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WorkflowsApi->createWorkflow: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **workflowCreateDto** | [**WorkflowCreateDto**](WorkflowCreateDto.md)|  | 

### Return type

[**WorkflowResponseDto**](WorkflowResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteWorkflow**
> deleteWorkflow(id)

Delete a workflow

Delete a workflow by its ID.

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

final api = Openapi().getWorkflowsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.deleteWorkflow(id);
} on DioException catch (e) {
    print('Exception when calling WorkflowsApi->deleteWorkflow: $e\n');
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

# **getWorkflow**
> WorkflowResponseDto getWorkflow(id)

Retrieve a workflow

Retrieve information about a specific workflow by its ID.

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

final api = Openapi().getWorkflowsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getWorkflow(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WorkflowsApi->getWorkflow: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**WorkflowResponseDto**](WorkflowResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getWorkflowForShare**
> WorkflowShareResponseDto getWorkflowForShare(id)

Retrieve a workflow

Retrieve a workflow details without ids, default values, etc.

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

final api = Openapi().getWorkflowsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getWorkflowForShare(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WorkflowsApi->getWorkflowForShare: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**WorkflowShareResponseDto**](WorkflowShareResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getWorkflowLogs**
> BuiltList<WorkflowLogEntryDto> getWorkflowLogs(id, before, limit, result)

Retrieve workflow logs

Retrieve logs of a workflows runs by ID

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

final api = Openapi().getWorkflowsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final DateTime before = 2024-01-01T00:00Z; // DateTime | Filter by runs before a date/time
final int limit = 56; // int | Maximum number of logs
final WorkflowResult result = ; // WorkflowResult | Filter by run result

try {
    final response = api.getWorkflowLogs(id, before, limit, result);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WorkflowsApi->getWorkflowLogs: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **before** | **DateTime**| Filter by runs before a date/time | [optional] 
 **limit** | **int**| Maximum number of logs | [optional] [default to 50]
 **result** | [**WorkflowResult**](.md)| Filter by run result | [optional] 

### Return type

[**BuiltList&lt;WorkflowLogEntryDto&gt;**](WorkflowLogEntryDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getWorkflowTriggers**
> BuiltList<WorkflowTriggerResponseDto> getWorkflowTriggers()

List all workflow triggers

Retrieve a list of all available workflow triggers.

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

final api = Openapi().getWorkflowsApi();

try {
    final response = api.getWorkflowTriggers();
    print(response);
} on DioException catch (e) {
    print('Exception when calling WorkflowsApi->getWorkflowTriggers: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;WorkflowTriggerResponseDto&gt;**](WorkflowTriggerResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchWorkflows**
> BuiltList<WorkflowResponseDto> searchWorkflows(description, enabled, id, logging, name, trigger)

List all workflows

Retrieve a list of workflows available to the authenticated user.

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

final api = Openapi().getWorkflowsApi();
final String description = description_example; // String | Workflow description
final bool enabled = true; // bool | Workflow enabled
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Workflow ID
final bool logging = true; // bool | Workflow logs run results
final String name = name_example; // String | Workflow name
final WorkflowTrigger trigger = ; // WorkflowTrigger | Workflow trigger type

try {
    final response = api.searchWorkflows(description, enabled, id, logging, name, trigger);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WorkflowsApi->searchWorkflows: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **description** | **String**| Workflow description | [optional] 
 **enabled** | **bool**| Workflow enabled | [optional] 
 **id** | **String**| Workflow ID | [optional] 
 **logging** | **bool**| Workflow logs run results | [optional] 
 **name** | **String**| Workflow name | [optional] 
 **trigger** | [**WorkflowTrigger**](.md)| Workflow trigger type | [optional] 

### Return type

[**BuiltList&lt;WorkflowResponseDto&gt;**](WorkflowResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateWorkflow**
> WorkflowResponseDto updateWorkflow(id, workflowUpdateDto)

Update a workflow

Update the information of a specific workflow by its ID. This endpoint can be used to update the workflow name, description, trigger type, filters and actions order, etc.

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

final api = Openapi().getWorkflowsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final WorkflowUpdateDto workflowUpdateDto = ; // WorkflowUpdateDto | 

try {
    final response = api.updateWorkflow(id, workflowUpdateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WorkflowsApi->updateWorkflow: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **workflowUpdateDto** | [**WorkflowUpdateDto**](WorkflowUpdateDto.md)|  | 

### Return type

[**WorkflowResponseDto**](WorkflowResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

