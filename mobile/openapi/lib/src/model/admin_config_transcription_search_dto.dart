//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_transcription_search_dto.g.dart';

/// AdminConfigTranscriptionSearchDto
///
/// Properties:
/// * [additionalMoments] - Additional matching moments returned per video
/// * [coverageWeight] - Token coverage weight
/// * [fuzzyThreshold] - Strict-word similarity threshold for spelling fallback
/// * [minimumCoverage] - Minimum query-token coverage
/// * [minimumFuzzyLength] - Minimum query-token length for fuzzy matching
/// * [proximityWeight] - Proximity weight
/// * [similarityWeight] - Spelling similarity weight
@BuiltValue()
abstract class AdminConfigTranscriptionSearchDto implements Built<AdminConfigTranscriptionSearchDto, AdminConfigTranscriptionSearchDtoBuilder> {
  /// Additional matching moments returned per video
  @BuiltValueField(wireName: r'additionalMoments')
  int get additionalMoments;

  /// Token coverage weight
  @BuiltValueField(wireName: r'coverageWeight')
  double get coverageWeight;

  /// Strict-word similarity threshold for spelling fallback
  @BuiltValueField(wireName: r'fuzzyThreshold')
  double get fuzzyThreshold;

  /// Minimum query-token coverage
  @BuiltValueField(wireName: r'minimumCoverage')
  double get minimumCoverage;

  /// Minimum query-token length for fuzzy matching
  @BuiltValueField(wireName: r'minimumFuzzyLength')
  int get minimumFuzzyLength;

  /// Proximity weight
  @BuiltValueField(wireName: r'proximityWeight')
  double get proximityWeight;

  /// Spelling similarity weight
  @BuiltValueField(wireName: r'similarityWeight')
  double get similarityWeight;

  AdminConfigTranscriptionSearchDto._();

  factory AdminConfigTranscriptionSearchDto([void updates(AdminConfigTranscriptionSearchDtoBuilder b)]) = _$AdminConfigTranscriptionSearchDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigTranscriptionSearchDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigTranscriptionSearchDto> get serializer => _$AdminConfigTranscriptionSearchDtoSerializer();
}

class _$AdminConfigTranscriptionSearchDtoSerializer implements PrimitiveSerializer<AdminConfigTranscriptionSearchDto> {
  @override
  final Iterable<Type> types = const [AdminConfigTranscriptionSearchDto, _$AdminConfigTranscriptionSearchDto];

  @override
  final String wireName = r'AdminConfigTranscriptionSearchDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigTranscriptionSearchDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'additionalMoments';
    yield serializers.serialize(
      object.additionalMoments,
      specifiedType: const FullType(int),
    );
    yield r'coverageWeight';
    yield serializers.serialize(
      object.coverageWeight,
      specifiedType: const FullType(double),
    );
    yield r'fuzzyThreshold';
    yield serializers.serialize(
      object.fuzzyThreshold,
      specifiedType: const FullType(double),
    );
    yield r'minimumCoverage';
    yield serializers.serialize(
      object.minimumCoverage,
      specifiedType: const FullType(double),
    );
    yield r'minimumFuzzyLength';
    yield serializers.serialize(
      object.minimumFuzzyLength,
      specifiedType: const FullType(int),
    );
    yield r'proximityWeight';
    yield serializers.serialize(
      object.proximityWeight,
      specifiedType: const FullType(double),
    );
    yield r'similarityWeight';
    yield serializers.serialize(
      object.similarityWeight,
      specifiedType: const FullType(double),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigTranscriptionSearchDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigTranscriptionSearchDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'additionalMoments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.additionalMoments = valueDes;
          break;
        case r'coverageWeight':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.coverageWeight = valueDes;
          break;
        case r'fuzzyThreshold':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.fuzzyThreshold = valueDes;
          break;
        case r'minimumCoverage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.minimumCoverage = valueDes;
          break;
        case r'minimumFuzzyLength':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.minimumFuzzyLength = valueDes;
          break;
        case r'proximityWeight':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.proximityWeight = valueDes;
          break;
        case r'similarityWeight':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.similarityWeight = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigTranscriptionSearchDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigTranscriptionSearchDtoBuilder();
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


