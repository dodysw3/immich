//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'time_buckets_response_dto.g.dart';

/// TimeBucketsResponseDto
///
/// Properties:
/// * [count] - Number of assets in this time bucket
/// * [timeBucket] - Time bucket identifier in YYYY-MM-DD format representing the start of the time period
@BuiltValue()
abstract class TimeBucketsResponseDto implements Built<TimeBucketsResponseDto, TimeBucketsResponseDtoBuilder> {
  /// Number of assets in this time bucket
  @BuiltValueField(wireName: r'count')
  int get count;

  /// Time bucket identifier in YYYY-MM-DD format representing the start of the time period
  @BuiltValueField(wireName: r'timeBucket')
  String get timeBucket;

  TimeBucketsResponseDto._();

  factory TimeBucketsResponseDto([void updates(TimeBucketsResponseDtoBuilder b)]) = _$TimeBucketsResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TimeBucketsResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TimeBucketsResponseDto> get serializer => _$TimeBucketsResponseDtoSerializer();
}

class _$TimeBucketsResponseDtoSerializer implements PrimitiveSerializer<TimeBucketsResponseDto> {
  @override
  final Iterable<Type> types = const [TimeBucketsResponseDto, _$TimeBucketsResponseDto];

  @override
  final String wireName = r'TimeBucketsResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TimeBucketsResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    yield r'timeBucket';
    yield serializers.serialize(
      object.timeBucket,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TimeBucketsResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TimeBucketsResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        case r'timeBucket':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.timeBucket = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TimeBucketsResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TimeBucketsResponseDtoBuilder();
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


