//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tag_bulk_assets_response_dto.g.dart';

/// TagBulkAssetsResponseDto
///
/// Properties:
/// * [count] - Number of assets tagged
@BuiltValue()
abstract class TagBulkAssetsResponseDto implements Built<TagBulkAssetsResponseDto, TagBulkAssetsResponseDtoBuilder> {
  /// Number of assets tagged
  @BuiltValueField(wireName: r'count')
  int get count;

  TagBulkAssetsResponseDto._();

  factory TagBulkAssetsResponseDto([void updates(TagBulkAssetsResponseDtoBuilder b)]) = _$TagBulkAssetsResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TagBulkAssetsResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TagBulkAssetsResponseDto> get serializer => _$TagBulkAssetsResponseDtoSerializer();
}

class _$TagBulkAssetsResponseDtoSerializer implements PrimitiveSerializer<TagBulkAssetsResponseDto> {
  @override
  final Iterable<Type> types = const [TagBulkAssetsResponseDto, _$TagBulkAssetsResponseDto];

  @override
  final String wireName = r'TagBulkAssetsResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TagBulkAssetsResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TagBulkAssetsResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TagBulkAssetsResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TagBulkAssetsResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TagBulkAssetsResponseDtoBuilder();
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


