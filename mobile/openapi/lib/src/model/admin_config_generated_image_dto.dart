//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/image_format.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_generated_image_dto.g.dart';

/// AdminConfigGeneratedImageDto
///
/// Properties:
/// * [format] 
/// * [progressive] - Progressive
/// * [quality] - Quality
/// * [size] - Size
@BuiltValue()
abstract class AdminConfigGeneratedImageDto implements Built<AdminConfigGeneratedImageDto, AdminConfigGeneratedImageDtoBuilder> {
  @BuiltValueField(wireName: r'format')
  ImageFormat get format;
  // enum formatEnum {  jpeg,  jxl,  webp,  };

  /// Progressive
  @BuiltValueField(wireName: r'progressive')
  bool? get progressive;

  /// Quality
  @BuiltValueField(wireName: r'quality')
  int get quality;

  /// Size
  @BuiltValueField(wireName: r'size')
  int get size;

  AdminConfigGeneratedImageDto._();

  factory AdminConfigGeneratedImageDto([void updates(AdminConfigGeneratedImageDtoBuilder b)]) = _$AdminConfigGeneratedImageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigGeneratedImageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigGeneratedImageDto> get serializer => _$AdminConfigGeneratedImageDtoSerializer();
}

class _$AdminConfigGeneratedImageDtoSerializer implements PrimitiveSerializer<AdminConfigGeneratedImageDto> {
  @override
  final Iterable<Type> types = const [AdminConfigGeneratedImageDto, _$AdminConfigGeneratedImageDto];

  @override
  final String wireName = r'AdminConfigGeneratedImageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigGeneratedImageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'size';
    yield serializers.serialize(
      object.size,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigGeneratedImageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigGeneratedImageDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'size':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.size = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigGeneratedImageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigGeneratedImageDtoBuilder();
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


