//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_asset_metadata_v1.g.dart';

/// SyncAssetMetadataV1
///
/// Properties:
/// * [assetId] - Asset ID
/// * [key] - Key
/// * [value] - Value
@BuiltValue()
abstract class SyncAssetMetadataV1 implements Built<SyncAssetMetadataV1, SyncAssetMetadataV1Builder> {
  /// Asset ID
  @BuiltValueField(wireName: r'assetId')
  String get assetId;

  /// Key
  @BuiltValueField(wireName: r'key')
  String get key;

  /// Value
  @BuiltValueField(wireName: r'value')
  BuiltMap<String, JsonObject?> get value;

  SyncAssetMetadataV1._();

  factory SyncAssetMetadataV1([void updates(SyncAssetMetadataV1Builder b)]) = _$SyncAssetMetadataV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncAssetMetadataV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncAssetMetadataV1> get serializer => _$SyncAssetMetadataV1Serializer();
}

class _$SyncAssetMetadataV1Serializer implements PrimitiveSerializer<SyncAssetMetadataV1> {
  @override
  final Iterable<Type> types = const [SyncAssetMetadataV1, _$SyncAssetMetadataV1];

  @override
  final String wireName = r'SyncAssetMetadataV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncAssetMetadataV1 object, {
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
    SyncAssetMetadataV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncAssetMetadataV1Builder result,
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
  SyncAssetMetadataV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncAssetMetadataV1Builder();
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


