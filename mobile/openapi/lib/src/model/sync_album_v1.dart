//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/asset_order.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_album_v1.g.dart';

/// SyncAlbumV1
///
/// Properties:
/// * [createdAt] - Created at
/// * [description] - Album description
/// * [id] - Album ID
/// * [isActivityEnabled] - Is activity enabled
/// * [name] - Album name
/// * [order] 
/// * [ownerId] - Owner ID
/// * [thumbnailAssetId] - Thumbnail asset ID
/// * [updatedAt] - Updated at
@BuiltValue()
abstract class SyncAlbumV1 implements Built<SyncAlbumV1, SyncAlbumV1Builder> {
  /// Created at
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// Album description
  @BuiltValueField(wireName: r'description')
  String get description;

  /// Album ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Is activity enabled
  @BuiltValueField(wireName: r'isActivityEnabled')
  bool get isActivityEnabled;

  /// Album name
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'order')
  AssetOrder get order;
  // enum orderEnum {  asc,  desc,  };

  /// Owner ID
  @BuiltValueField(wireName: r'ownerId')
  String get ownerId;

  /// Thumbnail asset ID
  @BuiltValueField(wireName: r'thumbnailAssetId')
  String? get thumbnailAssetId;

  /// Updated at
  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  SyncAlbumV1._();

  factory SyncAlbumV1([void updates(SyncAlbumV1Builder b)]) = _$SyncAlbumV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncAlbumV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncAlbumV1> get serializer => _$SyncAlbumV1Serializer();
}

class _$SyncAlbumV1Serializer implements PrimitiveSerializer<SyncAlbumV1> {
  @override
  final Iterable<Type> types = const [SyncAlbumV1, _$SyncAlbumV1];

  @override
  final String wireName = r'SyncAlbumV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncAlbumV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'isActivityEnabled';
    yield serializers.serialize(
      object.isActivityEnabled,
      specifiedType: const FullType(bool),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'order';
    yield serializers.serialize(
      object.order,
      specifiedType: const FullType(AssetOrder),
    );
    yield r'ownerId';
    yield serializers.serialize(
      object.ownerId,
      specifiedType: const FullType(String),
    );
    yield r'thumbnailAssetId';
    yield object.thumbnailAssetId == null ? null : serializers.serialize(
      object.thumbnailAssetId,
      specifiedType: const FullType.nullable(String),
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
    SyncAlbumV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncAlbumV1Builder result,
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
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'isActivityEnabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isActivityEnabled = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'order':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AssetOrder),
          ) as AssetOrder;
          result.order = valueDes;
          break;
        case r'ownerId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ownerId = valueDes;
          break;
        case r'thumbnailAssetId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.thumbnailAssetId = valueDes;
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
  SyncAlbumV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncAlbumV1Builder();
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


