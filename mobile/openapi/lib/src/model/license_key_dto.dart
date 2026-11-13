//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'license_key_dto.g.dart';

/// LicenseKeyDto
///
/// Properties:
/// * [activationKey] - Activation key
/// * [licenseKey] - License key (format: /^IM(SV|CL)(-[\\dA-Za-z]{4}){8}$/)
@BuiltValue()
abstract class LicenseKeyDto implements Built<LicenseKeyDto, LicenseKeyDtoBuilder> {
  /// Activation key
  @BuiltValueField(wireName: r'activationKey')
  String get activationKey;

  /// License key (format: /^IM(SV|CL)(-[\\dA-Za-z]{4}){8}$/)
  @BuiltValueField(wireName: r'licenseKey')
  String get licenseKey;

  LicenseKeyDto._();

  factory LicenseKeyDto([void updates(LicenseKeyDtoBuilder b)]) = _$LicenseKeyDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LicenseKeyDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LicenseKeyDto> get serializer => _$LicenseKeyDtoSerializer();
}

class _$LicenseKeyDtoSerializer implements PrimitiveSerializer<LicenseKeyDto> {
  @override
  final Iterable<Type> types = const [LicenseKeyDto, _$LicenseKeyDto];

  @override
  final String wireName = r'LicenseKeyDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LicenseKeyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'activationKey';
    yield serializers.serialize(
      object.activationKey,
      specifiedType: const FullType(String),
    );
    yield r'licenseKey';
    yield serializers.serialize(
      object.licenseKey,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LicenseKeyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LicenseKeyDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'activationKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.activationKey = valueDes;
          break;
        case r'licenseKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.licenseKey = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LicenseKeyDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LicenseKeyDtoBuilder();
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


