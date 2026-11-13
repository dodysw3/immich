//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/asset_type_enum.dart';
import 'package:openapi/src/model/asset_visibility.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ai_interpret_search_dto.g.dart';

/// AiInterpretSearchDto
///
/// Properties:
/// * [city] - Filter by city name (null = no city)
/// * [country] - Filter by country name (null = no country)
/// * [hasAiInterpretation] - Filter by presence of a completed AI interpretation
/// * [isFavorite] - Filter by favorite status
/// * [isNotInAlbum] - Filter assets not in any album
/// * [lensModel] - Filter by lens model (null = no lens)
/// * [make] - Filter by camera make (null = no make)
/// * [model] - Filter by camera model (null = no model)
/// * [page] - Page number
/// * [personIds] - Filter by person IDs (all must match)
/// * [q] - Natural language query against AI interpretations
/// * [rating] - Filter by rating (null = unrated)
/// * [size] - Number of results to return
/// * [state] - Filter by state/province name (null = no state)
/// * [tagIds] - Filter by tag IDs (all must match; null = untagged)
/// * [takenAfter] - Filter by taken date (after)
/// * [takenBefore] - Filter by taken date (before)
/// * [type] 
/// * [visibility] 
/// * [withStacked] - Include stacked assets
@BuiltValue()
abstract class AiInterpretSearchDto implements Built<AiInterpretSearchDto, AiInterpretSearchDtoBuilder> {
  /// Filter by city name (null = no city)
  @BuiltValueField(wireName: r'city')
  String? get city;

  /// Filter by country name (null = no country)
  @BuiltValueField(wireName: r'country')
  String? get country;

  /// Filter by presence of a completed AI interpretation
  @BuiltValueField(wireName: r'hasAiInterpretation')
  bool? get hasAiInterpretation;

  /// Filter by favorite status
  @BuiltValueField(wireName: r'isFavorite')
  bool? get isFavorite;

  /// Filter assets not in any album
  @BuiltValueField(wireName: r'isNotInAlbum')
  bool? get isNotInAlbum;

  /// Filter by lens model (null = no lens)
  @BuiltValueField(wireName: r'lensModel')
  String? get lensModel;

  /// Filter by camera make (null = no make)
  @BuiltValueField(wireName: r'make')
  String? get make;

  /// Filter by camera model (null = no model)
  @BuiltValueField(wireName: r'model')
  String? get model;

  /// Page number
  @BuiltValueField(wireName: r'page')
  int? get page;

  /// Filter by person IDs (all must match)
  @BuiltValueField(wireName: r'personIds')
  BuiltList<String>? get personIds;

  /// Natural language query against AI interpretations
  @BuiltValueField(wireName: r'q')
  String get q;

  /// Filter by rating (null = unrated)
  @BuiltValueField(wireName: r'rating')
  int? get rating;

  /// Number of results to return
  @BuiltValueField(wireName: r'size')
  int? get size;

  /// Filter by state/province name (null = no state)
  @BuiltValueField(wireName: r'state')
  String? get state;

  /// Filter by tag IDs (all must match; null = untagged)
  @BuiltValueField(wireName: r'tagIds')
  BuiltList<String>? get tagIds;

  /// Filter by taken date (after)
  @BuiltValueField(wireName: r'takenAfter')
  DateTime? get takenAfter;

  /// Filter by taken date (before)
  @BuiltValueField(wireName: r'takenBefore')
  DateTime? get takenBefore;

  @BuiltValueField(wireName: r'type')
  AssetTypeEnum? get type;
  // enum typeEnum {  IMAGE,  VIDEO,  AUDIO,  OTHER,  };

  @BuiltValueField(wireName: r'visibility')
  AssetVisibility? get visibility;
  // enum visibilityEnum {  archive,  timeline,  hidden,  locked,  };

  /// Include stacked assets
  @BuiltValueField(wireName: r'withStacked')
  bool? get withStacked;

  AiInterpretSearchDto._();

  factory AiInterpretSearchDto([void updates(AiInterpretSearchDtoBuilder b)]) = _$AiInterpretSearchDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AiInterpretSearchDtoBuilder b) => b
      ..size = 100;

  @BuiltValueSerializer(custom: true)
  static Serializer<AiInterpretSearchDto> get serializer => _$AiInterpretSearchDtoSerializer();
}

class _$AiInterpretSearchDtoSerializer implements PrimitiveSerializer<AiInterpretSearchDto> {
  @override
  final Iterable<Type> types = const [AiInterpretSearchDto, _$AiInterpretSearchDto];

  @override
  final String wireName = r'AiInterpretSearchDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AiInterpretSearchDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    if (object.hasAiInterpretation != null) {
      yield r'hasAiInterpretation';
      yield serializers.serialize(
        object.hasAiInterpretation,
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
    if (object.isNotInAlbum != null) {
      yield r'isNotInAlbum';
      yield serializers.serialize(
        object.isNotInAlbum,
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
    yield r'q';
    yield serializers.serialize(
      object.q,
      specifiedType: const FullType(String),
    );
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
    if (object.type != null) {
      yield r'type';
      yield serializers.serialize(
        object.type,
        specifiedType: const FullType(AssetTypeEnum),
      );
    }
    if (object.visibility != null) {
      yield r'visibility';
      yield serializers.serialize(
        object.visibility,
        specifiedType: const FullType(AssetVisibility),
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
    AiInterpretSearchDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AiInterpretSearchDtoBuilder result,
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
        case r'hasAiInterpretation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.hasAiInterpretation = valueDes;
          break;
        case r'isFavorite':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isFavorite = valueDes;
          break;
        case r'isNotInAlbum':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isNotInAlbum = valueDes;
          break;
        case r'lensModel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.lensModel = valueDes;
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
        case r'q':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.q = valueDes;
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
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AssetTypeEnum),
          ) as AssetTypeEnum?;
          if (valueDes == null) continue;
          result.type = valueDes;
          break;
        case r'visibility':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AssetVisibility),
          ) as AssetVisibility?;
          if (valueDes == null) continue;
          result.visibility = valueDes;
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
  AiInterpretSearchDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AiInterpretSearchDtoBuilder();
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


