//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_config_passkey_dto.g.dart';

/// UserConfigPasskeyDto
///
/// Properties:
/// * [enabled] - Enabled
@BuiltValue()
abstract class UserConfigPasskeyDto implements Built<UserConfigPasskeyDto, UserConfigPasskeyDtoBuilder> {
  /// Enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  UserConfigPasskeyDto._();

  factory UserConfigPasskeyDto([void updates(UserConfigPasskeyDtoBuilder b)]) = _$UserConfigPasskeyDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserConfigPasskeyDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserConfigPasskeyDto> get serializer => _$UserConfigPasskeyDtoSerializer();
}

class _$UserConfigPasskeyDtoSerializer implements PrimitiveSerializer<UserConfigPasskeyDto> {
  @override
  final Iterable<Type> types = const [UserConfigPasskeyDto, _$UserConfigPasskeyDto];

  @override
  final String wireName = r'UserConfigPasskeyDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserConfigPasskeyDto object, {
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
    UserConfigPasskeyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserConfigPasskeyDtoBuilder result,
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
  UserConfigPasskeyDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserConfigPasskeyDtoBuilder();
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


