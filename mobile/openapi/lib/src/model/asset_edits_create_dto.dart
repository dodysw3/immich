//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/asset_edit_action_item_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_edits_create_dto.g.dart';

/// AssetEditsCreateDto
///
/// Properties:
/// * [edits] - List of edit actions to apply (crop, rotate, or mirror)
@BuiltValue()
abstract class AssetEditsCreateDto implements Built<AssetEditsCreateDto, AssetEditsCreateDtoBuilder> {
  /// List of edit actions to apply (crop, rotate, or mirror)
  @BuiltValueField(wireName: r'edits')
  BuiltList<AssetEditActionItemDto> get edits;

  AssetEditsCreateDto._();

  factory AssetEditsCreateDto([void updates(AssetEditsCreateDtoBuilder b)]) = _$AssetEditsCreateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetEditsCreateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetEditsCreateDto> get serializer => _$AssetEditsCreateDtoSerializer();
}

class _$AssetEditsCreateDtoSerializer implements PrimitiveSerializer<AssetEditsCreateDto> {
  @override
  final Iterable<Type> types = const [AssetEditsCreateDto, _$AssetEditsCreateDto];

  @override
  final String wireName = r'AssetEditsCreateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetEditsCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'edits';
    yield serializers.serialize(
      object.edits,
      specifiedType: const FullType(BuiltList, [FullType(AssetEditActionItemDto)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AssetEditsCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssetEditsCreateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'edits':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AssetEditActionItemDto)]),
          ) as BuiltList<AssetEditActionItemDto>;
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
  AssetEditsCreateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetEditsCreateDtoBuilder();
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


