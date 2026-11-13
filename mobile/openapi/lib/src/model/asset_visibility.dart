//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_visibility.g.dart';

/// Asset visibility
class AssetVisibility extends EnumClass {

  @BuiltValueEnumConst(wireName: r'archive')
  static const AssetVisibility archive = _$archive;
  @BuiltValueEnumConst(wireName: r'timeline')
  static const AssetVisibility timeline = _$timeline;
  @BuiltValueEnumConst(wireName: r'hidden')
  static const AssetVisibility hidden = _$hidden;
  @BuiltValueEnumConst(wireName: r'locked')
  static const AssetVisibility locked = _$locked;

  static Serializer<AssetVisibility> get serializer => _$assetVisibilitySerializer;

  const AssetVisibility._(String name): super(name);

  static BuiltSet<AssetVisibility> get values => _$values;
  static AssetVisibility valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class AssetVisibilityMixin = Object with _$AssetVisibilityMixin;

