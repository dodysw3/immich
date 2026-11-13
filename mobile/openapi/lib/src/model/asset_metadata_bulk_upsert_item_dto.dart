//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_metadata_bulk_upsert_item_dto.g.dart';

/// AssetMetadataBulkUpsertItemDto
///
/// Properties:
/// * [assetId] - Asset ID
/// * [key] - Metadata key
/// * [value] - Metadata value (object)
@BuiltValue()
abstract class AssetMetadataBulkUpsertItemDto implements Built<AssetMetadataBulkUpsertItemDto, AssetMetadataBulkUpsertItemDtoBuilder> {
  /// Asset ID
  @BuiltValueField(wireName: r'assetId')
  String get assetId;

  /// Metadata key
  @BuiltValueField(wireName: r'key')
  String get key;

  /// Metadata value (object)
  @BuiltValueField(wireName: r'value')
  BuiltMap<String, JsonObject?> get value;

  AssetMetadataBulkUpsertItemDto._();

  factory AssetMetadataBulkUpsertItemDto([void updates(AssetMetadataBulkUpsertItemDtoBuilder b)]) = _$AssetMetadataBulkUpsertItemDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetMetadataBulkUpsertItemDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetMetadataBulkUpsertItemDto> get serializer => _$AssetMetadataBulkUpsertItemDtoSerializer();
}

class _$AssetMetadataBulkUpsertItemDtoSerializer implements PrimitiveSerializer<AssetMetadataBulkUpsertItemDto> {
  @override
  final Iterable<Type> types = const [AssetMetadataBulkUpsertItemDto, _$AssetMetadataBulkUpsertItemDto];

  @override
  final String wireName = r'AssetMetadataBulkUpsertItemDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetMetadataBulkUpsertItemDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assetId';
    yield serializers.serialize(
      object.assetId,
      specifiedType: const FullType(String),
    );
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AssetMetadataBulkUpsertItemDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssetMetadataBulkUpsertItemDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assetId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.assetId = valueDes;
          break;
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.value.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AssetMetadataBulkUpsertItemDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetMetadataBulkUpsertItemDtoBuilder();
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


