//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_ocr_response_dto.g.dart';

/// AssetOcrResponseDto
///
/// Properties:
/// * [assetId] 
/// * [boxScore] - Confidence score for text detection box
/// * [id] 
/// * [text] - Recognized text
/// * [textScore] - Confidence score for text recognition
/// * [x1] - Normalized x coordinate of box corner 1 (0-1)
/// * [x2] - Normalized x coordinate of box corner 2 (0-1)
/// * [x3] - Normalized x coordinate of box corner 3 (0-1)
/// * [x4] - Normalized x coordinate of box corner 4 (0-1)
/// * [y1] - Normalized y coordinate of box corner 1 (0-1)
/// * [y2] - Normalized y coordinate of box corner 2 (0-1)
/// * [y3] - Normalized y coordinate of box corner 3 (0-1)
/// * [y4] - Normalized y coordinate of box corner 4 (0-1)
@BuiltValue()
abstract class AssetOcrResponseDto implements Built<AssetOcrResponseDto, AssetOcrResponseDtoBuilder> {
  @BuiltValueField(wireName: r'assetId')
  String get assetId;

  /// Confidence score for text detection box
  @BuiltValueField(wireName: r'boxScore')
  double get boxScore;

  @BuiltValueField(wireName: r'id')
  String get id;

  /// Recognized text
  @BuiltValueField(wireName: r'text')
  String get text;

  /// Confidence score for text recognition
  @BuiltValueField(wireName: r'textScore')
  double get textScore;

  /// Normalized x coordinate of box corner 1 (0-1)
  @BuiltValueField(wireName: r'x1')
  double get x1;

  /// Normalized x coordinate of box corner 2 (0-1)
  @BuiltValueField(wireName: r'x2')
  double get x2;

  /// Normalized x coordinate of box corner 3 (0-1)
  @BuiltValueField(wireName: r'x3')
  double get x3;

  /// Normalized x coordinate of box corner 4 (0-1)
  @BuiltValueField(wireName: r'x4')
  double get x4;

  /// Normalized y coordinate of box corner 1 (0-1)
  @BuiltValueField(wireName: r'y1')
  double get y1;

  /// Normalized y coordinate of box corner 2 (0-1)
  @BuiltValueField(wireName: r'y2')
  double get y2;

  /// Normalized y coordinate of box corner 3 (0-1)
  @BuiltValueField(wireName: r'y3')
  double get y3;

  /// Normalized y coordinate of box corner 4 (0-1)
  @BuiltValueField(wireName: r'y4')
  double get y4;

  AssetOcrResponseDto._();

  factory AssetOcrResponseDto([void updates(AssetOcrResponseDtoBuilder b)]) = _$AssetOcrResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetOcrResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetOcrResponseDto> get serializer => _$AssetOcrResponseDtoSerializer();
}

class _$AssetOcrResponseDtoSerializer implements PrimitiveSerializer<AssetOcrResponseDto> {
  @override
  final Iterable<Type> types = const [AssetOcrResponseDto, _$AssetOcrResponseDto];

  @override
  final String wireName = r'AssetOcrResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetOcrResponseDto object, {
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
    AssetOcrResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssetOcrResponseDtoBuilder result,
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
  AssetOcrResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetOcrResponseDtoBuilder();
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


