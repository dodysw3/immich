//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_memory_delete_v1.g.dart';

/// SyncMemoryDeleteV1
///
/// Properties:
/// * [memoryId] - Memory ID
@BuiltValue()
abstract class SyncMemoryDeleteV1 implements Built<SyncMemoryDeleteV1, SyncMemoryDeleteV1Builder> {
  /// Memory ID
  @BuiltValueField(wireName: r'memoryId')
  String get memoryId;

  SyncMemoryDeleteV1._();

  factory SyncMemoryDeleteV1([void updates(SyncMemoryDeleteV1Builder b)]) = _$SyncMemoryDeleteV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncMemoryDeleteV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncMemoryDeleteV1> get serializer => _$SyncMemoryDeleteV1Serializer();
}

class _$SyncMemoryDeleteV1Serializer implements PrimitiveSerializer<SyncMemoryDeleteV1> {
  @override
  final Iterable<Type> types = const [SyncMemoryDeleteV1, _$SyncMemoryDeleteV1];

  @override
  final String wireName = r'SyncMemoryDeleteV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncMemoryDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'memoryId';
    yield serializers.serialize(
      object.memoryId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncMemoryDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncMemoryDeleteV1Builder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'memoryId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.memoryId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncMemoryDeleteV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncMemoryDeleteV1Builder();
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


