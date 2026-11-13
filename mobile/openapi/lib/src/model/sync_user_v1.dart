//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user_avatar_color.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_user_v1.g.dart';

/// SyncUserV1
///
/// Properties:
/// * [avatarColor] 
/// * [deletedAt] - User deleted at
/// * [email] - User email
/// * [hasProfileImage] - User has profile image
/// * [id] - User ID
/// * [name] - User name
/// * [profileChangedAt] - User profile changed at
@BuiltValue()
abstract class SyncUserV1 implements Built<SyncUserV1, SyncUserV1Builder> {
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

  /// User name
  @BuiltValueField(wireName: r'name')
  String get name;

  /// User profile changed at
  @BuiltValueField(wireName: r'profileChangedAt')
  DateTime get profileChangedAt;

  SyncUserV1._();

  factory SyncUserV1([void updates(SyncUserV1Builder b)]) = _$SyncUserV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncUserV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncUserV1> get serializer => _$SyncUserV1Serializer();
}

class _$SyncUserV1Serializer implements PrimitiveSerializer<SyncUserV1> {
  @override
  final Iterable<Type> types = const [SyncUserV1, _$SyncUserV1];

  @override
  final String wireName = r'SyncUserV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncUserV1 object, {
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
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'profileChangedAt';
    yield serializers.serialize(
      object.profileChangedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncUserV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncUserV1Builder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'profileChangedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.profileChangedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncUserV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncUserV1Builder();
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


