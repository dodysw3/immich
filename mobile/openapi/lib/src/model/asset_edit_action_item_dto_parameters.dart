//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/mirror_axis.dart';
import 'package:openapi/src/model/crop_parameters.dart';
import 'package:openapi/src/model/rotate_parameters.dart';
import 'package:openapi/src/model/mirror_parameters.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/any_of.dart';

part 'asset_edit_action_item_dto_parameters.g.dart';

/// List of edit actions to apply (crop, rotate, or mirror)
///
/// Properties:
/// * [height] - Height of the crop
/// * [width] - Width of the crop
/// * [x] - Top-Left X coordinate of crop
/// * [y] - Top-Left Y coordinate of crop
/// * [angle] - Rotation angle in degrees
/// * [axis] 
@BuiltValue()
abstract class AssetEditActionItemDtoParameters implements Built<AssetEditActionItemDtoParameters, AssetEditActionItemDtoParametersBuilder> {
  /// Any Of [CropParameters], [MirrorParameters], [RotateParameters]
  AnyOf get anyOf;

  AssetEditActionItemDtoParameters._();

  factory AssetEditActionItemDtoParameters([void updates(AssetEditActionItemDtoParametersBuilder b)]) = _$AssetEditActionItemDtoParameters;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetEditActionItemDtoParametersBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetEditActionItemDtoParameters> get serializer => _$AssetEditActionItemDtoParametersSerializer();
}

class _$AssetEditActionItemDtoParametersSerializer implements PrimitiveSerializer<AssetEditActionItemDtoParameters> {
  @override
  final Iterable<Type> types = const [AssetEditActionItemDtoParameters, _$AssetEditActionItemDtoParameters];

  @override
  final String wireName = r'AssetEditActionItemDtoParameters';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetEditActionItemDtoParameters object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
  }

  @override
  Object serialize(
    Serializers serializers,
    AssetEditActionItemDtoParameters object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final anyOf = object.anyOf;
    return serializers.serialize(anyOf, specifiedType: FullType(AnyOf, anyOf.types.map((type) => FullType(type)).toList()))!;
  }

  @override
  AssetEditActionItemDtoParameters deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetEditActionItemDtoParametersBuilder();
    Object? anyOfDataSrc;
    final targetType = const FullType(AnyOf, [FullType(CropParameters), FullType(RotateParameters), FullType(MirrorParameters), ]);
    anyOfDataSrc = serialized;
    result.anyOf = serializers.deserialize(anyOfDataSrc, specifiedType: targetType) as AnyOf;
    return result.build();
  }
}


