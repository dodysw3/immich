//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'email_notifications_response.g.dart';

/// EmailNotificationsResponse
///
/// Properties:
/// * [albumInvite] - Whether to receive email notifications for album invites
/// * [albumUpdate] - Whether to receive email notifications for album updates
/// * [enabled] - Whether email notifications are enabled
@BuiltValue()
abstract class EmailNotificationsResponse implements Built<EmailNotificationsResponse, EmailNotificationsResponseBuilder> {
  /// Whether to receive email notifications for album invites
  @BuiltValueField(wireName: r'albumInvite')
  bool get albumInvite;

  /// Whether to receive email notifications for album updates
  @BuiltValueField(wireName: r'albumUpdate')
  bool get albumUpdate;

  /// Whether email notifications are enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  EmailNotificationsResponse._();

  factory EmailNotificationsResponse([void updates(EmailNotificationsResponseBuilder b)]) = _$EmailNotificationsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmailNotificationsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmailNotificationsResponse> get serializer => _$EmailNotificationsResponseSerializer();
}

class _$EmailNotificationsResponseSerializer implements PrimitiveSerializer<EmailNotificationsResponse> {
  @override
  final Iterable<Type> types = const [EmailNotificationsResponse, _$EmailNotificationsResponse];

  @override
  final String wireName = r'EmailNotificationsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmailNotificationsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'albumInvite';
    yield serializers.serialize(
      object.albumInvite,
      specifiedType: const FullType(bool),
    );
    yield r'albumUpdate';
    yield serializers.serialize(
      object.albumUpdate,
      specifiedType: const FullType(bool),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmailNotificationsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmailNotificationsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'albumInvite':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.albumInvite = valueDes;
          break;
        case r'albumUpdate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.albumUpdate = valueDes;
          break;
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
  EmailNotificationsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmailNotificationsResponseBuilder();
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


