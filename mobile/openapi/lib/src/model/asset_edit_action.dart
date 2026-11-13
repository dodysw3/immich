//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_edit_action.g.dart';

/// Type of edit action to perform
class AssetEditAction extends EnumClass {

  @BuiltValueEnumConst(wireName: r'crop')
  static const AssetEditAction crop = _$crop;
  @BuiltValueEnumConst(wireName: r'rotate')
  static const AssetEditAction rotate = _$rotate;
  @BuiltValueEnumConst(wireName: r'mirror')
  static const AssetEditAction mirror = _$mirror;

  static Serializer<AssetEditAction> get serializer => _$assetEditActionSerializer;

  const AssetEditAction._(String name): super(name);

  static BuiltSet<AssetEditAction> get values => _$values;
  static AssetEditAction valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class AssetEditActionMixin = Object with _$AssetEditActionMixin;

