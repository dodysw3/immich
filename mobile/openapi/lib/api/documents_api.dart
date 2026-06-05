//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class DocumentsApi {
  DocumentsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Get PDF document metadata
  ///
  /// Get metadata for a single PDF document.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   PDF document asset ID
  Future<Response> getDocumentWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final apiPath = r'/documents/{id}'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      apiPath,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get PDF document metadata
  ///
  /// Get metadata for a single PDF document.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   PDF document asset ID
  Future<Object?> getDocument(String id,) async {
    final response = await getDocumentWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Object',) as Object;
    
    }
    return null;
  }

  /// List PDF documents
  ///
  /// List PDF documents owned by the authenticated user.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] page:
  ///   Page number
  ///
  /// * [int] size:
  ///   Number of items per page
  ///
  /// * [String] status:
  ///   Filter documents by processing status
  Future<Response> getDocumentsWithHttpInfo({ int? page, int? size, String? status, }) async {
    // ignore: prefer_const_declarations
    final apiPath = r'/documents';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (page != null) {
      queryParams.addAll(_queryParams('', 'page', page));
    }
    if (size != null) {
      queryParams.addAll(_queryParams('', 'size', size));
    }
    if (status != null) {
      queryParams.addAll(_queryParams('', 'status', status));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      apiPath,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// List PDF documents
  ///
  /// List PDF documents owned by the authenticated user.
  ///
  /// Parameters:
  ///
  /// * [int] page:
  ///   Page number
  ///
  /// * [int] size:
  ///   Number of items per page
  ///
  /// * [String] status:
  ///   Filter documents by processing status
  Future<Object?> getDocuments({ int? page, int? size, String? status, }) async {
    final response = await getDocumentsWithHttpInfo( page: page, size: size, status: status, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Object',) as Object;
    
    }
    return null;
  }

  /// Get PDF page
  ///
  /// Get one indexed page for a PDF document.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   PDF document asset ID
  ///
  /// * [int] pageNumber (required):
  ///   Page number
  Future<Response> getPageWithHttpInfo(String id, int pageNumber,) async {
    // ignore: prefer_const_declarations
    final apiPath = r'/documents/{id}/pages/{pageNumber}'
      .replaceAll('{id}', id)
      .replaceAll('{pageNumber}', pageNumber.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      apiPath,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get PDF page
  ///
  /// Get one indexed page for a PDF document.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   PDF document asset ID
  ///
  /// * [int] pageNumber (required):
  ///   Page number
  Future<Object?> getPage(String id, int pageNumber,) async {
    final response = await getPageWithHttpInfo(id, pageNumber,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Object',) as Object;
    
    }
    return null;
  }

  /// Get PDF pages
  ///
  /// Get all indexed pages for a PDF document.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   PDF document asset ID
  Future<Response> getPagesWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final apiPath = r'/documents/{id}/pages'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      apiPath,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get PDF pages
  ///
  /// Get all indexed pages for a PDF document.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   PDF document asset ID
  Future<List<Object>?> getPages(String id,) async {
    final response = await getPagesWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<Object>') as List)
        .cast<Object>()
        .toList(growable: false);

    }
    return null;
  }

  /// Reprocess a PDF document
  ///
  /// Queue PDF text extraction and OCR processing for a specific document again.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   PDF document asset ID
  Future<Response> reprocessDocumentWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final apiPath = r'/documents/{id}/reprocess'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      apiPath,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Reprocess a PDF document
  ///
  /// Queue PDF text extraction and OCR processing for a specific document again.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   PDF document asset ID
  Future<void> reprocessDocument(String id,) async {
    final response = await reprocessDocumentWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Search PDF documents
  ///
  /// Search PDF text and return matching documents with matching page numbers.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] query (required):
  ///   Search phrase
  ///
  /// * [int] page:
  ///   Page number
  ///
  /// * [int] size:
  ///   Number of items per page
  ///
  /// * [String] status:
  ///   Filter documents by processing status
  Future<Response> searchDocumentsWithHttpInfo(String query, { int? page, int? size, String? status, }) async {
    // ignore: prefer_const_declarations
    final apiPath = r'/documents/search';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (page != null) {
      queryParams.addAll(_queryParams('', 'page', page));
    }
      queryParams.addAll(_queryParams('', 'query', query));
    if (size != null) {
      queryParams.addAll(_queryParams('', 'size', size));
    }
    if (status != null) {
      queryParams.addAll(_queryParams('', 'status', status));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      apiPath,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Search PDF documents
  ///
  /// Search PDF text and return matching documents with matching page numbers.
  ///
  /// Parameters:
  ///
  /// * [String] query (required):
  ///   Search phrase
  ///
  /// * [int] page:
  ///   Page number
  ///
  /// * [int] size:
  ///   Number of items per page
  ///
  /// * [String] status:
  ///   Filter documents by processing status
  Future<Object?> searchDocuments(String query, { int? page, int? size, String? status, }) async {
    final response = await searchDocumentsWithHttpInfo(query,  page: page, size: size, status: status, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Object',) as Object;
    
    }
    return null;
  }

  /// Search inside a PDF document
  ///
  /// Search indexed page text for a specific PDF and return snippets per matching page.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   PDF document asset ID
  ///
  /// * [String] query (required):
  ///   Search phrase
  ///
  /// * [int] size:
  ///   Max matched pages to return
  Future<Response> searchInDocumentWithHttpInfo(String id, String query, { int? size, }) async {
    // ignore: prefer_const_declarations
    final apiPath = r'/documents/{id}/search'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'query', query));
    if (size != null) {
      queryParams.addAll(_queryParams('', 'size', size));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      apiPath,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Search inside a PDF document
  ///
  /// Search indexed page text for a specific PDF and return snippets per matching page.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   PDF document asset ID
  ///
  /// * [String] query (required):
  ///   Search phrase
  ///
  /// * [int] size:
  ///   Max matched pages to return
  Future<List<Object>?> searchInDocument(String id, String query, { int? size, }) async {
    final response = await searchInDocumentWithHttpInfo(id, query,  size: size, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<Object>') as List)
        .cast<Object>()
        .toList(growable: false);

    }
    return null;
  }
}
