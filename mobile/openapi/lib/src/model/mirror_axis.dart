//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mirror_axis.g.dart';

/// Axis to mirror along
class MirrorAxis extends EnumClass {

  @BuiltValueEnumConst(wireName: r'horizontal')
  static const MirrorAxis horizontal = _$horizontal;
  @BuiltValueEnumConst(wireName: r'vertical')
  static const MirrorAxis vertical = _$vertical;

  static Serializer<MirrorAxis> get serializer => _$mirrorAxisSerializer;

  const MirrorAxis._(String name): super(name);

  static BuiltSet<MirrorAxis> get values => _$values;
  static MirrorAxis valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class MirrorAxisMixin = Object with _$MirrorAxisMixin;

