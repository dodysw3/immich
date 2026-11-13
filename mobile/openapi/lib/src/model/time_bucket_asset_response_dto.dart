//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/asset_visibility.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'time_bucket_asset_response_dto.g.dart';

/// TimeBucketAssetResponseDto
///
/// Properties:
/// * [aiInterpretationTitle] - Array of AI interpretation titles (most recent completed run per asset, null when the asset was never interpreted)
/// * [city] - Array of city names extracted from EXIF GPS data
/// * [country] - Array of country names extracted from EXIF GPS data
/// * [createdAt] - Array of UTC timestamps when each asset was originally uploaded to Immich
/// * [duration] - Array of video/gif durations in milliseconds (null for static images)
/// * [fileCreatedAt] - Array of file creation timestamps in UTC
/// * [id] - Array of asset IDs in the time bucket
/// * [isFavorite] - Array indicating whether each asset is favorited
/// * [isImage] - Array indicating whether each asset is an image (false for videos)
/// * [isTrashed] - Array indicating whether each asset is in the trash
/// * [latitude] - Array of latitude coordinates extracted from EXIF GPS data
/// * [livePhotoVideoId] - Array of live photo video asset IDs (null for non-live photos)
/// * [localOffsetHours] - Array of UTC offset hours at the time each photo was taken. Positive values are east of UTC, negative values are west of UTC. Values may be fractional (e.g., 5.5 for +05:30, -9.75 for -09:45). Applying this offset to 'fileCreatedAt' will give you the time the photo was taken from the photographer's perspective.
/// * [longitude] - Array of longitude coordinates extracted from EXIF GPS data
/// * [ownerId] - Array of owner IDs for each asset
/// * [projectionType] - Array of projection types for 360° content (e.g., \"EQUIRECTANGULAR\", \"CUBEFACE\", \"CYLINDRICAL\")
/// * [ratio] - Array of aspect ratios (width/height) for each asset
/// * [stack] - Array of stack information as [stackId, assetCount] tuples (null for non-stacked assets)
/// * [thumbhash] - Array of BlurHash strings for generating asset previews (base64 encoded)
/// * [visibility] - Array of visibility statuses for each asset (e.g., ARCHIVE, TIMELINE, HIDDEN, LOCKED)
@BuiltValue()
abstract class TimeBucketAssetResponseDto implements Built<TimeBucketAssetResponseDto, TimeBucketAssetResponseDtoBuilder> {
  /// Array of AI interpretation titles (most recent completed run per asset, null when the asset was never interpreted)
  @BuiltValueField(wireName: r'aiInterpretationTitle')
  BuiltList<String?>? get aiInterpretationTitle;

  /// Array of city names extracted from EXIF GPS data
  @BuiltValueField(wireName: r'city')
  BuiltList<String?>? get city;

  /// Array of country names extracted from EXIF GPS data
  @BuiltValueField(wireName: r'country')
  BuiltList<String?>? get country;

  /// Array of UTC timestamps when each asset was originally uploaded to Immich
  @BuiltValueField(wireName: r'createdAt')
  BuiltList<String> get createdAt;

  /// Array of video/gif durations in milliseconds (null for static images)
  @BuiltValueField(wireName: r'duration')
  BuiltList<int?> get duration;

  /// Array of file creation timestamps in UTC
  @BuiltValueField(wireName: r'fileCreatedAt')
  BuiltList<String> get fileCreatedAt;

  /// Array of asset IDs in the time bucket
  @BuiltValueField(wireName: r'id')
  BuiltList<String> get id;

  /// Array indicating whether each asset is favorited
  @BuiltValueField(wireName: r'isFavorite')
  BuiltList<bool> get isFavorite;

  /// Array indicating whether each asset is an image (false for videos)
  @BuiltValueField(wireName: r'isImage')
  BuiltList<bool> get isImage;

  /// Array indicating whether each asset is in the trash
  @BuiltValueField(wireName: r'isTrashed')
  BuiltList<bool> get isTrashed;

  /// Array of latitude coordinates extracted from EXIF GPS data
  @BuiltValueField(wireName: r'latitude')
  BuiltList<double?>? get latitude;

  /// Array of live photo video asset IDs (null for non-live photos)
  @BuiltValueField(wireName: r'livePhotoVideoId')
  BuiltList<String?> get livePhotoVideoId;

  /// Array of UTC offset hours at the time each photo was taken. Positive values are east of UTC, negative values are west of UTC. Values may be fractional (e.g., 5.5 for +05:30, -9.75 for -09:45). Applying this offset to 'fileCreatedAt' will give you the time the photo was taken from the photographer's perspective.
  @BuiltValueField(wireName: r'localOffsetHours')
  BuiltList<double> get localOffsetHours;

  /// Array of longitude coordinates extracted from EXIF GPS data
  @BuiltValueField(wireName: r'longitude')
  BuiltList<double?>? get longitude;

  /// Array of owner IDs for each asset
  @BuiltValueField(wireName: r'ownerId')
  BuiltList<String> get ownerId;

  /// Array of projection types for 360° content (e.g., \"EQUIRECTANGULAR\", \"CUBEFACE\", \"CYLINDRICAL\")
  @BuiltValueField(wireName: r'projectionType')
  BuiltList<String?> get projectionType;

  /// Array of aspect ratios (width/height) for each asset
  @BuiltValueField(wireName: r'ratio')
  BuiltList<double> get ratio;

  /// Array of stack information as [stackId, assetCount] tuples (null for non-stacked assets)
  @BuiltValueField(wireName: r'stack')
  BuiltList<BuiltList<String>?>? get stack;

  /// Array of BlurHash strings for generating asset previews (base64 encoded)
  @BuiltValueField(wireName: r'thumbhash')
  BuiltList<String?> get thumbhash;

  /// Array of visibility statuses for each asset (e.g., ARCHIVE, TIMELINE, HIDDEN, LOCKED)
  @BuiltValueField(wireName: r'visibility')
  BuiltList<AssetVisibility> get visibility;

  TimeBucketAssetResponseDto._();

  factory TimeBucketAssetResponseDto([void updates(TimeBucketAssetResponseDtoBuilder b)]) = _$TimeBucketAssetResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TimeBucketAssetResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TimeBucketAssetResponseDto> get serializer => _$TimeBucketAssetResponseDtoSerializer();
}

class _$TimeBucketAssetResponseDtoSerializer implements PrimitiveSerializer<TimeBucketAssetResponseDto> {
  @override
  final Iterable<Type> types = const [TimeBucketAssetResponseDto, _$TimeBucketAssetResponseDto];

  @override
  final String wireName = r'TimeBucketAssetResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TimeBucketAssetResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.aiInterpretationTitle != null) {
      yield r'aiInterpretationTitle';
      yield serializers.serialize(
        object.aiInterpretationTitle,
        specifiedType: const FullType(BuiltList, [FullType.nullable(String)]),
      );
    }
    if (object.city != null) {
      yield r'city';
      yield serializers.serialize(
        object.city,
        specifiedType: const FullType(BuiltList, [FullType.nullable(String)]),
      );
    }
    if (object.country != null) {
      yield r'country';
      yield serializers.serialize(
        object.country,
        specifiedType: const FullType(BuiltList, [FullType.nullable(String)]),
      );
    }
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'duration';
    yield serializers.serialize(
      object.duration,
      specifiedType: const FullType(BuiltList, [FullType.nullable(int)]),
    );
    yield r'fileCreatedAt';
    yield serializers.serialize(
      object.fileCreatedAt,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'isFavorite';
    yield serializers.serialize(
      object.isFavorite,
      specifiedType: const FullType(BuiltList, [FullType(bool)]),
    );
    yield r'isImage';
    yield serializers.serialize(
      object.isImage,
      specifiedType: const FullType(BuiltList, [FullType(bool)]),
    );
    yield r'isTrashed';
    yield serializers.serialize(
      object.isTrashed,
      specifiedType: const FullType(BuiltList, [FullType(bool)]),
    );
    if (object.latitude != null) {
      yield r'latitude';
      yield serializers.serialize(
        object.latitude,
        specifiedType: const FullType(BuiltList, [FullType.nullable(double)]),
      );
    }
    yield r'livePhotoVideoId';
    yield serializers.serialize(
      object.livePhotoVideoId,
      specifiedType: const FullType(BuiltList, [FullType.nullable(String)]),
    );
    yield r'localOffsetHours';
    yield serializers.serialize(
      object.localOffsetHours,
      specifiedType: const FullType(BuiltList, [FullType(double)]),
    );
    if (object.longitude != null) {
      yield r'longitude';
      yield serializers.serialize(
        object.longitude,
        specifiedType: const FullType(BuiltList, [FullType.nullable(double)]),
      );
    }
    yield r'ownerId';
    yield serializers.serialize(
      object.ownerId,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'projectionType';
    yield serializers.serialize(
      object.projectionType,
      specifiedType: const FullType(BuiltList, [FullType.nullable(String)]),
    );
    yield r'ratio';
    yield serializers.serialize(
      object.ratio,
      specifiedType: const FullType(BuiltList, [FullType(double)]),
    );
    if (object.stack != null) {
      yield r'stack';
      yield serializers.serialize(
        object.stack,
        specifiedType: const FullType(BuiltList, [FullType.nullable(BuiltList, [FullType(String)])]),
      );
    }
    yield r'thumbhash';
    yield serializers.serialize(
      object.thumbhash,
      specifiedType: const FullType(BuiltList, [FullType.nullable(String)]),
    );
    yield r'visibility';
    yield serializers.serialize(
      object.visibility,
      specifiedType: const FullType(BuiltList, [FullType(AssetVisibility)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TimeBucketAssetResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TimeBucketAssetResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'aiInterpretationTitle':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType.nullable(String)]),
          ) as BuiltList<String?>?;
          if (valueDes == null) continue;
          result.aiInterpretationTitle.replace(valueDes);
          break;
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType.nullable(String)]),
          ) as BuiltList<String?>?;
          if (valueDes == null) continue;
          result.city.replace(valueDes);
          break;
        case r'country':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType.nullable(String)]),
          ) as BuiltList<String?>?;
          if (valueDes == null) continue;
          result.country.replace(valueDes);
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.createdAt.replace(valueDes);
          break;
        case r'duration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType.nullable(int)]),
          ) as BuiltList<int?>;
          result.duration.replace(valueDes);
          break;
        case r'fileCreatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.fileCreatedAt.replace(valueDes);
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.id.replace(valueDes);
          break;
        case r'isFavorite':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(bool)]),
          ) as BuiltList<bool>;
          result.isFavorite.replace(valueDes);
          break;
        case r'isImage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(bool)]),
          ) as BuiltList<bool>;
          result.isImage.replace(valueDes);
          break;
        case r'isTrashed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(bool)]),
          ) as BuiltList<bool>;
          result.isTrashed.replace(valueDes);
          break;
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType.nullable(double)]),
          ) as BuiltList<double?>?;
          if (valueDes == null) continue;
          result.latitude.replace(valueDes);
          break;
        case r'livePhotoVideoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType.nullable(String)]),
          ) as BuiltList<String?>;
          result.livePhotoVideoId.replace(valueDes);
          break;
        case r'localOffsetHours':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(double)]),
          ) as BuiltList<double>;
          result.localOffsetHours.replace(valueDes);
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType.nullable(double)]),
          ) as BuiltList<double?>?;
          if (valueDes == null) continue;
          result.longitude.replace(valueDes);
          break;
        case r'ownerId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.ownerId.replace(valueDes);
          break;
        case r'projectionType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType.nullable(String)]),
          ) as BuiltList<String?>;
          result.projectionType.replace(valueDes);
          break;
        case r'ratio':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(double)]),
          ) as BuiltList<double>;
          result.ratio.replace(valueDes);
          break;
        case r'stack':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType.nullable(BuiltList, [FullType(String)])]),
          ) as BuiltList<BuiltList<String>?>?;
          if (valueDes == null) continue;
          result.stack.replace(valueDes);
          break;
        case r'thumbhash':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType.nullable(String)]),
          ) as BuiltList<String?>;
          result.thumbhash.replace(valueDes);
          break;
        case r'visibility':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AssetVisibility)]),
          ) as BuiltList<AssetVisibility>;
          result.visibility.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TimeBucketAssetResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TimeBucketAssetResponseDtoBuilder();
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


