//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/asset_order.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'albums_update.g.dart';

/// Album preferences
///
/// Properties:
/// * [defaultAssetOrder] 
@BuiltValue()
abstract class AlbumsUpdate implements Built<AlbumsUpdate, AlbumsUpdateBuilder> {
  @BuiltValueField(wireName: r'defaultAssetOrder')
  AssetOrder? get defaultAssetOrder;
  // enum defaultAssetOrderEnum {  asc,  desc,  };

  AlbumsUpdate._();

  factory AlbumsUpdate([void updates(AlbumsUpdateBuilder b)]) = _$AlbumsUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AlbumsUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AlbumsUpdate> get serializer => _$AlbumsUpdateSerializer();
}

class _$AlbumsUpdateSerializer implements PrimitiveSerializer<AlbumsUpdate> {
  @override
  final Iterable<Type> types = const [AlbumsUpdate, _$AlbumsUpdate];

  @override
  final String wireName = r'AlbumsUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AlbumsUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.defaultAssetOrder != null) {
      yield r'defaultAssetOrder';
      yield serializers.serialize(
        object.defaultAssetOrder,
        specifiedType: const FullType(AssetOrder),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AlbumsUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AlbumsUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'defaultAssetOrder':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AssetOrder),
          ) as AssetOrder?;
          if (valueDes == null) continue;
          result.defaultAssetOrder = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AlbumsUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AlbumsUpdateBuilder();
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


