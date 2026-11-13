//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/asset_edit_action_item_response_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_edits_response_dto.g.dart';

/// AssetEditsResponseDto
///
/// Properties:
/// * [assetId] - Asset ID these edits belong to
/// * [edits] - List of edit actions applied to the asset
@BuiltValue()
abstract class AssetEditsResponseDto implements Built<AssetEditsResponseDto, AssetEditsResponseDtoBuilder> {
  /// Asset ID these edits belong to
  @BuiltValueField(wireName: r'assetId')
  String get assetId;

  /// List of edit actions applied to the asset
  @BuiltValueField(wireName: r'edits')
  BuiltList<AssetEditActionItemResponseDto> get edits;

  AssetEditsResponseDto._();

  factory AssetEditsResponseDto([void updates(AssetEditsResponseDtoBuilder b)]) = _$AssetEditsResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetEditsResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetEditsResponseDto> get serializer => _$AssetEditsResponseDtoSerializer();
}

class _$AssetEditsResponseDtoSerializer implements PrimitiveSerializer<AssetEditsResponseDto> {
  @override
  final Iterable<Type> types = const [AssetEditsResponseDto, _$AssetEditsResponseDto];

  @override
  final String wireName = r'AssetEditsResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetEditsResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assetId';
    yield serializers.serialize(
      object.assetId,
      specifiedType: const FullType(String),
    );
    yield r'edits';
    yield serializers.serialize(
      object.edits,
      specifiedType: const FullType(BuiltList, [FullType(AssetEditActionItemResponseDto)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AssetEditsResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssetEditsResponseDtoBuilder result,
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
        case r'edits':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AssetEditActionItemResponseDto)]),
          ) as BuiltList<AssetEditActionItemResponseDto>;
          result.edits.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AssetEditsResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetEditsResponseDtoBuilder();
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


