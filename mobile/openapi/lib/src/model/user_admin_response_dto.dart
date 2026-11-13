//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user_status.dart';
import 'package:openapi/src/model/user_avatar_color.dart';
import 'package:openapi/src/model/user_license.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_admin_response_dto.g.dart';

/// UserAdminResponseDto
///
/// Properties:
/// * [avatarColor] 
/// * [clusterGroupId] - Cluster group the user is a member of
/// * [createdAt] - Creation date
/// * [deletedAt] - Deletion date
/// * [email] - User email
/// * [id] - User ID
/// * [isAdmin] - Is admin user
/// * [license] 
/// * [name] - User name
/// * [oauthId] - OAuth ID
/// * [profileChangedAt] - Profile change date
/// * [profileImagePath] - Profile image path
/// * [quotaSizeInBytes] - Storage quota in bytes
/// * [quotaUsageInBytes] - Storage usage in bytes
/// * [shouldChangePassword] - Require password change on next login
/// * [status] 
/// * [storageLabel] - Storage label
/// * [updatedAt] - Last update date
@BuiltValue()
abstract class UserAdminResponseDto implements Built<UserAdminResponseDto, UserAdminResponseDtoBuilder> {
  @BuiltValueField(wireName: r'avatarColor')
  UserAvatarColor get avatarColor;
  // enum avatarColorEnum {  primary,  pink,  red,  yellow,  blue,  green,  purple,  orange,  gray,  amber,  };

  /// Cluster group the user is a member of
  @BuiltValueField(wireName: r'clusterGroupId')
  String get clusterGroupId;

  /// Creation date
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// Deletion date
  @BuiltValueField(wireName: r'deletedAt')
  DateTime? get deletedAt;

  /// User email
  @BuiltValueField(wireName: r'email')
  String get email;

  /// User ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Is admin user
  @BuiltValueField(wireName: r'isAdmin')
  bool get isAdmin;

  @BuiltValueField(wireName: r'license')
  UserLicense? get license;

  /// User name
  @BuiltValueField(wireName: r'name')
  String get name;

  /// OAuth ID
  @BuiltValueField(wireName: r'oauthId')
  String get oauthId;

  /// Profile change date
  @BuiltValueField(wireName: r'profileChangedAt')
  DateTime get profileChangedAt;

  /// Profile image path
  @BuiltValueField(wireName: r'profileImagePath')
  String get profileImagePath;

  /// Storage quota in bytes
  @BuiltValueField(wireName: r'quotaSizeInBytes')
  int? get quotaSizeInBytes;

  /// Storage usage in bytes
  @BuiltValueField(wireName: r'quotaUsageInBytes')
  int? get quotaUsageInBytes;

  /// Require password change on next login
  @BuiltValueField(wireName: r'shouldChangePassword')
  bool get shouldChangePassword;

  @BuiltValueField(wireName: r'status')
  UserStatus get status;
  // enum statusEnum {  active,  removing,  deleted,  };

  /// Storage label
  @BuiltValueField(wireName: r'storageLabel')
  String? get storageLabel;

  /// Last update date
  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  UserAdminResponseDto._();

  factory UserAdminResponseDto([void updates(UserAdminResponseDtoBuilder b)]) = _$UserAdminResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserAdminResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserAdminResponseDto> get serializer => _$UserAdminResponseDtoSerializer();
}

class _$UserAdminResponseDtoSerializer implements PrimitiveSerializer<UserAdminResponseDto> {
  @override
  final Iterable<Type> types = const [UserAdminResponseDto, _$UserAdminResponseDto];

  @override
  final String wireName = r'UserAdminResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserAdminResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'avatarColor';
    yield serializers.serialize(
      object.avatarColor,
      specifiedType: const FullType(UserAvatarColor),
    );
    yield r'clusterGroupId';
    yield serializers.serialize(
      object.clusterGroupId,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'deletedAt';
    yield object.deletedAt == null ? null : serializers.serialize(
      object.deletedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'isAdmin';
    yield serializers.serialize(
      object.isAdmin,
      specifiedType: const FullType(bool),
    );
    yield r'license';
    yield object.license == null ? null : serializers.serialize(
      object.license,
      specifiedType: const FullType.nullable(UserLicense),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'oauthId';
    yield serializers.serialize(
      object.oauthId,
      specifiedType: const FullType(String),
    );
    yield r'profileChangedAt';
    yield serializers.serialize(
      object.profileChangedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'profileImagePath';
    yield serializers.serialize(
      object.profileImagePath,
      specifiedType: const FullType(String),
    );
    yield r'quotaSizeInBytes';
    yield object.quotaSizeInBytes == null ? null : serializers.serialize(
      object.quotaSizeInBytes,
      specifiedType: const FullType.nullable(int),
    );
    yield r'quotaUsageInBytes';
    yield object.quotaUsageInBytes == null ? null : serializers.serialize(
      object.quotaUsageInBytes,
      specifiedType: const FullType.nullable(int),
    );
    yield r'shouldChangePassword';
    yield serializers.serialize(
      object.shouldChangePassword,
      specifiedType: const FullType(bool),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(UserStatus),
    );
    yield r'storageLabel';
    yield object.storageLabel == null ? null : serializers.serialize(
      object.storageLabel,
      specifiedType: const FullType.nullable(String),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserAdminResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserAdminResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'avatarColor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserAvatarColor),
          ) as UserAvatarColor;
          result.avatarColor = valueDes;
          break;
        case r'clusterGroupId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.clusterGroupId = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'deletedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.deletedAt = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'isAdmin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isAdmin = valueDes;
          break;
        case r'license':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(UserLicense),
          ) as UserLicense?;
          if (valueDes == null) continue;
          result.license.replace(valueDes);
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'oauthId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.oauthId = valueDes;
          break;
        case r'profileChangedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.profileChangedAt = valueDes;
          break;
        case r'profileImagePath':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.profileImagePath = valueDes;
          break;
        case r'quotaSizeInBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.quotaSizeInBytes = valueDes;
          break;
        case r'quotaUsageInBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.quotaUsageInBytes = valueDes;
          break;
        case r'shouldChangePassword':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.shouldChangePassword = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserStatus),
          ) as UserStatus;
          result.status = valueDes;
          break;
        case r'storageLabel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.storageLabel = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserAdminResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserAdminResponseDtoBuilder();
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


