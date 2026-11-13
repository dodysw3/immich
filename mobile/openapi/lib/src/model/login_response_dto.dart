//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'login_response_dto.g.dart';

/// LoginResponseDto
///
/// Properties:
/// * [accessToken] - Access token
/// * [isAdmin] - Is admin user
/// * [isOnboarded] - Is onboarded
/// * [name] - User name
/// * [profileImagePath] - Profile image path
/// * [shouldChangePassword] - Should change password
/// * [userEmail] - User email
/// * [userId] - User ID
@BuiltValue()
abstract class LoginResponseDto implements Built<LoginResponseDto, LoginResponseDtoBuilder> {
  /// Access token
  @BuiltValueField(wireName: r'accessToken')
  String get accessToken;

  /// Is admin user
  @BuiltValueField(wireName: r'isAdmin')
  bool get isAdmin;

  /// Is onboarded
  @BuiltValueField(wireName: r'isOnboarded')
  bool get isOnboarded;

  /// User name
  @BuiltValueField(wireName: r'name')
  String get name;

  /// Profile image path
  @BuiltValueField(wireName: r'profileImagePath')
  String get profileImagePath;

  /// Should change password
  @BuiltValueField(wireName: r'shouldChangePassword')
  bool get shouldChangePassword;

  /// User email
  @BuiltValueField(wireName: r'userEmail')
  String get userEmail;

  /// User ID
  @BuiltValueField(wireName: r'userId')
  String get userId;

  LoginResponseDto._();

  factory LoginResponseDto([void updates(LoginResponseDtoBuilder b)]) = _$LoginResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoginResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoginResponseDto> get serializer => _$LoginResponseDtoSerializer();
}

class _$LoginResponseDtoSerializer implements PrimitiveSerializer<LoginResponseDto> {
  @override
  final Iterable<Type> types = const [LoginResponseDto, _$LoginResponseDto];

  @override
  final String wireName = r'LoginResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoginResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accessToken';
    yield serializers.serialize(
      object.accessToken,
      specifiedType: const FullType(String),
    );
    yield r'isAdmin';
    yield serializers.serialize(
      object.isAdmin,
      specifiedType: const FullType(bool),
    );
    yield r'isOnboarded';
    yield serializers.serialize(
      object.isOnboarded,
      specifiedType: const FullType(bool),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'profileImagePath';
    yield serializers.serialize(
      object.profileImagePath,
      specifiedType: const FullType(String),
    );
    yield r'shouldChangePassword';
    yield serializers.serialize(
      object.shouldChangePassword,
      specifiedType: const FullType(bool),
    );
    yield r'userEmail';
    yield serializers.serialize(
      object.userEmail,
      specifiedType: const FullType(String),
    );
    yield r'userId';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LoginResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoginResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accessToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accessToken = valueDes;
          break;
        case r'isAdmin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isAdmin = valueDes;
          break;
        case r'isOnboarded':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isOnboarded = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'profileImagePath':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.profileImagePath = valueDes;
          break;
        case r'shouldChangePassword':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.shouldChangePassword = valueDes;
          break;
        case r'userEmail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userEmail = valueDes;
          break;
        case r'userId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LoginResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoginResponseDtoBuilder();
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


