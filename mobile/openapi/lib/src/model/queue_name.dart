//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'queue_name.g.dart';

/// Queue name
class QueueName extends EnumClass {

  @BuiltValueEnumConst(wireName: r'thumbnailGeneration')
  static const QueueName thumbnailGeneration = _$thumbnailGeneration;
  @BuiltValueEnumConst(wireName: r'metadataExtraction')
  static const QueueName metadataExtraction = _$metadataExtraction;
  @BuiltValueEnumConst(wireName: r'videoConversion')
  static const QueueName videoConversion = _$videoConversion;
  @BuiltValueEnumConst(wireName: r'faceDetection')
  static const QueueName faceDetection = _$faceDetection;
  @BuiltValueEnumConst(wireName: r'facialRecognition')
  static const QueueName facialRecognition = _$facialRecognition;
  @BuiltValueEnumConst(wireName: r'smartSearch')
  static const QueueName smartSearch = _$smartSearch;
  @BuiltValueEnumConst(wireName: r'duplicateDetection')
  static const QueueName duplicateDetection = _$duplicateDetection;
  @BuiltValueEnumConst(wireName: r'backgroundTask')
  static const QueueName backgroundTask = _$backgroundTask;
  @BuiltValueEnumConst(wireName: r'storageTemplateMigration')
  static const QueueName storageTemplateMigration = _$storageTemplateMigration;
  @BuiltValueEnumConst(wireName: r'migration')
  static const QueueName migration = _$migration;
  @BuiltValueEnumConst(wireName: r'search')
  static const QueueName search = _$search;
  @BuiltValueEnumConst(wireName: r'sidecar')
  static const QueueName sidecar = _$sidecar;
  @BuiltValueEnumConst(wireName: r'library')
  static const QueueName library_ = _$library_;
  @BuiltValueEnumConst(wireName: r'notifications')
  static const QueueName notifications = _$notifications;
  @BuiltValueEnumConst(wireName: r'backupDatabase')
  static const QueueName backupDatabase = _$backupDatabase;
  @BuiltValueEnumConst(wireName: r'ocr')
  static const QueueName ocr = _$ocr;
  @BuiltValueEnumConst(wireName: r'pdfProcessing')
  static const QueueName pdfProcessing = _$pdfProcessing;
  @BuiltValueEnumConst(wireName: r'workflow')
  static const QueueName workflow = _$workflow;
  @BuiltValueEnumConst(wireName: r'integrityCheck')
  static const QueueName integrityCheck = _$integrityCheck;
  @BuiltValueEnumConst(wireName: r'editor')
  static const QueueName editor = _$editor;
  @BuiltValueEnumConst(wireName: r'imageInterpretation')
  static const QueueName imageInterpretation = _$imageInterpretation;
  @BuiltValueEnumConst(wireName: r'imageInterpretationPublic')
  static const QueueName imageInterpretationPublic = _$imageInterpretationPublic;
  @BuiltValueEnumConst(wireName: r'aiInterpretSearch')
  static const QueueName aiInterpretSearch = _$aiInterpretSearch;
  @BuiltValueEnumConst(wireName: r'videoFaceScan')
  static const QueueName videoFaceScan = _$videoFaceScan;
  @BuiltValueEnumConst(wireName: r'videoCaptioning')
  static const QueueName videoCaptioning = _$videoCaptioning;
  @BuiltValueEnumConst(wireName: r'videoTranscription')
  static const QueueName videoTranscription = _$videoTranscription;
  @BuiltValueEnumConst(wireName: r'transcriptIndexSync')
  static const QueueName transcriptIndexSync = _$transcriptIndexSync;

  static Serializer<QueueName> get serializer => _$queueNameSerializer;

  const QueueName._(String name): super(name);

  static BuiltSet<QueueName> get values => _$values;
  static QueueName valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class QueueNameMixin = Object with _$QueueNameMixin;

