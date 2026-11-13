//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_id_error_reason.g.dart';

/// Error reason if failed
class AssetIdErrorReason extends EnumClass {

  @BuiltValueEnumConst(wireName: r'duplicate')
  static const AssetIdErrorReason duplicate = _$duplicate;
  @BuiltValueEnumConst(wireName: r'no_permission')
  static const AssetIdErrorReason noPermission = _$noPermission;
  @BuiltValueEnumConst(wireName: r'not_found')
  static const AssetIdErrorReason notFound = _$notFound;

  static Serializer<AssetIdErrorReason> get serializer => _$assetIdErrorReasonSerializer;

  const AssetIdErrorReason._(String name): super(name);

  static BuiltSet<AssetIdErrorReason> get values => _$values;
  static AssetIdErrorReason valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class AssetIdErrorReasonMixin = Object with _$AssetIdErrorReasonMixin;

