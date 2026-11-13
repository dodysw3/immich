//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'queue_statistics_dto.g.dart';

/// QueueStatisticsDto
///
/// Properties:
/// * [active] - Number of active jobs
/// * [completed] - Number of completed jobs
/// * [delayed] - Number of delayed jobs
/// * [failed] - Number of failed jobs
/// * [paused] - Number of paused jobs
/// * [waiting] - Number of waiting jobs
@BuiltValue()
abstract class QueueStatisticsDto implements Built<QueueStatisticsDto, QueueStatisticsDtoBuilder> {
  /// Number of active jobs
  @BuiltValueField(wireName: r'active')
  int get active;

  /// Number of completed jobs
  @BuiltValueField(wireName: r'completed')
  int get completed;

  /// Number of delayed jobs
  @BuiltValueField(wireName: r'delayed')
  int get delayed;

  /// Number of failed jobs
  @BuiltValueField(wireName: r'failed')
  int get failed;

  /// Number of paused jobs
  @BuiltValueField(wireName: r'paused')
  int get paused;

  /// Number of waiting jobs
  @BuiltValueField(wireName: r'waiting')
  int get waiting;

  QueueStatisticsDto._();

  factory QueueStatisticsDto([void updates(QueueStatisticsDtoBuilder b)]) = _$QueueStatisticsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QueueStatisticsDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<QueueStatisticsDto> get serializer => _$QueueStatisticsDtoSerializer();
}

class _$QueueStatisticsDtoSerializer implements PrimitiveSerializer<QueueStatisticsDto> {
  @override
  final Iterable<Type> types = const [QueueStatisticsDto, _$QueueStatisticsDto];

  @override
  final String wireName = r'QueueStatisticsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    QueueStatisticsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'active';
    yield serializers.serialize(
      object.active,
      specifiedType: const FullType(int),
    );
    yield r'completed';
    yield serializers.serialize(
      object.completed,
      specifiedType: const FullType(int),
    );
    yield r'delayed';
    yield serializers.serialize(
      object.delayed,
      specifiedType: const FullType(int),
    );
    yield r'failed';
    yield serializers.serialize(
      object.failed,
      specifiedType: const FullType(int),
    );
    yield r'paused';
    yield serializers.serialize(
      object.paused,
      specifiedType: const FullType(int),
    );
    yield r'waiting';
    yield serializers.serialize(
      object.waiting,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    QueueStatisticsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required QueueStatisticsDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.active = valueDes;
          break;
        case r'completed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.completed = valueDes;
          break;
        case r'delayed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.delayed = valueDes;
          break;
        case r'failed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.failed = valueDes;
          break;
        case r'paused':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.paused = valueDes;
          break;
        case r'waiting':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.waiting = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  QueueStatisticsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QueueStatisticsDtoBuilder();
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


