//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_file_type.g.dart';

/// Type of file
class AssetFileType extends EnumClass {

  @BuiltValueEnumConst(wireName: r'fullsize')
  static const AssetFileType fullsize = _$fullsize;
  @BuiltValueEnumConst(wireName: r'preview')
  static const AssetFileType preview = _$preview;
  @BuiltValueEnumConst(wireName: r'thumbnail')
  static const AssetFileType thumbnail = _$thumbnail;
  @BuiltValueEnumConst(wireName: r'sidecar')
  static const AssetFileType sidecar = _$sidecar;
  @BuiltValueEnumConst(wireName: r'encoded_video')
  static const AssetFileType encodedVideo = _$encodedVideo;

  static Serializer<AssetFileType> get serializer => _$assetFileTypeSerializer;

  const AssetFileType._(String name): super(name);

  static BuiltSet<AssetFileType> get values => _$values;
  static AssetFileType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class AssetFileTypeMixin = Object with _$AssetFileTypeMixin;

