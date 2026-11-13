//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_license.g.dart';

/// UserLicense
///
/// Properties:
/// * [activatedAt] - Activation date
/// * [activationKey] - Activation key
/// * [licenseKey] - License key (format: /^IM(SV|CL)(-[\\dA-Za-z]{4}){8}$/)
@BuiltValue()
abstract class UserLicense implements Built<UserLicense, UserLicenseBuilder> {
  /// Activation date
  @BuiltValueField(wireName: r'activatedAt')
  DateTime get activatedAt;

  /// Activation key
  @BuiltValueField(wireName: r'activationKey')
  String get activationKey;

  /// License key (format: /^IM(SV|CL)(-[\\dA-Za-z]{4}){8}$/)
  @BuiltValueField(wireName: r'licenseKey')
  String get licenseKey;

  UserLicense._();

  factory UserLicense([void updates(UserLicenseBuilder b)]) = _$UserLicense;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserLicenseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserLicense> get serializer => _$UserLicenseSerializer();
}

class _$UserLicenseSerializer implements PrimitiveSerializer<UserLicense> {
  @override
  final Iterable<Type> types = const [UserLicense, _$UserLicense];

  @override
  final String wireName = r'UserLicense';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserLicense object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'activatedAt';
    yield serializers.serialize(
      object.activatedAt,
      specifiedType: const FullType(DateTime),
    );
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
    UserLicense object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserLicenseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'activatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.activatedAt = valueDes;
          break;
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
  UserLicense deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserLicenseBuilder();
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


