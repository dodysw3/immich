//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'places_response_dto.g.dart';

/// PlacesResponseDto
///
/// Properties:
/// * [admin1name] - Administrative level 1 name (state/province)
/// * [admin2name] - Administrative level 2 name (county/district)
/// * [latitude] - Latitude coordinate
/// * [longitude] - Longitude coordinate
/// * [name] - Place name
@BuiltValue()
abstract class PlacesResponseDto implements Built<PlacesResponseDto, PlacesResponseDtoBuilder> {
  /// Administrative level 1 name (state/province)
  @BuiltValueField(wireName: r'admin1name')
  String? get admin1name;

  /// Administrative level 2 name (county/district)
  @BuiltValueField(wireName: r'admin2name')
  String? get admin2name;

  /// Latitude coordinate
  @BuiltValueField(wireName: r'latitude')
  double get latitude;

  /// Longitude coordinate
  @BuiltValueField(wireName: r'longitude')
  double get longitude;

  /// Place name
  @BuiltValueField(wireName: r'name')
  String get name;

  PlacesResponseDto._();

  factory PlacesResponseDto([void updates(PlacesResponseDtoBuilder b)]) = _$PlacesResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PlacesResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PlacesResponseDto> get serializer => _$PlacesResponseDtoSerializer();
}

class _$PlacesResponseDtoSerializer implements PrimitiveSerializer<PlacesResponseDto> {
  @override
  final Iterable<Type> types = const [PlacesResponseDto, _$PlacesResponseDto];

  @override
  final String wireName = r'PlacesResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PlacesResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.admin1name != null) {
      yield r'admin1name';
      yield serializers.serialize(
        object.admin1name,
        specifiedType: const FullType(String),
      );
    }
    if (object.admin2name != null) {
      yield r'admin2name';
      yield serializers.serialize(
        object.admin2name,
        specifiedType: const FullType(String),
      );
    }
    yield r'latitude';
    yield serializers.serialize(
      object.latitude,
      specifiedType: const FullType(double),
    );
    yield r'longitude';
    yield serializers.serialize(
      object.longitude,
      specifiedType: const FullType(double),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PlacesResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PlacesResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'admin1name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.admin1name = valueDes;
          break;
        case r'admin2name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.admin2name = valueDes;
          break;
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.longitude = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  PlacesResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PlacesResponseDtoBuilder();
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


