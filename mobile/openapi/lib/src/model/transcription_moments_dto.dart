//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'transcription_moments_dto.g.dart';

/// TranscriptionMomentsDto
///
/// Properties:
/// * [assetId] 
/// * [cursor] 
/// * [q] 
/// * [size] - Moments per page
@BuiltValue()
abstract class TranscriptionMomentsDto implements Built<TranscriptionMomentsDto, TranscriptionMomentsDtoBuilder> {
  @BuiltValueField(wireName: r'assetId')
  String get assetId;

  @BuiltValueField(wireName: r'cursor')
  String? get cursor;

  @BuiltValueField(wireName: r'q')
  String get q;

  /// Moments per page
  @BuiltValueField(wireName: r'size')
  int? get size;

  TranscriptionMomentsDto._();

  factory TranscriptionMomentsDto([void updates(TranscriptionMomentsDtoBuilder b)]) = _$TranscriptionMomentsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TranscriptionMomentsDtoBuilder b) => b
      ..size = 10;

  @BuiltValueSerializer(custom: true)
  static Serializer<TranscriptionMomentsDto> get serializer => _$TranscriptionMomentsDtoSerializer();
}

class _$TranscriptionMomentsDtoSerializer implements PrimitiveSerializer<TranscriptionMomentsDto> {
  @override
  final Iterable<Type> types = const [TranscriptionMomentsDto, _$TranscriptionMomentsDto];

  @override
  final String wireName = r'TranscriptionMomentsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TranscriptionMomentsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assetId';
    yield serializers.serialize(
      object.assetId,
      specifiedType: const FullType(String),
    );
    if (object.cursor != null) {
      yield r'cursor';
      yield serializers.serialize(
        object.cursor,
        specifiedType: const FullType(String),
      );
    }
    yield r'q';
    yield serializers.serialize(
      object.q,
      specifiedType: const FullType(String),
    );
    if (object.size != null) {
      yield r'size';
      yield serializers.serialize(
        object.size,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    TranscriptionMomentsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TranscriptionMomentsDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assetId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.assetId = valueDes;
          break;
        case r'cursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cursor = valueDes;
          break;
        case r'q':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.q = valueDes;
          break;
        case r'size':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.size = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TranscriptionMomentsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TranscriptionMomentsDtoBuilder();
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


