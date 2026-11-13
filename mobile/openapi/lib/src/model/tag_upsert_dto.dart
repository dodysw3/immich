//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tag_upsert_dto.g.dart';

/// TagUpsertDto
///
/// Properties:
/// * [tags] - Tag names to upsert
@BuiltValue()
abstract class TagUpsertDto implements Built<TagUpsertDto, TagUpsertDtoBuilder> {
  /// Tag names to upsert
  @BuiltValueField(wireName: r'tags')
  BuiltList<String> get tags;

  TagUpsertDto._();

  factory TagUpsertDto([void updates(TagUpsertDtoBuilder b)]) = _$TagUpsertDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TagUpsertDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TagUpsertDto> get serializer => _$TagUpsertDtoSerializer();
}

class _$TagUpsertDtoSerializer implements PrimitiveSerializer<TagUpsertDto> {
  @override
  final Iterable<Type> types = const [TagUpsertDto, _$TagUpsertDto];

  @override
  final String wireName = r'TagUpsertDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TagUpsertDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tags';
    yield serializers.serialize(
      object.tags,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TagUpsertDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TagUpsertDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tags':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.tags.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TagUpsertDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TagUpsertDtoBuilder();
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


