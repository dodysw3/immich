//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'passkey_update_dto.g.dart';

/// PasskeyUpdateDto
///
/// Properties:
/// * [name] - Passkey name
@BuiltValue()
abstract class PasskeyUpdateDto implements Built<PasskeyUpdateDto, PasskeyUpdateDtoBuilder> {
  /// Passkey name
  @BuiltValueField(wireName: r'name')
  String? get name;

  PasskeyUpdateDto._();

  factory PasskeyUpdateDto([void updates(PasskeyUpdateDtoBuilder b)]) = _$PasskeyUpdateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PasskeyUpdateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PasskeyUpdateDto> get serializer => _$PasskeyUpdateDtoSerializer();
}

class _$PasskeyUpdateDtoSerializer implements PrimitiveSerializer<PasskeyUpdateDto> {
  @override
  final Iterable<Type> types = const [PasskeyUpdateDto, _$PasskeyUpdateDto];

  @override
  final String wireName = r'PasskeyUpdateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PasskeyUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield object.name == null ? null : serializers.serialize(
      object.name,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PasskeyUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PasskeyUpdateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PasskeyUpdateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PasskeyUpdateDtoBuilder();
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


