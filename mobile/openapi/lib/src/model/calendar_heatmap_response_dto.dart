//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/calendar_heatmap_response_dto_series_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'calendar_heatmap_response_dto.g.dart';

/// CalendarHeatmapResponseDto
///
/// Properties:
/// * [from] - Start date in UTC
/// * [series] 
/// * [to] - End date in UTC
/// * [totalCount] - Total activity count over the period
@BuiltValue()
abstract class CalendarHeatmapResponseDto implements Built<CalendarHeatmapResponseDto, CalendarHeatmapResponseDtoBuilder> {
  /// Start date in UTC
  @BuiltValueField(wireName: r'from')
  String get from;

  @BuiltValueField(wireName: r'series')
  BuiltList<CalendarHeatmapResponseDtoSeriesInner> get series;

  /// End date in UTC
  @BuiltValueField(wireName: r'to')
  String get to;

  /// Total activity count over the period
  @BuiltValueField(wireName: r'totalCount')
  int get totalCount;

  CalendarHeatmapResponseDto._();

  factory CalendarHeatmapResponseDto([void updates(CalendarHeatmapResponseDtoBuilder b)]) = _$CalendarHeatmapResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CalendarHeatmapResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CalendarHeatmapResponseDto> get serializer => _$CalendarHeatmapResponseDtoSerializer();
}

class _$CalendarHeatmapResponseDtoSerializer implements PrimitiveSerializer<CalendarHeatmapResponseDto> {
  @override
  final Iterable<Type> types = const [CalendarHeatmapResponseDto, _$CalendarHeatmapResponseDto];

  @override
  final String wireName = r'CalendarHeatmapResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CalendarHeatmapResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(String),
    );
    yield r'series';
    yield serializers.serialize(
      object.series,
      specifiedType: const FullType(BuiltList, [FullType(CalendarHeatmapResponseDtoSeriesInner)]),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(String),
    );
    yield r'totalCount';
    yield serializers.serialize(
      object.totalCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CalendarHeatmapResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CalendarHeatmapResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.from = valueDes;
          break;
        case r'series':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CalendarHeatmapResponseDtoSeriesInner)]),
          ) as BuiltList<CalendarHeatmapResponseDtoSeriesInner>;
          result.series.replace(valueDes);
          break;
        case r'to':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.to = valueDes;
          break;
        case r'totalCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CalendarHeatmapResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CalendarHeatmapResponseDtoBuilder();
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


