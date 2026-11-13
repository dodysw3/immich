//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'memory_statistics_response_dto.g.dart';

/// MemoryStatisticsResponseDto
///
/// Properties:
/// * [total] - Total number of memories
@BuiltValue()
abstract class MemoryStatisticsResponseDto implements Built<MemoryStatisticsResponseDto, MemoryStatisticsResponseDtoBuilder> {
  /// Total number of memories
  @BuiltValueField(wireName: r'total')
  int get total;

  MemoryStatisticsResponseDto._();

  factory MemoryStatisticsResponseDto([void updates(MemoryStatisticsResponseDtoBuilder b)]) = _$MemoryStatisticsResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MemoryStatisticsResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MemoryStatisticsResponseDto> get serializer => _$MemoryStatisticsResponseDtoSerializer();
}

class _$MemoryStatisticsResponseDtoSerializer implements PrimitiveSerializer<MemoryStatisticsResponseDto> {
  @override
  final Iterable<Type> types = const [MemoryStatisticsResponseDto, _$MemoryStatisticsResponseDto];

  @override
  final String wireName = r'MemoryStatisticsResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MemoryStatisticsResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MemoryStatisticsResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MemoryStatisticsResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MemoryStatisticsResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MemoryStatisticsResponseDtoBuilder();
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


