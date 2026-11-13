//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_media_size.g.dart';

/// Asset media size
class AssetMediaSize extends EnumClass {

  @BuiltValueEnumConst(wireName: r'original')
  static const AssetMediaSize original = _$original;
  @BuiltValueEnumConst(wireName: r'fullsize')
  static const AssetMediaSize fullsize = _$fullsize;
  @BuiltValueEnumConst(wireName: r'preview')
  static const AssetMediaSize preview = _$preview;
  @BuiltValueEnumConst(wireName: r'thumbnail')
  static const AssetMediaSize thumbnail = _$thumbnail;

  static Serializer<AssetMediaSize> get serializer => _$assetMediaSizeSerializer;

  const AssetMediaSize._(String name): super(name);

  static BuiltSet<AssetMediaSize> get values => _$values;
  static AssetMediaSize valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class AssetMediaSizeMixin = Object with _$AssetMediaSizeMixin;

