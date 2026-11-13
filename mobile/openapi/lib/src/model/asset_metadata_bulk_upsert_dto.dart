//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/asset_metadata_bulk_upsert_item_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_metadata_bulk_upsert_dto.g.dart';

/// AssetMetadataBulkUpsertDto
///
/// Properties:
/// * [items] - Metadata items to upsert
@BuiltValue()
abstract class AssetMetadataBulkUpsertDto implements Built<AssetMetadataBulkUpsertDto, AssetMetadataBulkUpsertDtoBuilder> {
  /// Metadata items to upsert
  @BuiltValueField(wireName: r'items')
  BuiltList<AssetMetadataBulkUpsertItemDto> get items;

  AssetMetadataBulkUpsertDto._();

  factory AssetMetadataBulkUpsertDto([void updates(AssetMetadataBulkUpsertDtoBuilder b)]) = _$AssetMetadataBulkUpsertDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetMetadataBulkUpsertDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetMetadataBulkUpsertDto> get serializer => _$AssetMetadataBulkUpsertDtoSerializer();
}

class _$AssetMetadataBulkUpsertDtoSerializer implements PrimitiveSerializer<AssetMetadataBulkUpsertDto> {
  @override
  final Iterable<Type> types = const [AssetMetadataBulkUpsertDto, _$AssetMetadataBulkUpsertDto];

  @override
  final String wireName = r'AssetMetadataBulkUpsertDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetMetadataBulkUpsertDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AssetMetadataBulkUpsertItemDto)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AssetMetadataBulkUpsertDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssetMetadataBulkUpsertDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AssetMetadataBulkUpsertItemDto)]),
          ) as BuiltList<AssetMetadataBulkUpsertItemDto>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AssetMetadataBulkUpsertDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetMetadataBulkUpsertDtoBuilder();
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


