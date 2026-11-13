//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_config_smtp_dto.g.dart';

/// UserConfigSmtpDto
///
/// Properties:
/// * [enabled] - Whether SMTP email notifications are enabled
@BuiltValue()
abstract class UserConfigSmtpDto implements Built<UserConfigSmtpDto, UserConfigSmtpDtoBuilder> {
  /// Whether SMTP email notifications are enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  UserConfigSmtpDto._();

  factory UserConfigSmtpDto([void updates(UserConfigSmtpDtoBuilder b)]) = _$UserConfigSmtpDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserConfigSmtpDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserConfigSmtpDto> get serializer => _$UserConfigSmtpDtoSerializer();
}

class _$UserConfigSmtpDtoSerializer implements PrimitiveSerializer<UserConfigSmtpDto> {
  @override
  final Iterable<Type> types = const [UserConfigSmtpDto, _$UserConfigSmtpDto];

  @override
  final String wireName = r'UserConfigSmtpDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserConfigSmtpDto object, {
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
    UserConfigSmtpDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserConfigSmtpDtoBuilder result,
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
  UserConfigSmtpDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserConfigSmtpDtoBuilder();
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


