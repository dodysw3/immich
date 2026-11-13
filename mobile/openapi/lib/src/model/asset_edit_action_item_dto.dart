//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/asset_edit_action_item_dto_parameters.dart';
import 'package:openapi/src/model/asset_edit_action.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_edit_action_item_dto.g.dart';

/// AssetEditActionItemDto
///
/// Properties:
/// * [action] 
/// * [parameters] 
@BuiltValue()
abstract class AssetEditActionItemDto implements Built<AssetEditActionItemDto, AssetEditActionItemDtoBuilder> {
  @BuiltValueField(wireName: r'action')
  AssetEditAction get action;
  // enum actionEnum {  crop,  rotate,  mirror,  };

  @BuiltValueField(wireName: r'parameters')
  AssetEditActionItemDtoParameters get parameters;

  AssetEditActionItemDto._();

  factory AssetEditActionItemDto([void updates(AssetEditActionItemDtoBuilder b)]) = _$AssetEditActionItemDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetEditActionItemDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetEditActionItemDto> get serializer => _$AssetEditActionItemDtoSerializer();
}

class _$AssetEditActionItemDtoSerializer implements PrimitiveSerializer<AssetEditActionItemDto> {
  @override
  final Iterable<Type> types = const [AssetEditActionItemDto, _$AssetEditActionItemDto];

  @override
  final String wireName = r'AssetEditActionItemDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetEditActionItemDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(AssetEditAction),
    );
    yield r'parameters';
    yield serializers.serialize(
      object.parameters,
      specifiedType: const FullType(AssetEditActionItemDtoParameters),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AssetEditActionItemDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssetEditActionItemDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AssetEditAction),
          ) as AssetEditAction;
          result.action = valueDes;
          break;
        case r'parameters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AssetEditActionItemDtoParameters),
          ) as AssetEditActionItemDtoParameters;
          result.parameters.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AssetEditActionItemDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetEditActionItemDtoBuilder();
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


