//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_config_f_fmpeg_realtime_dto.g.dart';

/// PublicConfigFFmpegRealtimeDto
///
/// Properties:
/// * [enabled] - Enable real-time HLS transcoding (alpha)
@BuiltValue()
abstract class PublicConfigFFmpegRealtimeDto implements Built<PublicConfigFFmpegRealtimeDto, PublicConfigFFmpegRealtimeDtoBuilder> {
  /// Enable real-time HLS transcoding (alpha)
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  PublicConfigFFmpegRealtimeDto._();

  factory PublicConfigFFmpegRealtimeDto([void updates(PublicConfigFFmpegRealtimeDtoBuilder b)]) = _$PublicConfigFFmpegRealtimeDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicConfigFFmpegRealtimeDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicConfigFFmpegRealtimeDto> get serializer => _$PublicConfigFFmpegRealtimeDtoSerializer();
}

class _$PublicConfigFFmpegRealtimeDtoSerializer implements PrimitiveSerializer<PublicConfigFFmpegRealtimeDto> {
  @override
  final Iterable<Type> types = const [PublicConfigFFmpegRealtimeDto, _$PublicConfigFFmpegRealtimeDto];

  @override
  final String wireName = r'PublicConfigFFmpegRealtimeDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicConfigFFmpegRealtimeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicConfigFFmpegRealtimeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicConfigFFmpegRealtimeDtoBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicConfigFFmpegRealtimeDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicConfigFFmpegRealtimeDtoBuilder();
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


