//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'transcription_match_dto_components.g.dart';

/// Score components (opt-in diagnostics)
///
/// Properties:
/// * [coverage] 
/// * [proximity] 
/// * [similarity] 
@BuiltValue()
abstract class TranscriptionMatchDtoComponents implements Built<TranscriptionMatchDtoComponents, TranscriptionMatchDtoComponentsBuilder> {
  @BuiltValueField(wireName: r'coverage')
  double get coverage;

  @BuiltValueField(wireName: r'proximity')
  double get proximity;

  @BuiltValueField(wireName: r'similarity')
  double get similarity;

  TranscriptionMatchDtoComponents._();

  factory TranscriptionMatchDtoComponents([void updates(TranscriptionMatchDtoComponentsBuilder b)]) = _$TranscriptionMatchDtoComponents;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TranscriptionMatchDtoComponentsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TranscriptionMatchDtoComponents> get serializer => _$TranscriptionMatchDtoComponentsSerializer();
}

class _$TranscriptionMatchDtoComponentsSerializer implements PrimitiveSerializer<TranscriptionMatchDtoComponents> {
  @override
  final Iterable<Type> types = const [TranscriptionMatchDtoComponents, _$TranscriptionMatchDtoComponents];

  @override
  final String wireName = r'TranscriptionMatchDtoComponents';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TranscriptionMatchDtoComponents object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'coverage';
    yield serializers.serialize(
      object.coverage,
      specifiedType: const FullType(double),
    );
    yield r'proximity';
    yield serializers.serialize(
      object.proximity,
      specifiedType: const FullType(double),
    );
    yield r'similarity';
    yield serializers.serialize(
      object.similarity,
      specifiedType: const FullType(double),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TranscriptionMatchDtoComponents object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TranscriptionMatchDtoComponentsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'coverage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.coverage = valueDes;
          break;
        case r'proximity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.proximity = valueDes;
          break;
        case r'similarity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.similarity = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TranscriptionMatchDtoComponents deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TranscriptionMatchDtoComponentsBuilder();
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


