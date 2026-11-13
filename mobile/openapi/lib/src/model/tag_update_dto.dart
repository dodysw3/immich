//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tag_update_dto.g.dart';

/// TagUpdateDto
///
/// Properties:
/// * [color] - Tag color (hex)
/// * [name] - Tag name
@BuiltValue()
abstract class TagUpdateDto implements Built<TagUpdateDto, TagUpdateDtoBuilder> {
  /// Tag color (hex)
  @BuiltValueField(wireName: r'color')
  String? get color;

  /// Tag name
  @BuiltValueField(wireName: r'name')
  String? get name;

  TagUpdateDto._();

  factory TagUpdateDto([void updates(TagUpdateDtoBuilder b)]) = _$TagUpdateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TagUpdateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TagUpdateDto> get serializer => _$TagUpdateDtoSerializer();
}

class _$TagUpdateDtoSerializer implements PrimitiveSerializer<TagUpdateDto> {
  @override
  final Iterable<Type> types = const [TagUpdateDto, _$TagUpdateDto];

  @override
  final String wireName = r'TagUpdateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TagUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.color != null) {
      yield r'color';
      yield serializers.serialize(
        object.color,
        specifiedType: const FullType.nullable(String),
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
    TagUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TagUpdateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'color':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.color = valueDes;
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
  TagUpdateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TagUpdateDtoBuilder();
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


