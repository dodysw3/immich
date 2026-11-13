//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/asset_metadata_upsert_item_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_metadata_upsert_dto.g.dart';

/// AssetMetadataUpsertDto
///
/// Properties:
/// * [items] - Metadata items to upsert
@BuiltValue()
abstract class AssetMetadataUpsertDto implements Built<AssetMetadataUpsertDto, AssetMetadataUpsertDtoBuilder> {
  /// Metadata items to upsert
  @BuiltValueField(wireName: r'items')
  BuiltList<AssetMetadataUpsertItemDto> get items;

  AssetMetadataUpsertDto._();

  factory AssetMetadataUpsertDto([void updates(AssetMetadataUpsertDtoBuilder b)]) = _$AssetMetadataUpsertDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetMetadataUpsertDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetMetadataUpsertDto> get serializer => _$AssetMetadataUpsertDtoSerializer();
}

class _$AssetMetadataUpsertDtoSerializer implements PrimitiveSerializer<AssetMetadataUpsertDto> {
  @override
  final Iterable<Type> types = const [AssetMetadataUpsertDto, _$AssetMetadataUpsertDto];

  @override
  final String wireName = r'AssetMetadataUpsertDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetMetadataUpsertDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AssetMetadataUpsertItemDto)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AssetMetadataUpsertDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssetMetadataUpsertDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AssetMetadataUpsertItemDto)]),
          ) as BuiltList<AssetMetadataUpsertItemDto>;
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
  AssetMetadataUpsertDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetMetadataUpsertDtoBuilder();
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


