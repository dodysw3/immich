//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_asset_face_v1.g.dart';

/// SyncAssetFaceV1
///
/// Properties:
/// * [assetId] - Asset ID
/// * [boundingBoxX1] - Bounding box X1
/// * [boundingBoxX2] - Bounding box X2
/// * [boundingBoxY1] - Bounding box Y1
/// * [boundingBoxY2] - Bounding box Y2
/// * [id] - Asset face ID
/// * [imageHeight] - Image height
/// * [imageWidth] - Image width
/// * [personId] - Person ID
/// * [sourceType] - Source type
@BuiltValue()
abstract class SyncAssetFaceV1 implements Built<SyncAssetFaceV1, SyncAssetFaceV1Builder> {
  /// Asset ID
  @BuiltValueField(wireName: r'assetId')
  String get assetId;

  /// Bounding box X1
  @BuiltValueField(wireName: r'boundingBoxX1')
  int get boundingBoxX1;

  /// Bounding box X2
  @BuiltValueField(wireName: r'boundingBoxX2')
  int get boundingBoxX2;

  /// Bounding box Y1
  @BuiltValueField(wireName: r'boundingBoxY1')
  int get boundingBoxY1;

  /// Bounding box Y2
  @BuiltValueField(wireName: r'boundingBoxY2')
  int get boundingBoxY2;

  /// Asset face ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Image height
  @BuiltValueField(wireName: r'imageHeight')
  int get imageHeight;

  /// Image width
  @BuiltValueField(wireName: r'imageWidth')
  int get imageWidth;

  /// Person ID
  @BuiltValueField(wireName: r'personId')
  String? get personId;

  /// Source type
  @BuiltValueField(wireName: r'sourceType')
  String get sourceType;

  SyncAssetFaceV1._();

  factory SyncAssetFaceV1([void updates(SyncAssetFaceV1Builder b)]) = _$SyncAssetFaceV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncAssetFaceV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncAssetFaceV1> get serializer => _$SyncAssetFaceV1Serializer();
}

class _$SyncAssetFaceV1Serializer implements PrimitiveSerializer<SyncAssetFaceV1> {
  @override
  final Iterable<Type> types = const [SyncAssetFaceV1, _$SyncAssetFaceV1];

  @override
  final String wireName = r'SyncAssetFaceV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncAssetFaceV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assetId';
    yield serializers.serialize(
      object.assetId,
      specifiedType: const FullType(String),
    );
    yield r'boundingBoxX1';
    yield serializers.serialize(
      object.boundingBoxX1,
      specifiedType: const FullType(int),
    );
    yield r'boundingBoxX2';
    yield serializers.serialize(
      object.boundingBoxX2,
      specifiedType: const FullType(int),
    );
    yield r'boundingBoxY1';
    yield serializers.serialize(
      object.boundingBoxY1,
      specifiedType: const FullType(int),
    );
    yield r'boundingBoxY2';
    yield serializers.serialize(
      object.boundingBoxY2,
      specifiedType: const FullType(int),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'imageHeight';
    yield serializers.serialize(
      object.imageHeight,
      specifiedType: const FullType(int),
    );
    yield r'imageWidth';
    yield serializers.serialize(
      object.imageWidth,
      specifiedType: const FullType(int),
    );
    yield r'personId';
    yield object.personId == null ? null : serializers.serialize(
      object.personId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'sourceType';
    yield serializers.serialize(
      object.sourceType,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncAssetFaceV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncAssetFaceV1Builder result,
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
        case r'boundingBoxX1':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.boundingBoxX1 = valueDes;
          break;
        case r'boundingBoxX2':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.boundingBoxX2 = valueDes;
          break;
        case r'boundingBoxY1':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.boundingBoxY1 = valueDes;
          break;
        case r'boundingBoxY2':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.boundingBoxY2 = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'imageHeight':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.imageHeight = valueDes;
          break;
        case r'imageWidth':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.imageWidth = valueDes;
          break;
        case r'personId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.personId = valueDes;
          break;
        case r'sourceType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sourceType = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncAssetFaceV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncAssetFaceV1Builder();
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


