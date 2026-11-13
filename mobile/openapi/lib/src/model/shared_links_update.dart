//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'shared_links_update.g.dart';

/// SharedLinksUpdate
///
/// Properties:
/// * [enabled] - Whether shared links are enabled
/// * [sidebarWeb] - Whether shared links appear in web sidebar
@BuiltValue()
abstract class SharedLinksUpdate implements Built<SharedLinksUpdate, SharedLinksUpdateBuilder> {
  /// Whether shared links are enabled
  @BuiltValueField(wireName: r'enabled')
  bool? get enabled;

  /// Whether shared links appear in web sidebar
  @BuiltValueField(wireName: r'sidebarWeb')
  bool? get sidebarWeb;

  SharedLinksUpdate._();

  factory SharedLinksUpdate([void updates(SharedLinksUpdateBuilder b)]) = _$SharedLinksUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SharedLinksUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SharedLinksUpdate> get serializer => _$SharedLinksUpdateSerializer();
}

class _$SharedLinksUpdateSerializer implements PrimitiveSerializer<SharedLinksUpdate> {
  @override
  final Iterable<Type> types = const [SharedLinksUpdate, _$SharedLinksUpdate];

  @override
  final String wireName = r'SharedLinksUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SharedLinksUpdate object, {
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
    SharedLinksUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SharedLinksUpdateBuilder result,
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
  SharedLinksUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SharedLinksUpdateBuilder();
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


