import 'package:test/test.dart';
import 'package:openapi/openapi.dart';

// tests for TranscriptionSearchDto
void main() {
  final instance = TranscriptionSearchDtoBuilder();
  // TODO add properties to the builder and call build()

  group(TranscriptionSearchDto, () {
    // Filter by city name (null = no city)
    // String city
    test('to test the property `city`', () async {
      // TODO
    });

    // Filter by country name (null = no country)
    // String country
    test('to test the property `country`', () async {
      // TODO
    });

    // Opaque pagination cursor from a previous page
    // String cursor
    test('to test the property `cursor`', () async {
      // TODO
    });

    // Include score components and scoped coverage counts (diagnostics)
    // bool explain
    test('to test the property `explain`', () async {
      // TODO
    });

    // Filter by favorite status
    // bool isFavorite
    test('to test the property `isFavorite`', () async {
      // TODO
    });

    // Filter assets not in any album
    // bool isNotInAlbum
    test('to test the property `isNotInAlbum`', () async {
      // TODO
    });

    // Filter by lens model (null = no lens)
    // String lensModel
    test('to test the property `lensModel`', () async {
      // TODO
    });

    // Filter by camera make (null = no make)
    // String make
    test('to test the property `make`', () async {
      // TODO
    });

    // Filter by camera model (null = no model)
    // String model
    test('to test the property `model`', () async {
      // TODO
    });

    // Filter by person IDs (all must match)
    // BuiltList<String> personIds
    test('to test the property `personIds`', () async {
      // TODO
    });

    // Spoken words to search for (exact-first, spelling fallback)
    // String q
    test('to test the property `q`', () async {
      // TODO
    });

    // Filter by rating (null = unrated)
    // int rating
    test('to test the property `rating`', () async {
      // TODO
    });

    // Videos per page
    // int size (default value: 20)
    test('to test the property `size`', () async {
      // TODO
    });

    // Filter by state/province name (null = no state)
    // String state
    test('to test the property `state`', () async {
      // TODO
    });

    // Filter by tag IDs (all must match; null = untagged)
    // BuiltList<String> tagIds
    test('to test the property `tagIds`', () async {
      // TODO
    });

    // Filter by taken date (after)
    // DateTime takenAfter
    test('to test the property `takenAfter`', () async {
      // TODO
    });

    // Filter by taken date (before)
    // DateTime takenBefore
    test('to test the property `takenBefore`', () async {
      // TODO
    });

    // AssetVisibility visibility
    test('to test the property `visibility`', () async {
      // TODO
    });

    // Include stacked assets
    // bool withStacked
    test('to test the property `withStacked`', () async {
      // TODO
    });

  });
}
