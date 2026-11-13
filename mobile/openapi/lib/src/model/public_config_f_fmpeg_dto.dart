//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/public_config_f_fmpeg_realtime_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_config_f_fmpeg_dto.g.dart';

/// PublicConfigFFmpegDto
///
/// Properties:
/// * [realtime] 
@BuiltValue()
abstract class PublicConfigFFmpegDto implements Built<PublicConfigFFmpegDto, PublicConfigFFmpegDtoBuilder> {
  @BuiltValueField(wireName: r'realtime')
  PublicConfigFFmpegRealtimeDto get realtime;

  PublicConfigFFmpegDto._();

  factory PublicConfigFFmpegDto([void updates(PublicConfigFFmpegDtoBuilder b)]) = _$PublicConfigFFmpegDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicConfigFFmpegDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicConfigFFmpegDto> get serializer => _$PublicConfigFFmpegDtoSerializer();
}

class _$PublicConfigFFmpegDtoSerializer implements PrimitiveSerializer<PublicConfigFFmpegDto> {
  @override
  final Iterable<Type> types = const [PublicConfigFFmpegDto, _$PublicConfigFFmpegDto];

  @override
  final String wireName = r'PublicConfigFFmpegDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicConfigFFmpegDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'realtime';
    yield serializers.serialize(
      object.realtime,
      specifiedType: const FullType(PublicConfigFFmpegRealtimeDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicConfigFFmpegDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicConfigFFmpegDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'realtime':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicConfigFFmpegRealtimeDto),
          ) as PublicConfigFFmpegRealtimeDto;
          result.realtime.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicConfigFFmpegDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicConfigFFmpegDtoBuilder();
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


