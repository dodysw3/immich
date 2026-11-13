//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/workflow_trigger.dart';
import 'package:openapi/src/model/workflow_step_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'workflow_response_dto.g.dart';

/// WorkflowResponseDto
///
/// Properties:
/// * [createdAt] - Creation date
/// * [description] - Workflow description
/// * [enabled] - Workflow enabled
/// * [id] - Workflow ID
/// * [logging] - Workflow logs run results
/// * [name] - Workflow name
/// * [steps] - Workflow steps
/// * [trigger] 
/// * [updatedAt] - Update date
@BuiltValue()
abstract class WorkflowResponseDto implements Built<WorkflowResponseDto, WorkflowResponseDtoBuilder> {
  /// Creation date
  @BuiltValueField(wireName: r'createdAt')
  String get createdAt;

  /// Workflow description
  @BuiltValueField(wireName: r'description')
  String? get description;

  /// Workflow enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// Workflow ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Workflow logs run results
  @BuiltValueField(wireName: r'logging')
  bool get logging;

  /// Workflow name
  @BuiltValueField(wireName: r'name')
  String? get name;

  /// Workflow steps
  @BuiltValueField(wireName: r'steps')
  BuiltList<WorkflowStepDto> get steps;

  @BuiltValueField(wireName: r'trigger')
  WorkflowTrigger get trigger;
  // enum triggerEnum {  AssetCreate,  AssetMetadataExtraction,  AssetOcrExtraction,  AssetTagged,  };

  /// Update date
  @BuiltValueField(wireName: r'updatedAt')
  String get updatedAt;

  WorkflowResponseDto._();

  factory WorkflowResponseDto([void updates(WorkflowResponseDtoBuilder b)]) = _$WorkflowResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkflowResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkflowResponseDto> get serializer => _$WorkflowResponseDtoSerializer();
}

class _$WorkflowResponseDtoSerializer implements PrimitiveSerializer<WorkflowResponseDto> {
  @override
  final Iterable<Type> types = const [WorkflowResponseDto, _$WorkflowResponseDto];

  @override
  final String wireName = r'WorkflowResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkflowResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'logging';
    yield serializers.serialize(
      object.logging,
      specifiedType: const FullType(bool),
    );
    yield r'name';
    yield object.name == null ? null : serializers.serialize(
      object.name,
      specifiedType: const FullType.nullable(String),
    );
    yield r'steps';
    yield serializers.serialize(
      object.steps,
      specifiedType: const FullType(BuiltList, [FullType(WorkflowStepDto)]),
    );
    yield r'trigger';
    yield serializers.serialize(
      object.trigger,
      specifiedType: const FullType(WorkflowTrigger),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkflowResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkflowResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.createdAt = valueDes;
          break;
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
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'logging':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
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
            specifiedType: const FullType(BuiltList, [FullType(WorkflowStepDto)]),
          ) as BuiltList<WorkflowStepDto>;
          result.steps.replace(valueDes);
          break;
        case r'trigger':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkflowTrigger),
          ) as WorkflowTrigger;
          result.trigger = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkflowResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkflowResponseDtoBuilder();
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


