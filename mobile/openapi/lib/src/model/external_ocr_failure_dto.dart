//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'external_ocr_failure_dto.g.dart';

/// ExternalOcrFailureDto
///
/// Properties:
/// * [provider] - External OCR provider identifier
/// * [reason] - Failure reason
/// * [retriable] - Whether the failure is retriable
/// * [retryCount] - Number of retries attempted
@BuiltValue()
abstract class ExternalOcrFailureDto implements Built<ExternalOcrFailureDto, ExternalOcrFailureDtoBuilder> {
  /// External OCR provider identifier
  @BuiltValueField(wireName: r'provider')
  String get provider;

  /// Failure reason
  @BuiltValueField(wireName: r'reason')
  String get reason;

  /// Whether the failure is retriable
  @BuiltValueField(wireName: r'retriable')
  bool get retriable;

  /// Number of retries attempted
  @BuiltValueField(wireName: r'retryCount')
  int get retryCount;

  ExternalOcrFailureDto._();

  factory ExternalOcrFailureDto([void updates(ExternalOcrFailureDtoBuilder b)]) = _$ExternalOcrFailureDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExternalOcrFailureDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ExternalOcrFailureDto> get serializer => _$ExternalOcrFailureDtoSerializer();
}

class _$ExternalOcrFailureDtoSerializer implements PrimitiveSerializer<ExternalOcrFailureDto> {
  @override
  final Iterable<Type> types = const [ExternalOcrFailureDto, _$ExternalOcrFailureDto];

  @override
  final String wireName = r'ExternalOcrFailureDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ExternalOcrFailureDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'retriable';
    yield serializers.serialize(
      object.retriable,
      specifiedType: const FullType(bool),
    );
    yield r'retryCount';
    yield serializers.serialize(
      object.retryCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ExternalOcrFailureDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ExternalOcrFailureDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.provider = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'retriable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.retriable = valueDes;
          break;
        case r'retryCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.retryCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ExternalOcrFailureDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExternalOcrFailureDtoBuilder();
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


