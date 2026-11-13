import 'package:test/test.dart';
import 'package:openapi/openapi.dart';

// tests for RecentlyMatchedItemDto
void main() {
  final instance = RecentlyMatchedItemDtoBuilder();
  // TODO add properties to the builder and call build()

  group(RecentlyMatchedItemDto, () {
    // Asset ID of the matched face
    // String assetId
    test('to test the property `assetId`', () async {
      // TODO
    });

    // Person ID the face was matched to
    // String personId
    test('to test the property `personId`', () async {
      // TODO
    });

    // Person name, empty when the person is unnamed
    // String personName
    test('to test the property `personName`', () async {
      // TODO
    });

    // When this asset-person pair was last matched by recognition
    // DateTime recognizedAt
    test('to test the property `recognizedAt`', () async {
      // TODO
    });

  });
}
