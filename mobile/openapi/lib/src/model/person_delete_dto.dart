//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'person_delete_dto.g.dart';

/// PersonDeleteDto
///
/// Properties:
/// * [userId] 
@BuiltValue()
abstract class PersonDeleteDto implements Built<PersonDeleteDto, PersonDeleteDtoBuilder> {
  @BuiltValueField(wireName: r'userId')
  String? get userId;

  PersonDeleteDto._();

  factory PersonDeleteDto([void updates(PersonDeleteDtoBuilder b)]) = _$PersonDeleteDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PersonDeleteDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PersonDeleteDto> get serializer => _$PersonDeleteDtoSerializer();
}

class _$PersonDeleteDtoSerializer implements PrimitiveSerializer<PersonDeleteDto> {
  @override
  final Iterable<Type> types = const [PersonDeleteDto, _$PersonDeleteDto];

  @override
  final String wireName = r'PersonDeleteDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PersonDeleteDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.userId != null) {
      yield r'userId';
      yield serializers.serialize(
        object.userId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PersonDeleteDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PersonDeleteDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'userId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.userId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PersonDeleteDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PersonDeleteDtoBuilder();
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


