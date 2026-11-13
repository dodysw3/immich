//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/queue_statistics_dto.dart';
import 'package:openapi/src/model/queue_status_legacy_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'queue_response_legacy_dto.g.dart';

/// QueueResponseLegacyDto
///
/// Properties:
/// * [jobCounts] 
/// * [queueStatus] 
@BuiltValue()
abstract class QueueResponseLegacyDto implements Built<QueueResponseLegacyDto, QueueResponseLegacyDtoBuilder> {
  @BuiltValueField(wireName: r'jobCounts')
  QueueStatisticsDto get jobCounts;

  @BuiltValueField(wireName: r'queueStatus')
  QueueStatusLegacyDto get queueStatus;

  QueueResponseLegacyDto._();

  factory QueueResponseLegacyDto([void updates(QueueResponseLegacyDtoBuilder b)]) = _$QueueResponseLegacyDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QueueResponseLegacyDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<QueueResponseLegacyDto> get serializer => _$QueueResponseLegacyDtoSerializer();
}

class _$QueueResponseLegacyDtoSerializer implements PrimitiveSerializer<QueueResponseLegacyDto> {
  @override
  final Iterable<Type> types = const [QueueResponseLegacyDto, _$QueueResponseLegacyDto];

  @override
  final String wireName = r'QueueResponseLegacyDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    QueueResponseLegacyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'jobCounts';
    yield serializers.serialize(
      object.jobCounts,
      specifiedType: const FullType(QueueStatisticsDto),
    );
    yield r'queueStatus';
    yield serializers.serialize(
      object.queueStatus,
      specifiedType: const FullType(QueueStatusLegacyDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    QueueResponseLegacyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required QueueResponseLegacyDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'jobCounts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueStatisticsDto),
          ) as QueueStatisticsDto;
          result.jobCounts.replace(valueDes);
          break;
        case r'queueStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueStatusLegacyDto),
          ) as QueueStatusLegacyDto;
          result.queueStatus.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  QueueResponseLegacyDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QueueResponseLegacyDtoBuilder();
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


