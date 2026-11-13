//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'source_type.g.dart';

/// Face detection source type
class SourceType extends EnumClass {

  @BuiltValueEnumConst(wireName: r'machine-learning')
  static const SourceType machineLearning = _$machineLearning;
  @BuiltValueEnumConst(wireName: r'exif')
  static const SourceType exif = _$exif;
  @BuiltValueEnumConst(wireName: r'manual')
  static const SourceType manual = _$manual;

  static Serializer<SourceType> get serializer => _$sourceTypeSerializer;

  const SourceType._(String name): super(name);

  static BuiltSet<SourceType> get values => _$values;
  static SourceType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class SourceTypeMixin = Object with _$SourceTypeMixin;

