//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'people_delete_dto.g.dart';

/// PeopleDeleteDto
///
/// Properties:
/// * [ids] - IDs to process
/// * [userId] 
@BuiltValue()
abstract class PeopleDeleteDto implements Built<PeopleDeleteDto, PeopleDeleteDtoBuilder> {
  /// IDs to process
  @BuiltValueField(wireName: r'ids')
  BuiltList<String> get ids;

  @BuiltValueField(wireName: r'userId')
  String? get userId;

  PeopleDeleteDto._();

  factory PeopleDeleteDto([void updates(PeopleDeleteDtoBuilder b)]) = _$PeopleDeleteDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PeopleDeleteDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PeopleDeleteDto> get serializer => _$PeopleDeleteDtoSerializer();
}

class _$PeopleDeleteDtoSerializer implements PrimitiveSerializer<PeopleDeleteDto> {
  @override
  final Iterable<Type> types = const [PeopleDeleteDto, _$PeopleDeleteDto];

  @override
  final String wireName = r'PeopleDeleteDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PeopleDeleteDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ids';
    yield serializers.serialize(
      object.ids,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
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
    PeopleDeleteDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PeopleDeleteDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.ids.replace(valueDes);
          break;
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
  PeopleDeleteDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PeopleDeleteDtoBuilder();
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


