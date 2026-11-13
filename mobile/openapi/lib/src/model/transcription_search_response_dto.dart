//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/transcription_search_item_dto.dart';
import 'package:openapi/src/model/transcription_coverage_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'transcription_search_response_dto.g.dart';

/// TranscriptionSearchResponseDto
///
/// Properties:
/// * [configVersion] - Ranking configuration identity; cursors are invalid after a change
/// * [count] - Videos on this page
/// * [coverage] 
/// * [items] 
/// * [nextCursor] 
@BuiltValue()
abstract class TranscriptionSearchResponseDto implements Built<TranscriptionSearchResponseDto, TranscriptionSearchResponseDtoBuilder> {
  /// Ranking configuration identity; cursors are invalid after a change
  @BuiltValueField(wireName: r'configVersion')
  String get configVersion;

  /// Videos on this page
  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'coverage')
  TranscriptionCoverageDto? get coverage;

  @BuiltValueField(wireName: r'items')
  BuiltList<TranscriptionSearchItemDto> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  TranscriptionSearchResponseDto._();

  factory TranscriptionSearchResponseDto([void updates(TranscriptionSearchResponseDtoBuilder b)]) = _$TranscriptionSearchResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TranscriptionSearchResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TranscriptionSearchResponseDto> get serializer => _$TranscriptionSearchResponseDtoSerializer();
}

class _$TranscriptionSearchResponseDtoSerializer implements PrimitiveSerializer<TranscriptionSearchResponseDto> {
  @override
  final Iterable<Type> types = const [TranscriptionSearchResponseDto, _$TranscriptionSearchResponseDto];

  @override
  final String wireName = r'TranscriptionSearchResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TranscriptionSearchResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'configVersion';
    yield serializers.serialize(
      object.configVersion,
      specifiedType: const FullType(String),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    if (object.coverage != null) {
      yield r'coverage';
      yield serializers.serialize(
        object.coverage,
        specifiedType: const FullType(TranscriptionCoverageDto),
      );
    }
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(TranscriptionSearchItemDto)]),
    );
    yield r'nextCursor';
    yield object.nextCursor == null ? null : serializers.serialize(
      object.nextCursor,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TranscriptionSearchResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TranscriptionSearchResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'configVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.configVersion = valueDes;
          break;
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        case r'coverage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(TranscriptionCoverageDto),
          ) as TranscriptionCoverageDto?;
          if (valueDes == null) continue;
          result.coverage.replace(valueDes);
          break;
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TranscriptionSearchItemDto)]),
          ) as BuiltList<TranscriptionSearchItemDto>;
          result.items.replace(valueDes);
          break;
        case r'nextCursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextCursor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TranscriptionSearchResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TranscriptionSearchResponseDtoBuilder();
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


