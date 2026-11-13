//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_album_to_asset_delete_v1.g.dart';

/// SyncAlbumToAssetDeleteV1
///
/// Properties:
/// * [albumId] - Album ID
/// * [assetId] - Asset ID
@BuiltValue()
abstract class SyncAlbumToAssetDeleteV1 implements Built<SyncAlbumToAssetDeleteV1, SyncAlbumToAssetDeleteV1Builder> {
  /// Album ID
  @BuiltValueField(wireName: r'albumId')
  String get albumId;

  /// Asset ID
  @BuiltValueField(wireName: r'assetId')
  String get assetId;

  SyncAlbumToAssetDeleteV1._();

  factory SyncAlbumToAssetDeleteV1([void updates(SyncAlbumToAssetDeleteV1Builder b)]) = _$SyncAlbumToAssetDeleteV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncAlbumToAssetDeleteV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncAlbumToAssetDeleteV1> get serializer => _$SyncAlbumToAssetDeleteV1Serializer();
}

class _$SyncAlbumToAssetDeleteV1Serializer implements PrimitiveSerializer<SyncAlbumToAssetDeleteV1> {
  @override
  final Iterable<Type> types = const [SyncAlbumToAssetDeleteV1, _$SyncAlbumToAssetDeleteV1];

  @override
  final String wireName = r'SyncAlbumToAssetDeleteV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncAlbumToAssetDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'albumId';
    yield serializers.serialize(
      object.albumId,
      specifiedType: const FullType(String),
    );
    yield r'assetId';
    yield serializers.serialize(
      object.assetId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncAlbumToAssetDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncAlbumToAssetDeleteV1Builder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'albumId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.albumId = valueDes;
          break;
        case r'assetId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.assetId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncAlbumToAssetDeleteV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncAlbumToAssetDeleteV1Builder();
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


