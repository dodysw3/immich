//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/admin_config_faces_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_metadata_dto.g.dart';

/// AdminConfigMetadataDto
///
/// Properties:
/// * [faces] 
@BuiltValue()
abstract class AdminConfigMetadataDto implements Built<AdminConfigMetadataDto, AdminConfigMetadataDtoBuilder> {
  @BuiltValueField(wireName: r'faces')
  AdminConfigFacesDto get faces;

  AdminConfigMetadataDto._();

  factory AdminConfigMetadataDto([void updates(AdminConfigMetadataDtoBuilder b)]) = _$AdminConfigMetadataDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigMetadataDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigMetadataDto> get serializer => _$AdminConfigMetadataDtoSerializer();
}

class _$AdminConfigMetadataDtoSerializer implements PrimitiveSerializer<AdminConfigMetadataDto> {
  @override
  final Iterable<Type> types = const [AdminConfigMetadataDto, _$AdminConfigMetadataDto];

  @override
  final String wireName = r'AdminConfigMetadataDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigMetadataDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'faces';
    yield serializers.serialize(
      object.faces,
      specifiedType: const FullType(AdminConfigFacesDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigMetadataDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigMetadataDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'faces':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigFacesDto),
          ) as AdminConfigFacesDto;
          result.faces.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigMetadataDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigMetadataDtoBuilder();
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


