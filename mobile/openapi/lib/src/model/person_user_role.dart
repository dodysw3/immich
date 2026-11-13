//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'person_user_role.g.dart';

/// Levels of access for managing people resources on behalf of another user.
class PersonUserRole extends EnumClass {

  @BuiltValueEnumConst(wireName: r'read')
  static const PersonUserRole read = _$read;
  @BuiltValueEnumConst(wireName: r'write')
  static const PersonUserRole write = _$write;
  @BuiltValueEnumConst(wireName: r'admin')
  static const PersonUserRole admin = _$admin;

  static Serializer<PersonUserRole> get serializer => _$personUserRoleSerializer;

  const PersonUserRole._(String name): super(name);

  static BuiltSet<PersonUserRole> get values => _$values;
  static PersonUserRole valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class PersonUserRoleMixin = Object with _$PersonUserRoleMixin;

