//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/transcription_match_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'transcription_moments_response_dto.g.dart';

/// TranscriptionMomentsResponseDto
///
/// Properties:
/// * [configVersion] 
/// * [count] 
/// * [moments] 
/// * [nextCursor] 
@BuiltValue()
abstract class TranscriptionMomentsResponseDto implements Built<TranscriptionMomentsResponseDto, TranscriptionMomentsResponseDtoBuilder> {
  @BuiltValueField(wireName: r'configVersion')
  String get configVersion;

  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'moments')
  BuiltList<TranscriptionMatchDto> get moments;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  TranscriptionMomentsResponseDto._();

  factory TranscriptionMomentsResponseDto([void updates(TranscriptionMomentsResponseDtoBuilder b)]) = _$TranscriptionMomentsResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TranscriptionMomentsResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TranscriptionMomentsResponseDto> get serializer => _$TranscriptionMomentsResponseDtoSerializer();
}

class _$TranscriptionMomentsResponseDtoSerializer implements PrimitiveSerializer<TranscriptionMomentsResponseDto> {
  @override
  final Iterable<Type> types = const [TranscriptionMomentsResponseDto, _$TranscriptionMomentsResponseDto];

  @override
  final String wireName = r'TranscriptionMomentsResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TranscriptionMomentsResponseDto object, {
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
    yield r'moments';
    yield serializers.serialize(
      object.moments,
      specifiedType: const FullType(BuiltList, [FullType(TranscriptionMatchDto)]),
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
    TranscriptionMomentsResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TranscriptionMomentsResponseDtoBuilder result,
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
        case r'moments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TranscriptionMatchDto)]),
          ) as BuiltList<TranscriptionMatchDto>;
          result.moments.replace(valueDes);
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
  TranscriptionMomentsResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TranscriptionMomentsResponseDtoBuilder();
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


