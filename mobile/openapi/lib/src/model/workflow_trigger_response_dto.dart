//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/workflow_trigger.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/workflow_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'workflow_trigger_response_dto.g.dart';

/// WorkflowTriggerResponseDto
///
/// Properties:
/// * [trigger] 
/// * [types] - Workflow types
@BuiltValue()
abstract class WorkflowTriggerResponseDto implements Built<WorkflowTriggerResponseDto, WorkflowTriggerResponseDtoBuilder> {
  @BuiltValueField(wireName: r'trigger')
  WorkflowTrigger get trigger;
  // enum triggerEnum {  AssetCreate,  AssetMetadataExtraction,  AssetOcrExtraction,  AssetTagged,  };

  /// Workflow types
  @BuiltValueField(wireName: r'types')
  BuiltList<WorkflowType> get types;

  WorkflowTriggerResponseDto._();

  factory WorkflowTriggerResponseDto([void updates(WorkflowTriggerResponseDtoBuilder b)]) = _$WorkflowTriggerResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkflowTriggerResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkflowTriggerResponseDto> get serializer => _$WorkflowTriggerResponseDtoSerializer();
}

class _$WorkflowTriggerResponseDtoSerializer implements PrimitiveSerializer<WorkflowTriggerResponseDto> {
  @override
  final Iterable<Type> types = const [WorkflowTriggerResponseDto, _$WorkflowTriggerResponseDto];

  @override
  final String wireName = r'WorkflowTriggerResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkflowTriggerResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'trigger';
    yield serializers.serialize(
      object.trigger,
      specifiedType: const FullType(WorkflowTrigger),
    );
    yield r'types';
    yield serializers.serialize(
      object.types,
      specifiedType: const FullType(BuiltList, [FullType(WorkflowType)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkflowTriggerResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkflowTriggerResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'trigger':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkflowTrigger),
          ) as WorkflowTrigger;
          result.trigger = valueDes;
          break;
        case r'types':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(WorkflowType)]),
          ) as BuiltList<WorkflowType>;
          result.types.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkflowTriggerResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkflowTriggerResponseDtoBuilder();
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


