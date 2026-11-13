//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_asset_metadata_delete_v1.g.dart';

/// SyncAssetMetadataDeleteV1
///
/// Properties:
/// * [assetId] - Asset ID
/// * [key] - Key
@BuiltValue()
abstract class SyncAssetMetadataDeleteV1 implements Built<SyncAssetMetadataDeleteV1, SyncAssetMetadataDeleteV1Builder> {
  /// Asset ID
  @BuiltValueField(wireName: r'assetId')
  String get assetId;

  /// Key
  @BuiltValueField(wireName: r'key')
  String get key;

  SyncAssetMetadataDeleteV1._();

  factory SyncAssetMetadataDeleteV1([void updates(SyncAssetMetadataDeleteV1Builder b)]) = _$SyncAssetMetadataDeleteV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncAssetMetadataDeleteV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncAssetMetadataDeleteV1> get serializer => _$SyncAssetMetadataDeleteV1Serializer();
}

class _$SyncAssetMetadataDeleteV1Serializer implements PrimitiveSerializer<SyncAssetMetadataDeleteV1> {
  @override
  final Iterable<Type> types = const [SyncAssetMetadataDeleteV1, _$SyncAssetMetadataDeleteV1];

  @override
  final String wireName = r'SyncAssetMetadataDeleteV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncAssetMetadataDeleteV1 object, {
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
    SyncAssetMetadataDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncAssetMetadataDeleteV1Builder result,
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
  SyncAssetMetadataDeleteV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncAssetMetadataDeleteV1Builder();
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


