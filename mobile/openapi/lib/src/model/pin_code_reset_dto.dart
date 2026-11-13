//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pin_code_reset_dto.g.dart';

/// PinCodeResetDto
///
/// Properties:
/// * [password] - User password (required if PIN code is not provided)
/// * [pinCode] - New PIN code (4-6 digits)
@BuiltValue()
abstract class PinCodeResetDto implements Built<PinCodeResetDto, PinCodeResetDtoBuilder> {
  /// User password (required if PIN code is not provided)
  @BuiltValueField(wireName: r'password')
  String? get password;

  /// New PIN code (4-6 digits)
  @BuiltValueField(wireName: r'pinCode')
  String? get pinCode;

  PinCodeResetDto._();

  factory PinCodeResetDto([void updates(PinCodeResetDtoBuilder b)]) = _$PinCodeResetDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PinCodeResetDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PinCodeResetDto> get serializer => _$PinCodeResetDtoSerializer();
}

class _$PinCodeResetDtoSerializer implements PrimitiveSerializer<PinCodeResetDto> {
  @override
  final Iterable<Type> types = const [PinCodeResetDto, _$PinCodeResetDto];

  @override
  final String wireName = r'PinCodeResetDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PinCodeResetDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.password != null) {
      yield r'password';
      yield serializers.serialize(
        object.password,
        specifiedType: const FullType(String),
      );
    }
    if (object.pinCode != null) {
      yield r'pinCode';
      yield serializers.serialize(
        object.pinCode,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PinCodeResetDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PinCodeResetDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.password = valueDes;
          break;
        case r'pinCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.pinCode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PinCodeResetDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PinCodeResetDtoBuilder();
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


