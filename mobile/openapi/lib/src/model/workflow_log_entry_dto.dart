//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/workflow_log_entry_dto_last_step.dart';
import 'package:openapi/src/model/workflow_result.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'workflow_log_entry_dto.g.dart';

/// WorkflowLogEntryDto
///
/// Properties:
/// * [at] - Workflow run date/time
/// * [id] - Workflow log entry ID
/// * [lastStep] 
/// * [result] 
/// * [triggerDataId] - Workflow trigger data ID
@BuiltValue()
abstract class WorkflowLogEntryDto implements Built<WorkflowLogEntryDto, WorkflowLogEntryDtoBuilder> {
  /// Workflow run date/time
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// Workflow log entry ID
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'lastStep')
  WorkflowLogEntryDtoLastStep? get lastStep;

  @BuiltValueField(wireName: r'result')
  WorkflowResult get result;
  // enum resultEnum {  completed,  halted,  error,  };

  /// Workflow trigger data ID
  @BuiltValueField(wireName: r'triggerDataId')
  String? get triggerDataId;

  WorkflowLogEntryDto._();

  factory WorkflowLogEntryDto([void updates(WorkflowLogEntryDtoBuilder b)]) = _$WorkflowLogEntryDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkflowLogEntryDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkflowLogEntryDto> get serializer => _$WorkflowLogEntryDtoSerializer();
}

class _$WorkflowLogEntryDtoSerializer implements PrimitiveSerializer<WorkflowLogEntryDto> {
  @override
  final Iterable<Type> types = const [WorkflowLogEntryDto, _$WorkflowLogEntryDto];

  @override
  final String wireName = r'WorkflowLogEntryDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkflowLogEntryDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    if (object.lastStep != null) {
      yield r'lastStep';
      yield serializers.serialize(
        object.lastStep,
        specifiedType: const FullType(WorkflowLogEntryDtoLastStep),
      );
    }
    yield r'result';
    yield serializers.serialize(
      object.result,
      specifiedType: const FullType(WorkflowResult),
    );
    if (object.triggerDataId != null) {
      yield r'triggerDataId';
      yield serializers.serialize(
        object.triggerDataId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkflowLogEntryDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkflowLogEntryDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.at = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'lastStep':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(WorkflowLogEntryDtoLastStep),
          ) as WorkflowLogEntryDtoLastStep?;
          if (valueDes == null) continue;
          result.lastStep.replace(valueDes);
          break;
        case r'result':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkflowResult),
          ) as WorkflowResult;
          result.result = valueDes;
          break;
        case r'triggerDataId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.triggerDataId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkflowLogEntryDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkflowLogEntryDtoBuilder();
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


