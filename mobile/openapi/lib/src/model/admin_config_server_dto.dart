//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_server_dto.g.dart';

/// AdminConfigServerDto
///
/// Properties:
/// * [externalDomain] - External domain
/// * [loginPageMessage] - Login page message
/// * [publicUsers] - Public users
@BuiltValue()
abstract class AdminConfigServerDto implements Built<AdminConfigServerDto, AdminConfigServerDtoBuilder> {
  /// External domain
  @BuiltValueField(wireName: r'externalDomain')
  String get externalDomain;

  /// Login page message
  @BuiltValueField(wireName: r'loginPageMessage')
  String get loginPageMessage;

  /// Public users
  @BuiltValueField(wireName: r'publicUsers')
  bool get publicUsers;

  AdminConfigServerDto._();

  factory AdminConfigServerDto([void updates(AdminConfigServerDtoBuilder b)]) = _$AdminConfigServerDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigServerDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigServerDto> get serializer => _$AdminConfigServerDtoSerializer();
}

class _$AdminConfigServerDtoSerializer implements PrimitiveSerializer<AdminConfigServerDto> {
  @override
  final Iterable<Type> types = const [AdminConfigServerDto, _$AdminConfigServerDto];

  @override
  final String wireName = r'AdminConfigServerDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigServerDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'externalDomain';
    yield serializers.serialize(
      object.externalDomain,
      specifiedType: const FullType(String),
    );
    yield r'loginPageMessage';
    yield serializers.serialize(
      object.loginPageMessage,
      specifiedType: const FullType(String),
    );
    yield r'publicUsers';
    yield serializers.serialize(
      object.publicUsers,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigServerDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigServerDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'externalDomain':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.externalDomain = valueDes;
          break;
        case r'loginPageMessage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.loginPageMessage = valueDes;
          break;
        case r'publicUsers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.publicUsers = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigServerDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigServerDtoBuilder();
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


