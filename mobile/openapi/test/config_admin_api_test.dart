import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for ConfigAdminApi
void main() {
  final instance = Openapi().getConfigAdminApi();

  group(ConfigAdminApi, () {
    // Get the admin configuration
    //
    // Retrieve admin configuration.
    //
    //Future<AdminConfigDto> getAdminConfig() async
    test('test getAdminConfig', () async {
      // TODO
    });

    // Get the system configuration defaults
    //
    // Retrieve the default value of every system configuration property.
    //
    //Future<AdminConfigDto> getAdminConfigDefaults() async
    test('test getAdminConfigDefaults', () async {
      // TODO
    });

    // Update the system configuration
    //
    // Update the system configuration with a new system configuration.
    //
    //Future<AdminConfigDto> updateAdminConfig(AdminConfigDto adminConfigDto) async
    test('test updateAdminConfig', () async {
      // TODO
    });

  });
}
