//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_asset_exif_v1.g.dart';

/// SyncAssetExifV1
///
/// Properties:
/// * [assetId] - Asset ID
/// * [city] - City
/// * [country] - Country
/// * [dateTimeOriginal] - Date time original
/// * [description] - Description
/// * [exifImageHeight] - Exif image height
/// * [exifImageWidth] - Exif image width
/// * [exposureTime] - Exposure time
/// * [fNumber] - F number
/// * [fileSizeInByte] - File size in byte
/// * [focalLength] - Focal length
/// * [fps] - FPS
/// * [iso] - ISO
/// * [latitude] - Latitude
/// * [lensModel] - Lens model
/// * [longitude] - Longitude
/// * [make] - Make
/// * [model] - Model
/// * [modifyDate] - Modify date
/// * [orientation] - Orientation
/// * [profileDescription] - Profile description
/// * [projectionType] - Projection type
/// * [rating] - Rating
/// * [state] - State
/// * [timeZone] - Time zone
@BuiltValue()
abstract class SyncAssetExifV1 implements Built<SyncAssetExifV1, SyncAssetExifV1Builder> {
  /// Asset ID
  @BuiltValueField(wireName: r'assetId')
  String get assetId;

  /// City
  @BuiltValueField(wireName: r'city')
  String? get city;

  /// Country
  @BuiltValueField(wireName: r'country')
  String? get country;

  /// Date time original
  @BuiltValueField(wireName: r'dateTimeOriginal')
  DateTime? get dateTimeOriginal;

  /// Description
  @BuiltValueField(wireName: r'description')
  String? get description;

  /// Exif image height
  @BuiltValueField(wireName: r'exifImageHeight')
  int? get exifImageHeight;

  /// Exif image width
  @BuiltValueField(wireName: r'exifImageWidth')
  int? get exifImageWidth;

  /// Exposure time
  @BuiltValueField(wireName: r'exposureTime')
  String? get exposureTime;

  /// F number
  @BuiltValueField(wireName: r'fNumber')
  double? get fNumber;

  /// File size in byte
  @BuiltValueField(wireName: r'fileSizeInByte')
  int? get fileSizeInByte;

  /// Focal length
  @BuiltValueField(wireName: r'focalLength')
  double? get focalLength;

  /// FPS
  @BuiltValueField(wireName: r'fps')
  double? get fps;

  /// ISO
  @BuiltValueField(wireName: r'iso')
  int? get iso;

  /// Latitude
  @BuiltValueField(wireName: r'latitude')
  double? get latitude;

  /// Lens model
  @BuiltValueField(wireName: r'lensModel')
  String? get lensModel;

  /// Longitude
  @BuiltValueField(wireName: r'longitude')
  double? get longitude;

  /// Make
  @BuiltValueField(wireName: r'make')
  String? get make;

  /// Model
  @BuiltValueField(wireName: r'model')
  String? get model;

  /// Modify date
  @BuiltValueField(wireName: r'modifyDate')
  DateTime? get modifyDate;

  /// Orientation
  @BuiltValueField(wireName: r'orientation')
  String? get orientation;

  /// Profile description
  @BuiltValueField(wireName: r'profileDescription')
  String? get profileDescription;

  /// Projection type
  @BuiltValueField(wireName: r'projectionType')
  String? get projectionType;

  /// Rating
  @BuiltValueField(wireName: r'rating')
  int? get rating;

  /// State
  @BuiltValueField(wireName: r'state')
  String? get state;

  /// Time zone
  @BuiltValueField(wireName: r'timeZone')
  String? get timeZone;

  SyncAssetExifV1._();

  factory SyncAssetExifV1([void updates(SyncAssetExifV1Builder b)]) = _$SyncAssetExifV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncAssetExifV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncAssetExifV1> get serializer => _$SyncAssetExifV1Serializer();
}

class _$SyncAssetExifV1Serializer implements PrimitiveSerializer<SyncAssetExifV1> {
  @override
  final Iterable<Type> types = const [SyncAssetExifV1, _$SyncAssetExifV1];

  @override
  final String wireName = r'SyncAssetExifV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncAssetExifV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assetId';
    yield serializers.serialize(
      object.assetId,
      specifiedType: const FullType(String),
    );
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
    yield r'dateTimeOriginal';
    yield object.dateTimeOriginal == null ? null : serializers.serialize(
      object.dateTimeOriginal,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
    yield r'exifImageHeight';
    yield object.exifImageHeight == null ? null : serializers.serialize(
      object.exifImageHeight,
      specifiedType: const FullType.nullable(int),
    );
    yield r'exifImageWidth';
    yield object.exifImageWidth == null ? null : serializers.serialize(
      object.exifImageWidth,
      specifiedType: const FullType.nullable(int),
    );
    yield r'exposureTime';
    yield object.exposureTime == null ? null : serializers.serialize(
      object.exposureTime,
      specifiedType: const FullType.nullable(String),
    );
    yield r'fNumber';
    yield object.fNumber == null ? null : serializers.serialize(
      object.fNumber,
      specifiedType: const FullType.nullable(double),
    );
    yield r'fileSizeInByte';
    yield object.fileSizeInByte == null ? null : serializers.serialize(
      object.fileSizeInByte,
      specifiedType: const FullType.nullable(int),
    );
    yield r'focalLength';
    yield object.focalLength == null ? null : serializers.serialize(
      object.focalLength,
      specifiedType: const FullType.nullable(double),
    );
    yield r'fps';
    yield object.fps == null ? null : serializers.serialize(
      object.fps,
      specifiedType: const FullType.nullable(double),
    );
    yield r'iso';
    yield object.iso == null ? null : serializers.serialize(
      object.iso,
      specifiedType: const FullType.nullable(int),
    );
    yield r'latitude';
    yield object.latitude == null ? null : serializers.serialize(
      object.latitude,
      specifiedType: const FullType.nullable(double),
    );
    yield r'lensModel';
    yield object.lensModel == null ? null : serializers.serialize(
      object.lensModel,
      specifiedType: const FullType.nullable(String),
    );
    yield r'longitude';
    yield object.longitude == null ? null : serializers.serialize(
      object.longitude,
      specifiedType: const FullType.nullable(double),
    );
    yield r'make';
    yield object.make == null ? null : serializers.serialize(
      object.make,
      specifiedType: const FullType.nullable(String),
    );
    yield r'model';
    yield object.model == null ? null : serializers.serialize(
      object.model,
      specifiedType: const FullType.nullable(String),
    );
    yield r'modifyDate';
    yield object.modifyDate == null ? null : serializers.serialize(
      object.modifyDate,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'orientation';
    yield object.orientation == null ? null : serializers.serialize(
      object.orientation,
      specifiedType: const FullType.nullable(String),
    );
    yield r'profileDescription';
    yield object.profileDescription == null ? null : serializers.serialize(
      object.profileDescription,
      specifiedType: const FullType.nullable(String),
    );
    yield r'projectionType';
    yield object.projectionType == null ? null : serializers.serialize(
      object.projectionType,
      specifiedType: const FullType.nullable(String),
    );
    yield r'rating';
    yield object.rating == null ? null : serializers.serialize(
      object.rating,
      specifiedType: const FullType.nullable(int),
    );
    yield r'state';
    yield object.state == null ? null : serializers.serialize(
      object.state,
      specifiedType: const FullType.nullable(String),
    );
    yield r'timeZone';
    yield object.timeZone == null ? null : serializers.serialize(
      object.timeZone,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncAssetExifV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncAssetExifV1Builder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assetId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.assetId = valueDes;
          break;
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
  SyncAssetExifV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncAssetExifV1Builder();
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


