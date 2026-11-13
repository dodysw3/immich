//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_order_by.g.dart';

/// Asset sorting property
class AssetOrderBy extends EnumClass {

  @BuiltValueEnumConst(wireName: r'takenAt')
  static const AssetOrderBy takenAt = _$takenAt;
  @BuiltValueEnumConst(wireName: r'createdAt')
  static const AssetOrderBy createdAt = _$createdAt;

  static Serializer<AssetOrderBy> get serializer => _$assetOrderBySerializer;

  const AssetOrderBy._(String name): super(name);

  static BuiltSet<AssetOrderBy> get values => _$values;
  static AssetOrderBy valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class AssetOrderByMixin = Object with _$AssetOrderByMixin;

