//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/hls_video_resolution.dart';
import 'package:openapi/src/model/video_codec.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_f_fmpeg_realtime_dto.g.dart';

/// AdminConfigFFmpegRealtimeDto
///
/// Properties:
/// * [enabled] - Enable real-time HLS transcoding (alpha)
/// * [resolutions] - Resolutions to use for real-time HLS transcoding
/// * [videoCodecs] - Video codecs to use for real-time HLS transcoding
@BuiltValue()
abstract class AdminConfigFFmpegRealtimeDto implements Built<AdminConfigFFmpegRealtimeDto, AdminConfigFFmpegRealtimeDtoBuilder> {
  /// Enable real-time HLS transcoding (alpha)
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// Resolutions to use for real-time HLS transcoding
  @BuiltValueField(wireName: r'resolutions')
  BuiltList<HlsVideoResolution> get resolutions;

  /// Video codecs to use for real-time HLS transcoding
  @BuiltValueField(wireName: r'videoCodecs')
  BuiltList<VideoCodec> get videoCodecs;

  AdminConfigFFmpegRealtimeDto._();

  factory AdminConfigFFmpegRealtimeDto([void updates(AdminConfigFFmpegRealtimeDtoBuilder b)]) = _$AdminConfigFFmpegRealtimeDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigFFmpegRealtimeDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigFFmpegRealtimeDto> get serializer => _$AdminConfigFFmpegRealtimeDtoSerializer();
}

class _$AdminConfigFFmpegRealtimeDtoSerializer implements PrimitiveSerializer<AdminConfigFFmpegRealtimeDto> {
  @override
  final Iterable<Type> types = const [AdminConfigFFmpegRealtimeDto, _$AdminConfigFFmpegRealtimeDto];

  @override
  final String wireName = r'AdminConfigFFmpegRealtimeDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigFFmpegRealtimeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'resolutions';
    yield serializers.serialize(
      object.resolutions,
      specifiedType: const FullType(BuiltList, [FullType(HlsVideoResolution)]),
    );
    yield r'videoCodecs';
    yield serializers.serialize(
      object.videoCodecs,
      specifiedType: const FullType(BuiltList, [FullType(VideoCodec)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigFFmpegRealtimeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigFFmpegRealtimeDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'resolutions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(HlsVideoResolution)]),
          ) as BuiltList<HlsVideoResolution>;
          result.resolutions.replace(valueDes);
          break;
        case r'videoCodecs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VideoCodec)]),
          ) as BuiltList<VideoCodec>;
          result.videoCodecs.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigFFmpegRealtimeDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigFFmpegRealtimeDtoBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


