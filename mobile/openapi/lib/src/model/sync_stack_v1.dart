//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_stack_v1.g.dart';

/// SyncStackV1
///
/// Properties:
/// * [createdAt] - Created at
/// * [id] - Stack ID
/// * [ownerId] - Owner ID
/// * [primaryAssetId] - Primary asset ID
/// * [updatedAt] - Updated at
@BuiltValue()
abstract class SyncStackV1 implements Built<SyncStackV1, SyncStackV1Builder> {
  /// Created at
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// Stack ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Owner ID
  @BuiltValueField(wireName: r'ownerId')
  String get ownerId;

  /// Primary asset ID
  @BuiltValueField(wireName: r'primaryAssetId')
  String get primaryAssetId;

  /// Updated at
  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  SyncStackV1._();

  factory SyncStackV1([void updates(SyncStackV1Builder b)]) = _$SyncStackV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncStackV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncStackV1> get serializer => _$SyncStackV1Serializer();
}

class _$SyncStackV1Serializer implements PrimitiveSerializer<SyncStackV1> {
  @override
  final Iterable<Type> types = const [SyncStackV1, _$SyncStackV1];

  @override
  final String wireName = r'SyncStackV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncStackV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'ownerId';
    yield serializers.serialize(
      object.ownerId,
      specifiedType: const FullType(String),
    );
    yield r'primaryAssetId';
    yield serializers.serialize(
      object.primaryAssetId,
      specifiedType: const FullType(String),
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
    SyncStackV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncStackV1Builder result,
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
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'ownerId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ownerId = valueDes;
          break;
        case r'primaryAssetId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.primaryAssetId = valueDes;
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
  SyncStackV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncStackV1Builder();
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


