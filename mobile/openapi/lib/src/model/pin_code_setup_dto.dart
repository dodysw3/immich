//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pin_code_setup_dto.g.dart';

/// PinCodeSetupDto
///
/// Properties:
/// * [pinCode] - PIN code (4-6 digits)
@BuiltValue()
abstract class PinCodeSetupDto implements Built<PinCodeSetupDto, PinCodeSetupDtoBuilder> {
  /// PIN code (4-6 digits)
  @BuiltValueField(wireName: r'pinCode')
  String get pinCode;

  PinCodeSetupDto._();

  factory PinCodeSetupDto([void updates(PinCodeSetupDtoBuilder b)]) = _$PinCodeSetupDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PinCodeSetupDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PinCodeSetupDto> get serializer => _$PinCodeSetupDtoSerializer();
}

class _$PinCodeSetupDtoSerializer implements PrimitiveSerializer<PinCodeSetupDto> {
  @override
  final Iterable<Type> types = const [PinCodeSetupDto, _$PinCodeSetupDto];

  @override
  final String wireName = r'PinCodeSetupDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PinCodeSetupDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'pinCode';
    yield serializers.serialize(
      object.pinCode,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PinCodeSetupDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PinCodeSetupDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pinCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  PinCodeSetupDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PinCodeSetupDtoBuilder();
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


