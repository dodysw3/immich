import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for ConfigUserApi
void main() {
  final instance = Openapi().getConfigUserApi();

  group(ConfigUserApi, () {
    // Get the configuration with user visibility
    //
    // Retrieve the system configuration properties that are visible to logged in users.
    //
    //Future<UserConfigDto> getUserConfig() async
    test('test getUserConfig', () async {
      // TODO
    });

    // Get the default configuration with user visibility
    //
    // Retrieve the default value of the configuration properties that are visible to logged in users.
    //
    //Future<UserConfigDto> getUserConfigDefaults() async
    test('test getUserConfigDefaults', () async {
      // TODO
    });

  });
}
