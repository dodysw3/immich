//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_asset_ocr_delete_v1.g.dart';

/// SyncAssetOcrDeleteV1
///
/// Properties:
/// * [assetId] - Original asset ID of the deleted OCR entry
/// * [deletedAt] - Timestamp when the OCR entry was deleted
/// * [id] - Audit row ID of the deleted OCR entry
@BuiltValue()
abstract class SyncAssetOcrDeleteV1 implements Built<SyncAssetOcrDeleteV1, SyncAssetOcrDeleteV1Builder> {
  /// Original asset ID of the deleted OCR entry
  @BuiltValueField(wireName: r'assetId')
  String get assetId;

  /// Timestamp when the OCR entry was deleted
  @BuiltValueField(wireName: r'deletedAt')
  DateTime get deletedAt;

  /// Audit row ID of the deleted OCR entry
  @BuiltValueField(wireName: r'id')
  String get id;

  SyncAssetOcrDeleteV1._();

  factory SyncAssetOcrDeleteV1([void updates(SyncAssetOcrDeleteV1Builder b)]) = _$SyncAssetOcrDeleteV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncAssetOcrDeleteV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncAssetOcrDeleteV1> get serializer => _$SyncAssetOcrDeleteV1Serializer();
}

class _$SyncAssetOcrDeleteV1Serializer implements PrimitiveSerializer<SyncAssetOcrDeleteV1> {
  @override
  final Iterable<Type> types = const [SyncAssetOcrDeleteV1, _$SyncAssetOcrDeleteV1];

  @override
  final String wireName = r'SyncAssetOcrDeleteV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncAssetOcrDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assetId';
    yield serializers.serialize(
      object.assetId,
      specifiedType: const FullType(String),
    );
    yield r'deletedAt';
    yield serializers.serialize(
      object.deletedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncAssetOcrDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncAssetOcrDeleteV1Builder result,
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
        case r'deletedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.deletedAt = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncAssetOcrDeleteV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncAssetOcrDeleteV1Builder();
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


