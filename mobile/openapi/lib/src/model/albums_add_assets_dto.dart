//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'albums_add_assets_dto.g.dart';

/// AlbumsAddAssetsDto
///
/// Properties:
/// * [albumIds] - Album IDs
/// * [assetIds] - Asset IDs
@BuiltValue()
abstract class AlbumsAddAssetsDto implements Built<AlbumsAddAssetsDto, AlbumsAddAssetsDtoBuilder> {
  /// Album IDs
  @BuiltValueField(wireName: r'albumIds')
  BuiltList<String> get albumIds;

  /// Asset IDs
  @BuiltValueField(wireName: r'assetIds')
  BuiltList<String> get assetIds;

  AlbumsAddAssetsDto._();

  factory AlbumsAddAssetsDto([void updates(AlbumsAddAssetsDtoBuilder b)]) = _$AlbumsAddAssetsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AlbumsAddAssetsDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AlbumsAddAssetsDto> get serializer => _$AlbumsAddAssetsDtoSerializer();
}

class _$AlbumsAddAssetsDtoSerializer implements PrimitiveSerializer<AlbumsAddAssetsDto> {
  @override
  final Iterable<Type> types = const [AlbumsAddAssetsDto, _$AlbumsAddAssetsDto];

  @override
  final String wireName = r'AlbumsAddAssetsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AlbumsAddAssetsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'albumIds';
    yield serializers.serialize(
      object.albumIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'assetIds';
    yield serializers.serialize(
      object.assetIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AlbumsAddAssetsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AlbumsAddAssetsDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'albumIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.albumIds.replace(valueDes);
          break;
        case r'assetIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.assetIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AlbumsAddAssetsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AlbumsAddAssetsDtoBuilder();
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


