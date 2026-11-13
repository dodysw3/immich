//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_asset_face_delete_v1.g.dart';

/// SyncAssetFaceDeleteV1
///
/// Properties:
/// * [assetFaceId] - Asset face ID
@BuiltValue()
abstract class SyncAssetFaceDeleteV1 implements Built<SyncAssetFaceDeleteV1, SyncAssetFaceDeleteV1Builder> {
  /// Asset face ID
  @BuiltValueField(wireName: r'assetFaceId')
  String get assetFaceId;

  SyncAssetFaceDeleteV1._();

  factory SyncAssetFaceDeleteV1([void updates(SyncAssetFaceDeleteV1Builder b)]) = _$SyncAssetFaceDeleteV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncAssetFaceDeleteV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncAssetFaceDeleteV1> get serializer => _$SyncAssetFaceDeleteV1Serializer();
}

class _$SyncAssetFaceDeleteV1Serializer implements PrimitiveSerializer<SyncAssetFaceDeleteV1> {
  @override
  final Iterable<Type> types = const [SyncAssetFaceDeleteV1, _$SyncAssetFaceDeleteV1];

  @override
  final String wireName = r'SyncAssetFaceDeleteV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncAssetFaceDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assetFaceId';
    yield serializers.serialize(
      object.assetFaceId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncAssetFaceDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncAssetFaceDeleteV1Builder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assetFaceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.assetFaceId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncAssetFaceDeleteV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncAssetFaceDeleteV1Builder();
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


