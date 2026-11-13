//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'o_auth_config_dto.g.dart';

/// OAuthConfigDto
///
/// Properties:
/// * [codeChallenge] - OAuth code challenge (PKCE)
/// * [redirectUri] - OAuth redirect URI
/// * [state] - OAuth state parameter
@BuiltValue()
abstract class OAuthConfigDto implements Built<OAuthConfigDto, OAuthConfigDtoBuilder> {
  /// OAuth code challenge (PKCE)
  @BuiltValueField(wireName: r'codeChallenge')
  String? get codeChallenge;

  /// OAuth redirect URI
  @BuiltValueField(wireName: r'redirectUri')
  String get redirectUri;

  /// OAuth state parameter
  @BuiltValueField(wireName: r'state')
  String? get state;

  OAuthConfigDto._();

  factory OAuthConfigDto([void updates(OAuthConfigDtoBuilder b)]) = _$OAuthConfigDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OAuthConfigDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OAuthConfigDto> get serializer => _$OAuthConfigDtoSerializer();
}

class _$OAuthConfigDtoSerializer implements PrimitiveSerializer<OAuthConfigDto> {
  @override
  final Iterable<Type> types = const [OAuthConfigDto, _$OAuthConfigDto];

  @override
  final String wireName = r'OAuthConfigDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OAuthConfigDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.codeChallenge != null) {
      yield r'codeChallenge';
      yield serializers.serialize(
        object.codeChallenge,
        specifiedType: const FullType(String),
      );
    }
    yield r'redirectUri';
    yield serializers.serialize(
      object.redirectUri,
      specifiedType: const FullType(String),
    );
    if (object.state != null) {
      yield r'state';
      yield serializers.serialize(
        object.state,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    OAuthConfigDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OAuthConfigDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'codeChallenge':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.codeChallenge = valueDes;
          break;
        case r'redirectUri':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.redirectUri = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.state = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OAuthConfigDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OAuthConfigDtoBuilder();
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


