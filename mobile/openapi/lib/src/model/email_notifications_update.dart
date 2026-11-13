//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'email_notifications_update.g.dart';

/// EmailNotificationsUpdate
///
/// Properties:
/// * [albumInvite] - Whether to receive email notifications for album invites
/// * [albumUpdate] - Whether to receive email notifications for album updates
/// * [enabled] - Whether email notifications are enabled
@BuiltValue()
abstract class EmailNotificationsUpdate implements Built<EmailNotificationsUpdate, EmailNotificationsUpdateBuilder> {
  /// Whether to receive email notifications for album invites
  @BuiltValueField(wireName: r'albumInvite')
  bool? get albumInvite;

  /// Whether to receive email notifications for album updates
  @BuiltValueField(wireName: r'albumUpdate')
  bool? get albumUpdate;

  /// Whether email notifications are enabled
  @BuiltValueField(wireName: r'enabled')
  bool? get enabled;

  EmailNotificationsUpdate._();

  factory EmailNotificationsUpdate([void updates(EmailNotificationsUpdateBuilder b)]) = _$EmailNotificationsUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmailNotificationsUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmailNotificationsUpdate> get serializer => _$EmailNotificationsUpdateSerializer();
}

class _$EmailNotificationsUpdateSerializer implements PrimitiveSerializer<EmailNotificationsUpdate> {
  @override
  final Iterable<Type> types = const [EmailNotificationsUpdate, _$EmailNotificationsUpdate];

  @override
  final String wireName = r'EmailNotificationsUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmailNotificationsUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.albumInvite != null) {
      yield r'albumInvite';
      yield serializers.serialize(
        object.albumInvite,
        specifiedType: const FullType(bool),
      );
    }
    if (object.albumUpdate != null) {
      yield r'albumUpdate';
      yield serializers.serialize(
        object.albumUpdate,
        specifiedType: const FullType(bool),
      );
    }
    if (object.enabled != null) {
      yield r'enabled';
      yield serializers.serialize(
        object.enabled,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    EmailNotificationsUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmailNotificationsUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'albumInvite':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.albumInvite = valueDes;
          break;
        case r'albumUpdate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.albumUpdate = valueDes;
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
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
  EmailNotificationsUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmailNotificationsUpdateBuilder();
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


