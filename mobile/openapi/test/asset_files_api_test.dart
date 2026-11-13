import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for AssetFilesApi
void main() {
  final instance = Openapi().getAssetFilesApi();

  group(AssetFilesApi, () {
    // Delete an asset file
    //
    // Delete a file and remove it from the database.
    //
    //Future deleteAssetFile(String id) async
    test('test deleteAssetFile', () async {
      // TODO
    });

    // Download an asset file
    //
    // Serve the contents of a specific asset file.
    //
    //Future<Uint8List> downloadAssetFile(String id) async
    test('test downloadAssetFile', () async {
      // TODO
    });

    // Retrieve an asset file
    //
    // Returns metadata about a specific asset file.
    //
    //Future<AssetFileResponseDto> getAssetFile(String id) async
    test('test getAssetFile', () async {
      // TODO
    });

    // Search asset files
    //
    // Returns all matching asset files.
    //
    //Future<BuiltList<AssetFileResponseDto>> searchAssetFiles(String assetId, { bool isEdited, bool isProgressive, bool isTransparent, AssetFileType type }) async
    test('test searchAssetFiles', () async {
      // TODO
    });

  });
}
