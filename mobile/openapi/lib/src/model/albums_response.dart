//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/asset_order.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'albums_response.g.dart';

/// AlbumsResponse
///
/// Properties:
/// * [defaultAssetOrder] 
@BuiltValue()
abstract class AlbumsResponse implements Built<AlbumsResponse, AlbumsResponseBuilder> {
  @BuiltValueField(wireName: r'defaultAssetOrder')
  AssetOrder get defaultAssetOrder;
  // enum defaultAssetOrderEnum {  asc,  desc,  };

  AlbumsResponse._();

  factory AlbumsResponse([void updates(AlbumsResponseBuilder b)]) = _$AlbumsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AlbumsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AlbumsResponse> get serializer => _$AlbumsResponseSerializer();
}

class _$AlbumsResponseSerializer implements PrimitiveSerializer<AlbumsResponse> {
  @override
  final Iterable<Type> types = const [AlbumsResponse, _$AlbumsResponse];

  @override
  final String wireName = r'AlbumsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AlbumsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'defaultAssetOrder';
    yield serializers.serialize(
      object.defaultAssetOrder,
      specifiedType: const FullType(AssetOrder),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AlbumsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AlbumsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'defaultAssetOrder':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AssetOrder),
          ) as AssetOrder;
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
  AlbumsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AlbumsResponseBuilder();
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


