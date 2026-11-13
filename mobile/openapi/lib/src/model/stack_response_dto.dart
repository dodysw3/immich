//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/asset_response_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stack_response_dto.g.dart';

/// Stack response
///
/// Properties:
/// * [assets] 
/// * [id] - Stack ID
/// * [primaryAssetId] - Primary asset ID
@BuiltValue()
abstract class StackResponseDto implements Built<StackResponseDto, StackResponseDtoBuilder> {
  @BuiltValueField(wireName: r'assets')
  BuiltList<AssetResponseDto> get assets;

  /// Stack ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Primary asset ID
  @BuiltValueField(wireName: r'primaryAssetId')
  String get primaryAssetId;

  StackResponseDto._();

  factory StackResponseDto([void updates(StackResponseDtoBuilder b)]) = _$StackResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StackResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StackResponseDto> get serializer => _$StackResponseDtoSerializer();
}

class _$StackResponseDtoSerializer implements PrimitiveSerializer<StackResponseDto> {
  @override
  final Iterable<Type> types = const [StackResponseDto, _$StackResponseDto];

  @override
  final String wireName = r'StackResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StackResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assets';
    yield serializers.serialize(
      object.assets,
      specifiedType: const FullType(BuiltList, [FullType(AssetResponseDto)]),
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
    StackResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StackResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AssetResponseDto)]),
          ) as BuiltList<AssetResponseDto>;
          result.assets.replace(valueDes);
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
  StackResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StackResponseDtoBuilder();
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


