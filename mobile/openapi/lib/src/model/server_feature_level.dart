//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'server_feature_level.g.dart';

/// Server feature level
class ServerFeatureLevel extends EnumClass {

  @BuiltValueEnumConst(wireNumber: 1)
  static const ServerFeatureLevel FeatureLevel = _$FeatureLevel;
  @BuiltValueEnumConst(wireNumber: 2)
  static const ServerFeatureLevel Passkeys = _$Passkeys;

  static Serializer<ServerFeatureLevel> get serializer => _$serverFeatureLevelSerializer;

  const ServerFeatureLevel._(String name): super(name);

  static BuiltSet<ServerFeatureLevel> get values => _$values;
  static ServerFeatureLevel valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ServerFeatureLevelMixin = Object with _$ServerFeatureLevelMixin;

