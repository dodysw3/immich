//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/passkey_authentication_finish_dto_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'passkey_authentication_finish_dto.g.dart';

/// PasskeyAuthenticationFinishDto
///
/// Properties:
/// * [response] 
@BuiltValue()
abstract class PasskeyAuthenticationFinishDto implements Built<PasskeyAuthenticationFinishDto, PasskeyAuthenticationFinishDtoBuilder> {
  @BuiltValueField(wireName: r'response')
  PasskeyAuthenticationFinishDtoResponse get response;

  PasskeyAuthenticationFinishDto._();

  factory PasskeyAuthenticationFinishDto([void updates(PasskeyAuthenticationFinishDtoBuilder b)]) = _$PasskeyAuthenticationFinishDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PasskeyAuthenticationFinishDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PasskeyAuthenticationFinishDto> get serializer => _$PasskeyAuthenticationFinishDtoSerializer();
}

class _$PasskeyAuthenticationFinishDtoSerializer implements PrimitiveSerializer<PasskeyAuthenticationFinishDto> {
  @override
  final Iterable<Type> types = const [PasskeyAuthenticationFinishDto, _$PasskeyAuthenticationFinishDto];

  @override
  final String wireName = r'PasskeyAuthenticationFinishDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PasskeyAuthenticationFinishDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'response';
    yield serializers.serialize(
      object.response,
      specifiedType: const FullType(PasskeyAuthenticationFinishDtoResponse),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PasskeyAuthenticationFinishDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PasskeyAuthenticationFinishDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'response':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PasskeyAuthenticationFinishDtoResponse),
          ) as PasskeyAuthenticationFinishDtoResponse;
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
  PasskeyAuthenticationFinishDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PasskeyAuthenticationFinishDtoBuilder();
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


