//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/admin_config_smtp_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_notifications_dto.g.dart';

/// AdminConfigNotificationsDto
///
/// Properties:
/// * [smtp] 
@BuiltValue()
abstract class AdminConfigNotificationsDto implements Built<AdminConfigNotificationsDto, AdminConfigNotificationsDtoBuilder> {
  @BuiltValueField(wireName: r'smtp')
  AdminConfigSmtpDto get smtp;

  AdminConfigNotificationsDto._();

  factory AdminConfigNotificationsDto([void updates(AdminConfigNotificationsDtoBuilder b)]) = _$AdminConfigNotificationsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigNotificationsDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigNotificationsDto> get serializer => _$AdminConfigNotificationsDtoSerializer();
}

class _$AdminConfigNotificationsDtoSerializer implements PrimitiveSerializer<AdminConfigNotificationsDto> {
  @override
  final Iterable<Type> types = const [AdminConfigNotificationsDto, _$AdminConfigNotificationsDto];

  @override
  final String wireName = r'AdminConfigNotificationsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigNotificationsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'smtp';
    yield serializers.serialize(
      object.smtp,
      specifiedType: const FullType(AdminConfigSmtpDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigNotificationsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigNotificationsDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'smtp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigSmtpDto),
          ) as AdminConfigSmtpDto;
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
  AdminConfigNotificationsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigNotificationsDtoBuilder();
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


