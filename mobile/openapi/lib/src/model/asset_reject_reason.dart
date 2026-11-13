//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_reject_reason.g.dart';

/// Rejection reason if rejected
class AssetRejectReason extends EnumClass {

  @BuiltValueEnumConst(wireName: r'duplicate')
  static const AssetRejectReason duplicate = _$duplicate;
  @BuiltValueEnumConst(wireName: r'unsupported-format')
  static const AssetRejectReason unsupportedFormat = _$unsupportedFormat;

  static Serializer<AssetRejectReason> get serializer => _$assetRejectReasonSerializer;

  const AssetRejectReason._(String name): super(name);

  static BuiltSet<AssetRejectReason> get values => _$values;
  static AssetRejectReason valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class AssetRejectReasonMixin = Object with _$AssetRejectReasonMixin;

