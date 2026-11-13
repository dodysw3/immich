//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_metadata_bulk_delete_item_dto.g.dart';

/// AssetMetadataBulkDeleteItemDto
///
/// Properties:
/// * [assetId] - Asset ID
/// * [key] - Metadata key
@BuiltValue()
abstract class AssetMetadataBulkDeleteItemDto implements Built<AssetMetadataBulkDeleteItemDto, AssetMetadataBulkDeleteItemDtoBuilder> {
  /// Asset ID
  @BuiltValueField(wireName: r'assetId')
  String get assetId;

  /// Metadata key
  @BuiltValueField(wireName: r'key')
  String get key;

  AssetMetadataBulkDeleteItemDto._();

  factory AssetMetadataBulkDeleteItemDto([void updates(AssetMetadataBulkDeleteItemDtoBuilder b)]) = _$AssetMetadataBulkDeleteItemDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetMetadataBulkDeleteItemDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetMetadataBulkDeleteItemDto> get serializer => _$AssetMetadataBulkDeleteItemDtoSerializer();
}

class _$AssetMetadataBulkDeleteItemDtoSerializer implements PrimitiveSerializer<AssetMetadataBulkDeleteItemDto> {
  @override
  final Iterable<Type> types = const [AssetMetadataBulkDeleteItemDto, _$AssetMetadataBulkDeleteItemDto];

  @override
  final String wireName = r'AssetMetadataBulkDeleteItemDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetMetadataBulkDeleteItemDto object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AssetMetadataBulkDeleteItemDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssetMetadataBulkDeleteItemDtoBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AssetMetadataBulkDeleteItemDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetMetadataBulkDeleteItemDtoBuilder();
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


