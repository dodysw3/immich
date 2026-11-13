//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/image_format.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_generated_fullsize_image_dto.g.dart';

/// AdminConfigGeneratedFullsizeImageDto
///
/// Properties:
/// * [enabled] - Enabled
/// * [format] 
/// * [progressive] - Progressive
/// * [quality] - Quality
@BuiltValue()
abstract class AdminConfigGeneratedFullsizeImageDto implements Built<AdminConfigGeneratedFullsizeImageDto, AdminConfigGeneratedFullsizeImageDtoBuilder> {
  /// Enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'format')
  ImageFormat get format;
  // enum formatEnum {  jpeg,  jxl,  webp,  };

  /// Progressive
  @BuiltValueField(wireName: r'progressive')
  bool? get progressive;

  /// Quality
  @BuiltValueField(wireName: r'quality')
  int get quality;

  AdminConfigGeneratedFullsizeImageDto._();

  factory AdminConfigGeneratedFullsizeImageDto([void updates(AdminConfigGeneratedFullsizeImageDtoBuilder b)]) = _$AdminConfigGeneratedFullsizeImageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigGeneratedFullsizeImageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigGeneratedFullsizeImageDto> get serializer => _$AdminConfigGeneratedFullsizeImageDtoSerializer();
}

class _$AdminConfigGeneratedFullsizeImageDtoSerializer implements PrimitiveSerializer<AdminConfigGeneratedFullsizeImageDto> {
  @override
  final Iterable<Type> types = const [AdminConfigGeneratedFullsizeImageDto, _$AdminConfigGeneratedFullsizeImageDto];

  @override
  final String wireName = r'AdminConfigGeneratedFullsizeImageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigGeneratedFullsizeImageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'format';
    yield serializers.serialize(
      object.format,
      specifiedType: const FullType(ImageFormat),
    );
    if (object.progressive != null) {
      yield r'progressive';
      yield serializers.serialize(
        object.progressive,
        specifiedType: const FullType(bool),
      );
    }
    yield r'quality';
    yield serializers.serialize(
      object.quality,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigGeneratedFullsizeImageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigGeneratedFullsizeImageDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'format':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ImageFormat),
          ) as ImageFormat;
          result.format = valueDes;
          break;
        case r'progressive':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.progressive = valueDes;
          break;
        case r'quality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.quality = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigGeneratedFullsizeImageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigGeneratedFullsizeImageDtoBuilder();
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


