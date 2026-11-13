import 'package:test/test.dart';
import 'package:openapi/openapi.dart';

// tests for AdminConfigVideoNearDupDto
void main() {
  final instance = AdminConfigVideoNearDupDtoBuilder();
  // TODO add properties to the builder and call build()

  group(AdminConfigVideoNearDupDto, () {
    // Relative duration tolerance as a fraction of the longer video
    // double durationRelTol
    test('to test the property `durationRelTol`', () async {
      // TODO
    });

    // Group near-duplicate videos via frame, audio, and metadata fingerprints when CLIP preview similarity finds none
    // bool enabled
    test('to test the property `enabled`', () async {
      // TODO
    });

    // Minimum composite similarity before two videos are grouped as near-duplicates
    // double groupThreshold
    test('to test the property `groupThreshold`', () async {
      // TODO
    });

    // Absolute duration tolerance in milliseconds for video near-duplicate candidates
    // int maxDurationDeltaMs
    test('to test the property `maxDurationDeltaMs`', () async {
      // TODO
    });

  });
}
