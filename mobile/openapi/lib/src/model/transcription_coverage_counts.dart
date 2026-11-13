//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'transcription_coverage_counts.g.dart';

/// TranscriptionCoverageCounts
///
/// Properties:
/// * [complete] 
/// * [failed] 
/// * [inProgress] 
/// * [indexCurrent] 
/// * [indexFailed] 
/// * [indexPending] 
/// * [missing] 
/// * [noAudio] 
/// * [noSpeech] 
/// * [partial] 
@BuiltValue()
abstract class TranscriptionCoverageCounts implements Built<TranscriptionCoverageCounts, TranscriptionCoverageCountsBuilder> {
  @BuiltValueField(wireName: r'complete')
  int get complete;

  @BuiltValueField(wireName: r'failed')
  int get failed;

  @BuiltValueField(wireName: r'inProgress')
  int get inProgress;

  @BuiltValueField(wireName: r'indexCurrent')
  int get indexCurrent;

  @BuiltValueField(wireName: r'indexFailed')
  int get indexFailed;

  @BuiltValueField(wireName: r'indexPending')
  int get indexPending;

  @BuiltValueField(wireName: r'missing')
  int get missing;

  @BuiltValueField(wireName: r'noAudio')
  int get noAudio;

  @BuiltValueField(wireName: r'noSpeech')
  int get noSpeech;

  @BuiltValueField(wireName: r'partial')
  int get partial;

  TranscriptionCoverageCounts._();

  factory TranscriptionCoverageCounts([void updates(TranscriptionCoverageCountsBuilder b)]) = _$TranscriptionCoverageCounts;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TranscriptionCoverageCountsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TranscriptionCoverageCounts> get serializer => _$TranscriptionCoverageCountsSerializer();
}

class _$TranscriptionCoverageCountsSerializer implements PrimitiveSerializer<TranscriptionCoverageCounts> {
  @override
  final Iterable<Type> types = const [TranscriptionCoverageCounts, _$TranscriptionCoverageCounts];

  @override
  final String wireName = r'TranscriptionCoverageCounts';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TranscriptionCoverageCounts object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'complete';
    yield serializers.serialize(
      object.complete,
      specifiedType: const FullType(int),
    );
    yield r'failed';
    yield serializers.serialize(
      object.failed,
      specifiedType: const FullType(int),
    );
    yield r'inProgress';
    yield serializers.serialize(
      object.inProgress,
      specifiedType: const FullType(int),
    );
    yield r'indexCurrent';
    yield serializers.serialize(
      object.indexCurrent,
      specifiedType: const FullType(int),
    );
    yield r'indexFailed';
    yield serializers.serialize(
      object.indexFailed,
      specifiedType: const FullType(int),
    );
    yield r'indexPending';
    yield serializers.serialize(
      object.indexPending,
      specifiedType: const FullType(int),
    );
    yield r'missing';
    yield serializers.serialize(
      object.missing,
      specifiedType: const FullType(int),
    );
    yield r'noAudio';
    yield serializers.serialize(
      object.noAudio,
      specifiedType: const FullType(int),
    );
    yield r'noSpeech';
    yield serializers.serialize(
      object.noSpeech,
      specifiedType: const FullType(int),
    );
    yield r'partial';
    yield serializers.serialize(
      object.partial,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TranscriptionCoverageCounts object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TranscriptionCoverageCountsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'complete':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.complete = valueDes;
          break;
        case r'failed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.failed = valueDes;
          break;
        case r'inProgress':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.inProgress = valueDes;
          break;
        case r'indexCurrent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.indexCurrent = valueDes;
          break;
        case r'indexFailed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.indexFailed = valueDes;
          break;
        case r'indexPending':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.indexPending = valueDes;
          break;
        case r'missing':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.missing = valueDes;
          break;
        case r'noAudio':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.noAudio = valueDes;
          break;
        case r'noSpeech':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.noSpeech = valueDes;
          break;
        case r'partial':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.partial = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TranscriptionCoverageCounts deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TranscriptionCoverageCountsBuilder();
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


