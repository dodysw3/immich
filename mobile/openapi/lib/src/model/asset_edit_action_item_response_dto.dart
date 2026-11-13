//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/asset_edit_action_item_dto_parameters.dart';
import 'package:openapi/src/model/asset_edit_action.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_edit_action_item_response_dto.g.dart';

/// AssetEditActionItemResponseDto
///
/// Properties:
/// * [action] 
/// * [id] - Asset edit ID
/// * [parameters] 
@BuiltValue()
abstract class AssetEditActionItemResponseDto implements Built<AssetEditActionItemResponseDto, AssetEditActionItemResponseDtoBuilder> {
  @BuiltValueField(wireName: r'action')
  AssetEditAction get action;
  // enum actionEnum {  crop,  rotate,  mirror,  };

  /// Asset edit ID
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'parameters')
  AssetEditActionItemDtoParameters get parameters;

  AssetEditActionItemResponseDto._();

  factory AssetEditActionItemResponseDto([void updates(AssetEditActionItemResponseDtoBuilder b)]) = _$AssetEditActionItemResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetEditActionItemResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetEditActionItemResponseDto> get serializer => _$AssetEditActionItemResponseDtoSerializer();
}

class _$AssetEditActionItemResponseDtoSerializer implements PrimitiveSerializer<AssetEditActionItemResponseDto> {
  @override
  final Iterable<Type> types = const [AssetEditActionItemResponseDto, _$AssetEditActionItemResponseDto];

  @override
  final String wireName = r'AssetEditActionItemResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetEditActionItemResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(AssetEditAction),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
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
    AssetEditActionItemResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssetEditActionItemResponseDtoBuilder result,
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
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
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
  AssetEditActionItemResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetEditActionItemResponseDtoBuilder();
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


