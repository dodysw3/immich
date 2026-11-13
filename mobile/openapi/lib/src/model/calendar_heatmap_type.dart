//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'calendar_heatmap_type.g.dart';

/// Type of calendar heatmap
class CalendarHeatmapType extends EnumClass {

  @BuiltValueEnumConst(wireName: r'Upload')
  static const CalendarHeatmapType upload = _$upload;
  @BuiltValueEnumConst(wireName: r'Taken')
  static const CalendarHeatmapType taken = _$taken;

  static Serializer<CalendarHeatmapType> get serializer => _$calendarHeatmapTypeSerializer;

  const CalendarHeatmapType._(String name): super(name);

  static BuiltSet<CalendarHeatmapType> get values => _$values;
  static CalendarHeatmapType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class CalendarHeatmapTypeMixin = Object with _$CalendarHeatmapTypeMixin;

