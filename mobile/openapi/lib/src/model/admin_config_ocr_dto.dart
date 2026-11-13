//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_ocr_dto.g.dart';

/// AdminConfigOcrDto
///
/// Properties:
/// * [enabled] - Whether the task is enabled
/// * [maxResolution] - Maximum resolution for OCR processing
/// * [minDetectionScore] - Minimum confidence score for text detection
/// * [minRecognitionScore] - Minimum confidence score for text recognition
/// * [modelName] - Name of the model to use
@BuiltValue()
abstract class AdminConfigOcrDto implements Built<AdminConfigOcrDto, AdminConfigOcrDtoBuilder> {
  /// Whether the task is enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// Maximum resolution for OCR processing
  @BuiltValueField(wireName: r'maxResolution')
  int get maxResolution;

  /// Minimum confidence score for text detection
  @BuiltValueField(wireName: r'minDetectionScore')
  double get minDetectionScore;

  /// Minimum confidence score for text recognition
  @BuiltValueField(wireName: r'minRecognitionScore')
  double get minRecognitionScore;

  /// Name of the model to use
  @BuiltValueField(wireName: r'modelName')
  String get modelName;

  AdminConfigOcrDto._();

  factory AdminConfigOcrDto([void updates(AdminConfigOcrDtoBuilder b)]) = _$AdminConfigOcrDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigOcrDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigOcrDto> get serializer => _$AdminConfigOcrDtoSerializer();
}

class _$AdminConfigOcrDtoSerializer implements PrimitiveSerializer<AdminConfigOcrDto> {
  @override
  final Iterable<Type> types = const [AdminConfigOcrDto, _$AdminConfigOcrDto];

  @override
  final String wireName = r'AdminConfigOcrDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigOcrDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'maxResolution';
    yield serializers.serialize(
      object.maxResolution,
      specifiedType: const FullType(int),
    );
    yield r'minDetectionScore';
    yield serializers.serialize(
      object.minDetectionScore,
      specifiedType: const FullType(double),
    );
    yield r'minRecognitionScore';
    yield serializers.serialize(
      object.minRecognitionScore,
      specifiedType: const FullType(double),
    );
    yield r'modelName';
    yield serializers.serialize(
      object.modelName,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigOcrDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigOcrDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'maxResolution':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.maxResolution = valueDes;
          break;
        case r'minDetectionScore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.minDetectionScore = valueDes;
          break;
        case r'minRecognitionScore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.minRecognitionScore = valueDes;
          break;
        case r'modelName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.modelName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigOcrDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigOcrDtoBuilder();
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


