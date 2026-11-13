//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_faces_dto.g.dart';

/// AdminConfigFacesDto
///
/// Properties:
/// * [import_] - Import
@BuiltValue()
abstract class AdminConfigFacesDto implements Built<AdminConfigFacesDto, AdminConfigFacesDtoBuilder> {
  /// Import
  @BuiltValueField(wireName: r'import')
  bool get import_;

  AdminConfigFacesDto._();

  factory AdminConfigFacesDto([void updates(AdminConfigFacesDtoBuilder b)]) = _$AdminConfigFacesDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigFacesDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigFacesDto> get serializer => _$AdminConfigFacesDtoSerializer();
}

class _$AdminConfigFacesDtoSerializer implements PrimitiveSerializer<AdminConfigFacesDto> {
  @override
  final Iterable<Type> types = const [AdminConfigFacesDto, _$AdminConfigFacesDto];

  @override
  final String wireName = r'AdminConfigFacesDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigFacesDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'import';
    yield serializers.serialize(
      object.import_,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigFacesDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigFacesDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'import':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.import_ = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigFacesDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigFacesDtoBuilder();
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


