//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'o_auth_callback_dto.g.dart';

/// OAuthCallbackDto
///
/// Properties:
/// * [codeVerifier] - OAuth code verifier (PKCE)
/// * [state] - OAuth state parameter
/// * [url] - OAuth callback URL
@BuiltValue()
abstract class OAuthCallbackDto implements Built<OAuthCallbackDto, OAuthCallbackDtoBuilder> {
  /// OAuth code verifier (PKCE)
  @BuiltValueField(wireName: r'codeVerifier')
  String? get codeVerifier;

  /// OAuth state parameter
  @BuiltValueField(wireName: r'state')
  String? get state;

  /// OAuth callback URL
  @BuiltValueField(wireName: r'url')
  String get url;

  OAuthCallbackDto._();

  factory OAuthCallbackDto([void updates(OAuthCallbackDtoBuilder b)]) = _$OAuthCallbackDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OAuthCallbackDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OAuthCallbackDto> get serializer => _$OAuthCallbackDtoSerializer();
}

class _$OAuthCallbackDtoSerializer implements PrimitiveSerializer<OAuthCallbackDto> {
  @override
  final Iterable<Type> types = const [OAuthCallbackDto, _$OAuthCallbackDto];

  @override
  final String wireName = r'OAuthCallbackDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OAuthCallbackDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.codeVerifier != null) {
      yield r'codeVerifier';
      yield serializers.serialize(
        object.codeVerifier,
        specifiedType: const FullType(String),
      );
    }
    if (object.state != null) {
      yield r'state';
      yield serializers.serialize(
        object.state,
        specifiedType: const FullType(String),
      );
    }
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OAuthCallbackDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OAuthCallbackDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'codeVerifier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.codeVerifier = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.state = valueDes;
          break;
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OAuthCallbackDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OAuthCallbackDtoBuilder();
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


