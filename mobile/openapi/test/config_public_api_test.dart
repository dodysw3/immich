import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for ConfigPublicApi
void main() {
  final instance = Openapi().getConfigPublicApi();

  group(ConfigPublicApi, () {
    // Get the public configuration
    //
    // Retrieve the system configuration properties that are visible to everyone.
    //
    //Future<PublicConfigDto> getPublicConfig() async
    test('test getPublicConfig', () async {
      // TODO
    });

    // Get the public configuration defaults
    //
    // Retrieve the default value of the configuration properties that are visible to everyone.
    //
    //Future<PublicConfigDto> getPublicConfigDefaults() async
    test('test getPublicConfigDefaults', () async {
      // TODO
    });

  });
}
