//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_config_server_dto.g.dart';

/// PublicConfigServerDto
///
/// Properties:
/// * [loginPageMessage] - Login page message
@BuiltValue()
abstract class PublicConfigServerDto implements Built<PublicConfigServerDto, PublicConfigServerDtoBuilder> {
  /// Login page message
  @BuiltValueField(wireName: r'loginPageMessage')
  String get loginPageMessage;

  PublicConfigServerDto._();

  factory PublicConfigServerDto([void updates(PublicConfigServerDtoBuilder b)]) = _$PublicConfigServerDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicConfigServerDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicConfigServerDto> get serializer => _$PublicConfigServerDtoSerializer();
}

class _$PublicConfigServerDtoSerializer implements PrimitiveSerializer<PublicConfigServerDto> {
  @override
  final Iterable<Type> types = const [PublicConfigServerDto, _$PublicConfigServerDto];

  @override
  final String wireName = r'PublicConfigServerDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicConfigServerDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'loginPageMessage';
    yield serializers.serialize(
      object.loginPageMessage,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicConfigServerDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicConfigServerDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'loginPageMessage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.loginPageMessage = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicConfigServerDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicConfigServerDtoBuilder();
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


