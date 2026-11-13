//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sharing_direction.g.dart';

/// Sharing direction
class SharingDirection extends EnumClass {

  @BuiltValueEnumConst(wireName: r'shared-by')
  static const SharingDirection sharedBy = _$sharedBy;
  @BuiltValueEnumConst(wireName: r'shared-with')
  static const SharingDirection sharedWith = _$sharedWith;

  static Serializer<SharingDirection> get serializer => _$sharingDirectionSerializer;

  const SharingDirection._(String name): super(name);

  static BuiltSet<SharingDirection> get values => _$values;
  static SharingDirection valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class SharingDirectionMixin = Object with _$SharingDirectionMixin;

