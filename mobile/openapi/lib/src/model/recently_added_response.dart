//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recently_added_response.g.dart';

/// RecentlyAddedResponse
///
/// Properties:
/// * [sidebarWeb] - Whether the recently added page appears in the web sidebar
@BuiltValue()
abstract class RecentlyAddedResponse implements Built<RecentlyAddedResponse, RecentlyAddedResponseBuilder> {
  /// Whether the recently added page appears in the web sidebar
  @BuiltValueField(wireName: r'sidebarWeb')
  bool get sidebarWeb;

  RecentlyAddedResponse._();

  factory RecentlyAddedResponse([void updates(RecentlyAddedResponseBuilder b)]) = _$RecentlyAddedResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecentlyAddedResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecentlyAddedResponse> get serializer => _$RecentlyAddedResponseSerializer();
}

class _$RecentlyAddedResponseSerializer implements PrimitiveSerializer<RecentlyAddedResponse> {
  @override
  final Iterable<Type> types = const [RecentlyAddedResponse, _$RecentlyAddedResponse];

  @override
  final String wireName = r'RecentlyAddedResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecentlyAddedResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sidebarWeb';
    yield serializers.serialize(
      object.sidebarWeb,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RecentlyAddedResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RecentlyAddedResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  RecentlyAddedResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecentlyAddedResponseBuilder();
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


