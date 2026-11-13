//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/asset_response_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'duplicate_response_dto.g.dart';

/// DuplicateResponseDto
///
/// Properties:
/// * [assets] - Duplicate assets
/// * [duplicateId] - Duplicate group ID
/// * [suggestedKeepAssetIds] - Suggested asset IDs to keep based on file size and EXIF data
@BuiltValue()
abstract class DuplicateResponseDto implements Built<DuplicateResponseDto, DuplicateResponseDtoBuilder> {
  /// Duplicate assets
  @BuiltValueField(wireName: r'assets')
  BuiltList<AssetResponseDto> get assets;

  /// Duplicate group ID
  @BuiltValueField(wireName: r'duplicateId')
  String get duplicateId;

  /// Suggested asset IDs to keep based on file size and EXIF data
  @BuiltValueField(wireName: r'suggestedKeepAssetIds')
  BuiltList<String> get suggestedKeepAssetIds;

  DuplicateResponseDto._();

  factory DuplicateResponseDto([void updates(DuplicateResponseDtoBuilder b)]) = _$DuplicateResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DuplicateResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DuplicateResponseDto> get serializer => _$DuplicateResponseDtoSerializer();
}

class _$DuplicateResponseDtoSerializer implements PrimitiveSerializer<DuplicateResponseDto> {
  @override
  final Iterable<Type> types = const [DuplicateResponseDto, _$DuplicateResponseDto];

  @override
  final String wireName = r'DuplicateResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DuplicateResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assets';
    yield serializers.serialize(
      object.assets,
      specifiedType: const FullType(BuiltList, [FullType(AssetResponseDto)]),
    );
    yield r'duplicateId';
    yield serializers.serialize(
      object.duplicateId,
      specifiedType: const FullType(String),
    );
    yield r'suggestedKeepAssetIds';
    yield serializers.serialize(
      object.suggestedKeepAssetIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DuplicateResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DuplicateResponseDtoBuilder result,
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
        case r'duplicateId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.duplicateId = valueDes;
          break;
        case r'suggestedKeepAssetIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.suggestedKeepAssetIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DuplicateResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DuplicateResponseDtoBuilder();
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


