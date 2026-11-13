//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/people_user_response_dto.dart';
import 'package:openapi/src/model/person_other_response_dto.dart';
import 'package:openapi/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'person_response_dto.g.dart';

/// PersonResponseDto
///
/// Properties:
/// * [birthDate] - Person date of birth
/// * [color] - Person color (hex)
/// * [id] - Person ID
/// * [isFavorite] - Is favorite
/// * [isHidden] - Is hidden
/// * [name] - Person name
/// * [otherPeople] 
/// * [sharedBy] - Users that gave the current user access to this person
/// * [sharedWith] - Users the current user gave access to this person
/// * [thumbnailPath] - Thumbnail path
/// * [updatedAt] - Last update date
@BuiltValue()
abstract class PersonResponseDto implements Built<PersonResponseDto, PersonResponseDtoBuilder> {
  /// Person date of birth
  @BuiltValueField(wireName: r'birthDate')
  Date? get birthDate;

  /// Person color (hex)
  @BuiltValueField(wireName: r'color')
  String? get color;

  /// Person ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Is favorite
  @BuiltValueField(wireName: r'isFavorite')
  bool? get isFavorite;

  /// Is hidden
  @BuiltValueField(wireName: r'isHidden')
  bool get isHidden;

  /// Person name
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'otherPeople')
  BuiltList<PersonOtherResponseDto> get otherPeople;

  /// Users that gave the current user access to this person
  @BuiltValueField(wireName: r'sharedBy')
  BuiltList<PeopleUserResponseDto> get sharedBy;

  /// Users the current user gave access to this person
  @BuiltValueField(wireName: r'sharedWith')
  BuiltList<PeopleUserResponseDto> get sharedWith;

  /// Thumbnail path
  @BuiltValueField(wireName: r'thumbnailPath')
  String get thumbnailPath;

  /// Last update date
  @BuiltValueField(wireName: r'updatedAt')
  DateTime? get updatedAt;

  PersonResponseDto._();

  factory PersonResponseDto([void updates(PersonResponseDtoBuilder b)]) = _$PersonResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PersonResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PersonResponseDto> get serializer => _$PersonResponseDtoSerializer();
}

class _$PersonResponseDtoSerializer implements PrimitiveSerializer<PersonResponseDto> {
  @override
  final Iterable<Type> types = const [PersonResponseDto, _$PersonResponseDto];

  @override
  final String wireName = r'PersonResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PersonResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'birthDate';
    yield object.birthDate == null ? null : serializers.serialize(
      object.birthDate,
      specifiedType: const FullType.nullable(Date),
    );
    if (object.color != null) {
      yield r'color';
      yield serializers.serialize(
        object.color,
        specifiedType: const FullType(String),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    if (object.isFavorite != null) {
      yield r'isFavorite';
      yield serializers.serialize(
        object.isFavorite,
        specifiedType: const FullType(bool),
      );
    }
    yield r'isHidden';
    yield serializers.serialize(
      object.isHidden,
      specifiedType: const FullType(bool),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'otherPeople';
    yield serializers.serialize(
      object.otherPeople,
      specifiedType: const FullType(BuiltList, [FullType(PersonOtherResponseDto)]),
    );
    yield r'sharedBy';
    yield serializers.serialize(
      object.sharedBy,
      specifiedType: const FullType(BuiltList, [FullType(PeopleUserResponseDto)]),
    );
    yield r'sharedWith';
    yield serializers.serialize(
      object.sharedWith,
      specifiedType: const FullType(BuiltList, [FullType(PeopleUserResponseDto)]),
    );
    yield r'thumbnailPath';
    yield serializers.serialize(
      object.thumbnailPath,
      specifiedType: const FullType(String),
    );
    if (object.updatedAt != null) {
      yield r'updatedAt';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PersonResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PersonResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'birthDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.birthDate = valueDes;
          break;
        case r'color':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.color = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'isFavorite':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isFavorite = valueDes;
          break;
        case r'isHidden':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isHidden = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'otherPeople':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PersonOtherResponseDto)]),
          ) as BuiltList<PersonOtherResponseDto>;
          result.otherPeople.replace(valueDes);
          break;
        case r'sharedBy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PeopleUserResponseDto)]),
          ) as BuiltList<PeopleUserResponseDto>;
          result.sharedBy.replace(valueDes);
          break;
        case r'sharedWith':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PeopleUserResponseDto)]),
          ) as BuiltList<PeopleUserResponseDto>;
          result.sharedWith.replace(valueDes);
          break;
        case r'thumbnailPath':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.thumbnailPath = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
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
  PersonResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PersonResponseDtoBuilder();
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


