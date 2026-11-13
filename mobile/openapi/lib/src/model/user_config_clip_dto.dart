//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_config_clip_dto.g.dart';

/// UserConfigClipDto
///
/// Properties:
/// * [enabled] - Whether the task is enabled
@BuiltValue()
abstract class UserConfigClipDto implements Built<UserConfigClipDto, UserConfigClipDtoBuilder> {
  /// Whether the task is enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  UserConfigClipDto._();

  factory UserConfigClipDto([void updates(UserConfigClipDtoBuilder b)]) = _$UserConfigClipDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserConfigClipDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserConfigClipDto> get serializer => _$UserConfigClipDtoSerializer();
}

class _$UserConfigClipDtoSerializer implements PrimitiveSerializer<UserConfigClipDto> {
  @override
  final Iterable<Type> types = const [UserConfigClipDto, _$UserConfigClipDto];

  @override
  final String wireName = r'UserConfigClipDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserConfigClipDto object, {
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
    UserConfigClipDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserConfigClipDtoBuilder result,
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
  UserConfigClipDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserConfigClipDtoBuilder();
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


