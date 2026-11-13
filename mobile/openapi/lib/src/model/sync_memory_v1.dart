//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/memory_type_v1.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_memory_v1.g.dart';

/// SyncMemoryV1
///
/// Properties:
/// * [createdAt] - Created at
/// * [data] - Data
/// * [deletedAt] - Deleted at
/// * [hideAt] - Hide at
/// * [id] - Memory ID
/// * [isSaved] - Is saved
/// * [memoryAt] - Memory at
/// * [ownerId] - Owner ID
/// * [seenAt] - Seen at
/// * [showAt] - Show at
/// * [type] 
/// * [updatedAt] - Updated at
@BuiltValue()
abstract class SyncMemoryV1 implements Built<SyncMemoryV1, SyncMemoryV1Builder> {
  /// Created at
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// Data
  @BuiltValueField(wireName: r'data')
  BuiltMap<String, JsonObject?> get data;

  /// Deleted at
  @BuiltValueField(wireName: r'deletedAt')
  DateTime? get deletedAt;

  /// Hide at
  @BuiltValueField(wireName: r'hideAt')
  DateTime? get hideAt;

  /// Memory ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Is saved
  @BuiltValueField(wireName: r'isSaved')
  bool get isSaved;

  /// Memory at
  @BuiltValueField(wireName: r'memoryAt')
  DateTime get memoryAt;

  /// Owner ID
  @BuiltValueField(wireName: r'ownerId')
  String get ownerId;

  /// Seen at
  @BuiltValueField(wireName: r'seenAt')
  DateTime? get seenAt;

  /// Show at
  @BuiltValueField(wireName: r'showAt')
  DateTime? get showAt;

  @BuiltValueField(wireName: r'type')
  MemoryTypeV1 get type;
  // enum typeEnum {  on_this_day,  };

  /// Updated at
  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  SyncMemoryV1._();

  factory SyncMemoryV1([void updates(SyncMemoryV1Builder b)]) = _$SyncMemoryV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncMemoryV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncMemoryV1> get serializer => _$SyncMemoryV1Serializer();
}

class _$SyncMemoryV1Serializer implements PrimitiveSerializer<SyncMemoryV1> {
  @override
  final Iterable<Type> types = const [SyncMemoryV1, _$SyncMemoryV1];

  @override
  final String wireName = r'SyncMemoryV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncMemoryV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'deletedAt';
    yield object.deletedAt == null ? null : serializers.serialize(
      object.deletedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'hideAt';
    yield object.hideAt == null ? null : serializers.serialize(
      object.hideAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'isSaved';
    yield serializers.serialize(
      object.isSaved,
      specifiedType: const FullType(bool),
    );
    yield r'memoryAt';
    yield serializers.serialize(
      object.memoryAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'ownerId';
    yield serializers.serialize(
      object.ownerId,
      specifiedType: const FullType(String),
    );
    yield r'seenAt';
    yield object.seenAt == null ? null : serializers.serialize(
      object.seenAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'showAt';
    yield object.showAt == null ? null : serializers.serialize(
      object.showAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(MemoryTypeV1),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncMemoryV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncMemoryV1Builder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.data.replace(valueDes);
          break;
        case r'deletedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.deletedAt = valueDes;
          break;
        case r'hideAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.hideAt = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'isSaved':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isSaved = valueDes;
          break;
        case r'memoryAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.memoryAt = valueDes;
          break;
        case r'ownerId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ownerId = valueDes;
          break;
        case r'seenAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.seenAt = valueDes;
          break;
        case r'showAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.showAt = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MemoryTypeV1),
          ) as MemoryTypeV1;
          result.type = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncMemoryV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncMemoryV1Builder();
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


