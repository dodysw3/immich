//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_asset_delete_v1.g.dart';

/// SyncAssetDeleteV1
///
/// Properties:
/// * [assetId] - Asset ID
@BuiltValue()
abstract class SyncAssetDeleteV1 implements Built<SyncAssetDeleteV1, SyncAssetDeleteV1Builder> {
  /// Asset ID
  @BuiltValueField(wireName: r'assetId')
  String get assetId;

  SyncAssetDeleteV1._();

  factory SyncAssetDeleteV1([void updates(SyncAssetDeleteV1Builder b)]) = _$SyncAssetDeleteV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncAssetDeleteV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncAssetDeleteV1> get serializer => _$SyncAssetDeleteV1Serializer();
}

class _$SyncAssetDeleteV1Serializer implements PrimitiveSerializer<SyncAssetDeleteV1> {
  @override
  final Iterable<Type> types = const [SyncAssetDeleteV1, _$SyncAssetDeleteV1];

  @override
  final String wireName = r'SyncAssetDeleteV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncAssetDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assetId';
    yield serializers.serialize(
      object.assetId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncAssetDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncAssetDeleteV1Builder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncAssetDeleteV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncAssetDeleteV1Builder();
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


