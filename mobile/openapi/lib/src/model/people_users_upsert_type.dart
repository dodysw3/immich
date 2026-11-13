//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'people_users_upsert_type.g.dart';

/// Which people to update when personIds is omitted
class PeopleUsersUpsertType extends EnumClass {

  @BuiltValueEnumConst(wireName: r'everyone')
  static const PeopleUsersUpsertType everyone = _$everyone;

  static Serializer<PeopleUsersUpsertType> get serializer => _$peopleUsersUpsertTypeSerializer;

  const PeopleUsersUpsertType._(String name): super(name);

  static BuiltSet<PeopleUsersUpsertType> get values => _$values;
  static PeopleUsersUpsertType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class PeopleUsersUpsertTypeMixin = Object with _$PeopleUsersUpsertTypeMixin;

