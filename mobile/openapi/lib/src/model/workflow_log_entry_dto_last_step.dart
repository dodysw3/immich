//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'workflow_log_entry_dto_last_step.g.dart';

/// Last step ran, if the workflow ended early
///
/// Properties:
/// * [index] - Index of the step in the workflow
/// * [method] - Method of the step
@BuiltValue()
abstract class WorkflowLogEntryDtoLastStep implements Built<WorkflowLogEntryDtoLastStep, WorkflowLogEntryDtoLastStepBuilder> {
  /// Index of the step in the workflow
  @BuiltValueField(wireName: r'index')
  int get index;

  /// Method of the step
  @BuiltValueField(wireName: r'method')
  String get method;

  WorkflowLogEntryDtoLastStep._();

  factory WorkflowLogEntryDtoLastStep([void updates(WorkflowLogEntryDtoLastStepBuilder b)]) = _$WorkflowLogEntryDtoLastStep;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkflowLogEntryDtoLastStepBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkflowLogEntryDtoLastStep> get serializer => _$WorkflowLogEntryDtoLastStepSerializer();
}

class _$WorkflowLogEntryDtoLastStepSerializer implements PrimitiveSerializer<WorkflowLogEntryDtoLastStep> {
  @override
  final Iterable<Type> types = const [WorkflowLogEntryDtoLastStep, _$WorkflowLogEntryDtoLastStep];

  @override
  final String wireName = r'WorkflowLogEntryDtoLastStep';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkflowLogEntryDtoLastStep object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'index';
    yield serializers.serialize(
      object.index,
      specifiedType: const FullType(int),
    );
    yield r'method';
    yield serializers.serialize(
      object.method,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkflowLogEntryDtoLastStep object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkflowLogEntryDtoLastStepBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'index':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.index = valueDes;
          break;
        case r'method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.method = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkflowLogEntryDtoLastStep deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkflowLogEntryDtoLastStepBuilder();
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


