//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'workflow_type.g.dart';

/// Workflow type
class WorkflowType extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AssetV1')
  static const WorkflowType assetV1 = _$assetV1;

  static Serializer<WorkflowType> get serializer => _$workflowTypeSerializer;

  const WorkflowType._(String name): super(name);

  static BuiltSet<WorkflowType> get values => _$values;
  static WorkflowType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class WorkflowTypeMixin = Object with _$WorkflowTypeMixin;

