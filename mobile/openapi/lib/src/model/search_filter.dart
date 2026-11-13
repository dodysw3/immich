//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/string_filter_nullable.dart';
import 'package:openapi/src/model/enum_filter_asset_type.dart';
import 'package:openapi/src/model/number_filter.dart';
import 'package:openapi/src/model/date_filter_nullable.dart';
import 'package:openapi/src/model/id_filter_nullable.dart';
import 'package:openapi/src/model/enum_filter_asset_visibility.dart';
import 'package:openapi/src/model/bool_filter.dart';
import 'package:openapi/src/model/search_filter_branch.dart';
import 'package:openapi/src/model/string_pattern_filter.dart';
import 'package:openapi/src/model/date_filter.dart';
import 'package:openapi/src/model/number_filter_nullable.dart';
import 'package:openapi/src/model/string_similarity_filter.dart';
import 'package:openapi/src/model/ids_filter.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/id_filter.dart';
import 'package:openapi/src/model/string_filter.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_filter.g.dart';

/// SearchFilter
///
/// Properties:
/// * [albumIds] 
/// * [checksum] 
/// * [city] 
/// * [country] 
/// * [createdAt] 
/// * [description] 
/// * [encodedVideoPath] 
/// * [fileSizeInBytes] 
/// * [hasAiInterpretation] 
/// * [hasAlbums] 
/// * [hasPeople] 
/// * [hasTags] 
/// * [id] 
/// * [isEncoded] 
/// * [isFavorite] 
/// * [isMotion] 
/// * [isOffline] 
/// * [lensModel] 
/// * [libraryId] 
/// * [make] 
/// * [model] 
/// * [ocr] 
/// * [or] 
/// * [originalFileName] 
/// * [originalPath] 
/// * [personIds] 
/// * [rating] 
/// * [state] 
/// * [tagIds] 
/// * [takenAt] 
/// * [trashedAt] 
/// * [type] 
/// * [updatedAt] 
/// * [visibility] 
@BuiltValue()
abstract class SearchFilter implements Built<SearchFilter, SearchFilterBuilder> {
  @BuiltValueField(wireName: r'albumIds')
  IdsFilter? get albumIds;

  @BuiltValueField(wireName: r'checksum')
  StringFilter? get checksum;

  @BuiltValueField(wireName: r'city')
  StringFilterNullable? get city;

  @BuiltValueField(wireName: r'country')
  StringFilterNullable? get country;

  @BuiltValueField(wireName: r'createdAt')
  DateFilter? get createdAt;

  @BuiltValueField(wireName: r'description')
  StringPatternFilter? get description;

  @BuiltValueField(wireName: r'encodedVideoPath')
  StringFilter? get encodedVideoPath;

  @BuiltValueField(wireName: r'fileSizeInBytes')
  NumberFilter? get fileSizeInBytes;

  @BuiltValueField(wireName: r'hasAiInterpretation')
  BoolFilter? get hasAiInterpretation;

  @BuiltValueField(wireName: r'hasAlbums')
  BoolFilter? get hasAlbums;

  @BuiltValueField(wireName: r'hasPeople')
  BoolFilter? get hasPeople;

  @BuiltValueField(wireName: r'hasTags')
  BoolFilter? get hasTags;

  @BuiltValueField(wireName: r'id')
  IdFilter? get id;

  @BuiltValueField(wireName: r'isEncoded')
  BoolFilter? get isEncoded;

  @BuiltValueField(wireName: r'isFavorite')
  BoolFilter? get isFavorite;

  @BuiltValueField(wireName: r'isMotion')
  BoolFilter? get isMotion;

  @BuiltValueField(wireName: r'isOffline')
  BoolFilter? get isOffline;

  @BuiltValueField(wireName: r'lensModel')
  StringFilterNullable? get lensModel;

  @BuiltValueField(wireName: r'libraryId')
  IdFilterNullable? get libraryId;

  @BuiltValueField(wireName: r'make')
  StringFilterNullable? get make;

  @BuiltValueField(wireName: r'model')
  StringFilterNullable? get model;

  @BuiltValueField(wireName: r'ocr')
  StringSimilarityFilter? get ocr;

  @BuiltValueField(wireName: r'or')
  BuiltList<SearchFilterBranch>? get or;

  @BuiltValueField(wireName: r'originalFileName')
  StringPatternFilter? get originalFileName;

  @BuiltValueField(wireName: r'originalPath')
  StringPatternFilter? get originalPath;

  @BuiltValueField(wireName: r'personIds')
  IdsFilter? get personIds;

  @BuiltValueField(wireName: r'rating')
  NumberFilterNullable? get rating;

  @BuiltValueField(wireName: r'state')
  StringFilterNullable? get state;

  @BuiltValueField(wireName: r'tagIds')
  IdsFilter? get tagIds;

  @BuiltValueField(wireName: r'takenAt')
  DateFilter? get takenAt;

  @BuiltValueField(wireName: r'trashedAt')
  DateFilterNullable? get trashedAt;

  @BuiltValueField(wireName: r'type')
  EnumFilterAssetType? get type;

  @BuiltValueField(wireName: r'updatedAt')
  DateFilter? get updatedAt;

  @BuiltValueField(wireName: r'visibility')
  EnumFilterAssetVisibility? get visibility;

  SearchFilter._();

  factory SearchFilter([void updates(SearchFilterBuilder b)]) = _$SearchFilter;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SearchFilterBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SearchFilter> get serializer => _$SearchFilterSerializer();
}

class _$SearchFilterSerializer implements PrimitiveSerializer<SearchFilter> {
  @override
  final Iterable<Type> types = const [SearchFilter, _$SearchFilter];

  @override
  final String wireName = r'SearchFilter';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SearchFilter object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.albumIds != null) {
      yield r'albumIds';
      yield serializers.serialize(
        object.albumIds,
        specifiedType: const FullType(IdsFilter),
      );
    }
    if (object.checksum != null) {
      yield r'checksum';
      yield serializers.serialize(
        object.checksum,
        specifiedType: const FullType(StringFilter),
      );
    }
    if (object.city != null) {
      yield r'city';
      yield serializers.serialize(
        object.city,
        specifiedType: const FullType(StringFilterNullable),
      );
    }
    if (object.country != null) {
      yield r'country';
      yield serializers.serialize(
        object.country,
        specifiedType: const FullType(StringFilterNullable),
      );
    }
    if (object.createdAt != null) {
      yield r'createdAt';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateFilter),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(StringPatternFilter),
      );
    }
    if (object.encodedVideoPath != null) {
      yield r'encodedVideoPath';
      yield serializers.serialize(
        object.encodedVideoPath,
        specifiedType: const FullType(StringFilter),
      );
    }
    if (object.fileSizeInBytes != null) {
      yield r'fileSizeInBytes';
      yield serializers.serialize(
        object.fileSizeInBytes,
        specifiedType: const FullType(NumberFilter),
      );
    }
    if (object.hasAiInterpretation != null) {
      yield r'hasAiInterpretation';
      yield serializers.serialize(
        object.hasAiInterpretation,
        specifiedType: const FullType(BoolFilter),
      );
    }
    if (object.hasAlbums != null) {
      yield r'hasAlbums';
      yield serializers.serialize(
        object.hasAlbums,
        specifiedType: const FullType(BoolFilter),
      );
    }
    if (object.hasPeople != null) {
      yield r'hasPeople';
      yield serializers.serialize(
        object.hasPeople,
        specifiedType: const FullType(BoolFilter),
      );
    }
    if (object.hasTags != null) {
      yield r'hasTags';
      yield serializers.serialize(
        object.hasTags,
        specifiedType: const FullType(BoolFilter),
      );
    }
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(IdFilter),
      );
    }
    if (object.isEncoded != null) {
      yield r'isEncoded';
      yield serializers.serialize(
        object.isEncoded,
        specifiedType: const FullType(BoolFilter),
      );
    }
    if (object.isFavorite != null) {
      yield r'isFavorite';
      yield serializers.serialize(
        object.isFavorite,
        specifiedType: const FullType(BoolFilter),
      );
    }
    if (object.isMotion != null) {
      yield r'isMotion';
      yield serializers.serialize(
        object.isMotion,
        specifiedType: const FullType(BoolFilter),
      );
    }
    if (object.isOffline != null) {
      yield r'isOffline';
      yield serializers.serialize(
        object.isOffline,
        specifiedType: const FullType(BoolFilter),
      );
    }
    if (object.lensModel != null) {
      yield r'lensModel';
      yield serializers.serialize(
        object.lensModel,
        specifiedType: const FullType(StringFilterNullable),
      );
    }
    if (object.libraryId != null) {
      yield r'libraryId';
      yield serializers.serialize(
        object.libraryId,
        specifiedType: const FullType(IdFilterNullable),
      );
    }
    if (object.make != null) {
      yield r'make';
      yield serializers.serialize(
        object.make,
        specifiedType: const FullType(StringFilterNullable),
      );
    }
    if (object.model != null) {
      yield r'model';
      yield serializers.serialize(
        object.model,
        specifiedType: const FullType(StringFilterNullable),
      );
    }
    if (object.ocr != null) {
      yield r'ocr';
      yield serializers.serialize(
        object.ocr,
        specifiedType: const FullType(StringSimilarityFilter),
      );
    }
    if (object.or != null) {
      yield r'or';
      yield serializers.serialize(
        object.or,
        specifiedType: const FullType(BuiltList, [FullType(SearchFilterBranch)]),
      );
    }
    if (object.originalFileName != null) {
      yield r'originalFileName';
      yield serializers.serialize(
        object.originalFileName,
        specifiedType: const FullType(StringPatternFilter),
      );
    }
    if (object.originalPath != null) {
      yield r'originalPath';
      yield serializers.serialize(
        object.originalPath,
        specifiedType: const FullType(StringPatternFilter),
      );
    }
    if (object.personIds != null) {
      yield r'personIds';
      yield serializers.serialize(
        object.personIds,
        specifiedType: const FullType(IdsFilter),
      );
    }
    if (object.rating != null) {
      yield r'rating';
      yield serializers.serialize(
        object.rating,
        specifiedType: const FullType(NumberFilterNullable),
      );
    }
    if (object.state != null) {
      yield r'state';
      yield serializers.serialize(
        object.state,
        specifiedType: const FullType(StringFilterNullable),
      );
    }
    if (object.tagIds != null) {
      yield r'tagIds';
      yield serializers.serialize(
        object.tagIds,
        specifiedType: const FullType(IdsFilter),
      );
    }
    if (object.takenAt != null) {
      yield r'takenAt';
      yield serializers.serialize(
        object.takenAt,
        specifiedType: const FullType(DateFilter),
      );
    }
    if (object.trashedAt != null) {
      yield r'trashedAt';
      yield serializers.serialize(
        object.trashedAt,
        specifiedType: const FullType(DateFilterNullable),
      );
    }
    if (object.type != null) {
      yield r'type';
      yield serializers.serialize(
        object.type,
        specifiedType: const FullType(EnumFilterAssetType),
      );
    }
    if (object.updatedAt != null) {
      yield r'updatedAt';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(DateFilter),
      );
    }
    if (object.visibility != null) {
      yield r'visibility';
      yield serializers.serialize(
        object.visibility,
        specifiedType: const FullType(EnumFilterAssetVisibility),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SearchFilter object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SearchFilterBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'albumIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(IdsFilter),
          ) as IdsFilter?;
          if (valueDes == null) continue;
          result.albumIds.replace(valueDes);
          break;
        case r'checksum':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(StringFilter),
          ) as StringFilter?;
          if (valueDes == null) continue;
          result.checksum.replace(valueDes);
          break;
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(StringFilterNullable),
          ) as StringFilterNullable?;
          if (valueDes == null) continue;
          result.city.replace(valueDes);
          break;
        case r'country':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(StringFilterNullable),
          ) as StringFilterNullable?;
          if (valueDes == null) continue;
          result.country.replace(valueDes);
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateFilter),
          ) as DateFilter?;
          if (valueDes == null) continue;
          result.createdAt.replace(valueDes);
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(StringPatternFilter),
          ) as StringPatternFilter?;
          if (valueDes == null) continue;
          result.description.replace(valueDes);
          break;
        case r'encodedVideoPath':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(StringFilter),
          ) as StringFilter?;
          if (valueDes == null) continue;
          result.encodedVideoPath.replace(valueDes);
          break;
        case r'fileSizeInBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(NumberFilter),
          ) as NumberFilter?;
          if (valueDes == null) continue;
          result.fileSizeInBytes.replace(valueDes);
          break;
        case r'hasAiInterpretation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BoolFilter),
          ) as BoolFilter?;
          if (valueDes == null) continue;
          result.hasAiInterpretation.replace(valueDes);
          break;
        case r'hasAlbums':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BoolFilter),
          ) as BoolFilter?;
          if (valueDes == null) continue;
          result.hasAlbums.replace(valueDes);
          break;
        case r'hasPeople':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BoolFilter),
          ) as BoolFilter?;
          if (valueDes == null) continue;
          result.hasPeople.replace(valueDes);
          break;
        case r'hasTags':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BoolFilter),
          ) as BoolFilter?;
          if (valueDes == null) continue;
          result.hasTags.replace(valueDes);
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(IdFilter),
          ) as IdFilter?;
          if (valueDes == null) continue;
          result.id.replace(valueDes);
          break;
        case r'isEncoded':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BoolFilter),
          ) as BoolFilter?;
          if (valueDes == null) continue;
          result.isEncoded.replace(valueDes);
          break;
        case r'isFavorite':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BoolFilter),
          ) as BoolFilter?;
          if (valueDes == null) continue;
          result.isFavorite.replace(valueDes);
          break;
        case r'isMotion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BoolFilter),
          ) as BoolFilter?;
          if (valueDes == null) continue;
          result.isMotion.replace(valueDes);
          break;
        case r'isOffline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BoolFilter),
          ) as BoolFilter?;
          if (valueDes == null) continue;
          result.isOffline.replace(valueDes);
          break;
        case r'lensModel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(StringFilterNullable),
          ) as StringFilterNullable?;
          if (valueDes == null) continue;
          result.lensModel.replace(valueDes);
          break;
        case r'libraryId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(IdFilterNullable),
          ) as IdFilterNullable?;
          if (valueDes == null) continue;
          result.libraryId.replace(valueDes);
          break;
        case r'make':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(StringFilterNullable),
          ) as StringFilterNullable?;
          if (valueDes == null) continue;
          result.make.replace(valueDes);
          break;
        case r'model':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(StringFilterNullable),
          ) as StringFilterNullable?;
          if (valueDes == null) continue;
          result.model.replace(valueDes);
          break;
        case r'ocr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(StringSimilarityFilter),
          ) as StringSimilarityFilter?;
          if (valueDes == null) continue;
          result.ocr.replace(valueDes);
          break;
        case r'or':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(SearchFilterBranch)]),
          ) as BuiltList<SearchFilterBranch>?;
          if (valueDes == null) continue;
          result.or.replace(valueDes);
          break;
        case r'originalFileName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(StringPatternFilter),
          ) as StringPatternFilter?;
          if (valueDes == null) continue;
          result.originalFileName.replace(valueDes);
          break;
        case r'originalPath':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(StringPatternFilter),
          ) as StringPatternFilter?;
          if (valueDes == null) continue;
          result.originalPath.replace(valueDes);
          break;
        case r'personIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(IdsFilter),
          ) as IdsFilter?;
          if (valueDes == null) continue;
          result.personIds.replace(valueDes);
          break;
        case r'rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(NumberFilterNullable),
          ) as NumberFilterNullable?;
          if (valueDes == null) continue;
          result.rating.replace(valueDes);
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(StringFilterNullable),
          ) as StringFilterNullable?;
          if (valueDes == null) continue;
          result.state.replace(valueDes);
          break;
        case r'tagIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(IdsFilter),
          ) as IdsFilter?;
          if (valueDes == null) continue;
          result.tagIds.replace(valueDes);
          break;
        case r'takenAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateFilter),
          ) as DateFilter?;
          if (valueDes == null) continue;
          result.takenAt.replace(valueDes);
          break;
        case r'trashedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateFilterNullable),
          ) as DateFilterNullable?;
          if (valueDes == null) continue;
          result.trashedAt.replace(valueDes);
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(EnumFilterAssetType),
          ) as EnumFilterAssetType?;
          if (valueDes == null) continue;
          result.type.replace(valueDes);
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateFilter),
          ) as DateFilter?;
          if (valueDes == null) continue;
          result.updatedAt.replace(valueDes);
          break;
        case r'visibility':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(EnumFilterAssetVisibility),
          ) as EnumFilterAssetVisibility?;
          if (valueDes == null) continue;
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
  SearchFilter deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SearchFilterBuilder();
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


