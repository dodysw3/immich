//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pin_code_change_dto.g.dart';

/// PinCodeChangeDto
///
/// Properties:
/// * [newPinCode] - New PIN code (4-6 digits)
/// * [password] - User password (required if PIN code is not provided)
/// * [pinCode] - New PIN code (4-6 digits)
@BuiltValue()
abstract class PinCodeChangeDto implements Built<PinCodeChangeDto, PinCodeChangeDtoBuilder> {
  /// New PIN code (4-6 digits)
  @BuiltValueField(wireName: r'newPinCode')
  String get newPinCode;

  /// User password (required if PIN code is not provided)
  @BuiltValueField(wireName: r'password')
  String? get password;

  /// New PIN code (4-6 digits)
  @BuiltValueField(wireName: r'pinCode')
  String? get pinCode;

  PinCodeChangeDto._();

  factory PinCodeChangeDto([void updates(PinCodeChangeDtoBuilder b)]) = _$PinCodeChangeDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PinCodeChangeDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PinCodeChangeDto> get serializer => _$PinCodeChangeDtoSerializer();
}

class _$PinCodeChangeDtoSerializer implements PrimitiveSerializer<PinCodeChangeDto> {
  @override
  final Iterable<Type> types = const [PinCodeChangeDto, _$PinCodeChangeDto];

  @override
  final String wireName = r'PinCodeChangeDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PinCodeChangeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'newPinCode';
    yield serializers.serialize(
      object.newPinCode,
      specifiedType: const FullType(String),
    );
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
    PinCodeChangeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PinCodeChangeDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'newPinCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.newPinCode = valueDes;
          break;
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
  PinCodeChangeDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PinCodeChangeDtoBuilder();
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


