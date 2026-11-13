//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/asset_visibility.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_bulk_update_dto.g.dart';

/// AssetBulkUpdateDto
///
/// Properties:
/// * [dateTimeOriginal] - Original date and time
/// * [dateTimeRelative] - Relative time offset in minutes
/// * [description] - Asset description
/// * [duplicateId] - Duplicate ID
/// * [ids] - Asset IDs to update
/// * [isFavorite] - Mark as favorite
/// * [latitude] - Latitude coordinate
/// * [longitude] - Longitude coordinate
/// * [rating] - Rating in range [1-5] (starred), -1 (rejected), or null (unrated)
/// * [timeZone] - Time zone (IANA timezone)
/// * [visibility] 
@BuiltValue()
abstract class AssetBulkUpdateDto implements Built<AssetBulkUpdateDto, AssetBulkUpdateDtoBuilder> {
  /// Original date and time
  @BuiltValueField(wireName: r'dateTimeOriginal')
  String? get dateTimeOriginal;

  /// Relative time offset in minutes
  @BuiltValueField(wireName: r'dateTimeRelative')
  int? get dateTimeRelative;

  /// Asset description
  @BuiltValueField(wireName: r'description')
  String? get description;

  /// Duplicate ID
  @BuiltValueField(wireName: r'duplicateId')
  String? get duplicateId;

  /// Asset IDs to update
  @BuiltValueField(wireName: r'ids')
  BuiltList<String> get ids;

  /// Mark as favorite
  @BuiltValueField(wireName: r'isFavorite')
  bool? get isFavorite;

  /// Latitude coordinate
  @BuiltValueField(wireName: r'latitude')
  double? get latitude;

  /// Longitude coordinate
  @BuiltValueField(wireName: r'longitude')
  double? get longitude;

  /// Rating in range [1-5] (starred), -1 (rejected), or null (unrated)
  @BuiltValueField(wireName: r'rating')
  int? get rating;

  /// Time zone (IANA timezone)
  @BuiltValueField(wireName: r'timeZone')
  String? get timeZone;

  @BuiltValueField(wireName: r'visibility')
  AssetVisibility? get visibility;
  // enum visibilityEnum {  archive,  timeline,  hidden,  locked,  };

  AssetBulkUpdateDto._();

  factory AssetBulkUpdateDto([void updates(AssetBulkUpdateDtoBuilder b)]) = _$AssetBulkUpdateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetBulkUpdateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetBulkUpdateDto> get serializer => _$AssetBulkUpdateDtoSerializer();
}

class _$AssetBulkUpdateDtoSerializer implements PrimitiveSerializer<AssetBulkUpdateDto> {
  @override
  final Iterable<Type> types = const [AssetBulkUpdateDto, _$AssetBulkUpdateDto];

  @override
  final String wireName = r'AssetBulkUpdateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetBulkUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.dateTimeOriginal != null) {
      yield r'dateTimeOriginal';
      yield serializers.serialize(
        object.dateTimeOriginal,
        specifiedType: const FullType(String),
      );
    }
    if (object.dateTimeRelative != null) {
      yield r'dateTimeRelative';
      yield serializers.serialize(
        object.dateTimeRelative,
        specifiedType: const FullType(int),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    if (object.duplicateId != null) {
      yield r'duplicateId';
      yield serializers.serialize(
        object.duplicateId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'ids';
    yield serializers.serialize(
      object.ids,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
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
    if (object.timeZone != null) {
      yield r'timeZone';
      yield serializers.serialize(
        object.timeZone,
        specifiedType: const FullType(String),
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
    AssetBulkUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssetBulkUpdateDtoBuilder result,
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
        case r'dateTimeRelative':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.dateTimeRelative = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'duplicateId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.duplicateId = valueDes;
          break;
        case r'ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.ids.replace(valueDes);
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
        case r'timeZone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.timeZone = valueDes;
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
  AssetBulkUpdateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetBulkUpdateDtoBuilder();
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


