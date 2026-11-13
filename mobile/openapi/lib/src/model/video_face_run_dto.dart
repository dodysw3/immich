//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'video_face_run_dto.g.dart';

/// VideoFaceRunDto
///
/// Properties:
/// * [configHash] 
/// * [durationMs] - Video timeline duration
/// * [finishedAt] 
/// * [firstSampledMs] 
/// * [framesAnalyzed] 
/// * [identities] 
/// * [lastSampledMs] 
/// * [outcome] 
@BuiltValue()
abstract class VideoFaceRunDto implements Built<VideoFaceRunDto, VideoFaceRunDtoBuilder> {
  @BuiltValueField(wireName: r'configHash')
  String get configHash;

  /// Video timeline duration
  @BuiltValueField(wireName: r'durationMs')
  int get durationMs;

  @BuiltValueField(wireName: r'finishedAt')
  String? get finishedAt;

  @BuiltValueField(wireName: r'firstSampledMs')
  int get firstSampledMs;

  @BuiltValueField(wireName: r'framesAnalyzed')
  int get framesAnalyzed;

  @BuiltValueField(wireName: r'identities')
  int get identities;

  @BuiltValueField(wireName: r'lastSampledMs')
  int get lastSampledMs;

  @BuiltValueField(wireName: r'outcome')
  VideoFaceRunDtoOutcomeEnum get outcome;
  // enum outcomeEnum {  saturated,  budget_exhausted,  deadline,  decode_failed,  };

  VideoFaceRunDto._();

  factory VideoFaceRunDto([void updates(VideoFaceRunDtoBuilder b)]) = _$VideoFaceRunDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VideoFaceRunDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VideoFaceRunDto> get serializer => _$VideoFaceRunDtoSerializer();
}

class _$VideoFaceRunDtoSerializer implements PrimitiveSerializer<VideoFaceRunDto> {
  @override
  final Iterable<Type> types = const [VideoFaceRunDto, _$VideoFaceRunDto];

  @override
  final String wireName = r'VideoFaceRunDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VideoFaceRunDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'configHash';
    yield serializers.serialize(
      object.configHash,
      specifiedType: const FullType(String),
    );
    yield r'durationMs';
    yield serializers.serialize(
      object.durationMs,
      specifiedType: const FullType(int),
    );
    yield r'finishedAt';
    yield object.finishedAt == null ? null : serializers.serialize(
      object.finishedAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'firstSampledMs';
    yield serializers.serialize(
      object.firstSampledMs,
      specifiedType: const FullType(int),
    );
    yield r'framesAnalyzed';
    yield serializers.serialize(
      object.framesAnalyzed,
      specifiedType: const FullType(int),
    );
    yield r'identities';
    yield serializers.serialize(
      object.identities,
      specifiedType: const FullType(int),
    );
    yield r'lastSampledMs';
    yield serializers.serialize(
      object.lastSampledMs,
      specifiedType: const FullType(int),
    );
    yield r'outcome';
    yield serializers.serialize(
      object.outcome,
      specifiedType: const FullType(VideoFaceRunDtoOutcomeEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VideoFaceRunDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VideoFaceRunDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'configHash':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.configHash = valueDes;
          break;
        case r'durationMs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.durationMs = valueDes;
          break;
        case r'finishedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.finishedAt = valueDes;
          break;
        case r'firstSampledMs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.firstSampledMs = valueDes;
          break;
        case r'framesAnalyzed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.framesAnalyzed = valueDes;
          break;
        case r'identities':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.identities = valueDes;
          break;
        case r'lastSampledMs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lastSampledMs = valueDes;
          break;
        case r'outcome':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VideoFaceRunDtoOutcomeEnum),
          ) as VideoFaceRunDtoOutcomeEnum;
          result.outcome = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VideoFaceRunDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VideoFaceRunDtoBuilder();
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


class VideoFaceRunDtoOutcomeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'saturated')
  static const VideoFaceRunDtoOutcomeEnum saturated = _$videoFaceRunDtoOutcomeEnum_saturated;
  @BuiltValueEnumConst(wireName: r'budget_exhausted')
  static const VideoFaceRunDtoOutcomeEnum budgetExhausted = _$videoFaceRunDtoOutcomeEnum_budgetExhausted;
  @BuiltValueEnumConst(wireName: r'deadline')
  static const VideoFaceRunDtoOutcomeEnum deadline = _$videoFaceRunDtoOutcomeEnum_deadline;
  @BuiltValueEnumConst(wireName: r'decode_failed')
  static const VideoFaceRunDtoOutcomeEnum decodeFailed = _$videoFaceRunDtoOutcomeEnum_decodeFailed;

  static Serializer<VideoFaceRunDtoOutcomeEnum> get serializer => _$videoFaceRunDtoOutcomeEnumSerializer;

  const VideoFaceRunDtoOutcomeEnum._(String name): super(name);

  static BuiltSet<VideoFaceRunDtoOutcomeEnum> get values => _$videoFaceRunDtoOutcomeEnumValues;
  static VideoFaceRunDtoOutcomeEnum valueOf(String name) => _$videoFaceRunDtoOutcomeEnumValueOf(name);
}

