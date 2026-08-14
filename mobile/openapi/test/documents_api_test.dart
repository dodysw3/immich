//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

import 'package:openapi/api.dart';
import 'package:test/test.dart';


/// tests for DocumentsApi
void main() {
  // final instance = DocumentsApi();

  group('tests for DocumentsApi', () {
    // Get PDF document metadata
    //
    // Get metadata for a single PDF document.
    //
    //Future<Object> getDocument(String id) async
    test('test getDocument', () async {
      // TODO
    });

    // List PDF documents
    //
    // List PDF documents owned by the authenticated user.
    //
    //Future<Object> getDocuments({ int page, int size, String status }) async
    test('test getDocuments', () async {
      // TODO
    });

    // Get PDF page
    //
    // Get one indexed page for a PDF document.
    //
    //Future<Object> getPage(String id, int pageNumber) async
    test('test getPage', () async {
      // TODO
    });

    // Get PDF pages
    //
    // Get all indexed pages for a PDF document.
    //
    //Future<List<Object>> getPages(String id) async
    test('test getPages', () async {
      // TODO
    });

    // Reprocess a PDF document
    //
    // Queue PDF text extraction and OCR processing for a specific document again.
    //
    //Future reprocessDocument(String id) async
    test('test reprocessDocument', () async {
      // TODO
    });

    // Search PDF documents
    //
    // Search PDF text and return matching documents with matching page numbers.
    //
    //Future<Object> searchDocuments(String query, { int page, int size, String status }) async
    test('test searchDocuments', () async {
      // TODO
    });

    // Search inside a PDF document
    //
    // Search indexed page text for a specific PDF and return snippets per matching page.
    //
    //Future<List<Object>> searchInDocument(String id, String query, { int size }) async
    test('test searchInDocument', () async {
      // TODO
    });

  });
}
