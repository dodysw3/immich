//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_smtp_transport_dto.g.dart';

/// AdminConfigSmtpTransportDto
///
/// Properties:
/// * [host] - SMTP server hostname
/// * [ignoreCert] - Whether to ignore SSL certificate errors
/// * [password] - SMTP password
/// * [port] - SMTP server port
/// * [secure] - Whether to use secure connection (TLS/SSL)
/// * [username] - SMTP username
@BuiltValue()
abstract class AdminConfigSmtpTransportDto implements Built<AdminConfigSmtpTransportDto, AdminConfigSmtpTransportDtoBuilder> {
  /// SMTP server hostname
  @BuiltValueField(wireName: r'host')
  String get host;

  /// Whether to ignore SSL certificate errors
  @BuiltValueField(wireName: r'ignoreCert')
  bool get ignoreCert;

  /// SMTP password
  @BuiltValueField(wireName: r'password')
  String get password;

  /// SMTP server port
  @BuiltValueField(wireName: r'port')
  int get port;

  /// Whether to use secure connection (TLS/SSL)
  @BuiltValueField(wireName: r'secure')
  bool get secure;

  /// SMTP username
  @BuiltValueField(wireName: r'username')
  String get username;

  AdminConfigSmtpTransportDto._();

  factory AdminConfigSmtpTransportDto([void updates(AdminConfigSmtpTransportDtoBuilder b)]) = _$AdminConfigSmtpTransportDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigSmtpTransportDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigSmtpTransportDto> get serializer => _$AdminConfigSmtpTransportDtoSerializer();
}

class _$AdminConfigSmtpTransportDtoSerializer implements PrimitiveSerializer<AdminConfigSmtpTransportDto> {
  @override
  final Iterable<Type> types = const [AdminConfigSmtpTransportDto, _$AdminConfigSmtpTransportDto];

  @override
  final String wireName = r'AdminConfigSmtpTransportDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigSmtpTransportDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'host';
    yield serializers.serialize(
      object.host,
      specifiedType: const FullType(String),
    );
    yield r'ignoreCert';
    yield serializers.serialize(
      object.ignoreCert,
      specifiedType: const FullType(bool),
    );
    yield r'password';
    yield serializers.serialize(
      object.password,
      specifiedType: const FullType(String),
    );
    yield r'port';
    yield serializers.serialize(
      object.port,
      specifiedType: const FullType(int),
    );
    yield r'secure';
    yield serializers.serialize(
      object.secure,
      specifiedType: const FullType(bool),
    );
    yield r'username';
    yield serializers.serialize(
      object.username,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigSmtpTransportDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigSmtpTransportDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'host':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.host = valueDes;
          break;
        case r'ignoreCert':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.ignoreCert = valueDes;
          break;
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.password = valueDes;
          break;
        case r'port':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.port = valueDes;
          break;
        case r'secure':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.secure = valueDes;
          break;
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.username = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigSmtpTransportDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigSmtpTransportDtoBuilder();
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


