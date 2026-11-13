//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'external_ocr_line_dto.g.dart';

/// ExternalOcrLineDto
///
/// Properties:
/// * [boxScore] - Detection confidence
/// * [text] - Recognized text
/// * [textScore] - Text recognition confidence
/// * [x1] - Bounding box x1
/// * [x2] - Bounding box x2
/// * [x3] - Bounding box x3
/// * [x4] - Bounding box x4
/// * [y1] - Bounding box y1
/// * [y2] - Bounding box y2
/// * [y3] - Bounding box y3
/// * [y4] - Bounding box y4
@BuiltValue()
abstract class ExternalOcrLineDto implements Built<ExternalOcrLineDto, ExternalOcrLineDtoBuilder> {
  /// Detection confidence
  @BuiltValueField(wireName: r'boxScore')
  double get boxScore;

  /// Recognized text
  @BuiltValueField(wireName: r'text')
  String get text;

  /// Text recognition confidence
  @BuiltValueField(wireName: r'textScore')
  double get textScore;

  /// Bounding box x1
  @BuiltValueField(wireName: r'x1')
  double get x1;

  /// Bounding box x2
  @BuiltValueField(wireName: r'x2')
  double get x2;

  /// Bounding box x3
  @BuiltValueField(wireName: r'x3')
  double get x3;

  /// Bounding box x4
  @BuiltValueField(wireName: r'x4')
  double get x4;

  /// Bounding box y1
  @BuiltValueField(wireName: r'y1')
  double get y1;

  /// Bounding box y2
  @BuiltValueField(wireName: r'y2')
  double get y2;

  /// Bounding box y3
  @BuiltValueField(wireName: r'y3')
  double get y3;

  /// Bounding box y4
  @BuiltValueField(wireName: r'y4')
  double get y4;

  ExternalOcrLineDto._();

  factory ExternalOcrLineDto([void updates(ExternalOcrLineDtoBuilder b)]) = _$ExternalOcrLineDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExternalOcrLineDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ExternalOcrLineDto> get serializer => _$ExternalOcrLineDtoSerializer();
}

class _$ExternalOcrLineDtoSerializer implements PrimitiveSerializer<ExternalOcrLineDto> {
  @override
  final Iterable<Type> types = const [ExternalOcrLineDto, _$ExternalOcrLineDto];

  @override
  final String wireName = r'ExternalOcrLineDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ExternalOcrLineDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'boxScore';
    yield serializers.serialize(
      object.boxScore,
      specifiedType: const FullType(double),
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
    ExternalOcrLineDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ExternalOcrLineDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'boxScore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.boxScore = valueDes;
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
  ExternalOcrLineDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExternalOcrLineDtoBuilder();
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


