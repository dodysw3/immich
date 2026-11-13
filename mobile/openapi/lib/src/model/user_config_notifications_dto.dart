//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user_config_smtp_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_config_notifications_dto.g.dart';

/// UserConfigNotificationsDto
///
/// Properties:
/// * [smtp] 
@BuiltValue()
abstract class UserConfigNotificationsDto implements Built<UserConfigNotificationsDto, UserConfigNotificationsDtoBuilder> {
  @BuiltValueField(wireName: r'smtp')
  UserConfigSmtpDto get smtp;

  UserConfigNotificationsDto._();

  factory UserConfigNotificationsDto([void updates(UserConfigNotificationsDtoBuilder b)]) = _$UserConfigNotificationsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserConfigNotificationsDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserConfigNotificationsDto> get serializer => _$UserConfigNotificationsDtoSerializer();
}

class _$UserConfigNotificationsDtoSerializer implements PrimitiveSerializer<UserConfigNotificationsDto> {
  @override
  final Iterable<Type> types = const [UserConfigNotificationsDto, _$UserConfigNotificationsDto];

  @override
  final String wireName = r'UserConfigNotificationsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserConfigNotificationsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'smtp';
    yield serializers.serialize(
      object.smtp,
      specifiedType: const FullType(UserConfigSmtpDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserConfigNotificationsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserConfigNotificationsDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'smtp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserConfigSmtpDto),
          ) as UserConfigSmtpDto;
          result.smtp.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserConfigNotificationsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserConfigNotificationsDtoBuilder();
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


