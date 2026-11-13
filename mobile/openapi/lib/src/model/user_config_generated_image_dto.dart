//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_config_generated_image_dto.g.dart';

/// UserConfigGeneratedImageDto
///
/// Properties:
/// * [size] - Size
@BuiltValue()
abstract class UserConfigGeneratedImageDto implements Built<UserConfigGeneratedImageDto, UserConfigGeneratedImageDtoBuilder> {
  /// Size
  @BuiltValueField(wireName: r'size')
  int get size;

  UserConfigGeneratedImageDto._();

  factory UserConfigGeneratedImageDto([void updates(UserConfigGeneratedImageDtoBuilder b)]) = _$UserConfigGeneratedImageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserConfigGeneratedImageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserConfigGeneratedImageDto> get serializer => _$UserConfigGeneratedImageDtoSerializer();
}

class _$UserConfigGeneratedImageDtoSerializer implements PrimitiveSerializer<UserConfigGeneratedImageDto> {
  @override
  final Iterable<Type> types = const [UserConfigGeneratedImageDto, _$UserConfigGeneratedImageDto];

  @override
  final String wireName = r'UserConfigGeneratedImageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserConfigGeneratedImageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'size';
    yield serializers.serialize(
      object.size,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserConfigGeneratedImageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserConfigGeneratedImageDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  UserConfigGeneratedImageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserConfigGeneratedImageDtoBuilder();
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


