//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'person_update_strategy.g.dart';

/// Which person records to update when editing a person
class PersonUpdateStrategy extends EnumClass {

  @BuiltValueEnumConst(wireName: r'self')
  static const PersonUpdateStrategy self = _$self;
  @BuiltValueEnumConst(wireName: r'everyone')
  static const PersonUpdateStrategy everyone = _$everyone;

  static Serializer<PersonUpdateStrategy> get serializer => _$personUpdateStrategySerializer;

  const PersonUpdateStrategy._(String name): super(name);

  static BuiltSet<PersonUpdateStrategy> get values => _$values;
  static PersonUpdateStrategy valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class PersonUpdateStrategyMixin = Object with _$PersonUpdateStrategyMixin;

