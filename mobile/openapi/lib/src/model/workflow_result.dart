//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'workflow_result.g.dart';

/// Workflow run result
class WorkflowResult extends EnumClass {

  @BuiltValueEnumConst(wireName: r'completed')
  static const WorkflowResult completed = _$completed;
  @BuiltValueEnumConst(wireName: r'halted')
  static const WorkflowResult halted = _$halted;
  @BuiltValueEnumConst(wireName: r'error')
  static const WorkflowResult error = _$error;

  static Serializer<WorkflowResult> get serializer => _$workflowResultSerializer;

  const WorkflowResult._(String name): super(name);

  static BuiltSet<WorkflowResult> get values => _$values;
  static WorkflowResult valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class WorkflowResultMixin = Object with _$WorkflowResultMixin;

