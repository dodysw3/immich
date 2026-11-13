//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user_config_generated_image_dto.dart';
import 'package:openapi/src/model/user_config_generated_fullsize_image_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_config_image_dto.g.dart';

/// UserConfigImageDto
///
/// Properties:
/// * [fullsize] 
/// * [preview] 
/// * [thumbnail] 
@BuiltValue()
abstract class UserConfigImageDto implements Built<UserConfigImageDto, UserConfigImageDtoBuilder> {
  @BuiltValueField(wireName: r'fullsize')
  UserConfigGeneratedFullsizeImageDto get fullsize;

  @BuiltValueField(wireName: r'preview')
  UserConfigGeneratedImageDto get preview;

  @BuiltValueField(wireName: r'thumbnail')
  UserConfigGeneratedImageDto get thumbnail;

  UserConfigImageDto._();

  factory UserConfigImageDto([void updates(UserConfigImageDtoBuilder b)]) = _$UserConfigImageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserConfigImageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserConfigImageDto> get serializer => _$UserConfigImageDtoSerializer();
}

class _$UserConfigImageDtoSerializer implements PrimitiveSerializer<UserConfigImageDto> {
  @override
  final Iterable<Type> types = const [UserConfigImageDto, _$UserConfigImageDto];

  @override
  final String wireName = r'UserConfigImageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserConfigImageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fullsize';
    yield serializers.serialize(
      object.fullsize,
      specifiedType: const FullType(UserConfigGeneratedFullsizeImageDto),
    );
    yield r'preview';
    yield serializers.serialize(
      object.preview,
      specifiedType: const FullType(UserConfigGeneratedImageDto),
    );
    yield r'thumbnail';
    yield serializers.serialize(
      object.thumbnail,
      specifiedType: const FullType(UserConfigGeneratedImageDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserConfigImageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserConfigImageDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fullsize':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserConfigGeneratedFullsizeImageDto),
          ) as UserConfigGeneratedFullsizeImageDto;
          result.fullsize.replace(valueDes);
          break;
        case r'preview':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserConfigGeneratedImageDto),
          ) as UserConfigGeneratedImageDto;
          result.preview.replace(valueDes);
          break;
        case r'thumbnail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserConfigGeneratedImageDto),
          ) as UserConfigGeneratedImageDto;
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
  UserConfigImageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserConfigImageDtoBuilder();
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


