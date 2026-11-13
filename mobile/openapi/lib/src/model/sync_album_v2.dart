//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/asset_order.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_album_v2.g.dart';

/// SyncAlbumV2
///
/// Properties:
/// * [createdAt] - Created at
/// * [description] - Album description
/// * [id] - Album ID
/// * [isActivityEnabled] - Is activity enabled
/// * [name] - Album name
/// * [order] 
/// * [thumbnailAssetId] - Thumbnail asset ID
/// * [updatedAt] - Updated at
@BuiltValue()
abstract class SyncAlbumV2 implements Built<SyncAlbumV2, SyncAlbumV2Builder> {
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

  /// Thumbnail asset ID
  @BuiltValueField(wireName: r'thumbnailAssetId')
  String? get thumbnailAssetId;

  /// Updated at
  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  SyncAlbumV2._();

  factory SyncAlbumV2([void updates(SyncAlbumV2Builder b)]) = _$SyncAlbumV2;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncAlbumV2Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncAlbumV2> get serializer => _$SyncAlbumV2Serializer();
}

class _$SyncAlbumV2Serializer implements PrimitiveSerializer<SyncAlbumV2> {
  @override
  final Iterable<Type> types = const [SyncAlbumV2, _$SyncAlbumV2];

  @override
  final String wireName = r'SyncAlbumV2';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncAlbumV2 object, {
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
    SyncAlbumV2 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncAlbumV2Builder result,
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
  SyncAlbumV2 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncAlbumV2Builder();
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


