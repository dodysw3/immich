//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_metadata_bulk_response_dto.g.dart';

/// AssetMetadataBulkResponseDto
///
/// Properties:
/// * [assetId] - Asset ID
/// * [key] - Metadata key
/// * [updatedAt] - Last update date
/// * [value] - Metadata value (object)
@BuiltValue()
abstract class AssetMetadataBulkResponseDto implements Built<AssetMetadataBulkResponseDto, AssetMetadataBulkResponseDtoBuilder> {
  /// Asset ID
  @BuiltValueField(wireName: r'assetId')
  String get assetId;

  /// Metadata key
  @BuiltValueField(wireName: r'key')
  String get key;

  /// Last update date
  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  /// Metadata value (object)
  @BuiltValueField(wireName: r'value')
  BuiltMap<String, JsonObject?> get value;

  AssetMetadataBulkResponseDto._();

  factory AssetMetadataBulkResponseDto([void updates(AssetMetadataBulkResponseDtoBuilder b)]) = _$AssetMetadataBulkResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetMetadataBulkResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetMetadataBulkResponseDto> get serializer => _$AssetMetadataBulkResponseDtoSerializer();
}

class _$AssetMetadataBulkResponseDtoSerializer implements PrimitiveSerializer<AssetMetadataBulkResponseDto> {
  @override
  final Iterable<Type> types = const [AssetMetadataBulkResponseDto, _$AssetMetadataBulkResponseDto];

  @override
  final String wireName = r'AssetMetadataBulkResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetMetadataBulkResponseDto object, {
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
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
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
    AssetMetadataBulkResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssetMetadataBulkResponseDtoBuilder result,
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
  AssetMetadataBulkResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetMetadataBulkResponseDtoBuilder();
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


