//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'passkey_response_dto.g.dart';

/// PasskeyResponseDto
///
/// Properties:
/// * [createdAt] - Creation date
/// * [id] - Passkey ID
/// * [name] - Passkey name
/// * [updatedAt] - Last update date
/// * [usedAt] - Last used date
@BuiltValue()
abstract class PasskeyResponseDto implements Built<PasskeyResponseDto, PasskeyResponseDtoBuilder> {
  /// Creation date
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// Passkey ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Passkey name
  @BuiltValueField(wireName: r'name')
  String? get name;

  /// Last update date
  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  /// Last used date
  @BuiltValueField(wireName: r'usedAt')
  DateTime? get usedAt;

  PasskeyResponseDto._();

  factory PasskeyResponseDto([void updates(PasskeyResponseDtoBuilder b)]) = _$PasskeyResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PasskeyResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PasskeyResponseDto> get serializer => _$PasskeyResponseDtoSerializer();
}

class _$PasskeyResponseDtoSerializer implements PrimitiveSerializer<PasskeyResponseDto> {
  @override
  final Iterable<Type> types = const [PasskeyResponseDto, _$PasskeyResponseDto];

  @override
  final String wireName = r'PasskeyResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PasskeyResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield object.name == null ? null : serializers.serialize(
      object.name,
      specifiedType: const FullType.nullable(String),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'usedAt';
    yield object.usedAt == null ? null : serializers.serialize(
      object.usedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PasskeyResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PasskeyResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        case r'usedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.usedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PasskeyResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PasskeyResponseDtoBuilder();
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


