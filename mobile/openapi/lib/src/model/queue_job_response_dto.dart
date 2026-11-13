//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/job_name.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'queue_job_response_dto.g.dart';

/// QueueJobResponseDto
///
/// Properties:
/// * [data] - Job data payload
/// * [id] - Job ID
/// * [name] 
/// * [timestamp] - Job creation timestamp
@BuiltValue()
abstract class QueueJobResponseDto implements Built<QueueJobResponseDto, QueueJobResponseDtoBuilder> {
  /// Job data payload
  @BuiltValueField(wireName: r'data')
  BuiltMap<String, JsonObject?> get data;

  /// Job ID
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'name')
  JobName get name;
  // enum nameEnum {  AssetDelete,  AssetDeleteCheck,  AssetVideoFaceScan,  AssetDetectFacesQueueAll,  AssetDetectFaces,  FaceRecheckQueueAll,  FaceRecheck,  AssetDetectDuplicatesQueueAll,  AssetDetectDuplicates,  AssetEditThumbnailGeneration,  AssetEncodeVideoQueueAll,  AssetEncodeVideo,  AssetEmptyTrash,  AssetExtractMetadataQueueAll,  AssetExtractMetadata,  AssetFileMigration,  AssetGenerateThumbnailsQueueAll,  AssetGenerateThumbnails,  AssetInterpretImage,  AssetInterpretImagePublic,  AssetInterpretationReconcile,  AiInterpretSearchSync,  AiInterpretSearchReconcile,  AssetCaptionVideo,  AssetTranscribeVideo,  TranscriptionReconcile,  TranscriptIndexSync,  TranscriptIndexReconcile,  AuditTableCleanup,  AuthChallengeCleanup,  DatabaseBackup,  FacialRecognitionQueueAll,  FacialRecognition,  FileDelete,  FileMigrationQueueAll,  LibraryDeleteCheck,  LibraryDelete,  LibraryRemoveAsset,  LibraryScanAssetsQueueAll,  LibrarySyncAssets,  LibrarySyncFilesQueueAll,  LibrarySyncFiles,  LibraryScanQueueAll,  HlsSessionCleanup,  MemoryCleanup,  MemoryGenerate,  NotificationsCleanup,  NotifyUserSignup,  NotifyAlbumInvite,  NotifyAlbumUpdate,  UserDelete,  UserDeleteCheck,  UserSyncUsage,  PersonCleanup,  PersonFileMigration,  PersonGenerateThumbnail,  SessionCleanup,  SendMail,  SendAiInterpretationDiscordAlert,  SidecarQueueAll,  SidecarCheck,  SidecarWrite,  SmartSearchQueueAll,  SmartSearch,  StorageTemplateMigration,  StorageTemplateMigrationSingle,  TagCleanup,  VersionCheck,  OcrQueueAll,  Ocr,  PdfProcessQueueAll,  PdfProcess,  WorkflowAssetTrigger,  IntegrityUntrackedFilesQueueAll,  IntegrityUntrackedFiles,  IntegrityUntrackedRefresh,  IntegrityMissingFilesQueueAll,  IntegrityMissingFiles,  IntegrityMissingFilesRefresh,  IntegrityChecksumFiles,  IntegrityChecksumFilesRefresh,  IntegrityDeleteReportType,  IntegrityDeleteReports,  };

  /// Job creation timestamp
  @BuiltValueField(wireName: r'timestamp')
  int get timestamp;

  QueueJobResponseDto._();

  factory QueueJobResponseDto([void updates(QueueJobResponseDtoBuilder b)]) = _$QueueJobResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QueueJobResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<QueueJobResponseDto> get serializer => _$QueueJobResponseDtoSerializer();
}

class _$QueueJobResponseDtoSerializer implements PrimitiveSerializer<QueueJobResponseDto> {
  @override
  final Iterable<Type> types = const [QueueJobResponseDto, _$QueueJobResponseDto];

  @override
  final String wireName = r'QueueJobResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    QueueJobResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(JobName),
    );
    yield r'timestamp';
    yield serializers.serialize(
      object.timestamp,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    QueueJobResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required QueueJobResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.data.replace(valueDes);
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(JobName),
          ) as JobName;
          result.name = valueDes;
          break;
        case r'timestamp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.timestamp = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  QueueJobResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QueueJobResponseDtoBuilder();
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


