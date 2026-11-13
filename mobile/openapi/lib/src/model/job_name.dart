//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'job_name.g.dart';

/// Job name
class JobName extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AssetDelete')
  static const JobName assetDelete = _$assetDelete;
  @BuiltValueEnumConst(wireName: r'AssetDeleteCheck')
  static const JobName assetDeleteCheck = _$assetDeleteCheck;
  @BuiltValueEnumConst(wireName: r'AssetVideoFaceScan')
  static const JobName assetVideoFaceScan = _$assetVideoFaceScan;
  @BuiltValueEnumConst(wireName: r'AssetDetectFacesQueueAll')
  static const JobName assetDetectFacesQueueAll = _$assetDetectFacesQueueAll;
  @BuiltValueEnumConst(wireName: r'AssetDetectFaces')
  static const JobName assetDetectFaces = _$assetDetectFaces;
  @BuiltValueEnumConst(wireName: r'FaceRecheckQueueAll')
  static const JobName faceRecheckQueueAll = _$faceRecheckQueueAll;
  @BuiltValueEnumConst(wireName: r'FaceRecheck')
  static const JobName faceRecheck = _$faceRecheck;
  @BuiltValueEnumConst(wireName: r'AssetDetectDuplicatesQueueAll')
  static const JobName assetDetectDuplicatesQueueAll = _$assetDetectDuplicatesQueueAll;
  @BuiltValueEnumConst(wireName: r'AssetDetectDuplicates')
  static const JobName assetDetectDuplicates = _$assetDetectDuplicates;
  @BuiltValueEnumConst(wireName: r'AssetEditThumbnailGeneration')
  static const JobName assetEditThumbnailGeneration = _$assetEditThumbnailGeneration;
  @BuiltValueEnumConst(wireName: r'AssetEncodeVideoQueueAll')
  static const JobName assetEncodeVideoQueueAll = _$assetEncodeVideoQueueAll;
  @BuiltValueEnumConst(wireName: r'AssetEncodeVideo')
  static const JobName assetEncodeVideo = _$assetEncodeVideo;
  @BuiltValueEnumConst(wireName: r'AssetEmptyTrash')
  static const JobName assetEmptyTrash = _$assetEmptyTrash;
  @BuiltValueEnumConst(wireName: r'AssetExtractMetadataQueueAll')
  static const JobName assetExtractMetadataQueueAll = _$assetExtractMetadataQueueAll;
  @BuiltValueEnumConst(wireName: r'AssetExtractMetadata')
  static const JobName assetExtractMetadata = _$assetExtractMetadata;
  @BuiltValueEnumConst(wireName: r'AssetFileMigration')
  static const JobName assetFileMigration = _$assetFileMigration;
  @BuiltValueEnumConst(wireName: r'AssetGenerateThumbnailsQueueAll')
  static const JobName assetGenerateThumbnailsQueueAll = _$assetGenerateThumbnailsQueueAll;
  @BuiltValueEnumConst(wireName: r'AssetGenerateThumbnails')
  static const JobName assetGenerateThumbnails = _$assetGenerateThumbnails;
  @BuiltValueEnumConst(wireName: r'AssetInterpretImage')
  static const JobName assetInterpretImage = _$assetInterpretImage;
  @BuiltValueEnumConst(wireName: r'AssetInterpretImagePublic')
  static const JobName assetInterpretImagePublic = _$assetInterpretImagePublic;
  @BuiltValueEnumConst(wireName: r'AssetInterpretationReconcile')
  static const JobName assetInterpretationReconcile = _$assetInterpretationReconcile;
  @BuiltValueEnumConst(wireName: r'AiInterpretSearchSync')
  static const JobName aiInterpretSearchSync = _$aiInterpretSearchSync;
  @BuiltValueEnumConst(wireName: r'AiInterpretSearchReconcile')
  static const JobName aiInterpretSearchReconcile = _$aiInterpretSearchReconcile;
  @BuiltValueEnumConst(wireName: r'AssetCaptionVideo')
  static const JobName assetCaptionVideo = _$assetCaptionVideo;
  @BuiltValueEnumConst(wireName: r'AssetTranscribeVideo')
  static const JobName assetTranscribeVideo = _$assetTranscribeVideo;
  @BuiltValueEnumConst(wireName: r'TranscriptionReconcile')
  static const JobName transcriptionReconcile = _$transcriptionReconcile;
  @BuiltValueEnumConst(wireName: r'TranscriptIndexSync')
  static const JobName transcriptIndexSync = _$transcriptIndexSync;
  @BuiltValueEnumConst(wireName: r'TranscriptIndexReconcile')
  static const JobName transcriptIndexReconcile = _$transcriptIndexReconcile;
  @BuiltValueEnumConst(wireName: r'AuditTableCleanup')
  static const JobName auditTableCleanup = _$auditTableCleanup;
  @BuiltValueEnumConst(wireName: r'AuthChallengeCleanup')
  static const JobName authChallengeCleanup = _$authChallengeCleanup;
  @BuiltValueEnumConst(wireName: r'DatabaseBackup')
  static const JobName databaseBackup = _$databaseBackup;
  @BuiltValueEnumConst(wireName: r'FacialRecognitionQueueAll')
  static const JobName facialRecognitionQueueAll = _$facialRecognitionQueueAll;
  @BuiltValueEnumConst(wireName: r'FacialRecognition')
  static const JobName facialRecognition = _$facialRecognition;
  @BuiltValueEnumConst(wireName: r'FileDelete')
  static const JobName fileDelete = _$fileDelete;
  @BuiltValueEnumConst(wireName: r'FileMigrationQueueAll')
  static const JobName fileMigrationQueueAll = _$fileMigrationQueueAll;
  @BuiltValueEnumConst(wireName: r'LibraryDeleteCheck')
  static const JobName libraryDeleteCheck = _$libraryDeleteCheck;
  @BuiltValueEnumConst(wireName: r'LibraryDelete')
  static const JobName libraryDelete = _$libraryDelete;
  @BuiltValueEnumConst(wireName: r'LibraryRemoveAsset')
  static const JobName libraryRemoveAsset = _$libraryRemoveAsset;
  @BuiltValueEnumConst(wireName: r'LibraryScanAssetsQueueAll')
  static const JobName libraryScanAssetsQueueAll = _$libraryScanAssetsQueueAll;
  @BuiltValueEnumConst(wireName: r'LibrarySyncAssets')
  static const JobName librarySyncAssets = _$librarySyncAssets;
  @BuiltValueEnumConst(wireName: r'LibrarySyncFilesQueueAll')
  static const JobName librarySyncFilesQueueAll = _$librarySyncFilesQueueAll;
  @BuiltValueEnumConst(wireName: r'LibrarySyncFiles')
  static const JobName librarySyncFiles = _$librarySyncFiles;
  @BuiltValueEnumConst(wireName: r'LibraryScanQueueAll')
  static const JobName libraryScanQueueAll = _$libraryScanQueueAll;
  @BuiltValueEnumConst(wireName: r'HlsSessionCleanup')
  static const JobName hlsSessionCleanup = _$hlsSessionCleanup;
  @BuiltValueEnumConst(wireName: r'MemoryCleanup')
  static const JobName memoryCleanup = _$memoryCleanup;
  @BuiltValueEnumConst(wireName: r'MemoryGenerate')
  static const JobName memoryGenerate = _$memoryGenerate;
  @BuiltValueEnumConst(wireName: r'NotificationsCleanup')
  static const JobName notificationsCleanup = _$notificationsCleanup;
  @BuiltValueEnumConst(wireName: r'NotifyUserSignup')
  static const JobName notifyUserSignup = _$notifyUserSignup;
  @BuiltValueEnumConst(wireName: r'NotifyAlbumInvite')
  static const JobName notifyAlbumInvite = _$notifyAlbumInvite;
  @BuiltValueEnumConst(wireName: r'NotifyAlbumUpdate')
  static const JobName notifyAlbumUpdate = _$notifyAlbumUpdate;
  @BuiltValueEnumConst(wireName: r'UserDelete')
  static const JobName userDelete = _$userDelete;
  @BuiltValueEnumConst(wireName: r'UserDeleteCheck')
  static const JobName userDeleteCheck = _$userDeleteCheck;
  @BuiltValueEnumConst(wireName: r'UserSyncUsage')
  static const JobName userSyncUsage = _$userSyncUsage;
  @BuiltValueEnumConst(wireName: r'PersonCleanup')
  static const JobName personCleanup = _$personCleanup;
  @BuiltValueEnumConst(wireName: r'PersonFileMigration')
  static const JobName personFileMigration = _$personFileMigration;
  @BuiltValueEnumConst(wireName: r'PersonGenerateThumbnail')
  static const JobName personGenerateThumbnail = _$personGenerateThumbnail;
  @BuiltValueEnumConst(wireName: r'SessionCleanup')
  static const JobName sessionCleanup = _$sessionCleanup;
  @BuiltValueEnumConst(wireName: r'SendMail')
  static const JobName sendMail = _$sendMail;
  @BuiltValueEnumConst(wireName: r'SendAiInterpretationDiscordAlert')
  static const JobName sendAiInterpretationDiscordAlert = _$sendAiInterpretationDiscordAlert;
  @BuiltValueEnumConst(wireName: r'SidecarQueueAll')
  static const JobName sidecarQueueAll = _$sidecarQueueAll;
  @BuiltValueEnumConst(wireName: r'SidecarCheck')
  static const JobName sidecarCheck = _$sidecarCheck;
  @BuiltValueEnumConst(wireName: r'SidecarWrite')
  static const JobName sidecarWrite = _$sidecarWrite;
  @BuiltValueEnumConst(wireName: r'SmartSearchQueueAll')
  static const JobName smartSearchQueueAll = _$smartSearchQueueAll;
  @BuiltValueEnumConst(wireName: r'SmartSearch')
  static const JobName smartSearch = _$smartSearch;
  @BuiltValueEnumConst(wireName: r'StorageTemplateMigration')
  static const JobName storageTemplateMigration = _$storageTemplateMigration;
  @BuiltValueEnumConst(wireName: r'StorageTemplateMigrationSingle')
  static const JobName storageTemplateMigrationSingle = _$storageTemplateMigrationSingle;
  @BuiltValueEnumConst(wireName: r'TagCleanup')
  static const JobName tagCleanup = _$tagCleanup;
  @BuiltValueEnumConst(wireName: r'VersionCheck')
  static const JobName versionCheck = _$versionCheck;
  @BuiltValueEnumConst(wireName: r'OcrQueueAll')
  static const JobName ocrQueueAll = _$ocrQueueAll;
  @BuiltValueEnumConst(wireName: r'Ocr')
  static const JobName ocr = _$ocr;
  @BuiltValueEnumConst(wireName: r'PdfProcessQueueAll')
  static const JobName pdfProcessQueueAll = _$pdfProcessQueueAll;
  @BuiltValueEnumConst(wireName: r'PdfProcess')
  static const JobName pdfProcess = _$pdfProcess;
  @BuiltValueEnumConst(wireName: r'WorkflowAssetTrigger')
  static const JobName workflowAssetTrigger = _$workflowAssetTrigger;
  @BuiltValueEnumConst(wireName: r'IntegrityUntrackedFilesQueueAll')
  static const JobName integrityUntrackedFilesQueueAll = _$integrityUntrackedFilesQueueAll;
  @BuiltValueEnumConst(wireName: r'IntegrityUntrackedFiles')
  static const JobName integrityUntrackedFiles = _$integrityUntrackedFiles;
  @BuiltValueEnumConst(wireName: r'IntegrityUntrackedRefresh')
  static const JobName integrityUntrackedRefresh = _$integrityUntrackedRefresh;
  @BuiltValueEnumConst(wireName: r'IntegrityMissingFilesQueueAll')
  static const JobName integrityMissingFilesQueueAll = _$integrityMissingFilesQueueAll;
  @BuiltValueEnumConst(wireName: r'IntegrityMissingFiles')
  static const JobName integrityMissingFiles = _$integrityMissingFiles;
  @BuiltValueEnumConst(wireName: r'IntegrityMissingFilesRefresh')
  static const JobName integrityMissingFilesRefresh = _$integrityMissingFilesRefresh;
  @BuiltValueEnumConst(wireName: r'IntegrityChecksumFiles')
  static const JobName integrityChecksumFiles = _$integrityChecksumFiles;
  @BuiltValueEnumConst(wireName: r'IntegrityChecksumFilesRefresh')
  static const JobName integrityChecksumFilesRefresh = _$integrityChecksumFilesRefresh;
  @BuiltValueEnumConst(wireName: r'IntegrityDeleteReportType')
  static const JobName integrityDeleteReportType = _$integrityDeleteReportType;
  @BuiltValueEnumConst(wireName: r'IntegrityDeleteReports')
  static const JobName integrityDeleteReports = _$integrityDeleteReports;

  static Serializer<JobName> get serializer => _$jobNameSerializer;

  const JobName._(String name): super(name);

  static BuiltSet<JobName> get values => _$values;
  static JobName valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class JobNameMixin = Object with _$JobNameMixin;

