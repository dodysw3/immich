import 'package:test/test.dart';
import 'package:openapi/openapi.dart';

// tests for UserConfigFFmpegRealtimeDto
void main() {
  final instance = UserConfigFFmpegRealtimeDtoBuilder();
  // TODO add properties to the builder and call build()

  group(UserConfigFFmpegRealtimeDto, () {
    // Enable real-time HLS transcoding (alpha)
    // bool enabled
    test('to test the property `enabled`', () async {
      // TODO
    });

    // Resolutions to use for real-time HLS transcoding
    // BuiltList<HlsVideoResolution> resolutions
    test('to test the property `resolutions`', () async {
      // TODO
    });

    // Video codecs to use for real-time HLS transcoding
    // BuiltList<VideoCodec> videoCodecs
    test('to test the property `videoCodecs`', () async {
      // TODO
    });

  });
}
