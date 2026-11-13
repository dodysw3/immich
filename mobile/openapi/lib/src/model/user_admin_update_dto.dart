//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user_avatar_color.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_admin_update_dto.g.dart';

/// UserAdminUpdateDto
///
/// Properties:
/// * [avatarColor] 
/// * [email] - User email
/// * [isAdmin] - Grant admin privileges
/// * [name] - User name
/// * [password] - User password
/// * [pinCode] - PIN code
/// * [quotaSizeInBytes] - Storage quota in bytes
/// * [shouldChangePassword] - Require password change on next login
/// * [storageLabel] - Storage label
@BuiltValue()
abstract class UserAdminUpdateDto implements Built<UserAdminUpdateDto, UserAdminUpdateDtoBuilder> {
  @BuiltValueField(wireName: r'avatarColor')
  UserAvatarColor? get avatarColor;
  // enum avatarColorEnum {  primary,  pink,  red,  yellow,  blue,  green,  purple,  orange,  gray,  amber,  };

  /// User email
  @BuiltValueField(wireName: r'email')
  String? get email;

  /// Grant admin privileges
  @BuiltValueField(wireName: r'isAdmin')
  bool? get isAdmin;

  /// User name
  @BuiltValueField(wireName: r'name')
  String? get name;

  /// User password
  @BuiltValueField(wireName: r'password')
  String? get password;

  /// PIN code
  @BuiltValueField(wireName: r'pinCode')
  String? get pinCode;

  /// Storage quota in bytes
  @BuiltValueField(wireName: r'quotaSizeInBytes')
  int? get quotaSizeInBytes;

  /// Require password change on next login
  @BuiltValueField(wireName: r'shouldChangePassword')
  bool? get shouldChangePassword;

  /// Storage label
  @BuiltValueField(wireName: r'storageLabel')
  String? get storageLabel;

  UserAdminUpdateDto._();

  factory UserAdminUpdateDto([void updates(UserAdminUpdateDtoBuilder b)]) = _$UserAdminUpdateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserAdminUpdateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserAdminUpdateDto> get serializer => _$UserAdminUpdateDtoSerializer();
}

class _$UserAdminUpdateDtoSerializer implements PrimitiveSerializer<UserAdminUpdateDto> {
  @override
  final Iterable<Type> types = const [UserAdminUpdateDto, _$UserAdminUpdateDto];

  @override
  final String wireName = r'UserAdminUpdateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserAdminUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.avatarColor != null) {
      yield r'avatarColor';
      yield serializers.serialize(
        object.avatarColor,
        specifiedType: const FullType.nullable(UserAvatarColor),
      );
    }
    if (object.email != null) {
      yield r'email';
      yield serializers.serialize(
        object.email,
        specifiedType: const FullType(String),
      );
    }
    if (object.isAdmin != null) {
      yield r'isAdmin';
      yield serializers.serialize(
        object.isAdmin,
        specifiedType: const FullType(bool),
      );
    }
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.password != null) {
      yield r'password';
      yield serializers.serialize(
        object.password,
        specifiedType: const FullType(String),
      );
    }
    if (object.pinCode != null) {
      yield r'pinCode';
      yield serializers.serialize(
        object.pinCode,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.quotaSizeInBytes != null) {
      yield r'quotaSizeInBytes';
      yield serializers.serialize(
        object.quotaSizeInBytes,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.shouldChangePassword != null) {
      yield r'shouldChangePassword';
      yield serializers.serialize(
        object.shouldChangePassword,
        specifiedType: const FullType(bool),
      );
    }
    if (object.storageLabel != null) {
      yield r'storageLabel';
      yield serializers.serialize(
        object.storageLabel,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UserAdminUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserAdminUpdateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'avatarColor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(UserAvatarColor),
          ) as UserAvatarColor?;
          if (valueDes == null) continue;
          result.avatarColor = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.email = valueDes;
          break;
        case r'isAdmin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isAdmin = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.password = valueDes;
          break;
        case r'pinCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.pinCode = valueDes;
          break;
        case r'quotaSizeInBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.quotaSizeInBytes = valueDes;
          break;
        case r'shouldChangePassword':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.shouldChangePassword = valueDes;
          break;
        case r'storageLabel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.storageLabel = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserAdminUpdateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserAdminUpdateDtoBuilder();
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


