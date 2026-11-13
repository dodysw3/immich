//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_asset_ocr_v1.g.dart';

/// SyncAssetOcrV1
///
/// Properties:
/// * [assetId] - Asset ID
/// * [boxScore] - Confidence score of the bounding box
/// * [id] - OCR entry ID
/// * [isVisible] - Whether the OCR entry is visible
/// * [text] - Recognized text content
/// * [textScore] - Confidence score of the recognized text
/// * [x1] - Top-left X coordinate (normalized 0–1)
/// * [x2] - Top-right X coordinate (normalized 0–1)
/// * [x3] - Bottom-right X coordinate (normalized 0–1)
/// * [x4] - Bottom-left X coordinate (normalized 0–1)
/// * [y1] - Top-left Y coordinate (normalized 0–1)
/// * [y2] - Top-right Y coordinate (normalized 0–1)
/// * [y3] - Bottom-right Y coordinate (normalized 0–1)
/// * [y4] - Bottom-left Y coordinate (normalized 0–1)
@BuiltValue()
abstract class SyncAssetOcrV1 implements Built<SyncAssetOcrV1, SyncAssetOcrV1Builder> {
  /// Asset ID
  @BuiltValueField(wireName: r'assetId')
  String get assetId;

  /// Confidence score of the bounding box
  @BuiltValueField(wireName: r'boxScore')
  double get boxScore;

  /// OCR entry ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Whether the OCR entry is visible
  @BuiltValueField(wireName: r'isVisible')
  bool get isVisible;

  /// Recognized text content
  @BuiltValueField(wireName: r'text')
  String get text;

  /// Confidence score of the recognized text
  @BuiltValueField(wireName: r'textScore')
  double get textScore;

  /// Top-left X coordinate (normalized 0–1)
  @BuiltValueField(wireName: r'x1')
  double get x1;

  /// Top-right X coordinate (normalized 0–1)
  @BuiltValueField(wireName: r'x2')
  double get x2;

  /// Bottom-right X coordinate (normalized 0–1)
  @BuiltValueField(wireName: r'x3')
  double get x3;

  /// Bottom-left X coordinate (normalized 0–1)
  @BuiltValueField(wireName: r'x4')
  double get x4;

  /// Top-left Y coordinate (normalized 0–1)
  @BuiltValueField(wireName: r'y1')
  double get y1;

  /// Top-right Y coordinate (normalized 0–1)
  @BuiltValueField(wireName: r'y2')
  double get y2;

  /// Bottom-right Y coordinate (normalized 0–1)
  @BuiltValueField(wireName: r'y3')
  double get y3;

  /// Bottom-left Y coordinate (normalized 0–1)
  @BuiltValueField(wireName: r'y4')
  double get y4;

  SyncAssetOcrV1._();

  factory SyncAssetOcrV1([void updates(SyncAssetOcrV1Builder b)]) = _$SyncAssetOcrV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncAssetOcrV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncAssetOcrV1> get serializer => _$SyncAssetOcrV1Serializer();
}

class _$SyncAssetOcrV1Serializer implements PrimitiveSerializer<SyncAssetOcrV1> {
  @override
  final Iterable<Type> types = const [SyncAssetOcrV1, _$SyncAssetOcrV1];

  @override
  final String wireName = r'SyncAssetOcrV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncAssetOcrV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assetId';
    yield serializers.serialize(
      object.assetId,
      specifiedType: const FullType(String),
    );
    yield r'boxScore';
    yield serializers.serialize(
      object.boxScore,
      specifiedType: const FullType(double),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'isVisible';
    yield serializers.serialize(
      object.isVisible,
      specifiedType: const FullType(bool),
    );
    yield r'text';
    yield serializers.serialize(
      object.text,
      specifiedType: const FullType(String),
    );
    yield r'textScore';
    yield serializers.serialize(
      object.textScore,
      specifiedType: const FullType(double),
    );
    yield r'x1';
    yield serializers.serialize(
      object.x1,
      specifiedType: const FullType(double),
    );
    yield r'x2';
    yield serializers.serialize(
      object.x2,
      specifiedType: const FullType(double),
    );
    yield r'x3';
    yield serializers.serialize(
      object.x3,
      specifiedType: const FullType(double),
    );
    yield r'x4';
    yield serializers.serialize(
      object.x4,
      specifiedType: const FullType(double),
    );
    yield r'y1';
    yield serializers.serialize(
      object.y1,
      specifiedType: const FullType(double),
    );
    yield r'y2';
    yield serializers.serialize(
      object.y2,
      specifiedType: const FullType(double),
    );
    yield r'y3';
    yield serializers.serialize(
      object.y3,
      specifiedType: const FullType(double),
    );
    yield r'y4';
    yield serializers.serialize(
      object.y4,
      specifiedType: const FullType(double),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncAssetOcrV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncAssetOcrV1Builder result,
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
        case r'boxScore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.boxScore = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'isVisible':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isVisible = valueDes;
          break;
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.text = valueDes;
          break;
        case r'textScore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.textScore = valueDes;
          break;
        case r'x1':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.x1 = valueDes;
          break;
        case r'x2':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.x2 = valueDes;
          break;
        case r'x3':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.x3 = valueDes;
          break;
        case r'x4':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.x4 = valueDes;
          break;
        case r'y1':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.y1 = valueDes;
          break;
        case r'y2':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.y2 = valueDes;
          break;
        case r'y3':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.y3 = valueDes;
          break;
        case r'y4':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.y4 = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncAssetOcrV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncAssetOcrV1Builder();
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


