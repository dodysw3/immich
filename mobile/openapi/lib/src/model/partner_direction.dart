//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'partner_direction.g.dart';

/// Partner direction
class PartnerDirection extends EnumClass {

  @BuiltValueEnumConst(wireName: r'shared-by')
  static const PartnerDirection sharedBy = _$sharedBy;
  @BuiltValueEnumConst(wireName: r'shared-with')
  static const PartnerDirection sharedWith = _$sharedWith;

  static Serializer<PartnerDirection> get serializer => _$partnerDirectionSerializer;

  const PartnerDirection._(String name): super(name);

  static BuiltSet<PartnerDirection> get values => _$values;
  static PartnerDirection valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class PartnerDirectionMixin = Object with _$PartnerDirectionMixin;

