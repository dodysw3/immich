//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'map_reverse_geocode_response_dto.g.dart';

/// MapReverseGeocodeResponseDto
///
/// Properties:
/// * [city] - City name
/// * [country] - Country name
/// * [state] - State/Province name
@BuiltValue()
abstract class MapReverseGeocodeResponseDto implements Built<MapReverseGeocodeResponseDto, MapReverseGeocodeResponseDtoBuilder> {
  /// City name
  @BuiltValueField(wireName: r'city')
  String? get city;

  /// Country name
  @BuiltValueField(wireName: r'country')
  String? get country;

  /// State/Province name
  @BuiltValueField(wireName: r'state')
  String? get state;

  MapReverseGeocodeResponseDto._();

  factory MapReverseGeocodeResponseDto([void updates(MapReverseGeocodeResponseDtoBuilder b)]) = _$MapReverseGeocodeResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MapReverseGeocodeResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MapReverseGeocodeResponseDto> get serializer => _$MapReverseGeocodeResponseDtoSerializer();
}

class _$MapReverseGeocodeResponseDtoSerializer implements PrimitiveSerializer<MapReverseGeocodeResponseDto> {
  @override
  final Iterable<Type> types = const [MapReverseGeocodeResponseDto, _$MapReverseGeocodeResponseDto];

  @override
  final String wireName = r'MapReverseGeocodeResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MapReverseGeocodeResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'city';
    yield object.city == null ? null : serializers.serialize(
      object.city,
      specifiedType: const FullType.nullable(String),
    );
    yield r'country';
    yield object.country == null ? null : serializers.serialize(
      object.country,
      specifiedType: const FullType.nullable(String),
    );
    yield r'state';
    yield object.state == null ? null : serializers.serialize(
      object.state,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MapReverseGeocodeResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MapReverseGeocodeResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.city = valueDes;
          break;
        case r'country':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.country = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.state = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MapReverseGeocodeResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MapReverseGeocodeResponseDtoBuilder();
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


