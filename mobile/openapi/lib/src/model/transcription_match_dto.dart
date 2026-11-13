//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/transcription_search_span_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/transcription_match_dto_components.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'transcription_match_dto.g.dart';

/// TranscriptionMatchDto
///
/// Properties:
/// * [components] 
/// * [endMs] 
/// * [firstSegment] 
/// * [lastSegment] 
/// * [passageId] - Opaque passage id (used for moment retrieval and frame resolution)
/// * [revision] - Source transcript content revision
/// * [runKey] - Source transcription run identity
/// * [score] - Normalized within-tier score
/// * [snippet] - Original transcript text of the passage
/// * [spans] - Matched text spans within the snippet (never HTML)
/// * [startMs] - Match moment: the start of the first matched segment (segment precision, not word alignment)
/// * [tier] 
/// * [windowId] - Contributing segment range (first:last)
@BuiltValue()
abstract class TranscriptionMatchDto implements Built<TranscriptionMatchDto, TranscriptionMatchDtoBuilder> {
  @BuiltValueField(wireName: r'components')
  TranscriptionMatchDtoComponents? get components;

  @BuiltValueField(wireName: r'endMs')
  int get endMs;

  @BuiltValueField(wireName: r'firstSegment')
  int get firstSegment;

  @BuiltValueField(wireName: r'lastSegment')
  int get lastSegment;

  /// Opaque passage id (used for moment retrieval and frame resolution)
  @BuiltValueField(wireName: r'passageId')
  String get passageId;

  /// Source transcript content revision
  @BuiltValueField(wireName: r'revision')
  String get revision;

  /// Source transcription run identity
  @BuiltValueField(wireName: r'runKey')
  String get runKey;

  /// Normalized within-tier score
  @BuiltValueField(wireName: r'score')
  double get score;

  /// Original transcript text of the passage
  @BuiltValueField(wireName: r'snippet')
  String get snippet;

  /// Matched text spans within the snippet (never HTML)
  @BuiltValueField(wireName: r'spans')
  BuiltList<TranscriptionSearchSpanDto> get spans;

  /// Match moment: the start of the first matched segment (segment precision, not word alignment)
  @BuiltValueField(wireName: r'startMs')
  int get startMs;

  @BuiltValueField(wireName: r'tier')
  TranscriptionMatchDtoTierEnum get tier;
  // enum tierEnum {  exact-phrase,  exact-all,  fuzzy,  partial,  };

  /// Contributing segment range (first:last)
  @BuiltValueField(wireName: r'windowId')
  String get windowId;

  TranscriptionMatchDto._();

  factory TranscriptionMatchDto([void updates(TranscriptionMatchDtoBuilder b)]) = _$TranscriptionMatchDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TranscriptionMatchDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TranscriptionMatchDto> get serializer => _$TranscriptionMatchDtoSerializer();
}

class _$TranscriptionMatchDtoSerializer implements PrimitiveSerializer<TranscriptionMatchDto> {
  @override
  final Iterable<Type> types = const [TranscriptionMatchDto, _$TranscriptionMatchDto];

  @override
  final String wireName = r'TranscriptionMatchDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TranscriptionMatchDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.components != null) {
      yield r'components';
      yield serializers.serialize(
        object.components,
        specifiedType: const FullType(TranscriptionMatchDtoComponents),
      );
    }
    yield r'endMs';
    yield serializers.serialize(
      object.endMs,
      specifiedType: const FullType(int),
    );
    yield r'firstSegment';
    yield serializers.serialize(
      object.firstSegment,
      specifiedType: const FullType(int),
    );
    yield r'lastSegment';
    yield serializers.serialize(
      object.lastSegment,
      specifiedType: const FullType(int),
    );
    yield r'passageId';
    yield serializers.serialize(
      object.passageId,
      specifiedType: const FullType(String),
    );
    yield r'revision';
    yield serializers.serialize(
      object.revision,
      specifiedType: const FullType(String),
    );
    yield r'runKey';
    yield serializers.serialize(
      object.runKey,
      specifiedType: const FullType(String),
    );
    yield r'score';
    yield serializers.serialize(
      object.score,
      specifiedType: const FullType(double),
    );
    yield r'snippet';
    yield serializers.serialize(
      object.snippet,
      specifiedType: const FullType(String),
    );
    yield r'spans';
    yield serializers.serialize(
      object.spans,
      specifiedType: const FullType(BuiltList, [FullType(TranscriptionSearchSpanDto)]),
    );
    yield r'startMs';
    yield serializers.serialize(
      object.startMs,
      specifiedType: const FullType(int),
    );
    yield r'tier';
    yield serializers.serialize(
      object.tier,
      specifiedType: const FullType(TranscriptionMatchDtoTierEnum),
    );
    yield r'windowId';
    yield serializers.serialize(
      object.windowId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TranscriptionMatchDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TranscriptionMatchDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'components':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(TranscriptionMatchDtoComponents),
          ) as TranscriptionMatchDtoComponents?;
          if (valueDes == null) continue;
          result.components.replace(valueDes);
          break;
        case r'endMs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.endMs = valueDes;
          break;
        case r'firstSegment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.firstSegment = valueDes;
          break;
        case r'lastSegment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lastSegment = valueDes;
          break;
        case r'passageId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.passageId = valueDes;
          break;
        case r'revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.revision = valueDes;
          break;
        case r'runKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.runKey = valueDes;
          break;
        case r'score':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.score = valueDes;
          break;
        case r'snippet':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.snippet = valueDes;
          break;
        case r'spans':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TranscriptionSearchSpanDto)]),
          ) as BuiltList<TranscriptionSearchSpanDto>;
          result.spans.replace(valueDes);
          break;
        case r'startMs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.startMs = valueDes;
          break;
        case r'tier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TranscriptionMatchDtoTierEnum),
          ) as TranscriptionMatchDtoTierEnum;
          result.tier = valueDes;
          break;
        case r'windowId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.windowId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TranscriptionMatchDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TranscriptionMatchDtoBuilder();
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


class TranscriptionMatchDtoTierEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'exact-phrase')
  static const TranscriptionMatchDtoTierEnum exactPhrase = _$transcriptionMatchDtoTierEnum_exactPhrase;
  @BuiltValueEnumConst(wireName: r'exact-all')
  static const TranscriptionMatchDtoTierEnum exactAll = _$transcriptionMatchDtoTierEnum_exactAll;
  @BuiltValueEnumConst(wireName: r'fuzzy')
  static const TranscriptionMatchDtoTierEnum fuzzy = _$transcriptionMatchDtoTierEnum_fuzzy;
  @BuiltValueEnumConst(wireName: r'partial')
  static const TranscriptionMatchDtoTierEnum partial = _$transcriptionMatchDtoTierEnum_partial;

  static Serializer<TranscriptionMatchDtoTierEnum> get serializer => _$transcriptionMatchDtoTierEnumSerializer;

  const TranscriptionMatchDtoTierEnum._(String name): super(name);

  static BuiltSet<TranscriptionMatchDtoTierEnum> get values => _$transcriptionMatchDtoTierEnumValues;
  static TranscriptionMatchDtoTierEnum valueOf(String name) => _$transcriptionMatchDtoTierEnumValueOf(name);
}

