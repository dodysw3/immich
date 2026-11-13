//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'exif_response_dto.g.dart';

/// EXIF response
///
/// Properties:
/// * [bitsPerSample] - Bits per sample
/// * [city] - City name
/// * [colorspace] - Color space
/// * [country] - Country name
/// * [dateTimeOriginal] - Original date/time
/// * [description] - Image description
/// * [exifImageHeight] - Image height in pixels
/// * [exifImageWidth] - Image width in pixels
/// * [exposureTime] - Exposure time
/// * [fNumber] - F-number (aperture)
/// * [fileSizeInByte] - File size in bytes
/// * [focalLength] - Focal length in mm
/// * [fps] - Frame rate in frames per second
/// * [iso] - ISO sensitivity
/// * [latitude] - GPS latitude
/// * [lensModel] - Lens model
/// * [longitude] - GPS longitude
/// * [make] - Camera make
/// * [model] - Camera model
/// * [modifyDate] - Modification date/time
/// * [orientation] - Image orientation
/// * [profileDescription] - Color profile description
/// * [projectionType] - Projection type
/// * [rating] - Rating
/// * [state] - State/province name
/// * [timeZone] - Time zone
@BuiltValue()
abstract class ExifResponseDto implements Built<ExifResponseDto, ExifResponseDtoBuilder> {
  /// Bits per sample
  @BuiltValueField(wireName: r'bitsPerSample')
  int? get bitsPerSample;

  /// City name
  @BuiltValueField(wireName: r'city')
  String? get city;

  /// Color space
  @BuiltValueField(wireName: r'colorspace')
  String? get colorspace;

  /// Country name
  @BuiltValueField(wireName: r'country')
  String? get country;

  /// Original date/time
  @BuiltValueField(wireName: r'dateTimeOriginal')
  DateTime? get dateTimeOriginal;

  /// Image description
  @BuiltValueField(wireName: r'description')
  String? get description;

  /// Image height in pixels
  @BuiltValueField(wireName: r'exifImageHeight')
  int? get exifImageHeight;

  /// Image width in pixels
  @BuiltValueField(wireName: r'exifImageWidth')
  int? get exifImageWidth;

  /// Exposure time
  @BuiltValueField(wireName: r'exposureTime')
  String? get exposureTime;

  /// F-number (aperture)
  @BuiltValueField(wireName: r'fNumber')
  double? get fNumber;

  /// File size in bytes
  @BuiltValueField(wireName: r'fileSizeInByte')
  int? get fileSizeInByte;

  /// Focal length in mm
  @BuiltValueField(wireName: r'focalLength')
  double? get focalLength;

  /// Frame rate in frames per second
  @BuiltValueField(wireName: r'fps')
  double? get fps;

  /// ISO sensitivity
  @BuiltValueField(wireName: r'iso')
  int? get iso;

  /// GPS latitude
  @BuiltValueField(wireName: r'latitude')
  double? get latitude;

  /// Lens model
  @BuiltValueField(wireName: r'lensModel')
  String? get lensModel;

  /// GPS longitude
  @BuiltValueField(wireName: r'longitude')
  double? get longitude;

  /// Camera make
  @BuiltValueField(wireName: r'make')
  String? get make;

  /// Camera model
  @BuiltValueField(wireName: r'model')
  String? get model;

  /// Modification date/time
  @BuiltValueField(wireName: r'modifyDate')
  DateTime? get modifyDate;

  /// Image orientation
  @BuiltValueField(wireName: r'orientation')
  String? get orientation;

  /// Color profile description
  @BuiltValueField(wireName: r'profileDescription')
  String? get profileDescription;

  /// Projection type
  @BuiltValueField(wireName: r'projectionType')
  String? get projectionType;

  /// Rating
  @BuiltValueField(wireName: r'rating')
  int? get rating;

  /// State/province name
  @BuiltValueField(wireName: r'state')
  String? get state;

  /// Time zone
  @BuiltValueField(wireName: r'timeZone')
  String? get timeZone;

  ExifResponseDto._();

  factory ExifResponseDto([void updates(ExifResponseDtoBuilder b)]) = _$ExifResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExifResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ExifResponseDto> get serializer => _$ExifResponseDtoSerializer();
}

class _$ExifResponseDtoSerializer implements PrimitiveSerializer<ExifResponseDto> {
  @override
  final Iterable<Type> types = const [ExifResponseDto, _$ExifResponseDto];

  @override
  final String wireName = r'ExifResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ExifResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.bitsPerSample != null) {
      yield r'bitsPerSample';
      yield serializers.serialize(
        object.bitsPerSample,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.city != null) {
      yield r'city';
      yield serializers.serialize(
        object.city,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.colorspace != null) {
      yield r'colorspace';
      yield serializers.serialize(
        object.colorspace,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.country != null) {
      yield r'country';
      yield serializers.serialize(
        object.country,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.dateTimeOriginal != null) {
      yield r'dateTimeOriginal';
      yield serializers.serialize(
        object.dateTimeOriginal,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.exifImageHeight != null) {
      yield r'exifImageHeight';
      yield serializers.serialize(
        object.exifImageHeight,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.exifImageWidth != null) {
      yield r'exifImageWidth';
      yield serializers.serialize(
        object.exifImageWidth,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.exposureTime != null) {
      yield r'exposureTime';
      yield serializers.serialize(
        object.exposureTime,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.fNumber != null) {
      yield r'fNumber';
      yield serializers.serialize(
        object.fNumber,
        specifiedType: const FullType.nullable(double),
      );
    }
    if (object.fileSizeInByte != null) {
      yield r'fileSizeInByte';
      yield serializers.serialize(
        object.fileSizeInByte,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.focalLength != null) {
      yield r'focalLength';
      yield serializers.serialize(
        object.focalLength,
        specifiedType: const FullType.nullable(double),
      );
    }
    if (object.fps != null) {
      yield r'fps';
      yield serializers.serialize(
        object.fps,
        specifiedType: const FullType.nullable(double),
      );
    }
    if (object.iso != null) {
      yield r'iso';
      yield serializers.serialize(
        object.iso,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.latitude != null) {
      yield r'latitude';
      yield serializers.serialize(
        object.latitude,
        specifiedType: const FullType.nullable(double),
      );
    }
    if (object.lensModel != null) {
      yield r'lensModel';
      yield serializers.serialize(
        object.lensModel,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.longitude != null) {
      yield r'longitude';
      yield serializers.serialize(
        object.longitude,
        specifiedType: const FullType.nullable(double),
      );
    }
    if (object.make != null) {
      yield r'make';
      yield serializers.serialize(
        object.make,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.model != null) {
      yield r'model';
      yield serializers.serialize(
        object.model,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.modifyDate != null) {
      yield r'modifyDate';
      yield serializers.serialize(
        object.modifyDate,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.orientation != null) {
      yield r'orientation';
      yield serializers.serialize(
        object.orientation,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.profileDescription != null) {
      yield r'profileDescription';
      yield serializers.serialize(
        object.profileDescription,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.projectionType != null) {
      yield r'projectionType';
      yield serializers.serialize(
        object.projectionType,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.rating != null) {
      yield r'rating';
      yield serializers.serialize(
        object.rating,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.state != null) {
      yield r'state';
      yield serializers.serialize(
        object.state,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.timeZone != null) {
      yield r'timeZone';
      yield serializers.serialize(
        object.timeZone,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ExifResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ExifResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'bitsPerSample':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.bitsPerSample = valueDes;
          break;
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.city = valueDes;
          break;
        case r'colorspace':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.colorspace = valueDes;
          break;
        case r'country':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.country = valueDes;
          break;
        case r'dateTimeOriginal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.dateTimeOriginal = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'exifImageHeight':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.exifImageHeight = valueDes;
          break;
        case r'exifImageWidth':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.exifImageWidth = valueDes;
          break;
        case r'exposureTime':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.exposureTime = valueDes;
          break;
        case r'fNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.fNumber = valueDes;
          break;
        case r'fileSizeInByte':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.fileSizeInByte = valueDes;
          break;
        case r'focalLength':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.focalLength = valueDes;
          break;
        case r'fps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.fps = valueDes;
          break;
        case r'iso':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.iso = valueDes;
          break;
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.latitude = valueDes;
          break;
        case r'lensModel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.lensModel = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.longitude = valueDes;
          break;
        case r'make':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.make = valueDes;
          break;
        case r'model':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.model = valueDes;
          break;
        case r'modifyDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.modifyDate = valueDes;
          break;
        case r'orientation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.orientation = valueDes;
          break;
        case r'profileDescription':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.profileDescription = valueDes;
          break;
        case r'projectionType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.projectionType = valueDes;
          break;
        case r'rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.rating = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.state = valueDes;
          break;
        case r'timeZone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.timeZone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ExifResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExifResponseDtoBuilder();
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


