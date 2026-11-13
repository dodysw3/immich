//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_config_passkey_dto.g.dart';

/// PublicConfigPasskeyDto
///
/// Properties:
/// * [enabled] - Enabled
@BuiltValue()
abstract class PublicConfigPasskeyDto implements Built<PublicConfigPasskeyDto, PublicConfigPasskeyDtoBuilder> {
  /// Enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  PublicConfigPasskeyDto._();

  factory PublicConfigPasskeyDto([void updates(PublicConfigPasskeyDtoBuilder b)]) = _$PublicConfigPasskeyDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicConfigPasskeyDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicConfigPasskeyDto> get serializer => _$PublicConfigPasskeyDtoSerializer();
}

class _$PublicConfigPasskeyDtoSerializer implements PrimitiveSerializer<PublicConfigPasskeyDto> {
  @override
  final Iterable<Type> types = const [PublicConfigPasskeyDto, _$PublicConfigPasskeyDto];

  @override
  final String wireName = r'PublicConfigPasskeyDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicConfigPasskeyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicConfigPasskeyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicConfigPasskeyDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicConfigPasskeyDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicConfigPasskeyDtoBuilder();
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


