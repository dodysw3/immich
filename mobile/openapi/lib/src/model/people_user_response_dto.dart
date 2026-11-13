//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/person_user_role.dart';
import 'package:openapi/src/model/user_avatar_color.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'people_user_response_dto.g.dart';

/// PeopleUserResponseDto
///
/// Properties:
/// * [avatarColor] 
/// * [email] - User email
/// * [id] - User ID
/// * [name] - User name
/// * [profileChangedAt] - Profile change date
/// * [profileImagePath] - Profile image path
/// * [role] 
@BuiltValue()
abstract class PeopleUserResponseDto implements Built<PeopleUserResponseDto, PeopleUserResponseDtoBuilder> {
  @BuiltValueField(wireName: r'avatarColor')
  UserAvatarColor get avatarColor;
  // enum avatarColorEnum {  primary,  pink,  red,  yellow,  blue,  green,  purple,  orange,  gray,  amber,  };

  /// User email
  @BuiltValueField(wireName: r'email')
  String get email;

  /// User ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// User name
  @BuiltValueField(wireName: r'name')
  String get name;

  /// Profile change date
  @BuiltValueField(wireName: r'profileChangedAt')
  DateTime get profileChangedAt;

  /// Profile image path
  @BuiltValueField(wireName: r'profileImagePath')
  String get profileImagePath;

  @BuiltValueField(wireName: r'role')
  PersonUserRole get role;
  // enum roleEnum {  read,  write,  admin,  };

  PeopleUserResponseDto._();

  factory PeopleUserResponseDto([void updates(PeopleUserResponseDtoBuilder b)]) = _$PeopleUserResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PeopleUserResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PeopleUserResponseDto> get serializer => _$PeopleUserResponseDtoSerializer();
}

class _$PeopleUserResponseDtoSerializer implements PrimitiveSerializer<PeopleUserResponseDto> {
  @override
  final Iterable<Type> types = const [PeopleUserResponseDto, _$PeopleUserResponseDto];

  @override
  final String wireName = r'PeopleUserResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PeopleUserResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'avatarColor';
    yield serializers.serialize(
      object.avatarColor,
      specifiedType: const FullType(UserAvatarColor),
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
    yield r'profileImagePath';
    yield serializers.serialize(
      object.profileImagePath,
      specifiedType: const FullType(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(PersonUserRole),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PeopleUserResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PeopleUserResponseDtoBuilder result,
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
        case r'profileImagePath':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.profileImagePath = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PersonUserRole),
          ) as PersonUserRole;
          result.role = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PeopleUserResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PeopleUserResponseDtoBuilder();
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


