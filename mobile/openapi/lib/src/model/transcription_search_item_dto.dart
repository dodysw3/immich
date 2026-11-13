//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/asset_response_dto.dart';
import 'package:openapi/src/model/transcription_match_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'transcription_search_item_dto.g.dart';

/// TranscriptionSearchItemDto
///
/// Properties:
/// * [additionalMatches] - Distinct additional matching moments
/// * [asset] 
/// * [bestMatch] 
/// * [matchCount] - Total distinct matching moments for this video
@BuiltValue()
abstract class TranscriptionSearchItemDto implements Built<TranscriptionSearchItemDto, TranscriptionSearchItemDtoBuilder> {
  /// Distinct additional matching moments
  @BuiltValueField(wireName: r'additionalMatches')
  BuiltList<TranscriptionMatchDto> get additionalMatches;

  @BuiltValueField(wireName: r'asset')
  AssetResponseDto get asset;

  @BuiltValueField(wireName: r'bestMatch')
  TranscriptionMatchDto get bestMatch;

  /// Total distinct matching moments for this video
  @BuiltValueField(wireName: r'matchCount')
  int get matchCount;

  TranscriptionSearchItemDto._();

  factory TranscriptionSearchItemDto([void updates(TranscriptionSearchItemDtoBuilder b)]) = _$TranscriptionSearchItemDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TranscriptionSearchItemDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TranscriptionSearchItemDto> get serializer => _$TranscriptionSearchItemDtoSerializer();
}

class _$TranscriptionSearchItemDtoSerializer implements PrimitiveSerializer<TranscriptionSearchItemDto> {
  @override
  final Iterable<Type> types = const [TranscriptionSearchItemDto, _$TranscriptionSearchItemDto];

  @override
  final String wireName = r'TranscriptionSearchItemDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TranscriptionSearchItemDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'additionalMatches';
    yield serializers.serialize(
      object.additionalMatches,
      specifiedType: const FullType(BuiltList, [FullType(TranscriptionMatchDto)]),
    );
    yield r'asset';
    yield serializers.serialize(
      object.asset,
      specifiedType: const FullType(AssetResponseDto),
    );
    yield r'bestMatch';
    yield serializers.serialize(
      object.bestMatch,
      specifiedType: const FullType(TranscriptionMatchDto),
    );
    yield r'matchCount';
    yield serializers.serialize(
      object.matchCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TranscriptionSearchItemDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TranscriptionSearchItemDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'additionalMatches':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TranscriptionMatchDto)]),
          ) as BuiltList<TranscriptionMatchDto>;
          result.additionalMatches.replace(valueDes);
          break;
        case r'asset':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AssetResponseDto),
          ) as AssetResponseDto;
          result.asset.replace(valueDes);
          break;
        case r'bestMatch':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TranscriptionMatchDto),
          ) as TranscriptionMatchDto;
          result.bestMatch.replace(valueDes);
          break;
        case r'matchCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.matchCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TranscriptionSearchItemDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TranscriptionSearchItemDtoBuilder();
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


