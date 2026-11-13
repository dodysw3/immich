//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'queue_status_legacy_dto.g.dart';

/// QueueStatusLegacyDto
///
/// Properties:
/// * [isActive] - Whether the queue is currently active (has running jobs)
/// * [isPaused] - Whether the queue is paused
@BuiltValue()
abstract class QueueStatusLegacyDto implements Built<QueueStatusLegacyDto, QueueStatusLegacyDtoBuilder> {
  /// Whether the queue is currently active (has running jobs)
  @BuiltValueField(wireName: r'isActive')
  bool get isActive;

  /// Whether the queue is paused
  @BuiltValueField(wireName: r'isPaused')
  bool get isPaused;

  QueueStatusLegacyDto._();

  factory QueueStatusLegacyDto([void updates(QueueStatusLegacyDtoBuilder b)]) = _$QueueStatusLegacyDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QueueStatusLegacyDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<QueueStatusLegacyDto> get serializer => _$QueueStatusLegacyDtoSerializer();
}

class _$QueueStatusLegacyDtoSerializer implements PrimitiveSerializer<QueueStatusLegacyDto> {
  @override
  final Iterable<Type> types = const [QueueStatusLegacyDto, _$QueueStatusLegacyDto];

  @override
  final String wireName = r'QueueStatusLegacyDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    QueueStatusLegacyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'isActive';
    yield serializers.serialize(
      object.isActive,
      specifiedType: const FullType(bool),
    );
    yield r'isPaused';
    yield serializers.serialize(
      object.isPaused,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    QueueStatusLegacyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required QueueStatusLegacyDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'isActive':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isActive = valueDes;
          break;
        case r'isPaused':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
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
  QueueStatusLegacyDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QueueStatusLegacyDtoBuilder();
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


