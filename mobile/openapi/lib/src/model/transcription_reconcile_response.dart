//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'transcription_reconcile_response.g.dart';

/// TranscriptionReconcileResponse
///
/// Properties:
/// * [queued] 
@BuiltValue()
abstract class TranscriptionReconcileResponse implements Built<TranscriptionReconcileResponse, TranscriptionReconcileResponseBuilder> {
  @BuiltValueField(wireName: r'queued')
  bool get queued;

  TranscriptionReconcileResponse._();

  factory TranscriptionReconcileResponse([void updates(TranscriptionReconcileResponseBuilder b)]) = _$TranscriptionReconcileResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TranscriptionReconcileResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TranscriptionReconcileResponse> get serializer => _$TranscriptionReconcileResponseSerializer();
}

class _$TranscriptionReconcileResponseSerializer implements PrimitiveSerializer<TranscriptionReconcileResponse> {
  @override
  final Iterable<Type> types = const [TranscriptionReconcileResponse, _$TranscriptionReconcileResponse];

  @override
  final String wireName = r'TranscriptionReconcileResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TranscriptionReconcileResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'queued';
    yield serializers.serialize(
      object.queued,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TranscriptionReconcileResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TranscriptionReconcileResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'queued':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.queued = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TranscriptionReconcileResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TranscriptionReconcileResponseBuilder();
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


