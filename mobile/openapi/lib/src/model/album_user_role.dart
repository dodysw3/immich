//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'album_user_role.g.dart';

/// Album user role
class AlbumUserRole extends EnumClass {

  @BuiltValueEnumConst(wireName: r'editor')
  static const AlbumUserRole editor = _$editor;
  @BuiltValueEnumConst(wireName: r'owner')
  static const AlbumUserRole owner = _$owner;
  @BuiltValueEnumConst(wireName: r'viewer')
  static const AlbumUserRole viewer = _$viewer;

  static Serializer<AlbumUserRole> get serializer => _$albumUserRoleSerializer;

  const AlbumUserRole._(String name): super(name);

  static BuiltSet<AlbumUserRole> get values => _$values;
  static AlbumUserRole valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class AlbumUserRoleMixin = Object with _$AlbumUserRoleMixin;

