//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/admin_config_tiling_min_dim_with_faces_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_tiling_triggers_dto.g.dart';

/// AdminConfigTilingTriggersDto
///
/// Properties:
/// * [minDimWithFaces] 
/// * [minPass1Faces] - Minimum pass-1 face count to trigger tiling
@BuiltValue()
abstract class AdminConfigTilingTriggersDto implements Built<AdminConfigTilingTriggersDto, AdminConfigTilingTriggersDtoBuilder> {
  @BuiltValueField(wireName: r'minDimWithFaces')
  AdminConfigTilingMinDimWithFacesDto get minDimWithFaces;

  /// Minimum pass-1 face count to trigger tiling
  @BuiltValueField(wireName: r'minPass1Faces')
  int get minPass1Faces;

  AdminConfigTilingTriggersDto._();

  factory AdminConfigTilingTriggersDto([void updates(AdminConfigTilingTriggersDtoBuilder b)]) = _$AdminConfigTilingTriggersDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigTilingTriggersDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigTilingTriggersDto> get serializer => _$AdminConfigTilingTriggersDtoSerializer();
}

class _$AdminConfigTilingTriggersDtoSerializer implements PrimitiveSerializer<AdminConfigTilingTriggersDto> {
  @override
  final Iterable<Type> types = const [AdminConfigTilingTriggersDto, _$AdminConfigTilingTriggersDto];

  @override
  final String wireName = r'AdminConfigTilingTriggersDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigTilingTriggersDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'minDimWithFaces';
    yield serializers.serialize(
      object.minDimWithFaces,
      specifiedType: const FullType(AdminConfigTilingMinDimWithFacesDto),
    );
    yield r'minPass1Faces';
    yield serializers.serialize(
      object.minPass1Faces,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigTilingTriggersDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigTilingTriggersDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'minDimWithFaces':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigTilingMinDimWithFacesDto),
          ) as AdminConfigTilingMinDimWithFacesDto;
          result.minDimWithFaces.replace(valueDes);
          break;
        case r'minPass1Faces':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.minPass1Faces = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigTilingTriggersDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigTilingTriggersDtoBuilder();
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


