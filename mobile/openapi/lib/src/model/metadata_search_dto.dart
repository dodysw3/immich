//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/asset_order.dart';
import 'package:openapi/src/model/asset_type_enum.dart';
import 'package:openapi/src/model/asset_visibility.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/search_filter.dart';
import 'package:openapi/src/model/search_order.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'metadata_search_dto.g.dart';

/// MetadataSearchDto
///
/// Properties:
/// * [albumIds] - Filter by album IDs
/// * [checksum] - Filter by file checksum
/// * [city] - Filter by city name
/// * [country] - Filter by country name
/// * [createdAfter] - Filter by creation date (after)
/// * [createdBefore] - Filter by creation date (before)
/// * [cursor] - Cursor for the next page of results
/// * [description] - Filter by description text
/// * [encodedVideoPath] - Filter by encoded video file path
/// * [filter] 
/// * [hasAiInterpretation] - Filter by presence of a completed AI image interpretation
/// * [id] - Filter by asset ID
/// * [isEncoded] - Filter by encoded status
/// * [isFavorite] - Filter by favorite status
/// * [isMotion] - Filter by motion photo status
/// * [isNotInAlbum] - Filter assets not in any album
/// * [isOffline] - Filter by offline status
/// * [lensModel] - Filter by lens model
/// * [libraryId] - Library ID to filter by
/// * [make] - Filter by camera make
/// * [model] - Filter by camera model
/// * [ocr] - Filter by OCR text content
/// * [order] 
/// * [orderBy] 
/// * [originalFileName] - Filter by original file name
/// * [originalPath] - Filter by original file path
/// * [page] - Page number
/// * [personIds] - Filter by person IDs
/// * [previewPath] - Filter by preview file path
/// * [rating] - Filter by rating [1-5], or null for unrated
/// * [size] - Number of results to return
/// * [state] - Filter by state/province name
/// * [tagIds] - Filter by tag IDs
/// * [takenAfter] - Filter by taken date (after)
/// * [takenBefore] - Filter by taken date (before)
/// * [thumbnailPath] - Filter by thumbnail file path
/// * [trashedAfter] - Filter by trash date (after)
/// * [trashedBefore] - Filter by trash date (before)
/// * [type] 
/// * [updatedAfter] - Filter by update date (after)
/// * [updatedBefore] - Filter by update date (before)
/// * [visibility] 
/// * [withDeleted] - Include deleted assets
/// * [withExif] - Include EXIF data in response
/// * [withPeople] - Include people data in response
/// * [withStacked] - Include stacked assets
@BuiltValue()
abstract class MetadataSearchDto implements Built<MetadataSearchDto, MetadataSearchDtoBuilder> {
  /// Filter by album IDs
  @Deprecated('albumIds has been deprecated')
  @BuiltValueField(wireName: r'albumIds')
  BuiltList<String>? get albumIds;

  /// Filter by file checksum
  @Deprecated('checksum has been deprecated')
  @BuiltValueField(wireName: r'checksum')
  String? get checksum;

  /// Filter by city name
  @Deprecated('city has been deprecated')
  @BuiltValueField(wireName: r'city')
  String? get city;

  /// Filter by country name
  @Deprecated('country has been deprecated')
  @BuiltValueField(wireName: r'country')
  String? get country;

  /// Filter by creation date (after)
  @Deprecated('createdAfter has been deprecated')
  @BuiltValueField(wireName: r'createdAfter')
  DateTime? get createdAfter;

  /// Filter by creation date (before)
  @Deprecated('createdBefore has been deprecated')
  @BuiltValueField(wireName: r'createdBefore')
  DateTime? get createdBefore;

  /// Cursor for the next page of results
  @BuiltValueField(wireName: r'cursor')
  String? get cursor;

  /// Filter by description text
  @Deprecated('description has been deprecated')
  @BuiltValueField(wireName: r'description')
  String? get description;

  /// Filter by encoded video file path
  @Deprecated('encodedVideoPath has been deprecated')
  @BuiltValueField(wireName: r'encodedVideoPath')
  String? get encodedVideoPath;

  @BuiltValueField(wireName: r'filter')
  SearchFilter? get filter;

  /// Filter by presence of a completed AI image interpretation
  @Deprecated('hasAiInterpretation has been deprecated')
  @BuiltValueField(wireName: r'hasAiInterpretation')
  bool? get hasAiInterpretation;

  /// Filter by asset ID
  @Deprecated('id has been deprecated')
  @BuiltValueField(wireName: r'id')
  String? get id;

  /// Filter by encoded status
  @Deprecated('isEncoded has been deprecated')
  @BuiltValueField(wireName: r'isEncoded')
  bool? get isEncoded;

  /// Filter by favorite status
  @Deprecated('isFavorite has been deprecated')
  @BuiltValueField(wireName: r'isFavorite')
  bool? get isFavorite;

  /// Filter by motion photo status
  @Deprecated('isMotion has been deprecated')
  @BuiltValueField(wireName: r'isMotion')
  bool? get isMotion;

  /// Filter assets not in any album
  @Deprecated('isNotInAlbum has been deprecated')
  @BuiltValueField(wireName: r'isNotInAlbum')
  bool? get isNotInAlbum;

  /// Filter by offline status
  @Deprecated('isOffline has been deprecated')
  @BuiltValueField(wireName: r'isOffline')
  bool? get isOffline;

  /// Filter by lens model
  @Deprecated('lensModel has been deprecated')
  @BuiltValueField(wireName: r'lensModel')
  String? get lensModel;

  /// Library ID to filter by
  @Deprecated('libraryId has been deprecated')
  @BuiltValueField(wireName: r'libraryId')
  String? get libraryId;

  /// Filter by camera make
  @Deprecated('make has been deprecated')
  @BuiltValueField(wireName: r'make')
  String? get make;

  /// Filter by camera model
  @Deprecated('model has been deprecated')
  @BuiltValueField(wireName: r'model')
  String? get model;

  /// Filter by OCR text content
  @Deprecated('ocr has been deprecated')
  @BuiltValueField(wireName: r'ocr')
  String? get ocr;

  @BuiltValueField(wireName: r'order')
  AssetOrder? get order;
  // enum orderEnum {  asc,  desc,  };

  @BuiltValueField(wireName: r'orderBy')
  SearchOrder? get orderBy;

  /// Filter by original file name
  @Deprecated('originalFileName has been deprecated')
  @BuiltValueField(wireName: r'originalFileName')
  String? get originalFileName;

  /// Filter by original file path
  @Deprecated('originalPath has been deprecated')
  @BuiltValueField(wireName: r'originalPath')
  String? get originalPath;

  /// Page number
  @Deprecated('page has been deprecated')
  @BuiltValueField(wireName: r'page')
  int? get page;

  /// Filter by person IDs
  @Deprecated('personIds has been deprecated')
  @BuiltValueField(wireName: r'personIds')
  BuiltList<String>? get personIds;

  /// Filter by preview file path
  @Deprecated('previewPath has been deprecated')
  @BuiltValueField(wireName: r'previewPath')
  String? get previewPath;

  /// Filter by rating [1-5], or null for unrated
  @Deprecated('rating has been deprecated')
  @BuiltValueField(wireName: r'rating')
  int? get rating;

  /// Number of results to return
  @BuiltValueField(wireName: r'size')
  int? get size;

  /// Filter by state/province name
  @Deprecated('state has been deprecated')
  @BuiltValueField(wireName: r'state')
  String? get state;

  /// Filter by tag IDs
  @Deprecated('tagIds has been deprecated')
  @BuiltValueField(wireName: r'tagIds')
  BuiltList<String>? get tagIds;

  /// Filter by taken date (after)
  @Deprecated('takenAfter has been deprecated')
  @BuiltValueField(wireName: r'takenAfter')
  DateTime? get takenAfter;

  /// Filter by taken date (before)
  @Deprecated('takenBefore has been deprecated')
  @BuiltValueField(wireName: r'takenBefore')
  DateTime? get takenBefore;

  /// Filter by thumbnail file path
  @Deprecated('thumbnailPath has been deprecated')
  @BuiltValueField(wireName: r'thumbnailPath')
  String? get thumbnailPath;

  /// Filter by trash date (after)
  @Deprecated('trashedAfter has been deprecated')
  @BuiltValueField(wireName: r'trashedAfter')
  DateTime? get trashedAfter;

  /// Filter by trash date (before)
  @Deprecated('trashedBefore has been deprecated')
  @BuiltValueField(wireName: r'trashedBefore')
  DateTime? get trashedBefore;

  @BuiltValueField(wireName: r'type')
  AssetTypeEnum? get type;
  // enum typeEnum {  IMAGE,  VIDEO,  AUDIO,  OTHER,  };

  /// Filter by update date (after)
  @Deprecated('updatedAfter has been deprecated')
  @BuiltValueField(wireName: r'updatedAfter')
  DateTime? get updatedAfter;

  /// Filter by update date (before)
  @Deprecated('updatedBefore has been deprecated')
  @BuiltValueField(wireName: r'updatedBefore')
  DateTime? get updatedBefore;

  @BuiltValueField(wireName: r'visibility')
  AssetVisibility? get visibility;
  // enum visibilityEnum {  archive,  timeline,  hidden,  locked,  };

  /// Include deleted assets
  @Deprecated('withDeleted has been deprecated')
  @BuiltValueField(wireName: r'withDeleted')
  bool? get withDeleted;

  /// Include EXIF data in response
  @BuiltValueField(wireName: r'withExif')
  bool? get withExif;

  /// Include people data in response
  @BuiltValueField(wireName: r'withPeople')
  bool? get withPeople;

  /// Include stacked assets
  @BuiltValueField(wireName: r'withStacked')
  bool? get withStacked;

  MetadataSearchDto._();

  factory MetadataSearchDto([void updates(MetadataSearchDtoBuilder b)]) = _$MetadataSearchDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MetadataSearchDtoBuilder b) => b
      ..size = 250;

  @BuiltValueSerializer(custom: true)
  static Serializer<MetadataSearchDto> get serializer => _$MetadataSearchDtoSerializer();
}

class _$MetadataSearchDtoSerializer implements PrimitiveSerializer<MetadataSearchDto> {
  @override
  final Iterable<Type> types = const [MetadataSearchDto, _$MetadataSearchDto];

  @override
  final String wireName = r'MetadataSearchDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MetadataSearchDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.albumIds != null) {
      yield r'albumIds';
      yield serializers.serialize(
        object.albumIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.checksum != null) {
      yield r'checksum';
      yield serializers.serialize(
        object.checksum,
        specifiedType: const FullType(String),
      );
    }
    if (object.city != null) {
      yield r'city';
      yield serializers.serialize(
        object.city,
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
    if (object.createdAfter != null) {
      yield r'createdAfter';
      yield serializers.serialize(
        object.createdAfter,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.createdBefore != null) {
      yield r'createdBefore';
      yield serializers.serialize(
        object.createdBefore,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.cursor != null) {
      yield r'cursor';
      yield serializers.serialize(
        object.cursor,
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
    if (object.encodedVideoPath != null) {
      yield r'encodedVideoPath';
      yield serializers.serialize(
        object.encodedVideoPath,
        specifiedType: const FullType(String),
      );
    }
    if (object.filter != null) {
      yield r'filter';
      yield serializers.serialize(
        object.filter,
        specifiedType: const FullType(SearchFilter),
      );
    }
    if (object.hasAiInterpretation != null) {
      yield r'hasAiInterpretation';
      yield serializers.serialize(
        object.hasAiInterpretation,
        specifiedType: const FullType(bool),
      );
    }
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
    if (object.isEncoded != null) {
      yield r'isEncoded';
      yield serializers.serialize(
        object.isEncoded,
        specifiedType: const FullType(bool),
      );
    }
    if (object.isFavorite != null) {
      yield r'isFavorite';
      yield serializers.serialize(
        object.isFavorite,
        specifiedType: const FullType(bool),
      );
    }
    if (object.isMotion != null) {
      yield r'isMotion';
      yield serializers.serialize(
        object.isMotion,
        specifiedType: const FullType(bool),
      );
    }
    if (object.isNotInAlbum != null) {
      yield r'isNotInAlbum';
      yield serializers.serialize(
        object.isNotInAlbum,
        specifiedType: const FullType(bool),
      );
    }
    if (object.isOffline != null) {
      yield r'isOffline';
      yield serializers.serialize(
        object.isOffline,
        specifiedType: const FullType(bool),
      );
    }
    if (object.lensModel != null) {
      yield r'lensModel';
      yield serializers.serialize(
        object.lensModel,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.libraryId != null) {
      yield r'libraryId';
      yield serializers.serialize(
        object.libraryId,
        specifiedType: const FullType.nullable(String),
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
    if (object.ocr != null) {
      yield r'ocr';
      yield serializers.serialize(
        object.ocr,
        specifiedType: const FullType(String),
      );
    }
    if (object.order != null) {
      yield r'order';
      yield serializers.serialize(
        object.order,
        specifiedType: const FullType(AssetOrder),
      );
    }
    if (object.orderBy != null) {
      yield r'orderBy';
      yield serializers.serialize(
        object.orderBy,
        specifiedType: const FullType(SearchOrder),
      );
    }
    if (object.originalFileName != null) {
      yield r'originalFileName';
      yield serializers.serialize(
        object.originalFileName,
        specifiedType: const FullType(String),
      );
    }
    if (object.originalPath != null) {
      yield r'originalPath';
      yield serializers.serialize(
        object.originalPath,
        specifiedType: const FullType(String),
      );
    }
    if (object.page != null) {
      yield r'page';
      yield serializers.serialize(
        object.page,
        specifiedType: const FullType(int),
      );
    }
    if (object.personIds != null) {
      yield r'personIds';
      yield serializers.serialize(
        object.personIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.previewPath != null) {
      yield r'previewPath';
      yield serializers.serialize(
        object.previewPath,
        specifiedType: const FullType(String),
      );
    }
    if (object.rating != null) {
      yield r'rating';
      yield serializers.serialize(
        object.rating,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.size != null) {
      yield r'size';
      yield serializers.serialize(
        object.size,
        specifiedType: const FullType(int),
      );
    }
    if (object.state != null) {
      yield r'state';
      yield serializers.serialize(
        object.state,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.tagIds != null) {
      yield r'tagIds';
      yield serializers.serialize(
        object.tagIds,
        specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
      );
    }
    if (object.takenAfter != null) {
      yield r'takenAfter';
      yield serializers.serialize(
        object.takenAfter,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.takenBefore != null) {
      yield r'takenBefore';
      yield serializers.serialize(
        object.takenBefore,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.thumbnailPath != null) {
      yield r'thumbnailPath';
      yield serializers.serialize(
        object.thumbnailPath,
        specifiedType: const FullType(String),
      );
    }
    if (object.trashedAfter != null) {
      yield r'trashedAfter';
      yield serializers.serialize(
        object.trashedAfter,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.trashedBefore != null) {
      yield r'trashedBefore';
      yield serializers.serialize(
        object.trashedBefore,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.type != null) {
      yield r'type';
      yield serializers.serialize(
        object.type,
        specifiedType: const FullType(AssetTypeEnum),
      );
    }
    if (object.updatedAfter != null) {
      yield r'updatedAfter';
      yield serializers.serialize(
        object.updatedAfter,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.updatedBefore != null) {
      yield r'updatedBefore';
      yield serializers.serialize(
        object.updatedBefore,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.visibility != null) {
      yield r'visibility';
      yield serializers.serialize(
        object.visibility,
        specifiedType: const FullType(AssetVisibility),
      );
    }
    if (object.withDeleted != null) {
      yield r'withDeleted';
      yield serializers.serialize(
        object.withDeleted,
        specifiedType: const FullType(bool),
      );
    }
    if (object.withExif != null) {
      yield r'withExif';
      yield serializers.serialize(
        object.withExif,
        specifiedType: const FullType(bool),
      );
    }
    if (object.withPeople != null) {
      yield r'withPeople';
      yield serializers.serialize(
        object.withPeople,
        specifiedType: const FullType(bool),
      );
    }
    if (object.withStacked != null) {
      yield r'withStacked';
      yield serializers.serialize(
        object.withStacked,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MetadataSearchDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MetadataSearchDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'albumIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.albumIds.replace(valueDes);
          break;
        case r'checksum':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.checksum = valueDes;
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
        case r'createdAfter':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAfter = valueDes;
          break;
        case r'createdBefore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdBefore = valueDes;
          break;
        case r'cursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cursor = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'encodedVideoPath':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.encodedVideoPath = valueDes;
          break;
        case r'filter':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SearchFilter),
          ) as SearchFilter?;
          if (valueDes == null) continue;
          result.filter.replace(valueDes);
          break;
        case r'hasAiInterpretation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.hasAiInterpretation = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'isEncoded':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isEncoded = valueDes;
          break;
        case r'isFavorite':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isFavorite = valueDes;
          break;
        case r'isMotion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isMotion = valueDes;
          break;
        case r'isNotInAlbum':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isNotInAlbum = valueDes;
          break;
        case r'isOffline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isOffline = valueDes;
          break;
        case r'lensModel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.lensModel = valueDes;
          break;
        case r'libraryId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.libraryId = valueDes;
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
        case r'ocr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.ocr = valueDes;
          break;
        case r'order':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AssetOrder),
          ) as AssetOrder?;
          if (valueDes == null) continue;
          result.order = valueDes;
          break;
        case r'orderBy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SearchOrder),
          ) as SearchOrder?;
          if (valueDes == null) continue;
          result.orderBy.replace(valueDes);
          break;
        case r'originalFileName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.originalFileName = valueDes;
          break;
        case r'originalPath':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.originalPath = valueDes;
          break;
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.page = valueDes;
          break;
        case r'personIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.personIds.replace(valueDes);
          break;
        case r'previewPath':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.previewPath = valueDes;
          break;
        case r'rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.rating = valueDes;
          break;
        case r'size':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.size = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.state = valueDes;
          break;
        case r'tagIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.tagIds.replace(valueDes);
          break;
        case r'takenAfter':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.takenAfter = valueDes;
          break;
        case r'takenBefore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.takenBefore = valueDes;
          break;
        case r'thumbnailPath':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.thumbnailPath = valueDes;
          break;
        case r'trashedAfter':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.trashedAfter = valueDes;
          break;
        case r'trashedBefore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.trashedBefore = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AssetTypeEnum),
          ) as AssetTypeEnum?;
          if (valueDes == null) continue;
          result.type = valueDes;
          break;
        case r'updatedAfter':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.updatedAfter = valueDes;
          break;
        case r'updatedBefore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.updatedBefore = valueDes;
          break;
        case r'visibility':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AssetVisibility),
          ) as AssetVisibility?;
          if (valueDes == null) continue;
          result.visibility = valueDes;
          break;
        case r'withDeleted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.withDeleted = valueDes;
          break;
        case r'withExif':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.withExif = valueDes;
          break;
        case r'withPeople':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.withPeople = valueDes;
          break;
        case r'withStacked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.withStacked = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MetadataSearchDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MetadataSearchDtoBuilder();
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


