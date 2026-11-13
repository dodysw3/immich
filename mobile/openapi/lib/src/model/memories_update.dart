//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'memories_update.g.dart';

/// MemoriesUpdate
///
/// Properties:
/// * [duration] - Memory duration in seconds
/// * [enabled] - Whether memories are enabled
/// * [sidebarWeb] - Whether memories appear in web sidebar
@BuiltValue()
abstract class MemoriesUpdate implements Built<MemoriesUpdate, MemoriesUpdateBuilder> {
  /// Memory duration in seconds
  @BuiltValueField(wireName: r'duration')
  int? get duration;

  /// Whether memories are enabled
  @BuiltValueField(wireName: r'enabled')
  bool? get enabled;

  /// Whether memories appear in web sidebar
  @BuiltValueField(wireName: r'sidebarWeb')
  bool? get sidebarWeb;

  MemoriesUpdate._();

  factory MemoriesUpdate([void updates(MemoriesUpdateBuilder b)]) = _$MemoriesUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MemoriesUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MemoriesUpdate> get serializer => _$MemoriesUpdateSerializer();
}

class _$MemoriesUpdateSerializer implements PrimitiveSerializer<MemoriesUpdate> {
  @override
  final Iterable<Type> types = const [MemoriesUpdate, _$MemoriesUpdate];

  @override
  final String wireName = r'MemoriesUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MemoriesUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.duration != null) {
      yield r'duration';
      yield serializers.serialize(
        object.duration,
        specifiedType: const FullType(int),
      );
    }
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
    MemoriesUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MemoriesUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'duration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.duration = valueDes;
          break;
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
  MemoriesUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MemoriesUpdateBuilder();
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


