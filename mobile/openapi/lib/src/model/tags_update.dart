//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tags_update.g.dart';

/// TagsUpdate
///
/// Properties:
/// * [enabled] - Whether tags are enabled
/// * [sidebarWeb] - Whether tags appear in web sidebar
@BuiltValue()
abstract class TagsUpdate implements Built<TagsUpdate, TagsUpdateBuilder> {
  /// Whether tags are enabled
  @BuiltValueField(wireName: r'enabled')
  bool? get enabled;

  /// Whether tags appear in web sidebar
  @BuiltValueField(wireName: r'sidebarWeb')
  bool? get sidebarWeb;

  TagsUpdate._();

  factory TagsUpdate([void updates(TagsUpdateBuilder b)]) = _$TagsUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TagsUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TagsUpdate> get serializer => _$TagsUpdateSerializer();
}

class _$TagsUpdateSerializer implements PrimitiveSerializer<TagsUpdate> {
  @override
  final Iterable<Type> types = const [TagsUpdate, _$TagsUpdate];

  @override
  final String wireName = r'TagsUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TagsUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.enabled != null) {
      yield r'enabled';
      yield serializers.serialize(
        object.enabled,
        specifiedType: const FullType(bool),
      );
    }
    if (object.sidebarWeb != null) {
      yield r'sidebarWeb';
      yield serializers.serialize(
        object.sidebarWeb,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    TagsUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TagsUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.enabled = valueDes;
          break;
        case r'sidebarWeb':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
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
  TagsUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TagsUpdateBuilder();
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


