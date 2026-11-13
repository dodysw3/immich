//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/admin_config_smtp_transport_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_smtp_dto.g.dart';

/// AdminConfigSmtpDto
///
/// Properties:
/// * [enabled] - Whether SMTP email notifications are enabled
/// * [from] - Email address to send from
/// * [replyTo] - Email address for replies
/// * [transport] 
@BuiltValue()
abstract class AdminConfigSmtpDto implements Built<AdminConfigSmtpDto, AdminConfigSmtpDtoBuilder> {
  /// Whether SMTP email notifications are enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// Email address to send from
  @BuiltValueField(wireName: r'from')
  String get from;

  /// Email address for replies
  @BuiltValueField(wireName: r'replyTo')
  String get replyTo;

  @BuiltValueField(wireName: r'transport')
  AdminConfigSmtpTransportDto get transport;

  AdminConfigSmtpDto._();

  factory AdminConfigSmtpDto([void updates(AdminConfigSmtpDtoBuilder b)]) = _$AdminConfigSmtpDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigSmtpDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigSmtpDto> get serializer => _$AdminConfigSmtpDtoSerializer();
}

class _$AdminConfigSmtpDtoSerializer implements PrimitiveSerializer<AdminConfigSmtpDto> {
  @override
  final Iterable<Type> types = const [AdminConfigSmtpDto, _$AdminConfigSmtpDto];

  @override
  final String wireName = r'AdminConfigSmtpDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigSmtpDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(String),
    );
    yield r'replyTo';
    yield serializers.serialize(
      object.replyTo,
      specifiedType: const FullType(String),
    );
    yield r'transport';
    yield serializers.serialize(
      object.transport,
      specifiedType: const FullType(AdminConfigSmtpTransportDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigSmtpDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigSmtpDtoBuilder result,
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
        case r'from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.from = valueDes;
          break;
        case r'replyTo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.replyTo = valueDes;
          break;
        case r'transport':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigSmtpTransportDto),
          ) as AdminConfigSmtpTransportDto;
          result.transport.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigSmtpDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigSmtpDtoBuilder();
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


