//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/admin_config_image_dto.dart';
import 'package:openapi/src/model/admin_config_password_login_dto.dart';
import 'package:openapi/src/model/admin_config_library_dto.dart';
import 'package:openapi/src/model/admin_config_f_fmpeg_dto.dart';
import 'package:openapi/src/model/admin_config_notifications_dto.dart';
import 'package:openapi/src/model/admin_config_transcription_search_dto.dart';
import 'package:openapi/src/model/admin_config_machine_learning_dto.dart';
import 'package:openapi/src/model/admin_config_integrity_checks_dto.dart';
import 'package:openapi/src/model/admin_config_metadata_dto.dart';
import 'package:openapi/src/model/admin_config_reverse_geocoding_dto.dart';
import 'package:openapi/src/model/admin_config_templates_dto.dart';
import 'package:openapi/src/model/admin_config_backups_dto.dart';
import 'package:openapi/src/model/admin_config_job_dto.dart';
import 'package:openapi/src/model/admin_config_logging_dto.dart';
import 'package:openapi/src/model/admin_config_o_auth_dto.dart';
import 'package:openapi/src/model/admin_config_server_dto.dart';
import 'package:openapi/src/model/admin_config_new_version_check_dto.dart';
import 'package:openapi/src/model/admin_config_storage_template_dto.dart';
import 'package:openapi/src/model/admin_config_map_dto.dart';
import 'package:openapi/src/model/admin_config_trash_dto.dart';
import 'package:openapi/src/model/admin_config_nightly_tasks_dto.dart';
import 'package:openapi/src/model/admin_config_theme_dto.dart';
import 'package:openapi/src/model/admin_config_user_dto.dart';
import 'package:openapi/src/model/admin_config_passkey_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_dto.g.dart';

/// Configuration properties that are visible to the admin
///
/// Properties:
/// * [backup] 
/// * [ffmpeg] 
/// * [image] 
/// * [integrityChecks] 
/// * [job] 
/// * [library_] 
/// * [logging] 
/// * [machineLearning] 
/// * [map] 
/// * [metadata] 
/// * [newVersionCheck] 
/// * [nightlyTasks] 
/// * [notifications] 
/// * [oauth] 
/// * [passkey] 
/// * [passwordLogin] 
/// * [reverseGeocoding] 
/// * [server] 
/// * [storageTemplate] 
/// * [templates] 
/// * [theme] 
/// * [transcriptionSearch] 
/// * [trash] 
/// * [user] 
@BuiltValue()
abstract class AdminConfigDto implements Built<AdminConfigDto, AdminConfigDtoBuilder> {
  @BuiltValueField(wireName: r'backup')
  AdminConfigBackupsDto get backup;

  @BuiltValueField(wireName: r'ffmpeg')
  AdminConfigFFmpegDto get ffmpeg;

  @BuiltValueField(wireName: r'image')
  AdminConfigImageDto get image;

  @BuiltValueField(wireName: r'integrityChecks')
  AdminConfigIntegrityChecksDto get integrityChecks;

  @BuiltValueField(wireName: r'job')
  AdminConfigJobDto get job;

  @BuiltValueField(wireName: r'library')
  AdminConfigLibraryDto get library_;

  @BuiltValueField(wireName: r'logging')
  AdminConfigLoggingDto get logging;

  @BuiltValueField(wireName: r'machineLearning')
  AdminConfigMachineLearningDto get machineLearning;

  @BuiltValueField(wireName: r'map')
  AdminConfigMapDto get map;

  @BuiltValueField(wireName: r'metadata')
  AdminConfigMetadataDto get metadata;

  @BuiltValueField(wireName: r'newVersionCheck')
  AdminConfigNewVersionCheckDto get newVersionCheck;

  @BuiltValueField(wireName: r'nightlyTasks')
  AdminConfigNightlyTasksDto get nightlyTasks;

  @BuiltValueField(wireName: r'notifications')
  AdminConfigNotificationsDto get notifications;

  @BuiltValueField(wireName: r'oauth')
  AdminConfigOAuthDto get oauth;

  @BuiltValueField(wireName: r'passkey')
  AdminConfigPasskeyDto get passkey;

  @BuiltValueField(wireName: r'passwordLogin')
  AdminConfigPasswordLoginDto get passwordLogin;

  @BuiltValueField(wireName: r'reverseGeocoding')
  AdminConfigReverseGeocodingDto get reverseGeocoding;

  @BuiltValueField(wireName: r'server')
  AdminConfigServerDto get server;

  @BuiltValueField(wireName: r'storageTemplate')
  AdminConfigStorageTemplateDto get storageTemplate;

  @BuiltValueField(wireName: r'templates')
  AdminConfigTemplatesDto get templates;

  @BuiltValueField(wireName: r'theme')
  AdminConfigThemeDto get theme;

  @BuiltValueField(wireName: r'transcriptionSearch')
  AdminConfigTranscriptionSearchDto get transcriptionSearch;

  @BuiltValueField(wireName: r'trash')
  AdminConfigTrashDto get trash;

  @BuiltValueField(wireName: r'user')
  AdminConfigUserDto get user;

  AdminConfigDto._();

  factory AdminConfigDto([void updates(AdminConfigDtoBuilder b)]) = _$AdminConfigDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigDto> get serializer => _$AdminConfigDtoSerializer();
}

class _$AdminConfigDtoSerializer implements PrimitiveSerializer<AdminConfigDto> {
  @override
  final Iterable<Type> types = const [AdminConfigDto, _$AdminConfigDto];

  @override
  final String wireName = r'AdminConfigDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'backup';
    yield serializers.serialize(
      object.backup,
      specifiedType: const FullType(AdminConfigBackupsDto),
    );
    yield r'ffmpeg';
    yield serializers.serialize(
      object.ffmpeg,
      specifiedType: const FullType(AdminConfigFFmpegDto),
    );
    yield r'image';
    yield serializers.serialize(
      object.image,
      specifiedType: const FullType(AdminConfigImageDto),
    );
    yield r'integrityChecks';
    yield serializers.serialize(
      object.integrityChecks,
      specifiedType: const FullType(AdminConfigIntegrityChecksDto),
    );
    yield r'job';
    yield serializers.serialize(
      object.job,
      specifiedType: const FullType(AdminConfigJobDto),
    );
    yield r'library';
    yield serializers.serialize(
      object.library_,
      specifiedType: const FullType(AdminConfigLibraryDto),
    );
    yield r'logging';
    yield serializers.serialize(
      object.logging,
      specifiedType: const FullType(AdminConfigLoggingDto),
    );
    yield r'machineLearning';
    yield serializers.serialize(
      object.machineLearning,
      specifiedType: const FullType(AdminConfigMachineLearningDto),
    );
    yield r'map';
    yield serializers.serialize(
      object.map,
      specifiedType: const FullType(AdminConfigMapDto),
    );
    yield r'metadata';
    yield serializers.serialize(
      object.metadata,
      specifiedType: const FullType(AdminConfigMetadataDto),
    );
    yield r'newVersionCheck';
    yield serializers.serialize(
      object.newVersionCheck,
      specifiedType: const FullType(AdminConfigNewVersionCheckDto),
    );
    yield r'nightlyTasks';
    yield serializers.serialize(
      object.nightlyTasks,
      specifiedType: const FullType(AdminConfigNightlyTasksDto),
    );
    yield r'notifications';
    yield serializers.serialize(
      object.notifications,
      specifiedType: const FullType(AdminConfigNotificationsDto),
    );
    yield r'oauth';
    yield serializers.serialize(
      object.oauth,
      specifiedType: const FullType(AdminConfigOAuthDto),
    );
    yield r'passkey';
    yield serializers.serialize(
      object.passkey,
      specifiedType: const FullType(AdminConfigPasskeyDto),
    );
    yield r'passwordLogin';
    yield serializers.serialize(
      object.passwordLogin,
      specifiedType: const FullType(AdminConfigPasswordLoginDto),
    );
    yield r'reverseGeocoding';
    yield serializers.serialize(
      object.reverseGeocoding,
      specifiedType: const FullType(AdminConfigReverseGeocodingDto),
    );
    yield r'server';
    yield serializers.serialize(
      object.server,
      specifiedType: const FullType(AdminConfigServerDto),
    );
    yield r'storageTemplate';
    yield serializers.serialize(
      object.storageTemplate,
      specifiedType: const FullType(AdminConfigStorageTemplateDto),
    );
    yield r'templates';
    yield serializers.serialize(
      object.templates,
      specifiedType: const FullType(AdminConfigTemplatesDto),
    );
    yield r'theme';
    yield serializers.serialize(
      object.theme,
      specifiedType: const FullType(AdminConfigThemeDto),
    );
    yield r'transcriptionSearch';
    yield serializers.serialize(
      object.transcriptionSearch,
      specifiedType: const FullType(AdminConfigTranscriptionSearchDto),
    );
    yield r'trash';
    yield serializers.serialize(
      object.trash,
      specifiedType: const FullType(AdminConfigTrashDto),
    );
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(AdminConfigUserDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'backup':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigBackupsDto),
          ) as AdminConfigBackupsDto;
          result.backup.replace(valueDes);
          break;
        case r'ffmpeg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigFFmpegDto),
          ) as AdminConfigFFmpegDto;
          result.ffmpeg.replace(valueDes);
          break;
        case r'image':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigImageDto),
          ) as AdminConfigImageDto;
          result.image.replace(valueDes);
          break;
        case r'integrityChecks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigIntegrityChecksDto),
          ) as AdminConfigIntegrityChecksDto;
          result.integrityChecks.replace(valueDes);
          break;
        case r'job':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigJobDto),
          ) as AdminConfigJobDto;
          result.job.replace(valueDes);
          break;
        case r'library':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigLibraryDto),
          ) as AdminConfigLibraryDto;
          result.library_.replace(valueDes);
          break;
        case r'logging':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigLoggingDto),
          ) as AdminConfigLoggingDto;
          result.logging.replace(valueDes);
          break;
        case r'machineLearning':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigMachineLearningDto),
          ) as AdminConfigMachineLearningDto;
          result.machineLearning.replace(valueDes);
          break;
        case r'map':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigMapDto),
          ) as AdminConfigMapDto;
          result.map.replace(valueDes);
          break;
        case r'metadata':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigMetadataDto),
          ) as AdminConfigMetadataDto;
          result.metadata.replace(valueDes);
          break;
        case r'newVersionCheck':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigNewVersionCheckDto),
          ) as AdminConfigNewVersionCheckDto;
          result.newVersionCheck.replace(valueDes);
          break;
        case r'nightlyTasks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigNightlyTasksDto),
          ) as AdminConfigNightlyTasksDto;
          result.nightlyTasks.replace(valueDes);
          break;
        case r'notifications':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigNotificationsDto),
          ) as AdminConfigNotificationsDto;
          result.notifications.replace(valueDes);
          break;
        case r'oauth':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigOAuthDto),
          ) as AdminConfigOAuthDto;
          result.oauth.replace(valueDes);
          break;
        case r'passkey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigPasskeyDto),
          ) as AdminConfigPasskeyDto;
          result.passkey.replace(valueDes);
          break;
        case r'passwordLogin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigPasswordLoginDto),
          ) as AdminConfigPasswordLoginDto;
          result.passwordLogin.replace(valueDes);
          break;
        case r'reverseGeocoding':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigReverseGeocodingDto),
          ) as AdminConfigReverseGeocodingDto;
          result.reverseGeocoding.replace(valueDes);
          break;
        case r'server':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigServerDto),
          ) as AdminConfigServerDto;
          result.server.replace(valueDes);
          break;
        case r'storageTemplate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigStorageTemplateDto),
          ) as AdminConfigStorageTemplateDto;
          result.storageTemplate.replace(valueDes);
          break;
        case r'templates':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigTemplatesDto),
          ) as AdminConfigTemplatesDto;
          result.templates.replace(valueDes);
          break;
        case r'theme':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigThemeDto),
          ) as AdminConfigThemeDto;
          result.theme.replace(valueDes);
          break;
        case r'transcriptionSearch':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigTranscriptionSearchDto),
          ) as AdminConfigTranscriptionSearchDto;
          result.transcriptionSearch.replace(valueDes);
          break;
        case r'trash':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigTrashDto),
          ) as AdminConfigTrashDto;
          result.trash.replace(valueDes);
          break;
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigUserDto),
          ) as AdminConfigUserDto;
          result.user.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigDtoBuilder();
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


