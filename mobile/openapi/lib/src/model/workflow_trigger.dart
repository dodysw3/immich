//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'workflow_trigger.g.dart';

/// Plugin trigger type
class WorkflowTrigger extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AssetCreate')
  static const WorkflowTrigger assetCreate = _$assetCreate;
  @BuiltValueEnumConst(wireName: r'AssetMetadataExtraction')
  static const WorkflowTrigger assetMetadataExtraction = _$assetMetadataExtraction;
  @BuiltValueEnumConst(wireName: r'AssetOcrExtraction')
  static const WorkflowTrigger assetOcrExtraction = _$assetOcrExtraction;
  @BuiltValueEnumConst(wireName: r'AssetTagged')
  static const WorkflowTrigger assetTagged = _$assetTagged;

  static Serializer<WorkflowTrigger> get serializer => _$workflowTriggerSerializer;

  const WorkflowTrigger._(String name): super(name);

  static BuiltSet<WorkflowTrigger> get values => _$values;
  static WorkflowTrigger valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class WorkflowTriggerMixin = Object with _$WorkflowTriggerMixin;

