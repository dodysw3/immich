//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/asset_id_error_reason.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_ids_response_dto.g.dart';

/// AssetIdsResponseDto
///
/// Properties:
/// * [assetId] - Asset ID
/// * [error] 
/// * [success] - Whether operation succeeded
@BuiltValue()
abstract class AssetIdsResponseDto implements Built<AssetIdsResponseDto, AssetIdsResponseDtoBuilder> {
  /// Asset ID
  @BuiltValueField(wireName: r'assetId')
  String get assetId;

  @BuiltValueField(wireName: r'error')
  AssetIdErrorReason? get error;
  // enum errorEnum {  duplicate,  no_permission,  not_found,  };

  /// Whether operation succeeded
  @BuiltValueField(wireName: r'success')
  bool get success;

  AssetIdsResponseDto._();

  factory AssetIdsResponseDto([void updates(AssetIdsResponseDtoBuilder b)]) = _$AssetIdsResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetIdsResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetIdsResponseDto> get serializer => _$AssetIdsResponseDtoSerializer();
}

class _$AssetIdsResponseDtoSerializer implements PrimitiveSerializer<AssetIdsResponseDto> {
  @override
  final Iterable<Type> types = const [AssetIdsResponseDto, _$AssetIdsResponseDto];

  @override
  final String wireName = r'AssetIdsResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetIdsResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assetId';
    yield serializers.serialize(
      object.assetId,
      specifiedType: const FullType(String),
    );
    if (object.error != null) {
      yield r'error';
      yield serializers.serialize(
        object.error,
        specifiedType: const FullType(AssetIdErrorReason),
      );
    }
    yield r'success';
    yield serializers.serialize(
      object.success,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AssetIdsResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssetIdsResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assetId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.assetId = valueDes;
          break;
        case r'error':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AssetIdErrorReason),
          ) as AssetIdErrorReason?;
          if (valueDes == null) continue;
          result.error = valueDes;
          break;
        case r'success':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.success = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AssetIdsResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetIdsResponseDtoBuilder();
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


