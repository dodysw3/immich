//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user_avatar_color.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_update_me_dto.g.dart';

/// UserUpdateMeDto
///
/// Properties:
/// * [avatarColor] 
/// * [email] - User email
/// * [name] - User name
@BuiltValue()
abstract class UserUpdateMeDto implements Built<UserUpdateMeDto, UserUpdateMeDtoBuilder> {
  @BuiltValueField(wireName: r'avatarColor')
  UserAvatarColor? get avatarColor;
  // enum avatarColorEnum {  primary,  pink,  red,  yellow,  blue,  green,  purple,  orange,  gray,  amber,  };

  /// User email
  @BuiltValueField(wireName: r'email')
  String? get email;

  /// User name
  @BuiltValueField(wireName: r'name')
  String? get name;

  UserUpdateMeDto._();

  factory UserUpdateMeDto([void updates(UserUpdateMeDtoBuilder b)]) = _$UserUpdateMeDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserUpdateMeDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserUpdateMeDto> get serializer => _$UserUpdateMeDtoSerializer();
}

class _$UserUpdateMeDtoSerializer implements PrimitiveSerializer<UserUpdateMeDto> {
  @override
  final Iterable<Type> types = const [UserUpdateMeDto, _$UserUpdateMeDto];

  @override
  final String wireName = r'UserUpdateMeDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserUpdateMeDto object, {
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
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UserUpdateMeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserUpdateMeDtoBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserUpdateMeDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserUpdateMeDtoBuilder();
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


