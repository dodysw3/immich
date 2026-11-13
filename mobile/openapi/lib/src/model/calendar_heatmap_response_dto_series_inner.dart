//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'calendar_heatmap_response_dto_series_inner.g.dart';

/// CalendarHeatmapResponseDtoSeriesInner
///
/// Properties:
/// * [count] - Activity count
/// * [date] - Date in UTC
@BuiltValue()
abstract class CalendarHeatmapResponseDtoSeriesInner implements Built<CalendarHeatmapResponseDtoSeriesInner, CalendarHeatmapResponseDtoSeriesInnerBuilder> {
  /// Activity count
  @BuiltValueField(wireName: r'count')
  int get count;

  /// Date in UTC
  @BuiltValueField(wireName: r'date')
  String get date;

  CalendarHeatmapResponseDtoSeriesInner._();

  factory CalendarHeatmapResponseDtoSeriesInner([void updates(CalendarHeatmapResponseDtoSeriesInnerBuilder b)]) = _$CalendarHeatmapResponseDtoSeriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CalendarHeatmapResponseDtoSeriesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CalendarHeatmapResponseDtoSeriesInner> get serializer => _$CalendarHeatmapResponseDtoSeriesInnerSerializer();
}

class _$CalendarHeatmapResponseDtoSeriesInnerSerializer implements PrimitiveSerializer<CalendarHeatmapResponseDtoSeriesInner> {
  @override
  final Iterable<Type> types = const [CalendarHeatmapResponseDtoSeriesInner, _$CalendarHeatmapResponseDtoSeriesInner];

  @override
  final String wireName = r'CalendarHeatmapResponseDtoSeriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CalendarHeatmapResponseDtoSeriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CalendarHeatmapResponseDtoSeriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CalendarHeatmapResponseDtoSeriesInnerBuilder result,
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
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.date = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CalendarHeatmapResponseDtoSeriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CalendarHeatmapResponseDtoSeriesInnerBuilder();
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


