//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_stack_response_dto.g.dart';

/// AssetStackResponseDto
///
/// Properties:
/// * [assetCount] - Number of assets in stack
/// * [id] - Stack ID
/// * [primaryAssetId] - Primary asset ID
@BuiltValue()
abstract class AssetStackResponseDto implements Built<AssetStackResponseDto, AssetStackResponseDtoBuilder> {
  /// Number of assets in stack
  @BuiltValueField(wireName: r'assetCount')
  int get assetCount;

  /// Stack ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Primary asset ID
  @BuiltValueField(wireName: r'primaryAssetId')
  String get primaryAssetId;

  AssetStackResponseDto._();

  factory AssetStackResponseDto([void updates(AssetStackResponseDtoBuilder b)]) = _$AssetStackResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetStackResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetStackResponseDto> get serializer => _$AssetStackResponseDtoSerializer();
}

class _$AssetStackResponseDtoSerializer implements PrimitiveSerializer<AssetStackResponseDto> {
  @override
  final Iterable<Type> types = const [AssetStackResponseDto, _$AssetStackResponseDto];

  @override
  final String wireName = r'AssetStackResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetStackResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assetCount';
    yield serializers.serialize(
      object.assetCount,
      specifiedType: const FullType(int),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'primaryAssetId';
    yield serializers.serialize(
      object.primaryAssetId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AssetStackResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssetStackResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assetCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.assetCount = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'primaryAssetId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.primaryAssetId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AssetStackResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetStackResponseDtoBuilder();
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


