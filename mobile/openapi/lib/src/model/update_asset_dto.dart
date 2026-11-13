//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/asset_visibility.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_asset_dto.g.dart';

/// UpdateAssetDto
///
/// Properties:
/// * [dateTimeOriginal] - Original date and time
/// * [description] - Asset description
/// * [isFavorite] - Mark as favorite
/// * [latitude] - Latitude coordinate
/// * [livePhotoVideoId] - Live photo video ID
/// * [longitude] - Longitude coordinate
/// * [rating] - Rating in range [1-5] (starred), -1 (rejected), or null (unrated)
/// * [visibility] 
@BuiltValue()
abstract class UpdateAssetDto implements Built<UpdateAssetDto, UpdateAssetDtoBuilder> {
  /// Original date and time
  @BuiltValueField(wireName: r'dateTimeOriginal')
  String? get dateTimeOriginal;

  /// Asset description
  @BuiltValueField(wireName: r'description')
  String? get description;

  /// Mark as favorite
  @BuiltValueField(wireName: r'isFavorite')
  bool? get isFavorite;

  /// Latitude coordinate
  @BuiltValueField(wireName: r'latitude')
  double? get latitude;

  /// Live photo video ID
  @BuiltValueField(wireName: r'livePhotoVideoId')
  String? get livePhotoVideoId;

  /// Longitude coordinate
  @BuiltValueField(wireName: r'longitude')
  double? get longitude;

  /// Rating in range [1-5] (starred), -1 (rejected), or null (unrated)
  @BuiltValueField(wireName: r'rating')
  int? get rating;

  @BuiltValueField(wireName: r'visibility')
  AssetVisibility? get visibility;
  // enum visibilityEnum {  archive,  timeline,  hidden,  locked,  };

  UpdateAssetDto._();

  factory UpdateAssetDto([void updates(UpdateAssetDtoBuilder b)]) = _$UpdateAssetDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateAssetDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateAssetDto> get serializer => _$UpdateAssetDtoSerializer();
}

class _$UpdateAssetDtoSerializer implements PrimitiveSerializer<UpdateAssetDto> {
  @override
  final Iterable<Type> types = const [UpdateAssetDto, _$UpdateAssetDto];

  @override
  final String wireName = r'UpdateAssetDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateAssetDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.dateTimeOriginal != null) {
      yield r'dateTimeOriginal';
      yield serializers.serialize(
        object.dateTimeOriginal,
        specifiedType: const FullType(String),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    if (object.isFavorite != null) {
      yield r'isFavorite';
      yield serializers.serialize(
        object.isFavorite,
        specifiedType: const FullType(bool),
      );
    }
    if (object.latitude != null) {
      yield r'latitude';
      yield serializers.serialize(
        object.latitude,
        specifiedType: const FullType(double),
      );
    }
    if (object.livePhotoVideoId != null) {
      yield r'livePhotoVideoId';
      yield serializers.serialize(
        object.livePhotoVideoId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.longitude != null) {
      yield r'longitude';
      yield serializers.serialize(
        object.longitude,
        specifiedType: const FullType(double),
      );
    }
    if (object.rating != null) {
      yield r'rating';
      yield serializers.serialize(
        object.rating,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.visibility != null) {
      yield r'visibility';
      yield serializers.serialize(
        object.visibility,
        specifiedType: const FullType(AssetVisibility),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateAssetDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateAssetDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'dateTimeOriginal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
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
        case r'isFavorite':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isFavorite = valueDes;
          break;
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.latitude = valueDes;
          break;
        case r'livePhotoVideoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.livePhotoVideoId = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.longitude = valueDes;
          break;
        case r'rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.rating = valueDes;
          break;
        case r'visibility':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AssetVisibility),
          ) as AssetVisibility?;
          if (valueDes == null) continue;
          result.visibility = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateAssetDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateAssetDtoBuilder();
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


