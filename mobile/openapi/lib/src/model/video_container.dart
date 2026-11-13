//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'video_container.g.dart';

/// Accepted video containers
class VideoContainer extends EnumClass {

  @BuiltValueEnumConst(wireName: r'mov')
  static const VideoContainer mov = _$mov;
  @BuiltValueEnumConst(wireName: r'mp4')
  static const VideoContainer mp4 = _$mp4;
  @BuiltValueEnumConst(wireName: r'ogg')
  static const VideoContainer ogg = _$ogg;
  @BuiltValueEnumConst(wireName: r'webm')
  static const VideoContainer webm = _$webm;

  static Serializer<VideoContainer> get serializer => _$videoContainerSerializer;

  const VideoContainer._(String name): super(name);

  static BuiltSet<VideoContainer> get values => _$values;
  static VideoContainer valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class VideoContainerMixin = Object with _$VideoContainerMixin;

