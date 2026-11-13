//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tag_bulk_assets_dto.g.dart';

/// TagBulkAssetsDto
///
/// Properties:
/// * [assetIds] - Asset IDs
/// * [tagIds] - Tag IDs
@BuiltValue()
abstract class TagBulkAssetsDto implements Built<TagBulkAssetsDto, TagBulkAssetsDtoBuilder> {
  /// Asset IDs
  @BuiltValueField(wireName: r'assetIds')
  BuiltList<String> get assetIds;

  /// Tag IDs
  @BuiltValueField(wireName: r'tagIds')
  BuiltList<String> get tagIds;

  TagBulkAssetsDto._();

  factory TagBulkAssetsDto([void updates(TagBulkAssetsDtoBuilder b)]) = _$TagBulkAssetsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TagBulkAssetsDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TagBulkAssetsDto> get serializer => _$TagBulkAssetsDtoSerializer();
}

class _$TagBulkAssetsDtoSerializer implements PrimitiveSerializer<TagBulkAssetsDto> {
  @override
  final Iterable<Type> types = const [TagBulkAssetsDto, _$TagBulkAssetsDto];

  @override
  final String wireName = r'TagBulkAssetsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TagBulkAssetsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assetIds';
    yield serializers.serialize(
      object.assetIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'tagIds';
    yield serializers.serialize(
      object.tagIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TagBulkAssetsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TagBulkAssetsDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assetIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.assetIds.replace(valueDes);
          break;
        case r'tagIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.tagIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TagBulkAssetsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TagBulkAssetsDtoBuilder();
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


