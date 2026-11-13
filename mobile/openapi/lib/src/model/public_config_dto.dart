//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/public_config_password_login_dto.dart';
import 'package:openapi/src/model/public_config_f_fmpeg_dto.dart';
import 'package:openapi/src/model/public_config_o_auth_dto.dart';
import 'package:openapi/src/model/public_config_map_dto.dart';
import 'package:openapi/src/model/public_config_server_dto.dart';
import 'package:openapi/src/model/public_config_passkey_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_config_dto.g.dart';

/// Configuration properties that are visible to everyone
///
/// Properties:
/// * [ffmpeg] 
/// * [map] 
/// * [oauth] 
/// * [passkey] 
/// * [passwordLogin] 
/// * [server] 
@BuiltValue()
abstract class PublicConfigDto implements Built<PublicConfigDto, PublicConfigDtoBuilder> {
  @BuiltValueField(wireName: r'ffmpeg')
  PublicConfigFFmpegDto get ffmpeg;

  @BuiltValueField(wireName: r'map')
  PublicConfigMapDto get map;

  @BuiltValueField(wireName: r'oauth')
  PublicConfigOAuthDto get oauth;

  @BuiltValueField(wireName: r'passkey')
  PublicConfigPasskeyDto get passkey;

  @BuiltValueField(wireName: r'passwordLogin')
  PublicConfigPasswordLoginDto get passwordLogin;

  @BuiltValueField(wireName: r'server')
  PublicConfigServerDto get server;

  PublicConfigDto._();

  factory PublicConfigDto([void updates(PublicConfigDtoBuilder b)]) = _$PublicConfigDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicConfigDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicConfigDto> get serializer => _$PublicConfigDtoSerializer();
}

class _$PublicConfigDtoSerializer implements PrimitiveSerializer<PublicConfigDto> {
  @override
  final Iterable<Type> types = const [PublicConfigDto, _$PublicConfigDto];

  @override
  final String wireName = r'PublicConfigDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicConfigDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ffmpeg';
    yield serializers.serialize(
      object.ffmpeg,
      specifiedType: const FullType(PublicConfigFFmpegDto),
    );
    yield r'map';
    yield serializers.serialize(
      object.map,
      specifiedType: const FullType(PublicConfigMapDto),
    );
    yield r'oauth';
    yield serializers.serialize(
      object.oauth,
      specifiedType: const FullType(PublicConfigOAuthDto),
    );
    yield r'passkey';
    yield serializers.serialize(
      object.passkey,
      specifiedType: const FullType(PublicConfigPasskeyDto),
    );
    yield r'passwordLogin';
    yield serializers.serialize(
      object.passwordLogin,
      specifiedType: const FullType(PublicConfigPasswordLoginDto),
    );
    yield r'server';
    yield serializers.serialize(
      object.server,
      specifiedType: const FullType(PublicConfigServerDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicConfigDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicConfigDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ffmpeg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicConfigFFmpegDto),
          ) as PublicConfigFFmpegDto;
          result.ffmpeg.replace(valueDes);
          break;
        case r'map':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicConfigMapDto),
          ) as PublicConfigMapDto;
          result.map.replace(valueDes);
          break;
        case r'oauth':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicConfigOAuthDto),
          ) as PublicConfigOAuthDto;
          result.oauth.replace(valueDes);
          break;
        case r'passkey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicConfigPasskeyDto),
          ) as PublicConfigPasskeyDto;
          result.passkey.replace(valueDes);
          break;
        case r'passwordLogin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicConfigPasswordLoginDto),
          ) as PublicConfigPasswordLoginDto;
          result.passwordLogin.replace(valueDes);
          break;
        case r'server':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicConfigServerDto),
          ) as PublicConfigServerDto;
          result.server.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicConfigDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicConfigDtoBuilder();
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


