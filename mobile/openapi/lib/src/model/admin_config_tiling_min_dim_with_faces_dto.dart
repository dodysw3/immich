//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_tiling_min_dim_with_faces_dto.g.dart';

/// AdminConfigTilingMinDimWithFacesDto
///
/// Properties:
/// * [dim] - Minimum original image dimension to consider tiling
/// * [faces] - Minimum pass-1 face count when original dim threshold is met
@BuiltValue()
abstract class AdminConfigTilingMinDimWithFacesDto implements Built<AdminConfigTilingMinDimWithFacesDto, AdminConfigTilingMinDimWithFacesDtoBuilder> {
  /// Minimum original image dimension to consider tiling
  @BuiltValueField(wireName: r'dim')
  int get dim;

  /// Minimum pass-1 face count when original dim threshold is met
  @BuiltValueField(wireName: r'faces')
  int get faces;

  AdminConfigTilingMinDimWithFacesDto._();

  factory AdminConfigTilingMinDimWithFacesDto([void updates(AdminConfigTilingMinDimWithFacesDtoBuilder b)]) = _$AdminConfigTilingMinDimWithFacesDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigTilingMinDimWithFacesDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigTilingMinDimWithFacesDto> get serializer => _$AdminConfigTilingMinDimWithFacesDtoSerializer();
}

class _$AdminConfigTilingMinDimWithFacesDtoSerializer implements PrimitiveSerializer<AdminConfigTilingMinDimWithFacesDto> {
  @override
  final Iterable<Type> types = const [AdminConfigTilingMinDimWithFacesDto, _$AdminConfigTilingMinDimWithFacesDto];

  @override
  final String wireName = r'AdminConfigTilingMinDimWithFacesDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigTilingMinDimWithFacesDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'dim';
    yield serializers.serialize(
      object.dim,
      specifiedType: const FullType(int),
    );
    yield r'faces';
    yield serializers.serialize(
      object.faces,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigTilingMinDimWithFacesDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigTilingMinDimWithFacesDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'dim':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.dim = valueDes;
          break;
        case r'faces':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.faces = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigTilingMinDimWithFacesDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigTilingMinDimWithFacesDtoBuilder();
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


