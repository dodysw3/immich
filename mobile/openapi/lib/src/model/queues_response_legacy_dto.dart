//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/queue_response_legacy_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'queues_response_legacy_dto.g.dart';

/// QueuesResponseLegacyDto
///
/// Properties:
/// * [aiInterpretSearch] 
/// * [backgroundTask] 
/// * [backupDatabase] 
/// * [duplicateDetection] 
/// * [editor] 
/// * [faceDetection] 
/// * [facialRecognition] 
/// * [imageInterpretation] 
/// * [imageInterpretationPublic] 
/// * [integrityCheck] 
/// * [library_] 
/// * [metadataExtraction] 
/// * [migration] 
/// * [notifications] 
/// * [ocr] 
/// * [pdfProcessing] 
/// * [search] 
/// * [sidecar] 
/// * [smartSearch] 
/// * [storageTemplateMigration] 
/// * [thumbnailGeneration] 
/// * [transcriptIndexSync] 
/// * [videoCaptioning] 
/// * [videoConversion] 
/// * [videoFaceScan] 
/// * [videoTranscription] 
/// * [workflow] 
@BuiltValue()
abstract class QueuesResponseLegacyDto implements Built<QueuesResponseLegacyDto, QueuesResponseLegacyDtoBuilder> {
  @BuiltValueField(wireName: r'aiInterpretSearch')
  QueueResponseLegacyDto get aiInterpretSearch;

  @BuiltValueField(wireName: r'backgroundTask')
  QueueResponseLegacyDto get backgroundTask;

  @BuiltValueField(wireName: r'backupDatabase')
  QueueResponseLegacyDto get backupDatabase;

  @BuiltValueField(wireName: r'duplicateDetection')
  QueueResponseLegacyDto get duplicateDetection;

  @BuiltValueField(wireName: r'editor')
  QueueResponseLegacyDto get editor;

  @BuiltValueField(wireName: r'faceDetection')
  QueueResponseLegacyDto get faceDetection;

  @BuiltValueField(wireName: r'facialRecognition')
  QueueResponseLegacyDto get facialRecognition;

  @BuiltValueField(wireName: r'imageInterpretation')
  QueueResponseLegacyDto get imageInterpretation;

  @BuiltValueField(wireName: r'imageInterpretationPublic')
  QueueResponseLegacyDto get imageInterpretationPublic;

  @BuiltValueField(wireName: r'integrityCheck')
  QueueResponseLegacyDto get integrityCheck;

  @BuiltValueField(wireName: r'library')
  QueueResponseLegacyDto get library_;

  @BuiltValueField(wireName: r'metadataExtraction')
  QueueResponseLegacyDto get metadataExtraction;

  @BuiltValueField(wireName: r'migration')
  QueueResponseLegacyDto get migration;

  @BuiltValueField(wireName: r'notifications')
  QueueResponseLegacyDto get notifications;

  @BuiltValueField(wireName: r'ocr')
  QueueResponseLegacyDto get ocr;

  @BuiltValueField(wireName: r'pdfProcessing')
  QueueResponseLegacyDto get pdfProcessing;

  @BuiltValueField(wireName: r'search')
  QueueResponseLegacyDto get search;

  @BuiltValueField(wireName: r'sidecar')
  QueueResponseLegacyDto get sidecar;

  @BuiltValueField(wireName: r'smartSearch')
  QueueResponseLegacyDto get smartSearch;

  @BuiltValueField(wireName: r'storageTemplateMigration')
  QueueResponseLegacyDto get storageTemplateMigration;

  @BuiltValueField(wireName: r'thumbnailGeneration')
  QueueResponseLegacyDto get thumbnailGeneration;

  @BuiltValueField(wireName: r'transcriptIndexSync')
  QueueResponseLegacyDto get transcriptIndexSync;

  @BuiltValueField(wireName: r'videoCaptioning')
  QueueResponseLegacyDto get videoCaptioning;

  @BuiltValueField(wireName: r'videoConversion')
  QueueResponseLegacyDto get videoConversion;

  @BuiltValueField(wireName: r'videoFaceScan')
  QueueResponseLegacyDto get videoFaceScan;

  @BuiltValueField(wireName: r'videoTranscription')
  QueueResponseLegacyDto get videoTranscription;

  @BuiltValueField(wireName: r'workflow')
  QueueResponseLegacyDto get workflow;

  QueuesResponseLegacyDto._();

  factory QueuesResponseLegacyDto([void updates(QueuesResponseLegacyDtoBuilder b)]) = _$QueuesResponseLegacyDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QueuesResponseLegacyDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<QueuesResponseLegacyDto> get serializer => _$QueuesResponseLegacyDtoSerializer();
}

class _$QueuesResponseLegacyDtoSerializer implements PrimitiveSerializer<QueuesResponseLegacyDto> {
  @override
  final Iterable<Type> types = const [QueuesResponseLegacyDto, _$QueuesResponseLegacyDto];

  @override
  final String wireName = r'QueuesResponseLegacyDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    QueuesResponseLegacyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'aiInterpretSearch';
    yield serializers.serialize(
      object.aiInterpretSearch,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'backgroundTask';
    yield serializers.serialize(
      object.backgroundTask,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'backupDatabase';
    yield serializers.serialize(
      object.backupDatabase,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'duplicateDetection';
    yield serializers.serialize(
      object.duplicateDetection,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'editor';
    yield serializers.serialize(
      object.editor,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'faceDetection';
    yield serializers.serialize(
      object.faceDetection,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'facialRecognition';
    yield serializers.serialize(
      object.facialRecognition,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'imageInterpretation';
    yield serializers.serialize(
      object.imageInterpretation,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'imageInterpretationPublic';
    yield serializers.serialize(
      object.imageInterpretationPublic,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'integrityCheck';
    yield serializers.serialize(
      object.integrityCheck,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'library';
    yield serializers.serialize(
      object.library_,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'metadataExtraction';
    yield serializers.serialize(
      object.metadataExtraction,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'migration';
    yield serializers.serialize(
      object.migration,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'notifications';
    yield serializers.serialize(
      object.notifications,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'ocr';
    yield serializers.serialize(
      object.ocr,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'pdfProcessing';
    yield serializers.serialize(
      object.pdfProcessing,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'search';
    yield serializers.serialize(
      object.search,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'sidecar';
    yield serializers.serialize(
      object.sidecar,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'smartSearch';
    yield serializers.serialize(
      object.smartSearch,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'storageTemplateMigration';
    yield serializers.serialize(
      object.storageTemplateMigration,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'thumbnailGeneration';
    yield serializers.serialize(
      object.thumbnailGeneration,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'transcriptIndexSync';
    yield serializers.serialize(
      object.transcriptIndexSync,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'videoCaptioning';
    yield serializers.serialize(
      object.videoCaptioning,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'videoConversion';
    yield serializers.serialize(
      object.videoConversion,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'videoFaceScan';
    yield serializers.serialize(
      object.videoFaceScan,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'videoTranscription';
    yield serializers.serialize(
      object.videoTranscription,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
    yield r'workflow';
    yield serializers.serialize(
      object.workflow,
      specifiedType: const FullType(QueueResponseLegacyDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    QueuesResponseLegacyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required QueuesResponseLegacyDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'aiInterpretSearch':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.aiInterpretSearch.replace(valueDes);
          break;
        case r'backgroundTask':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.backgroundTask.replace(valueDes);
          break;
        case r'backupDatabase':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.backupDatabase.replace(valueDes);
          break;
        case r'duplicateDetection':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.duplicateDetection.replace(valueDes);
          break;
        case r'editor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.editor.replace(valueDes);
          break;
        case r'faceDetection':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.faceDetection.replace(valueDes);
          break;
        case r'facialRecognition':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.facialRecognition.replace(valueDes);
          break;
        case r'imageInterpretation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.imageInterpretation.replace(valueDes);
          break;
        case r'imageInterpretationPublic':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.imageInterpretationPublic.replace(valueDes);
          break;
        case r'integrityCheck':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.integrityCheck.replace(valueDes);
          break;
        case r'library':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.library_.replace(valueDes);
          break;
        case r'metadataExtraction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.metadataExtraction.replace(valueDes);
          break;
        case r'migration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.migration.replace(valueDes);
          break;
        case r'notifications':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.notifications.replace(valueDes);
          break;
        case r'ocr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.ocr.replace(valueDes);
          break;
        case r'pdfProcessing':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.pdfProcessing.replace(valueDes);
          break;
        case r'search':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.search.replace(valueDes);
          break;
        case r'sidecar':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.sidecar.replace(valueDes);
          break;
        case r'smartSearch':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.smartSearch.replace(valueDes);
          break;
        case r'storageTemplateMigration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.storageTemplateMigration.replace(valueDes);
          break;
        case r'thumbnailGeneration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.thumbnailGeneration.replace(valueDes);
          break;
        case r'transcriptIndexSync':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.transcriptIndexSync.replace(valueDes);
          break;
        case r'videoCaptioning':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.videoCaptioning.replace(valueDes);
          break;
        case r'videoConversion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.videoConversion.replace(valueDes);
          break;
        case r'videoFaceScan':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.videoFaceScan.replace(valueDes);
          break;
        case r'videoTranscription':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.videoTranscription.replace(valueDes);
          break;
        case r'workflow':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueResponseLegacyDto),
          ) as QueueResponseLegacyDto;
          result.workflow.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  QueuesResponseLegacyDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QueuesResponseLegacyDtoBuilder();
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


