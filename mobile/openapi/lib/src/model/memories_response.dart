//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'memories_response.g.dart';

/// MemoriesResponse
///
/// Properties:
/// * [duration] - Memory duration in seconds
/// * [enabled] - Whether memories are enabled
/// * [sidebarWeb] - Whether memories appear in web sidebar
@BuiltValue()
abstract class MemoriesResponse implements Built<MemoriesResponse, MemoriesResponseBuilder> {
  /// Memory duration in seconds
  @BuiltValueField(wireName: r'duration')
  int get duration;

  /// Whether memories are enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// Whether memories appear in web sidebar
  @BuiltValueField(wireName: r'sidebarWeb')
  bool get sidebarWeb;

  MemoriesResponse._();

  factory MemoriesResponse([void updates(MemoriesResponseBuilder b)]) = _$MemoriesResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MemoriesResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MemoriesResponse> get serializer => _$MemoriesResponseSerializer();
}

class _$MemoriesResponseSerializer implements PrimitiveSerializer<MemoriesResponse> {
  @override
  final Iterable<Type> types = const [MemoriesResponse, _$MemoriesResponse];

  @override
  final String wireName = r'MemoriesResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MemoriesResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'duration';
    yield serializers.serialize(
      object.duration,
      specifiedType: const FullType(int),
    );
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
    MemoriesResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MemoriesResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'duration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.duration = valueDes;
          break;
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
  MemoriesResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MemoriesResponseBuilder();
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


