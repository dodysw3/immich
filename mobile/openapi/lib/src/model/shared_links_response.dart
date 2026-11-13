//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'shared_links_response.g.dart';

/// SharedLinksResponse
///
/// Properties:
/// * [enabled] - Whether shared links are enabled
/// * [sidebarWeb] - Whether shared links appear in web sidebar
@BuiltValue()
abstract class SharedLinksResponse implements Built<SharedLinksResponse, SharedLinksResponseBuilder> {
  /// Whether shared links are enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// Whether shared links appear in web sidebar
  @BuiltValueField(wireName: r'sidebarWeb')
  bool get sidebarWeb;

  SharedLinksResponse._();

  factory SharedLinksResponse([void updates(SharedLinksResponseBuilder b)]) = _$SharedLinksResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SharedLinksResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SharedLinksResponse> get serializer => _$SharedLinksResponseSerializer();
}

class _$SharedLinksResponseSerializer implements PrimitiveSerializer<SharedLinksResponse> {
  @override
  final Iterable<Type> types = const [SharedLinksResponse, _$SharedLinksResponse];

  @override
  final String wireName = r'SharedLinksResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SharedLinksResponse object, {
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
    SharedLinksResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SharedLinksResponseBuilder result,
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
  SharedLinksResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SharedLinksResponseBuilder();
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


