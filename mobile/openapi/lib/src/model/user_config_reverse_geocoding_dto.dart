//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_config_reverse_geocoding_dto.g.dart';

/// UserConfigReverseGeocodingDto
///
/// Properties:
/// * [enabled] - Enabled
@BuiltValue()
abstract class UserConfigReverseGeocodingDto implements Built<UserConfigReverseGeocodingDto, UserConfigReverseGeocodingDtoBuilder> {
  /// Enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  UserConfigReverseGeocodingDto._();

  factory UserConfigReverseGeocodingDto([void updates(UserConfigReverseGeocodingDtoBuilder b)]) = _$UserConfigReverseGeocodingDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserConfigReverseGeocodingDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserConfigReverseGeocodingDto> get serializer => _$UserConfigReverseGeocodingDtoSerializer();
}

class _$UserConfigReverseGeocodingDtoSerializer implements PrimitiveSerializer<UserConfigReverseGeocodingDto> {
  @override
  final Iterable<Type> types = const [UserConfigReverseGeocodingDto, _$UserConfigReverseGeocodingDto];

  @override
  final String wireName = r'UserConfigReverseGeocodingDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserConfigReverseGeocodingDto object, {
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
    UserConfigReverseGeocodingDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserConfigReverseGeocodingDtoBuilder result,
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
  UserConfigReverseGeocodingDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserConfigReverseGeocodingDtoBuilder();
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


