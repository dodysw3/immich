//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user_config_user_dto.dart';
import 'package:openapi/src/model/user_config_machine_learning_dto.dart';
import 'package:openapi/src/model/user_config_f_fmpeg_dto.dart';
import 'package:openapi/src/model/user_config_password_login_dto.dart';
import 'package:openapi/src/model/user_config_reverse_geocoding_dto.dart';
import 'package:openapi/src/model/user_config_map_dto.dart';
import 'package:openapi/src/model/user_config_o_auth_dto.dart';
import 'package:openapi/src/model/user_config_server_dto.dart';
import 'package:openapi/src/model/user_config_passkey_dto.dart';
import 'package:openapi/src/model/user_config_image_dto.dart';
import 'package:openapi/src/model/user_config_notifications_dto.dart';
import 'package:openapi/src/model/user_config_trash_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_config_dto.g.dart';

/// Configuration properties that are visible to a logged user
///
/// Properties:
/// * [ffmpeg] 
/// * [image] 
/// * [machineLearning] 
/// * [map] 
/// * [notifications] 
/// * [oauth] 
/// * [passkey] 
/// * [passwordLogin] 
/// * [reverseGeocoding] 
/// * [server] 
/// * [trash] 
/// * [user] 
@BuiltValue()
abstract class UserConfigDto implements Built<UserConfigDto, UserConfigDtoBuilder> {
  @BuiltValueField(wireName: r'ffmpeg')
  UserConfigFFmpegDto get ffmpeg;

  @BuiltValueField(wireName: r'image')
  UserConfigImageDto get image;

  @BuiltValueField(wireName: r'machineLearning')
  UserConfigMachineLearningDto get machineLearning;

  @BuiltValueField(wireName: r'map')
  UserConfigMapDto get map;

  @BuiltValueField(wireName: r'notifications')
  UserConfigNotificationsDto get notifications;

  @BuiltValueField(wireName: r'oauth')
  UserConfigOAuthDto get oauth;

  @BuiltValueField(wireName: r'passkey')
  UserConfigPasskeyDto get passkey;

  @BuiltValueField(wireName: r'passwordLogin')
  UserConfigPasswordLoginDto get passwordLogin;

  @BuiltValueField(wireName: r'reverseGeocoding')
  UserConfigReverseGeocodingDto get reverseGeocoding;

  @BuiltValueField(wireName: r'server')
  UserConfigServerDto get server;

  @BuiltValueField(wireName: r'trash')
  UserConfigTrashDto get trash;

  @BuiltValueField(wireName: r'user')
  UserConfigUserDto get user;

  UserConfigDto._();

  factory UserConfigDto([void updates(UserConfigDtoBuilder b)]) = _$UserConfigDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserConfigDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserConfigDto> get serializer => _$UserConfigDtoSerializer();
}

class _$UserConfigDtoSerializer implements PrimitiveSerializer<UserConfigDto> {
  @override
  final Iterable<Type> types = const [UserConfigDto, _$UserConfigDto];

  @override
  final String wireName = r'UserConfigDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserConfigDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ffmpeg';
    yield serializers.serialize(
      object.ffmpeg,
      specifiedType: const FullType(UserConfigFFmpegDto),
    );
    yield r'image';
    yield serializers.serialize(
      object.image,
      specifiedType: const FullType(UserConfigImageDto),
    );
    yield r'machineLearning';
    yield serializers.serialize(
      object.machineLearning,
      specifiedType: const FullType(UserConfigMachineLearningDto),
    );
    yield r'map';
    yield serializers.serialize(
      object.map,
      specifiedType: const FullType(UserConfigMapDto),
    );
    yield r'notifications';
    yield serializers.serialize(
      object.notifications,
      specifiedType: const FullType(UserConfigNotificationsDto),
    );
    yield r'oauth';
    yield serializers.serialize(
      object.oauth,
      specifiedType: const FullType(UserConfigOAuthDto),
    );
    yield r'passkey';
    yield serializers.serialize(
      object.passkey,
      specifiedType: const FullType(UserConfigPasskeyDto),
    );
    yield r'passwordLogin';
    yield serializers.serialize(
      object.passwordLogin,
      specifiedType: const FullType(UserConfigPasswordLoginDto),
    );
    yield r'reverseGeocoding';
    yield serializers.serialize(
      object.reverseGeocoding,
      specifiedType: const FullType(UserConfigReverseGeocodingDto),
    );
    yield r'server';
    yield serializers.serialize(
      object.server,
      specifiedType: const FullType(UserConfigServerDto),
    );
    yield r'trash';
    yield serializers.serialize(
      object.trash,
      specifiedType: const FullType(UserConfigTrashDto),
    );
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(UserConfigUserDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserConfigDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserConfigDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ffmpeg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserConfigFFmpegDto),
          ) as UserConfigFFmpegDto;
          result.ffmpeg.replace(valueDes);
          break;
        case r'image':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserConfigImageDto),
          ) as UserConfigImageDto;
          result.image.replace(valueDes);
          break;
        case r'machineLearning':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserConfigMachineLearningDto),
          ) as UserConfigMachineLearningDto;
          result.machineLearning.replace(valueDes);
          break;
        case r'map':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserConfigMapDto),
          ) as UserConfigMapDto;
          result.map.replace(valueDes);
          break;
        case r'notifications':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserConfigNotificationsDto),
          ) as UserConfigNotificationsDto;
          result.notifications.replace(valueDes);
          break;
        case r'oauth':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserConfigOAuthDto),
          ) as UserConfigOAuthDto;
          result.oauth.replace(valueDes);
          break;
        case r'passkey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserConfigPasskeyDto),
          ) as UserConfigPasskeyDto;
          result.passkey.replace(valueDes);
          break;
        case r'passwordLogin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserConfigPasswordLoginDto),
          ) as UserConfigPasswordLoginDto;
          result.passwordLogin.replace(valueDes);
          break;
        case r'reverseGeocoding':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserConfigReverseGeocodingDto),
          ) as UserConfigReverseGeocodingDto;
          result.reverseGeocoding.replace(valueDes);
          break;
        case r'server':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserConfigServerDto),
          ) as UserConfigServerDto;
          result.server.replace(valueDes);
          break;
        case r'trash':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserConfigTrashDto),
          ) as UserConfigTrashDto;
          result.trash.replace(valueDes);
          break;
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserConfigUserDto),
          ) as UserConfigUserDto;
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
  UserConfigDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserConfigDtoBuilder();
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


