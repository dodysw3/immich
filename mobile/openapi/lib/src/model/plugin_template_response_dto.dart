//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/plugin_template_step_response_dto.dart';
import 'package:openapi/src/model/workflow_trigger.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'plugin_template_response_dto.g.dart';

/// PluginTemplateResponseDto
///
/// Properties:
/// * [description] - Template description
/// * [key] - Template key (unique across all templates)
/// * [steps] - Workflow steps
/// * [title] - Template title
/// * [trigger] 
/// * [uiHints] - Ui hints, for example \"smart-album\"
@BuiltValue()
abstract class PluginTemplateResponseDto implements Built<PluginTemplateResponseDto, PluginTemplateResponseDtoBuilder> {
  /// Template description
  @BuiltValueField(wireName: r'description')
  String get description;

  /// Template key (unique across all templates)
  @BuiltValueField(wireName: r'key')
  String get key;

  /// Workflow steps
  @BuiltValueField(wireName: r'steps')
  BuiltList<PluginTemplateStepResponseDto> get steps;

  /// Template title
  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'trigger')
  WorkflowTrigger get trigger;
  // enum triggerEnum {  AssetCreate,  AssetMetadataExtraction,  AssetOcrExtraction,  AssetTagged,  };

  /// Ui hints, for example \"smart-album\"
  @BuiltValueField(wireName: r'uiHints')
  BuiltList<String> get uiHints;

  PluginTemplateResponseDto._();

  factory PluginTemplateResponseDto([void updates(PluginTemplateResponseDtoBuilder b)]) = _$PluginTemplateResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PluginTemplateResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PluginTemplateResponseDto> get serializer => _$PluginTemplateResponseDtoSerializer();
}

class _$PluginTemplateResponseDtoSerializer implements PrimitiveSerializer<PluginTemplateResponseDto> {
  @override
  final Iterable<Type> types = const [PluginTemplateResponseDto, _$PluginTemplateResponseDto];

  @override
  final String wireName = r'PluginTemplateResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PluginTemplateResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'steps';
    yield serializers.serialize(
      object.steps,
      specifiedType: const FullType(BuiltList, [FullType(PluginTemplateStepResponseDto)]),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'trigger';
    yield serializers.serialize(
      object.trigger,
      specifiedType: const FullType(WorkflowTrigger),
    );
    yield r'uiHints';
    yield serializers.serialize(
      object.uiHints,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PluginTemplateResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PluginTemplateResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        case r'steps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PluginTemplateStepResponseDto)]),
          ) as BuiltList<PluginTemplateStepResponseDto>;
          result.steps.replace(valueDes);
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'trigger':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkflowTrigger),
          ) as WorkflowTrigger;
          result.trigger = valueDes;
          break;
        case r'uiHints':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.uiHints.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PluginTemplateResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PluginTemplateResponseDtoBuilder();
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


