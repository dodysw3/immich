//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/person_user_role.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/people_users_upsert_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'people_users_upsert_dto.g.dart';

/// PeopleUsersUpsertDto
///
/// Properties:
/// * [personIds] - Person IDs, required when type is omitted
/// * [role] 
/// * [sharedWithIds] - User IDs that should be given access to the person
/// * [type] 
@BuiltValue()
abstract class PeopleUsersUpsertDto implements Built<PeopleUsersUpsertDto, PeopleUsersUpsertDtoBuilder> {
  /// Person IDs, required when type is omitted
  @BuiltValueField(wireName: r'personIds')
  BuiltList<String>? get personIds;

  @BuiltValueField(wireName: r'role')
  PersonUserRole get role;
  // enum roleEnum {  read,  write,  admin,  };

  /// User IDs that should be given access to the person
  @BuiltValueField(wireName: r'sharedWithIds')
  BuiltList<String> get sharedWithIds;

  @BuiltValueField(wireName: r'type')
  PeopleUsersUpsertType? get type;
  // enum typeEnum {  everyone,  };

  PeopleUsersUpsertDto._();

  factory PeopleUsersUpsertDto([void updates(PeopleUsersUpsertDtoBuilder b)]) = _$PeopleUsersUpsertDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PeopleUsersUpsertDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PeopleUsersUpsertDto> get serializer => _$PeopleUsersUpsertDtoSerializer();
}

class _$PeopleUsersUpsertDtoSerializer implements PrimitiveSerializer<PeopleUsersUpsertDto> {
  @override
  final Iterable<Type> types = const [PeopleUsersUpsertDto, _$PeopleUsersUpsertDto];

  @override
  final String wireName = r'PeopleUsersUpsertDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PeopleUsersUpsertDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.personIds != null) {
      yield r'personIds';
      yield serializers.serialize(
        object.personIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(PersonUserRole),
    );
    yield r'sharedWithIds';
    yield serializers.serialize(
      object.sharedWithIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    if (object.type != null) {
      yield r'type';
      yield serializers.serialize(
        object.type,
        specifiedType: const FullType(PeopleUsersUpsertType),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PeopleUsersUpsertDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PeopleUsersUpsertDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'personIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.personIds.replace(valueDes);
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PersonUserRole),
          ) as PersonUserRole;
          result.role = valueDes;
          break;
        case r'sharedWithIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.sharedWithIds.replace(valueDes);
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PeopleUsersUpsertType),
          ) as PeopleUsersUpsertType?;
          if (valueDes == null) continue;
          result.type = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PeopleUsersUpsertDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PeopleUsersUpsertDtoBuilder();
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


