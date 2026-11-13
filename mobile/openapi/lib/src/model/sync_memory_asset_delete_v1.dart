//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_memory_asset_delete_v1.g.dart';

/// SyncMemoryAssetDeleteV1
///
/// Properties:
/// * [assetId] - Asset ID
/// * [memoryId] - Memory ID
@BuiltValue()
abstract class SyncMemoryAssetDeleteV1 implements Built<SyncMemoryAssetDeleteV1, SyncMemoryAssetDeleteV1Builder> {
  /// Asset ID
  @BuiltValueField(wireName: r'assetId')
  String get assetId;

  /// Memory ID
  @BuiltValueField(wireName: r'memoryId')
  String get memoryId;

  SyncMemoryAssetDeleteV1._();

  factory SyncMemoryAssetDeleteV1([void updates(SyncMemoryAssetDeleteV1Builder b)]) = _$SyncMemoryAssetDeleteV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncMemoryAssetDeleteV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncMemoryAssetDeleteV1> get serializer => _$SyncMemoryAssetDeleteV1Serializer();
}

class _$SyncMemoryAssetDeleteV1Serializer implements PrimitiveSerializer<SyncMemoryAssetDeleteV1> {
  @override
  final Iterable<Type> types = const [SyncMemoryAssetDeleteV1, _$SyncMemoryAssetDeleteV1];

  @override
  final String wireName = r'SyncMemoryAssetDeleteV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncMemoryAssetDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assetId';
    yield serializers.serialize(
      object.assetId,
      specifiedType: const FullType(String),
    );
    yield r'memoryId';
    yield serializers.serialize(
      object.memoryId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncMemoryAssetDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncMemoryAssetDeleteV1Builder result,
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
        case r'memoryId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.memoryId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncMemoryAssetDeleteV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncMemoryAssetDeleteV1Builder();
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


