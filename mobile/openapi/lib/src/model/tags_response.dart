//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tags_response.g.dart';

/// TagsResponse
///
/// Properties:
/// * [enabled] - Whether tags are enabled
/// * [sidebarWeb] - Whether tags appear in web sidebar
@BuiltValue()
abstract class TagsResponse implements Built<TagsResponse, TagsResponseBuilder> {
  /// Whether tags are enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// Whether tags appear in web sidebar
  @BuiltValueField(wireName: r'sidebarWeb')
  bool get sidebarWeb;

  TagsResponse._();

  factory TagsResponse([void updates(TagsResponseBuilder b)]) = _$TagsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TagsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TagsResponse> get serializer => _$TagsResponseSerializer();
}

class _$TagsResponseSerializer implements PrimitiveSerializer<TagsResponse> {
  @override
  final Iterable<Type> types = const [TagsResponse, _$TagsResponse];

  @override
  final String wireName = r'TagsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TagsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'sidebarWeb';
    yield serializers.serialize(
      object.sidebarWeb,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TagsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TagsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'sidebarWeb':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.sidebarWeb = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TagsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TagsResponseBuilder();
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


