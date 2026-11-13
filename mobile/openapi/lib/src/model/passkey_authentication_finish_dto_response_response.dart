//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'passkey_authentication_finish_dto_response_response.g.dart';

/// PasskeyAuthenticationFinishDtoResponseResponse
///
/// Properties:
/// * [userHandle] - User handle
@BuiltValue()
abstract class PasskeyAuthenticationFinishDtoResponseResponse implements Built<PasskeyAuthenticationFinishDtoResponseResponse, PasskeyAuthenticationFinishDtoResponseResponseBuilder> {
  /// User handle
  @BuiltValueField(wireName: r'userHandle')
  String? get userHandle;

  PasskeyAuthenticationFinishDtoResponseResponse._();

  factory PasskeyAuthenticationFinishDtoResponseResponse([void updates(PasskeyAuthenticationFinishDtoResponseResponseBuilder b)]) = _$PasskeyAuthenticationFinishDtoResponseResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PasskeyAuthenticationFinishDtoResponseResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PasskeyAuthenticationFinishDtoResponseResponse> get serializer => _$PasskeyAuthenticationFinishDtoResponseResponseSerializer();
}

class _$PasskeyAuthenticationFinishDtoResponseResponseSerializer implements PrimitiveSerializer<PasskeyAuthenticationFinishDtoResponseResponse> {
  @override
  final Iterable<Type> types = const [PasskeyAuthenticationFinishDtoResponseResponse, _$PasskeyAuthenticationFinishDtoResponseResponse];

  @override
  final String wireName = r'PasskeyAuthenticationFinishDtoResponseResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PasskeyAuthenticationFinishDtoResponseResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.userHandle != null) {
      yield r'userHandle';
      yield serializers.serialize(
        object.userHandle,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PasskeyAuthenticationFinishDtoResponseResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PasskeyAuthenticationFinishDtoResponseResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'userHandle':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.userHandle = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PasskeyAuthenticationFinishDtoResponseResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PasskeyAuthenticationFinishDtoResponseResponseBuilder();
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


