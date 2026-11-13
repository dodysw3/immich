//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/person_user_role.dart';
import 'package:openapi/src/model/user_response_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'person_users_response_dto_inner.g.dart';

/// PersonUsersResponseDtoInner
///
/// Properties:
/// * [personId] - Person ID
/// * [role] 
/// * [sharedBy] 
/// * [sharedById] - User ID of the user that gave access to this person
/// * [sharedWith] 
/// * [sharedWithId] - User ID of the user that was given access to this person
@BuiltValue()
abstract class PersonUsersResponseDtoInner implements Built<PersonUsersResponseDtoInner, PersonUsersResponseDtoInnerBuilder> {
  /// Person ID
  @BuiltValueField(wireName: r'personId')
  String get personId;

  @BuiltValueField(wireName: r'role')
  PersonUserRole get role;
  // enum roleEnum {  read,  write,  admin,  };

  @BuiltValueField(wireName: r'sharedBy')
  UserResponseDto get sharedBy;

  /// User ID of the user that gave access to this person
  @BuiltValueField(wireName: r'sharedById')
  String get sharedById;

  @BuiltValueField(wireName: r'sharedWith')
  UserResponseDto get sharedWith;

  /// User ID of the user that was given access to this person
  @BuiltValueField(wireName: r'sharedWithId')
  String get sharedWithId;

  PersonUsersResponseDtoInner._();

  factory PersonUsersResponseDtoInner([void updates(PersonUsersResponseDtoInnerBuilder b)]) = _$PersonUsersResponseDtoInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PersonUsersResponseDtoInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PersonUsersResponseDtoInner> get serializer => _$PersonUsersResponseDtoInnerSerializer();
}

class _$PersonUsersResponseDtoInnerSerializer implements PrimitiveSerializer<PersonUsersResponseDtoInner> {
  @override
  final Iterable<Type> types = const [PersonUsersResponseDtoInner, _$PersonUsersResponseDtoInner];

  @override
  final String wireName = r'PersonUsersResponseDtoInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PersonUsersResponseDtoInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'personId';
    yield serializers.serialize(
      object.personId,
      specifiedType: const FullType(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(PersonUserRole),
    );
    yield r'sharedBy';
    yield serializers.serialize(
      object.sharedBy,
      specifiedType: const FullType(UserResponseDto),
    );
    yield r'sharedById';
    yield serializers.serialize(
      object.sharedById,
      specifiedType: const FullType(String),
    );
    yield r'sharedWith';
    yield serializers.serialize(
      object.sharedWith,
      specifiedType: const FullType(UserResponseDto),
    );
    yield r'sharedWithId';
    yield serializers.serialize(
      object.sharedWithId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PersonUsersResponseDtoInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PersonUsersResponseDtoInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'personId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.personId = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PersonUserRole),
          ) as PersonUserRole;
          result.role = valueDes;
          break;
        case r'sharedBy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserResponseDto),
          ) as UserResponseDto;
          result.sharedBy.replace(valueDes);
          break;
        case r'sharedById':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sharedById = valueDes;
          break;
        case r'sharedWith':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserResponseDto),
          ) as UserResponseDto;
          result.sharedWith.replace(valueDes);
          break;
        case r'sharedWithId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sharedWithId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PersonUsersResponseDtoInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PersonUsersResponseDtoInnerBuilder();
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


