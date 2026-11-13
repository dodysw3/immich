//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/workflow_type.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'plugin_method_response_dto.g.dart';

/// PluginMethodResponseDto
///
/// Properties:
/// * [description] - Description
/// * [hostFunctions] 
/// * [key] - Key
/// * [name] - Name
/// * [schema] 
/// * [title] - Title
/// * [types] - Workflow types
/// * [uiHints] - Ui hints
@BuiltValue()
abstract class PluginMethodResponseDto implements Built<PluginMethodResponseDto, PluginMethodResponseDtoBuilder> {
  /// Description
  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'hostFunctions')
  bool get hostFunctions;

  /// Key
  @BuiltValueField(wireName: r'key')
  String get key;

  /// Name
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'schema')
  JsonObject? get schema;

  /// Title
  @BuiltValueField(wireName: r'title')
  String get title;

  /// Workflow types
  @BuiltValueField(wireName: r'types')
  BuiltList<WorkflowType> get types;

  /// Ui hints
  @BuiltValueField(wireName: r'uiHints')
  BuiltList<String> get uiHints;

  PluginMethodResponseDto._();

  factory PluginMethodResponseDto([void updates(PluginMethodResponseDtoBuilder b)]) = _$PluginMethodResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PluginMethodResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PluginMethodResponseDto> get serializer => _$PluginMethodResponseDtoSerializer();
}

class _$PluginMethodResponseDtoSerializer implements PrimitiveSerializer<PluginMethodResponseDto> {
  @override
  final Iterable<Type> types = const [PluginMethodResponseDto, _$PluginMethodResponseDto];

  @override
  final String wireName = r'PluginMethodResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PluginMethodResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'hostFunctions';
    yield serializers.serialize(
      object.hostFunctions,
      specifiedType: const FullType(bool),
    );
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.schema != null) {
      yield r'schema';
      yield serializers.serialize(
        object.schema,
        specifiedType: const FullType(JsonObject),
      );
    }
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'types';
    yield serializers.serialize(
      object.types,
      specifiedType: const FullType(BuiltList, [FullType(WorkflowType)]),
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
    PluginMethodResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PluginMethodResponseDtoBuilder result,
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
        case r'hostFunctions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hostFunctions = valueDes;
          break;
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'schema':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.schema = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'types':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(WorkflowType)]),
          ) as BuiltList<WorkflowType>;
          result.types.replace(valueDes);
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
  PluginMethodResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PluginMethodResponseDtoBuilder();
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


