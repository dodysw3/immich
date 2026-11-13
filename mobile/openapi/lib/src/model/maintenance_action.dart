//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'maintenance_action.g.dart';

/// Maintenance action
class MaintenanceAction extends EnumClass {

  @BuiltValueEnumConst(wireName: r'start')
  static const MaintenanceAction start = _$start;
  @BuiltValueEnumConst(wireName: r'end')
  static const MaintenanceAction end = _$end;
  @BuiltValueEnumConst(wireName: r'select_database_restore')
  static const MaintenanceAction selectDatabaseRestore = _$selectDatabaseRestore;
  @BuiltValueEnumConst(wireName: r'restore_database')
  static const MaintenanceAction restoreDatabase = _$restoreDatabase;
  @BuiltValueEnumConst(wireName: r'rollback')
  static const MaintenanceAction rollback = _$rollback;

  static Serializer<MaintenanceAction> get serializer => _$maintenanceActionSerializer;

  const MaintenanceAction._(String name): super(name);

  static BuiltSet<MaintenanceAction> get values => _$values;
  static MaintenanceAction valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class MaintenanceActionMixin = Object with _$MaintenanceActionMixin;

