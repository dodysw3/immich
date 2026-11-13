//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'release_type.g.dart';

class ReleaseType extends EnumClass {

  @BuiltValueEnumConst(wireName: r'major')
  static const ReleaseType major = _$major;
  @BuiltValueEnumConst(wireName: r'premajor')
  static const ReleaseType premajor = _$premajor;
  @BuiltValueEnumConst(wireName: r'minor')
  static const ReleaseType minor = _$minor;
  @BuiltValueEnumConst(wireName: r'preminor')
  static const ReleaseType preminor = _$preminor;
  @BuiltValueEnumConst(wireName: r'patch')
  static const ReleaseType patch_ = _$patch_;
  @BuiltValueEnumConst(wireName: r'prepatch')
  static const ReleaseType prepatch = _$prepatch;
  @BuiltValueEnumConst(wireName: r'prerelease')
  static const ReleaseType prerelease = _$prerelease;

  static Serializer<ReleaseType> get serializer => _$releaseTypeSerializer;

  const ReleaseType._(String name): super(name);

  static BuiltSet<ReleaseType> get values => _$values;
  static ReleaseType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ReleaseTypeMixin = Object with _$ReleaseTypeMixin;

