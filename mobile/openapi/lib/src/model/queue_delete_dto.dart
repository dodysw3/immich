//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'queue_delete_dto.g.dart';

/// QueueDeleteDto
///
/// Properties:
/// * [failed] - If true, will also remove failed jobs from the queue.
@BuiltValue()
abstract class QueueDeleteDto implements Built<QueueDeleteDto, QueueDeleteDtoBuilder> {
  /// If true, will also remove failed jobs from the queue.
  @BuiltValueField(wireName: r'failed')
  bool? get failed;

  QueueDeleteDto._();

  factory QueueDeleteDto([void updates(QueueDeleteDtoBuilder b)]) = _$QueueDeleteDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QueueDeleteDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<QueueDeleteDto> get serializer => _$QueueDeleteDtoSerializer();
}

class _$QueueDeleteDtoSerializer implements PrimitiveSerializer<QueueDeleteDto> {
  @override
  final Iterable<Type> types = const [QueueDeleteDto, _$QueueDeleteDto];

  @override
  final String wireName = r'QueueDeleteDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    QueueDeleteDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.failed != null) {
      yield r'failed';
      yield serializers.serialize(
        object.failed,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    QueueDeleteDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required QueueDeleteDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'failed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.failed = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  QueueDeleteDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QueueDeleteDtoBuilder();
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


