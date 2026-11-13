//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/queue_name.dart';
import 'package:openapi/src/model/queue_statistics_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'queue_response_dto.g.dart';

/// QueueResponseDto
///
/// Properties:
/// * [isPaused] - Whether the queue is paused
/// * [name] 
/// * [statistics] 
@BuiltValue()
abstract class QueueResponseDto implements Built<QueueResponseDto, QueueResponseDtoBuilder> {
  /// Whether the queue is paused
  @BuiltValueField(wireName: r'isPaused')
  bool get isPaused;

  @BuiltValueField(wireName: r'name')
  QueueName get name;
  // enum nameEnum {  thumbnailGeneration,  metadataExtraction,  videoConversion,  faceDetection,  facialRecognition,  smartSearch,  duplicateDetection,  backgroundTask,  storageTemplateMigration,  migration,  search,  sidecar,  library,  notifications,  backupDatabase,  ocr,  pdfProcessing,  workflow,  integrityCheck,  editor,  imageInterpretation,  imageInterpretationPublic,  aiInterpretSearch,  videoFaceScan,  videoCaptioning,  videoTranscription,  transcriptIndexSync,  };

  @BuiltValueField(wireName: r'statistics')
  QueueStatisticsDto get statistics;

  QueueResponseDto._();

  factory QueueResponseDto([void updates(QueueResponseDtoBuilder b)]) = _$QueueResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QueueResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<QueueResponseDto> get serializer => _$QueueResponseDtoSerializer();
}

class _$QueueResponseDtoSerializer implements PrimitiveSerializer<QueueResponseDto> {
  @override
  final Iterable<Type> types = const [QueueResponseDto, _$QueueResponseDto];

  @override
  final String wireName = r'QueueResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    QueueResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'isPaused';
    yield serializers.serialize(
      object.isPaused,
      specifiedType: const FullType(bool),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(QueueName),
    );
    yield r'statistics';
    yield serializers.serialize(
      object.statistics,
      specifiedType: const FullType(QueueStatisticsDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    QueueResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required QueueResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'isPaused':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isPaused = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueName),
          ) as QueueName;
          result.name = valueDes;
          break;
        case r'statistics':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueStatisticsDto),
          ) as QueueStatisticsDto;
          result.statistics.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  QueueResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QueueResponseDtoBuilder();
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


