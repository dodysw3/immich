# openapi.api.PasskeysApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to */api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deletePasskey**](PasskeysApi.md#deletepasskey) | **DELETE** /passkeys/{id} | Delete a passkey
[**finishAuthentication**](PasskeysApi.md#finishauthentication) | **POST** /passkeys/authentication/finish | Finish passkey authentication
[**finishRegistration**](PasskeysApi.md#finishregistration) | **POST** /passkeys/registration/finish | Finish passkey registration
[**getPasskey**](PasskeysApi.md#getpasskey) | **GET** /passkeys/{id} | Retrieve a passkey
[**searchPasskeys**](PasskeysApi.md#searchpasskeys) | **GET** /passkeys | Search passkeys
[**startAuthentication**](PasskeysApi.md#startauthentication) | **POST** /passkeys/authentication/start | Start passkey authentication
[**startRegistration**](PasskeysApi.md#startregistration) | **POST** /passkeys/registration/start | Start passkey registration
[**updatePasskey**](PasskeysApi.md#updatepasskey) | **PATCH** /passkeys/{id} | Update a passkey


# **deletePasskey**
> deletePasskey(id)

Delete a passkey

Delete a passkey by its ID. The current user must own this passkey.

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

final api = Openapi().getPasskeysApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.deletePasskey(id);
} on DioException catch (e) {
    print('Exception when calling PasskeysApi->deletePasskey: $e\n');
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

# **finishAuthentication**
> LoginResponseDto finishAuthentication(passkeyAuthenticationFinishDto)

Finish passkey authentication

Verify the response from the authenticator and receive a session token.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getPasskeysApi();
final PasskeyAuthenticationFinishDto passkeyAuthenticationFinishDto = ; // PasskeyAuthenticationFinishDto | 

try {
    final response = api.finishAuthentication(passkeyAuthenticationFinishDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PasskeysApi->finishAuthentication: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **passkeyAuthenticationFinishDto** | [**PasskeyAuthenticationFinishDto**](PasskeyAuthenticationFinishDto.md)|  | 

### Return type

[**LoginResponseDto**](LoginResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **finishRegistration**
> PasskeyResponseDto finishRegistration(passkeyRegistrationFinishDto)

Finish passkey registration

Verify the response from the authenticator and save the new passkey for the current user.

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

final api = Openapi().getPasskeysApi();
final PasskeyRegistrationFinishDto passkeyRegistrationFinishDto = ; // PasskeyRegistrationFinishDto | 

try {
    final response = api.finishRegistration(passkeyRegistrationFinishDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PasskeysApi->finishRegistration: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **passkeyRegistrationFinishDto** | [**PasskeyRegistrationFinishDto**](PasskeyRegistrationFinishDto.md)|  | 

### Return type

[**PasskeyResponseDto**](PasskeyResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPasskey**
> PasskeyResponseDto getPasskey(id)

Retrieve a passkey

Retrieve a passkey by its ID. The current user must own this passkey.

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

final api = Openapi().getPasskeysApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getPasskey(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PasskeysApi->getPasskey: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**PasskeyResponseDto**](PasskeyResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchPasskeys**
> BuiltList<PasskeyResponseDto> searchPasskeys(id)

Search passkeys

Search the passkeys of the current user.

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

final api = Openapi().getPasskeysApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Filter by passkey ID

try {
    final response = api.searchPasskeys(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PasskeysApi->searchPasskeys: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Filter by passkey ID | [optional] 

### Return type

[**BuiltList&lt;PasskeyResponseDto&gt;**](PasskeyResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **startAuthentication**
> BuiltMap<String, JsonObject> startAuthentication()

Start passkey authentication

Generate the options used by the browser to sign in with a passkey.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getPasskeysApi();

try {
    final response = api.startAuthentication();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PasskeysApi->startAuthentication: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **startRegistration**
> BuiltMap<String, JsonObject> startRegistration()

Start passkey registration

Generate the options used by the browser to create a new passkey for the current user.

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

final api = Openapi().getPasskeysApi();

try {
    final response = api.startRegistration();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PasskeysApi->startRegistration: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updatePasskey**
> PasskeyResponseDto updatePasskey(id, passkeyUpdateDto)

Update a passkey

Update the name of a passkey by its ID. The current user must own this passkey.

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

final api = Openapi().getPasskeysApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final PasskeyUpdateDto passkeyUpdateDto = ; // PasskeyUpdateDto | 

try {
    final response = api.updatePasskey(id, passkeyUpdateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PasskeysApi->updatePasskey: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **passkeyUpdateDto** | [**PasskeyUpdateDto**](PasskeyUpdateDto.md)|  | 

### Return type

[**PasskeyResponseDto**](PasskeyResponseDto.md)

### Authorization

[cookie](../README.md#cookie), [api_key](../README.md#api_key), [bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

