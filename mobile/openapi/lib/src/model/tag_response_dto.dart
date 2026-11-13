//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tag_response_dto.g.dart';

/// TagResponseDto
///
/// Properties:
/// * [color] - Tag color (hex)
/// * [createdAt] - Creation date
/// * [id] - Tag ID
/// * [name] - Tag name
/// * [parentId] - Parent tag ID
/// * [updatedAt] - Last update date
/// * [value] - Tag value (full path)
@BuiltValue()
abstract class TagResponseDto implements Built<TagResponseDto, TagResponseDtoBuilder> {
  /// Tag color (hex)
  @BuiltValueField(wireName: r'color')
  String? get color;

  /// Creation date
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// Tag ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Tag name
  @BuiltValueField(wireName: r'name')
  String get name;

  /// Parent tag ID
  @BuiltValueField(wireName: r'parentId')
  String? get parentId;

  /// Last update date
  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  /// Tag value (full path)
  @BuiltValueField(wireName: r'value')
  String get value;

  TagResponseDto._();

  factory TagResponseDto([void updates(TagResponseDtoBuilder b)]) = _$TagResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TagResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TagResponseDto> get serializer => _$TagResponseDtoSerializer();
}

class _$TagResponseDtoSerializer implements PrimitiveSerializer<TagResponseDto> {
  @override
  final Iterable<Type> types = const [TagResponseDto, _$TagResponseDto];

  @override
  final String wireName = r'TagResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TagResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.color != null) {
      yield r'color';
      yield serializers.serialize(
        object.color,
        specifiedType: const FullType(String),
      );
    }
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
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
    if (object.parentId != null) {
      yield r'parentId';
      yield serializers.serialize(
        object.parentId,
        specifiedType: const FullType(String),
      );
    }
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TagResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TagResponseDtoBuilder result,
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
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
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
        case r'parentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.parentId = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.value = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TagResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TagResponseDtoBuilder();
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


