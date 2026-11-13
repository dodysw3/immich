//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/workflow_trigger.dart';
import 'package:openapi/src/model/workflow_step_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'workflow_update_dto.g.dart';

/// WorkflowUpdateDto
///
/// Properties:
/// * [description] - Workflow description
/// * [enabled] - Workflow enabled
/// * [logging] - Workflow logs run results
/// * [name] - Workflow name
/// * [steps] 
/// * [trigger] 
@BuiltValue()
abstract class WorkflowUpdateDto implements Built<WorkflowUpdateDto, WorkflowUpdateDtoBuilder> {
  /// Workflow description
  @BuiltValueField(wireName: r'description')
  String? get description;

  /// Workflow enabled
  @BuiltValueField(wireName: r'enabled')
  bool? get enabled;

  /// Workflow logs run results
  @BuiltValueField(wireName: r'logging')
  bool? get logging;

  /// Workflow name
  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'steps')
  BuiltList<WorkflowStepDto>? get steps;

  @BuiltValueField(wireName: r'trigger')
  WorkflowTrigger? get trigger;
  // enum triggerEnum {  AssetCreate,  AssetMetadataExtraction,  AssetOcrExtraction,  AssetTagged,  };

  WorkflowUpdateDto._();

  factory WorkflowUpdateDto([void updates(WorkflowUpdateDtoBuilder b)]) = _$WorkflowUpdateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkflowUpdateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkflowUpdateDto> get serializer => _$WorkflowUpdateDtoSerializer();
}

class _$WorkflowUpdateDtoSerializer implements PrimitiveSerializer<WorkflowUpdateDto> {
  @override
  final Iterable<Type> types = const [WorkflowUpdateDto, _$WorkflowUpdateDto];

  @override
  final String wireName = r'WorkflowUpdateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkflowUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.enabled != null) {
      yield r'enabled';
      yield serializers.serialize(
        object.enabled,
        specifiedType: const FullType(bool),
      );
    }
    if (object.logging != null) {
      yield r'logging';
      yield serializers.serialize(
        object.logging,
        specifiedType: const FullType(bool),
      );
    }
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.steps != null) {
      yield r'steps';
      yield serializers.serialize(
        object.steps,
        specifiedType: const FullType(BuiltList, [FullType(WorkflowStepDto)]),
      );
    }
    if (object.trigger != null) {
      yield r'trigger';
      yield serializers.serialize(
        object.trigger,
        specifiedType: const FullType(WorkflowTrigger),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkflowUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkflowUpdateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.enabled = valueDes;
          break;
        case r'logging':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.logging = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'steps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(WorkflowStepDto)]),
          ) as BuiltList<WorkflowStepDto>?;
          if (valueDes == null) continue;
          result.steps.replace(valueDes);
          break;
        case r'trigger':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(WorkflowTrigger),
          ) as WorkflowTrigger?;
          if (valueDes == null) continue;
          result.trigger = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkflowUpdateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkflowUpdateDtoBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


