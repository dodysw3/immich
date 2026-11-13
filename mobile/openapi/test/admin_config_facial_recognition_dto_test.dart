import 'package:test/test.dart';
import 'package:openapi/openapi.dart';

// tests for AdminConfigFacialRecognitionDto
void main() {
  final instance = AdminConfigFacialRecognitionDtoBuilder();
  // TODO add properties to the builder and call build()

  group(AdminConfigFacialRecognitionDto, () {
    // Whether the task is enabled
    // bool enabled
    test('to test the property `enabled`', () async {
      // TODO
    });

    // Import person names from other accounts in the same recognition cluster
    // bool importNamesFromOtherAccounts
    test('to test the property `importNamesFromOtherAccounts`', () async {
      // TODO
    });

    // Maximum distance threshold for face recognition
    // double maxDistance
    test('to test the property `maxDistance`', () async {
      // TODO
    });

    // Minimum bounding box pixel dimension for face recognition
    // int minFaceSize
    test('to test the property `minFaceSize`', () async {
      // TODO
    });

    // Minimum number of faces required for recognition
    // int minFaces
    test('to test the property `minFaces`', () async {
      // TODO
    });

    // Minimum confidence score for face detection
    // double minScore
    test('to test the property `minScore`', () async {
      // TODO
    });

    // Minimum detector score when each face is re-checked on a standard crop around it (0 disables the re-check)
    // double minVerifyScore
    test('to test the property `minVerifyScore`', () async {
      // TODO
    });

    // Name of the model to use
    // String modelName
    test('to test the property `modelName`', () async {
      // TODO
    });

    // AdminConfigTilingDto tiling
    test('to test the property `tiling`', () async {
      // TODO
    });

  });
}
