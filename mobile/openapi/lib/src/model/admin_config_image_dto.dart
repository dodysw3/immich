//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/admin_config_generated_image_dto.dart';
import 'package:openapi/src/model/colorspace.dart';
import 'package:openapi/src/model/admin_config_generated_fullsize_image_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_image_dto.g.dart';

/// AdminConfigImageDto
///
/// Properties:
/// * [colorspace] 
/// * [extractEmbedded] - Extract embedded
/// * [fullsize] 
/// * [preview] 
/// * [thumbnail] 
@BuiltValue()
abstract class AdminConfigImageDto implements Built<AdminConfigImageDto, AdminConfigImageDtoBuilder> {
  @BuiltValueField(wireName: r'colorspace')
  Colorspace get colorspace;
  // enum colorspaceEnum {  srgb,  p3,  };

  /// Extract embedded
  @BuiltValueField(wireName: r'extractEmbedded')
  bool get extractEmbedded;

  @BuiltValueField(wireName: r'fullsize')
  AdminConfigGeneratedFullsizeImageDto get fullsize;

  @BuiltValueField(wireName: r'preview')
  AdminConfigGeneratedImageDto get preview;

  @BuiltValueField(wireName: r'thumbnail')
  AdminConfigGeneratedImageDto get thumbnail;

  AdminConfigImageDto._();

  factory AdminConfigImageDto([void updates(AdminConfigImageDtoBuilder b)]) = _$AdminConfigImageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigImageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigImageDto> get serializer => _$AdminConfigImageDtoSerializer();
}

class _$AdminConfigImageDtoSerializer implements PrimitiveSerializer<AdminConfigImageDto> {
  @override
  final Iterable<Type> types = const [AdminConfigImageDto, _$AdminConfigImageDto];

  @override
  final String wireName = r'AdminConfigImageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigImageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'colorspace';
    yield serializers.serialize(
      object.colorspace,
      specifiedType: const FullType(Colorspace),
    );
    yield r'extractEmbedded';
    yield serializers.serialize(
      object.extractEmbedded,
      specifiedType: const FullType(bool),
    );
    yield r'fullsize';
    yield serializers.serialize(
      object.fullsize,
      specifiedType: const FullType(AdminConfigGeneratedFullsizeImageDto),
    );
    yield r'preview';
    yield serializers.serialize(
      object.preview,
      specifiedType: const FullType(AdminConfigGeneratedImageDto),
    );
    yield r'thumbnail';
    yield serializers.serialize(
      object.thumbnail,
      specifiedType: const FullType(AdminConfigGeneratedImageDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigImageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigImageDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'colorspace':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Colorspace),
          ) as Colorspace;
          result.colorspace = valueDes;
          break;
        case r'extractEmbedded':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.extractEmbedded = valueDes;
          break;
        case r'fullsize':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigGeneratedFullsizeImageDto),
          ) as AdminConfigGeneratedFullsizeImageDto;
          result.fullsize.replace(valueDes);
          break;
        case r'preview':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigGeneratedImageDto),
          ) as AdminConfigGeneratedImageDto;
          result.preview.replace(valueDes);
          break;
        case r'thumbnail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigGeneratedImageDto),
          ) as AdminConfigGeneratedImageDto;
          result.thumbnail.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigImageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigImageDtoBuilder();
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


