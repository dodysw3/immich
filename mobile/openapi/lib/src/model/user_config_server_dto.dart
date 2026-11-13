//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_config_server_dto.g.dart';

/// UserConfigServerDto
///
/// Properties:
/// * [externalDomain] - External domain
/// * [loginPageMessage] - Login page message
/// * [publicUsers] - Public users
@BuiltValue()
abstract class UserConfigServerDto implements Built<UserConfigServerDto, UserConfigServerDtoBuilder> {
  /// External domain
  @BuiltValueField(wireName: r'externalDomain')
  String get externalDomain;

  /// Login page message
  @BuiltValueField(wireName: r'loginPageMessage')
  String get loginPageMessage;

  /// Public users
  @BuiltValueField(wireName: r'publicUsers')
  bool get publicUsers;

  UserConfigServerDto._();

  factory UserConfigServerDto([void updates(UserConfigServerDtoBuilder b)]) = _$UserConfigServerDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserConfigServerDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserConfigServerDto> get serializer => _$UserConfigServerDtoSerializer();
}

class _$UserConfigServerDtoSerializer implements PrimitiveSerializer<UserConfigServerDto> {
  @override
  final Iterable<Type> types = const [UserConfigServerDto, _$UserConfigServerDto];

  @override
  final String wireName = r'UserConfigServerDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserConfigServerDto object, {
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
    UserConfigServerDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserConfigServerDtoBuilder result,
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
  UserConfigServerDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserConfigServerDtoBuilder();
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


