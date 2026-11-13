//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/passkey_authentication_finish_dto_response_response.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'passkey_authentication_finish_dto_response.g.dart';

/// Response returned by @simplewebauthn/browser's `startAuthentication()`
///
/// Properties:
/// * [id] - Credential ID
/// * [response] 
@BuiltValue()
abstract class PasskeyAuthenticationFinishDtoResponse implements Built<PasskeyAuthenticationFinishDtoResponse, PasskeyAuthenticationFinishDtoResponseBuilder> {
  /// Credential ID
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'response')
  PasskeyAuthenticationFinishDtoResponseResponse get response;

  PasskeyAuthenticationFinishDtoResponse._();

  factory PasskeyAuthenticationFinishDtoResponse([void updates(PasskeyAuthenticationFinishDtoResponseBuilder b)]) = _$PasskeyAuthenticationFinishDtoResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PasskeyAuthenticationFinishDtoResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PasskeyAuthenticationFinishDtoResponse> get serializer => _$PasskeyAuthenticationFinishDtoResponseSerializer();
}

class _$PasskeyAuthenticationFinishDtoResponseSerializer implements PrimitiveSerializer<PasskeyAuthenticationFinishDtoResponse> {
  @override
  final Iterable<Type> types = const [PasskeyAuthenticationFinishDtoResponse, _$PasskeyAuthenticationFinishDtoResponse];

  @override
  final String wireName = r'PasskeyAuthenticationFinishDtoResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PasskeyAuthenticationFinishDtoResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'response';
    yield serializers.serialize(
      object.response,
      specifiedType: const FullType(PasskeyAuthenticationFinishDtoResponseResponse),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PasskeyAuthenticationFinishDtoResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PasskeyAuthenticationFinishDtoResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'response':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PasskeyAuthenticationFinishDtoResponseResponse),
          ) as PasskeyAuthenticationFinishDtoResponseResponse;
          result.response = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PasskeyAuthenticationFinishDtoResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PasskeyAuthenticationFinishDtoResponseBuilder();
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


