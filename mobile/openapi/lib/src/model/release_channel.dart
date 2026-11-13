//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'release_channel.g.dart';

/// Release channel
class ReleaseChannel extends EnumClass {

  @BuiltValueEnumConst(wireName: r'stable')
  static const ReleaseChannel stable = _$stable;
  @BuiltValueEnumConst(wireName: r'releaseCandidate')
  static const ReleaseChannel releaseCandidate = _$releaseCandidate;

  static Serializer<ReleaseChannel> get serializer => _$releaseChannelSerializer;

  const ReleaseChannel._(String name): super(name);

  static BuiltSet<ReleaseChannel> get values => _$values;
  static ReleaseChannel valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ReleaseChannelMixin = Object with _$ReleaseChannelMixin;

