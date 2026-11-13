//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user_config_f_fmpeg_realtime_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_config_f_fmpeg_dto.g.dart';

/// UserConfigFFmpegDto
///
/// Properties:
/// * [realtime] 
@BuiltValue()
abstract class UserConfigFFmpegDto implements Built<UserConfigFFmpegDto, UserConfigFFmpegDtoBuilder> {
  @BuiltValueField(wireName: r'realtime')
  UserConfigFFmpegRealtimeDto get realtime;

  UserConfigFFmpegDto._();

  factory UserConfigFFmpegDto([void updates(UserConfigFFmpegDtoBuilder b)]) = _$UserConfigFFmpegDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserConfigFFmpegDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserConfigFFmpegDto> get serializer => _$UserConfigFFmpegDtoSerializer();
}

class _$UserConfigFFmpegDtoSerializer implements PrimitiveSerializer<UserConfigFFmpegDto> {
  @override
  final Iterable<Type> types = const [UserConfigFFmpegDto, _$UserConfigFFmpegDto];

  @override
  final String wireName = r'UserConfigFFmpegDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserConfigFFmpegDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'realtime';
    yield serializers.serialize(
      object.realtime,
      specifiedType: const FullType(UserConfigFFmpegRealtimeDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserConfigFFmpegDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserConfigFFmpegDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'realtime':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserConfigFFmpegRealtimeDto),
          ) as UserConfigFFmpegRealtimeDto;
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
  UserConfigFFmpegDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserConfigFFmpegDtoBuilder();
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


