//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'transcription_search_span_dto.g.dart';

/// TranscriptionSearchSpanDto
///
/// Properties:
/// * [end] - UTF-16 end offset of the matched text within the snippet
/// * [start] - UTF-16 start offset of the matched text within the snippet
@BuiltValue()
abstract class TranscriptionSearchSpanDto implements Built<TranscriptionSearchSpanDto, TranscriptionSearchSpanDtoBuilder> {
  /// UTF-16 end offset of the matched text within the snippet
  @BuiltValueField(wireName: r'end')
  int get end;

  /// UTF-16 start offset of the matched text within the snippet
  @BuiltValueField(wireName: r'start')
  int get start;

  TranscriptionSearchSpanDto._();

  factory TranscriptionSearchSpanDto([void updates(TranscriptionSearchSpanDtoBuilder b)]) = _$TranscriptionSearchSpanDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TranscriptionSearchSpanDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TranscriptionSearchSpanDto> get serializer => _$TranscriptionSearchSpanDtoSerializer();
}

class _$TranscriptionSearchSpanDtoSerializer implements PrimitiveSerializer<TranscriptionSearchSpanDto> {
  @override
  final Iterable<Type> types = const [TranscriptionSearchSpanDto, _$TranscriptionSearchSpanDto];

  @override
  final String wireName = r'TranscriptionSearchSpanDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TranscriptionSearchSpanDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'end';
    yield serializers.serialize(
      object.end,
      specifiedType: const FullType(int),
    );
    yield r'start';
    yield serializers.serialize(
      object.start,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TranscriptionSearchSpanDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TranscriptionSearchSpanDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'end':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.end = valueDes;
          break;
        case r'start':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.start = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TranscriptionSearchSpanDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TranscriptionSearchSpanDtoBuilder();
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


