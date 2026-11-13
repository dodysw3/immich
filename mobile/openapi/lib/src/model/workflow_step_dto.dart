//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'workflow_step_dto.g.dart';

/// WorkflowStepDto
///
/// Properties:
/// * [config] - Step configuration
/// * [enabled] - Step is enabled
/// * [method] - Step plugin method
@BuiltValue()
abstract class WorkflowStepDto implements Built<WorkflowStepDto, WorkflowStepDtoBuilder> {
  /// Step configuration
  @BuiltValueField(wireName: r'config')
  BuiltMap<String, JsonObject?>? get config;

  /// Step is enabled
  @BuiltValueField(wireName: r'enabled')
  bool? get enabled;

  /// Step plugin method
  @BuiltValueField(wireName: r'method')
  String get method;

  WorkflowStepDto._();

  factory WorkflowStepDto([void updates(WorkflowStepDtoBuilder b)]) = _$WorkflowStepDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkflowStepDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkflowStepDto> get serializer => _$WorkflowStepDtoSerializer();
}

class _$WorkflowStepDtoSerializer implements PrimitiveSerializer<WorkflowStepDto> {
  @override
  final Iterable<Type> types = const [WorkflowStepDto, _$WorkflowStepDto];

  @override
  final String wireName = r'WorkflowStepDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkflowStepDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'config';
    yield object.config == null ? null : serializers.serialize(
      object.config,
      specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    if (object.enabled != null) {
      yield r'enabled';
      yield serializers.serialize(
        object.enabled,
        specifiedType: const FullType(bool),
      );
    }
    yield r'method';
    yield serializers.serialize(
      object.method,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkflowStepDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkflowStepDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'config':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.config.replace(valueDes);
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.enabled = valueDes;
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
  WorkflowStepDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkflowStepDtoBuilder();
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


