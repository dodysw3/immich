//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/plugin_method_response_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'plugin_response_dto.g.dart';

/// PluginResponseDto
///
/// Properties:
/// * [author] - Plugin author
/// * [createdAt] - Creation date
/// * [description] - Plugin description
/// * [id] - Plugin ID
/// * [methods] - Plugin methods
/// * [name] - Plugin name
/// * [title] - Plugin title
/// * [updatedAt] - Last update date
/// * [version] - Plugin version
@BuiltValue()
abstract class PluginResponseDto implements Built<PluginResponseDto, PluginResponseDtoBuilder> {
  /// Plugin author
  @BuiltValueField(wireName: r'author')
  String get author;

  /// Creation date
  @BuiltValueField(wireName: r'createdAt')
  String get createdAt;

  /// Plugin description
  @BuiltValueField(wireName: r'description')
  String get description;

  /// Plugin ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Plugin methods
  @BuiltValueField(wireName: r'methods')
  BuiltList<PluginMethodResponseDto> get methods;

  /// Plugin name
  @BuiltValueField(wireName: r'name')
  String get name;

  /// Plugin title
  @BuiltValueField(wireName: r'title')
  String get title;

  /// Last update date
  @BuiltValueField(wireName: r'updatedAt')
  String get updatedAt;

  /// Plugin version
  @BuiltValueField(wireName: r'version')
  String get version;

  PluginResponseDto._();

  factory PluginResponseDto([void updates(PluginResponseDtoBuilder b)]) = _$PluginResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PluginResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PluginResponseDto> get serializer => _$PluginResponseDtoSerializer();
}

class _$PluginResponseDtoSerializer implements PrimitiveSerializer<PluginResponseDto> {
  @override
  final Iterable<Type> types = const [PluginResponseDto, _$PluginResponseDto];

  @override
  final String wireName = r'PluginResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PluginResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'author';
    yield serializers.serialize(
      object.author,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'methods';
    yield serializers.serialize(
      object.methods,
      specifiedType: const FullType(BuiltList, [FullType(PluginMethodResponseDto)]),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(String),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PluginResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PluginResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'author':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.author = valueDes;
          break;
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
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'methods':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PluginMethodResponseDto)]),
          ) as BuiltList<PluginMethodResponseDto>;
          result.methods.replace(valueDes);
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.updatedAt = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.version = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PluginResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PluginResponseDtoBuilder();
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


