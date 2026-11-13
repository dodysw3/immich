//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_album_to_asset_v1.g.dart';

/// SyncAlbumToAssetV1
///
/// Properties:
/// * [albumId] - Album ID
/// * [assetId] - Asset ID
@BuiltValue()
abstract class SyncAlbumToAssetV1 implements Built<SyncAlbumToAssetV1, SyncAlbumToAssetV1Builder> {
  /// Album ID
  @BuiltValueField(wireName: r'albumId')
  String get albumId;

  /// Asset ID
  @BuiltValueField(wireName: r'assetId')
  String get assetId;

  SyncAlbumToAssetV1._();

  factory SyncAlbumToAssetV1([void updates(SyncAlbumToAssetV1Builder b)]) = _$SyncAlbumToAssetV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncAlbumToAssetV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncAlbumToAssetV1> get serializer => _$SyncAlbumToAssetV1Serializer();
}

class _$SyncAlbumToAssetV1Serializer implements PrimitiveSerializer<SyncAlbumToAssetV1> {
  @override
  final Iterable<Type> types = const [SyncAlbumToAssetV1, _$SyncAlbumToAssetV1];

  @override
  final String wireName = r'SyncAlbumToAssetV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncAlbumToAssetV1 object, {
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
    SyncAlbumToAssetV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncAlbumToAssetV1Builder result,
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
  SyncAlbumToAssetV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncAlbumToAssetV1Builder();
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


