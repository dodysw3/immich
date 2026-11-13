import 'package:test/test.dart';
import 'package:openapi/openapi.dart';

// tests for AdminConfigDuplicateDetectionDto
void main() {
  final instance = AdminConfigDuplicateDetectionDtoBuilder();
  // TODO add properties to the builder and call build()

  group(AdminConfigDuplicateDetectionDto, () {
    // Whether the task is enabled
    // bool enabled
    test('to test the property `enabled`', () async {
      // TODO
    });

    // Maximum distance threshold for duplicate detection
    // double maxDistance
    test('to test the property `maxDistance`', () async {
      // TODO
    });

    // Exclude duplicate candidates whose OCR text differs materially from the source asset
    // bool ocrVeto
    test('to test the property `ocrVeto`', () async {
      // TODO
    });

    // Maximum OCR token-bag symmetric difference before a duplicate candidate is vetoed
    // int ocrVetoMaxTokenDiff
    test('to test the property `ocrVetoMaxTokenDiff`', () async {
      // TODO
    });

    // Exclude duplicate PDF candidates whose page count or whole-document text differs from the source asset
    // bool pdfVeto
    test('to test the property `pdfVeto`', () async {
      // TODO
    });

    // Maximum whole-document PDF text token-bag symmetric difference before a candidate is vetoed
    // int pdfVetoMaxTokenDiff
    test('to test the property `pdfVetoMaxTokenDiff`', () async {
      // TODO
    });

    // AdminConfigVideoNearDupDto videoNearDup
    test('to test the property `videoNearDup`', () async {
      // TODO
    });

  });
}
