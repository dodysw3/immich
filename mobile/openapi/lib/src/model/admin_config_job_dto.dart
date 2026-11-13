//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/admin_config_job_settings_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_job_dto.g.dart';

/// AdminConfigJobDto
///
/// Properties:
/// * [backgroundTask] 
/// * [editor] 
/// * [faceDetection] 
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
/// * [thumbnailGeneration] 
/// * [videoConversion] 
/// * [workflow] 
@BuiltValue()
abstract class AdminConfigJobDto implements Built<AdminConfigJobDto, AdminConfigJobDtoBuilder> {
  @BuiltValueField(wireName: r'backgroundTask')
  AdminConfigJobSettingsDto get backgroundTask;

  @BuiltValueField(wireName: r'editor')
  AdminConfigJobSettingsDto get editor;

  @BuiltValueField(wireName: r'faceDetection')
  AdminConfigJobSettingsDto get faceDetection;

  @BuiltValueField(wireName: r'integrityCheck')
  AdminConfigJobSettingsDto get integrityCheck;

  @BuiltValueField(wireName: r'library')
  AdminConfigJobSettingsDto get library_;

  @BuiltValueField(wireName: r'metadataExtraction')
  AdminConfigJobSettingsDto get metadataExtraction;

  @BuiltValueField(wireName: r'migration')
  AdminConfigJobSettingsDto get migration;

  @BuiltValueField(wireName: r'notifications')
  AdminConfigJobSettingsDto get notifications;

  @BuiltValueField(wireName: r'ocr')
  AdminConfigJobSettingsDto get ocr;

  @BuiltValueField(wireName: r'pdfProcessing')
  AdminConfigJobSettingsDto get pdfProcessing;

  @BuiltValueField(wireName: r'search')
  AdminConfigJobSettingsDto get search;

  @BuiltValueField(wireName: r'sidecar')
  AdminConfigJobSettingsDto get sidecar;

  @BuiltValueField(wireName: r'smartSearch')
  AdminConfigJobSettingsDto get smartSearch;

  @BuiltValueField(wireName: r'thumbnailGeneration')
  AdminConfigJobSettingsDto get thumbnailGeneration;

  @BuiltValueField(wireName: r'videoConversion')
  AdminConfigJobSettingsDto get videoConversion;

  @BuiltValueField(wireName: r'workflow')
  AdminConfigJobSettingsDto get workflow;

  AdminConfigJobDto._();

  factory AdminConfigJobDto([void updates(AdminConfigJobDtoBuilder b)]) = _$AdminConfigJobDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigJobDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigJobDto> get serializer => _$AdminConfigJobDtoSerializer();
}

class _$AdminConfigJobDtoSerializer implements PrimitiveSerializer<AdminConfigJobDto> {
  @override
  final Iterable<Type> types = const [AdminConfigJobDto, _$AdminConfigJobDto];

  @override
  final String wireName = r'AdminConfigJobDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigJobDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'backgroundTask';
    yield serializers.serialize(
      object.backgroundTask,
      specifiedType: const FullType(AdminConfigJobSettingsDto),
    );
    yield r'editor';
    yield serializers.serialize(
      object.editor,
      specifiedType: const FullType(AdminConfigJobSettingsDto),
    );
    yield r'faceDetection';
    yield serializers.serialize(
      object.faceDetection,
      specifiedType: const FullType(AdminConfigJobSettingsDto),
    );
    yield r'integrityCheck';
    yield serializers.serialize(
      object.integrityCheck,
      specifiedType: const FullType(AdminConfigJobSettingsDto),
    );
    yield r'library';
    yield serializers.serialize(
      object.library_,
      specifiedType: const FullType(AdminConfigJobSettingsDto),
    );
    yield r'metadataExtraction';
    yield serializers.serialize(
      object.metadataExtraction,
      specifiedType: const FullType(AdminConfigJobSettingsDto),
    );
    yield r'migration';
    yield serializers.serialize(
      object.migration,
      specifiedType: const FullType(AdminConfigJobSettingsDto),
    );
    yield r'notifications';
    yield serializers.serialize(
      object.notifications,
      specifiedType: const FullType(AdminConfigJobSettingsDto),
    );
    yield r'ocr';
    yield serializers.serialize(
      object.ocr,
      specifiedType: const FullType(AdminConfigJobSettingsDto),
    );
    yield r'pdfProcessing';
    yield serializers.serialize(
      object.pdfProcessing,
      specifiedType: const FullType(AdminConfigJobSettingsDto),
    );
    yield r'search';
    yield serializers.serialize(
      object.search,
      specifiedType: const FullType(AdminConfigJobSettingsDto),
    );
    yield r'sidecar';
    yield serializers.serialize(
      object.sidecar,
      specifiedType: const FullType(AdminConfigJobSettingsDto),
    );
    yield r'smartSearch';
    yield serializers.serialize(
      object.smartSearch,
      specifiedType: const FullType(AdminConfigJobSettingsDto),
    );
    yield r'thumbnailGeneration';
    yield serializers.serialize(
      object.thumbnailGeneration,
      specifiedType: const FullType(AdminConfigJobSettingsDto),
    );
    yield r'videoConversion';
    yield serializers.serialize(
      object.videoConversion,
      specifiedType: const FullType(AdminConfigJobSettingsDto),
    );
    yield r'workflow';
    yield serializers.serialize(
      object.workflow,
      specifiedType: const FullType(AdminConfigJobSettingsDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigJobDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigJobDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'backgroundTask':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigJobSettingsDto),
          ) as AdminConfigJobSettingsDto;
          result.backgroundTask.replace(valueDes);
          break;
        case r'editor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigJobSettingsDto),
          ) as AdminConfigJobSettingsDto;
          result.editor.replace(valueDes);
          break;
        case r'faceDetection':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigJobSettingsDto),
          ) as AdminConfigJobSettingsDto;
          result.faceDetection.replace(valueDes);
          break;
        case r'integrityCheck':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigJobSettingsDto),
          ) as AdminConfigJobSettingsDto;
          result.integrityCheck.replace(valueDes);
          break;
        case r'library':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigJobSettingsDto),
          ) as AdminConfigJobSettingsDto;
          result.library_.replace(valueDes);
          break;
        case r'metadataExtraction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigJobSettingsDto),
          ) as AdminConfigJobSettingsDto;
          result.metadataExtraction.replace(valueDes);
          break;
        case r'migration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigJobSettingsDto),
          ) as AdminConfigJobSettingsDto;
          result.migration.replace(valueDes);
          break;
        case r'notifications':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigJobSettingsDto),
          ) as AdminConfigJobSettingsDto;
          result.notifications.replace(valueDes);
          break;
        case r'ocr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigJobSettingsDto),
          ) as AdminConfigJobSettingsDto;
          result.ocr.replace(valueDes);
          break;
        case r'pdfProcessing':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigJobSettingsDto),
          ) as AdminConfigJobSettingsDto;
          result.pdfProcessing.replace(valueDes);
          break;
        case r'search':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigJobSettingsDto),
          ) as AdminConfigJobSettingsDto;
          result.search.replace(valueDes);
          break;
        case r'sidecar':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigJobSettingsDto),
          ) as AdminConfigJobSettingsDto;
          result.sidecar.replace(valueDes);
          break;
        case r'smartSearch':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigJobSettingsDto),
          ) as AdminConfigJobSettingsDto;
          result.smartSearch.replace(valueDes);
          break;
        case r'thumbnailGeneration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigJobSettingsDto),
          ) as AdminConfigJobSettingsDto;
          result.thumbnailGeneration.replace(valueDes);
          break;
        case r'videoConversion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigJobSettingsDto),
          ) as AdminConfigJobSettingsDto;
          result.videoConversion.replace(valueDes);
          break;
        case r'workflow':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigJobSettingsDto),
          ) as AdminConfigJobSettingsDto;
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
  AdminConfigJobDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigJobDtoBuilder();
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


