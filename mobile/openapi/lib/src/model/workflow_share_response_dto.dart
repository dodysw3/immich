//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/workflow_share_step_dto.dart';
import 'package:openapi/src/model/workflow_trigger.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'workflow_share_response_dto.g.dart';

/// WorkflowShareResponseDto
///
/// Properties:
/// * [description] - Workflow description
/// * [name] - Workflow name
/// * [steps] - Workflow steps
/// * [trigger] 
@BuiltValue()
abstract class WorkflowShareResponseDto implements Built<WorkflowShareResponseDto, WorkflowShareResponseDtoBuilder> {
  /// Workflow description
  @BuiltValueField(wireName: r'description')
  String? get description;

  /// Workflow name
  @BuiltValueField(wireName: r'name')
  String? get name;

  /// Workflow steps
  @BuiltValueField(wireName: r'steps')
  BuiltList<WorkflowShareStepDto> get steps;

  @BuiltValueField(wireName: r'trigger')
  WorkflowTrigger get trigger;
  // enum triggerEnum {  AssetCreate,  AssetMetadataExtraction,  AssetOcrExtraction,  AssetTagged,  };

  WorkflowShareResponseDto._();

  factory WorkflowShareResponseDto([void updates(WorkflowShareResponseDtoBuilder b)]) = _$WorkflowShareResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkflowShareResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkflowShareResponseDto> get serializer => _$WorkflowShareResponseDtoSerializer();
}

class _$WorkflowShareResponseDtoSerializer implements PrimitiveSerializer<WorkflowShareResponseDto> {
  @override
  final Iterable<Type> types = const [WorkflowShareResponseDto, _$WorkflowShareResponseDto];

  @override
  final String wireName = r'WorkflowShareResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkflowShareResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
    yield r'name';
    yield object.name == null ? null : serializers.serialize(
      object.name,
      specifiedType: const FullType.nullable(String),
    );
    yield r'steps';
    yield serializers.serialize(
      object.steps,
      specifiedType: const FullType(BuiltList, [FullType(WorkflowShareStepDto)]),
    );
    yield r'trigger';
    yield serializers.serialize(
      object.trigger,
      specifiedType: const FullType(WorkflowTrigger),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkflowShareResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkflowShareResponseDtoBuilder result,
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
            specifiedType: const FullType(BuiltList, [FullType(WorkflowShareStepDto)]),
          ) as BuiltList<WorkflowShareStepDto>;
          result.steps.replace(valueDes);
          break;
        case r'trigger':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkflowTrigger),
          ) as WorkflowTrigger;
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
  WorkflowShareResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkflowShareResponseDtoBuilder();
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


