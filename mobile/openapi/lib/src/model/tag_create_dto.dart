//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tag_create_dto.g.dart';

/// TagCreateDto
///
/// Properties:
/// * [color] - Tag color (hex)
/// * [name] - Tag name
/// * [parentId] - Parent tag ID
@BuiltValue()
abstract class TagCreateDto implements Built<TagCreateDto, TagCreateDtoBuilder> {
  /// Tag color (hex)
  @BuiltValueField(wireName: r'color')
  String? get color;

  /// Tag name
  @BuiltValueField(wireName: r'name')
  String get name;

  /// Parent tag ID
  @BuiltValueField(wireName: r'parentId')
  String? get parentId;

  TagCreateDto._();

  factory TagCreateDto([void updates(TagCreateDtoBuilder b)]) = _$TagCreateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TagCreateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TagCreateDto> get serializer => _$TagCreateDtoSerializer();
}

class _$TagCreateDtoSerializer implements PrimitiveSerializer<TagCreateDto> {
  @override
  final Iterable<Type> types = const [TagCreateDto, _$TagCreateDto];

  @override
  final String wireName = r'TagCreateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TagCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.color != null) {
      yield r'color';
      yield serializers.serialize(
        object.color,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.parentId != null) {
      yield r'parentId';
      yield serializers.serialize(
        object.parentId,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    TagCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TagCreateDtoBuilder result,
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
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'parentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.parentId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TagCreateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TagCreateDtoBuilder();
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


