//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'memory_type_v1.g.dart';

class MemoryTypeV1 extends EnumClass {

  @BuiltValueEnumConst(wireName: r'on_this_day')
  static const MemoryTypeV1 onThisDay = _$onThisDay;

  static Serializer<MemoryTypeV1> get serializer => _$memoryTypeV1Serializer;

  const MemoryTypeV1._(String name): super(name);

  static BuiltSet<MemoryTypeV1> get values => _$values;
  static MemoryTypeV1 valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class MemoryTypeV1Mixin = Object with _$MemoryTypeV1Mixin;

