//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/asset_order.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_album_dto.g.dart';

/// UpdateAlbumDto
///
/// Properties:
/// * [albumName] - Album name
/// * [albumThumbnailAssetId] - Album thumbnail asset ID
/// * [description] - Album description
/// * [isActivityEnabled] - Enable activity feed
/// * [order] 
@BuiltValue()
abstract class UpdateAlbumDto implements Built<UpdateAlbumDto, UpdateAlbumDtoBuilder> {
  /// Album name
  @BuiltValueField(wireName: r'albumName')
  String? get albumName;

  /// Album thumbnail asset ID
  @BuiltValueField(wireName: r'albumThumbnailAssetId')
  String? get albumThumbnailAssetId;

  /// Album description
  @BuiltValueField(wireName: r'description')
  String? get description;

  /// Enable activity feed
  @BuiltValueField(wireName: r'isActivityEnabled')
  bool? get isActivityEnabled;

  @BuiltValueField(wireName: r'order')
  AssetOrder? get order;
  // enum orderEnum {  asc,  desc,  };

  UpdateAlbumDto._();

  factory UpdateAlbumDto([void updates(UpdateAlbumDtoBuilder b)]) = _$UpdateAlbumDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateAlbumDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateAlbumDto> get serializer => _$UpdateAlbumDtoSerializer();
}

class _$UpdateAlbumDtoSerializer implements PrimitiveSerializer<UpdateAlbumDto> {
  @override
  final Iterable<Type> types = const [UpdateAlbumDto, _$UpdateAlbumDto];

  @override
  final String wireName = r'UpdateAlbumDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateAlbumDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.albumName != null) {
      yield r'albumName';
      yield serializers.serialize(
        object.albumName,
        specifiedType: const FullType(String),
      );
    }
    if (object.albumThumbnailAssetId != null) {
      yield r'albumThumbnailAssetId';
      yield serializers.serialize(
        object.albumThumbnailAssetId,
        specifiedType: const FullType(String),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.isActivityEnabled != null) {
      yield r'isActivityEnabled';
      yield serializers.serialize(
        object.isActivityEnabled,
        specifiedType: const FullType(bool),
      );
    }
    if (object.order != null) {
      yield r'order';
      yield serializers.serialize(
        object.order,
        specifiedType: const FullType(AssetOrder),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateAlbumDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateAlbumDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'albumName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.albumName = valueDes;
          break;
        case r'albumThumbnailAssetId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.albumThumbnailAssetId = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'isActivityEnabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isActivityEnabled = valueDes;
          break;
        case r'order':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AssetOrder),
          ) as AssetOrder?;
          if (valueDes == null) continue;
          result.order = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateAlbumDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateAlbumDtoBuilder();
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


