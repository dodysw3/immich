//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'transcription_coverage_dto.g.dart';

/// TranscriptionCoverageDto
///
/// Properties:
/// * [indexErrors] 
/// * [indexedVideos] 
/// * [pendingIndex] 
/// * [totalVideos] 
@BuiltValue()
abstract class TranscriptionCoverageDto implements Built<TranscriptionCoverageDto, TranscriptionCoverageDtoBuilder> {
  @BuiltValueField(wireName: r'indexErrors')
  int get indexErrors;

  @BuiltValueField(wireName: r'indexedVideos')
  int get indexedVideos;

  @BuiltValueField(wireName: r'pendingIndex')
  int get pendingIndex;

  @BuiltValueField(wireName: r'totalVideos')
  int get totalVideos;

  TranscriptionCoverageDto._();

  factory TranscriptionCoverageDto([void updates(TranscriptionCoverageDtoBuilder b)]) = _$TranscriptionCoverageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TranscriptionCoverageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TranscriptionCoverageDto> get serializer => _$TranscriptionCoverageDtoSerializer();
}

class _$TranscriptionCoverageDtoSerializer implements PrimitiveSerializer<TranscriptionCoverageDto> {
  @override
  final Iterable<Type> types = const [TranscriptionCoverageDto, _$TranscriptionCoverageDto];

  @override
  final String wireName = r'TranscriptionCoverageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TranscriptionCoverageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'indexErrors';
    yield serializers.serialize(
      object.indexErrors,
      specifiedType: const FullType(int),
    );
    yield r'indexedVideos';
    yield serializers.serialize(
      object.indexedVideos,
      specifiedType: const FullType(int),
    );
    yield r'pendingIndex';
    yield serializers.serialize(
      object.pendingIndex,
      specifiedType: const FullType(int),
    );
    yield r'totalVideos';
    yield serializers.serialize(
      object.totalVideos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TranscriptionCoverageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TranscriptionCoverageDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'indexErrors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.indexErrors = valueDes;
          break;
        case r'indexedVideos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.indexedVideos = valueDes;
          break;
        case r'pendingIndex':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pendingIndex = valueDes;
          break;
        case r'totalVideos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalVideos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TranscriptionCoverageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TranscriptionCoverageDtoBuilder();
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


