//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user_avatar_color.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_auth_user_v1.g.dart';

/// SyncAuthUserV1
///
/// Properties:
/// * [avatarColor] 
/// * [deletedAt] - User deleted at
/// * [email] - User email
/// * [hasProfileImage] - User has profile image
/// * [id] - User ID
/// * [isAdmin] - User is admin
/// * [name] - User name
/// * [oauthId] - User OAuth ID
/// * [pinCode] - User pin code
/// * [profileChangedAt] - User profile changed at
/// * [quotaSizeInBytes] - Quota size in bytes
/// * [quotaUsageInBytes] - Quota usage in bytes
/// * [storageLabel] - User storage label
@BuiltValue()
abstract class SyncAuthUserV1 implements Built<SyncAuthUserV1, SyncAuthUserV1Builder> {
  @BuiltValueField(wireName: r'avatarColor')
  UserAvatarColor? get avatarColor;
  // enum avatarColorEnum {  primary,  pink,  red,  yellow,  blue,  green,  purple,  orange,  gray,  amber,  };

  /// User deleted at
  @BuiltValueField(wireName: r'deletedAt')
  DateTime? get deletedAt;

  /// User email
  @BuiltValueField(wireName: r'email')
  String get email;

  /// User has profile image
  @BuiltValueField(wireName: r'hasProfileImage')
  bool get hasProfileImage;

  /// User ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// User is admin
  @BuiltValueField(wireName: r'isAdmin')
  bool get isAdmin;

  /// User name
  @BuiltValueField(wireName: r'name')
  String get name;

  /// User OAuth ID
  @BuiltValueField(wireName: r'oauthId')
  String get oauthId;

  /// User pin code
  @BuiltValueField(wireName: r'pinCode')
  String? get pinCode;

  /// User profile changed at
  @BuiltValueField(wireName: r'profileChangedAt')
  DateTime get profileChangedAt;

  /// Quota size in bytes
  @BuiltValueField(wireName: r'quotaSizeInBytes')
  int? get quotaSizeInBytes;

  /// Quota usage in bytes
  @BuiltValueField(wireName: r'quotaUsageInBytes')
  int get quotaUsageInBytes;

  /// User storage label
  @BuiltValueField(wireName: r'storageLabel')
  String? get storageLabel;

  SyncAuthUserV1._();

  factory SyncAuthUserV1([void updates(SyncAuthUserV1Builder b)]) = _$SyncAuthUserV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncAuthUserV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncAuthUserV1> get serializer => _$SyncAuthUserV1Serializer();
}

class _$SyncAuthUserV1Serializer implements PrimitiveSerializer<SyncAuthUserV1> {
  @override
  final Iterable<Type> types = const [SyncAuthUserV1, _$SyncAuthUserV1];

  @override
  final String wireName = r'SyncAuthUserV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncAuthUserV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.avatarColor != null) {
      yield r'avatarColor';
      yield serializers.serialize(
        object.avatarColor,
        specifiedType: const FullType.nullable(UserAvatarColor),
      );
    }
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
    yield r'hasProfileImage';
    yield serializers.serialize(
      object.hasProfileImage,
      specifiedType: const FullType(bool),
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
    yield r'pinCode';
    yield object.pinCode == null ? null : serializers.serialize(
      object.pinCode,
      specifiedType: const FullType.nullable(String),
    );
    yield r'profileChangedAt';
    yield serializers.serialize(
      object.profileChangedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'quotaSizeInBytes';
    yield object.quotaSizeInBytes == null ? null : serializers.serialize(
      object.quotaSizeInBytes,
      specifiedType: const FullType.nullable(int),
    );
    yield r'quotaUsageInBytes';
    yield serializers.serialize(
      object.quotaUsageInBytes,
      specifiedType: const FullType(int),
    );
    yield r'storageLabel';
    yield object.storageLabel == null ? null : serializers.serialize(
      object.storageLabel,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncAuthUserV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncAuthUserV1Builder result,
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
        case r'hasProfileImage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasProfileImage = valueDes;
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
        case r'pinCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.pinCode = valueDes;
          break;
        case r'profileChangedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.profileChangedAt = valueDes;
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
            specifiedType: const FullType(int),
          ) as int;
          result.quotaUsageInBytes = valueDes;
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
  SyncAuthUserV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncAuthUserV1Builder();
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


