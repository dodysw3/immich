//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'hls_video_resolution.g.dart';

/// HLS video resolution
class HlsVideoResolution extends EnumClass {

  @BuiltValueEnumConst(wireNumber: 480)
  static const HlsVideoResolution number480 = _$number480;
  @BuiltValueEnumConst(wireNumber: 720)
  static const HlsVideoResolution number720 = _$number720;
  @BuiltValueEnumConst(wireNumber: 1080)
  static const HlsVideoResolution number1080 = _$number1080;
  @BuiltValueEnumConst(wireNumber: 1440)
  static const HlsVideoResolution number1440 = _$number1440;
  @BuiltValueEnumConst(wireNumber: 2160)
  static const HlsVideoResolution number2160 = _$number2160;

  static Serializer<HlsVideoResolution> get serializer => _$hlsVideoResolutionSerializer;

  const HlsVideoResolution._(String name): super(name);

  static BuiltSet<HlsVideoResolution> get values => _$values;
  static HlsVideoResolution valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class HlsVideoResolutionMixin = Object with _$HlsVideoResolutionMixin;

