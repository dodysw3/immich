//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/person_user_role.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'person_other_response_dto.g.dart';

/// PersonOtherResponseDto
///
/// Properties:
/// * [birthDate] 
/// * [name] 
/// * [role] 
/// * [sharedById] 
@BuiltValue()
abstract class PersonOtherResponseDto implements Built<PersonOtherResponseDto, PersonOtherResponseDtoBuilder> {
  @BuiltValueField(wireName: r'birthDate')
  String? get birthDate;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'role')
  PersonUserRole get role;
  // enum roleEnum {  read,  write,  admin,  };

  @BuiltValueField(wireName: r'sharedById')
  String get sharedById;

  PersonOtherResponseDto._();

  factory PersonOtherResponseDto([void updates(PersonOtherResponseDtoBuilder b)]) = _$PersonOtherResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PersonOtherResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PersonOtherResponseDto> get serializer => _$PersonOtherResponseDtoSerializer();
}

class _$PersonOtherResponseDtoSerializer implements PrimitiveSerializer<PersonOtherResponseDto> {
  @override
  final Iterable<Type> types = const [PersonOtherResponseDto, _$PersonOtherResponseDto];

  @override
  final String wireName = r'PersonOtherResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PersonOtherResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'birthDate';
    yield object.birthDate == null ? null : serializers.serialize(
      object.birthDate,
      specifiedType: const FullType.nullable(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(PersonUserRole),
    );
    yield r'sharedById';
    yield serializers.serialize(
      object.sharedById,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PersonOtherResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PersonOtherResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'birthDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.birthDate = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PersonUserRole),
          ) as PersonUserRole;
          result.role = valueDes;
          break;
        case r'sharedById':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sharedById = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PersonOtherResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PersonOtherResponseDtoBuilder();
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


