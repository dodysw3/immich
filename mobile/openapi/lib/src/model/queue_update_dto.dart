//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'queue_update_dto.g.dart';

/// QueueUpdateDto
///
/// Properties:
/// * [isPaused] - Whether to pause the queue
@BuiltValue()
abstract class QueueUpdateDto implements Built<QueueUpdateDto, QueueUpdateDtoBuilder> {
  /// Whether to pause the queue
  @BuiltValueField(wireName: r'isPaused')
  bool? get isPaused;

  QueueUpdateDto._();

  factory QueueUpdateDto([void updates(QueueUpdateDtoBuilder b)]) = _$QueueUpdateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QueueUpdateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<QueueUpdateDto> get serializer => _$QueueUpdateDtoSerializer();
}

class _$QueueUpdateDtoSerializer implements PrimitiveSerializer<QueueUpdateDto> {
  @override
  final Iterable<Type> types = const [QueueUpdateDto, _$QueueUpdateDto];

  @override
  final String wireName = r'QueueUpdateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    QueueUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.isPaused != null) {
      yield r'isPaused';
      yield serializers.serialize(
        object.isPaused,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    QueueUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required QueueUpdateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'isPaused':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isPaused = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  QueueUpdateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QueueUpdateDtoBuilder();
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


