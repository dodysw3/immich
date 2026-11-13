//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_reverse_geocoding_dto.g.dart';

/// AdminConfigReverseGeocodingDto
///
/// Properties:
/// * [enabled] - Enabled
@BuiltValue()
abstract class AdminConfigReverseGeocodingDto implements Built<AdminConfigReverseGeocodingDto, AdminConfigReverseGeocodingDtoBuilder> {
  /// Enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  AdminConfigReverseGeocodingDto._();

  factory AdminConfigReverseGeocodingDto([void updates(AdminConfigReverseGeocodingDtoBuilder b)]) = _$AdminConfigReverseGeocodingDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigReverseGeocodingDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigReverseGeocodingDto> get serializer => _$AdminConfigReverseGeocodingDtoSerializer();
}

class _$AdminConfigReverseGeocodingDtoSerializer implements PrimitiveSerializer<AdminConfigReverseGeocodingDto> {
  @override
  final Iterable<Type> types = const [AdminConfigReverseGeocodingDto, _$AdminConfigReverseGeocodingDto];

  @override
  final String wireName = r'AdminConfigReverseGeocodingDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigReverseGeocodingDto object, {
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
    AdminConfigReverseGeocodingDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigReverseGeocodingDtoBuilder result,
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
  AdminConfigReverseGeocodingDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigReverseGeocodingDtoBuilder();
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


