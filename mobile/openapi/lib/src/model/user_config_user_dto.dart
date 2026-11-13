//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_config_user_dto.g.dart';

/// UserConfigUserDto
///
/// Properties:
/// * [deleteDelay] - Delete delay
@BuiltValue()
abstract class UserConfigUserDto implements Built<UserConfigUserDto, UserConfigUserDtoBuilder> {
  /// Delete delay
  @BuiltValueField(wireName: r'deleteDelay')
  int get deleteDelay;

  UserConfigUserDto._();

  factory UserConfigUserDto([void updates(UserConfigUserDtoBuilder b)]) = _$UserConfigUserDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserConfigUserDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserConfigUserDto> get serializer => _$UserConfigUserDtoSerializer();
}

class _$UserConfigUserDtoSerializer implements PrimitiveSerializer<UserConfigUserDto> {
  @override
  final Iterable<Type> types = const [UserConfigUserDto, _$UserConfigUserDto];

  @override
  final String wireName = r'UserConfigUserDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserConfigUserDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'deleteDelay';
    yield serializers.serialize(
      object.deleteDelay,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserConfigUserDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserConfigUserDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'deleteDelay':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.deleteDelay = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserConfigUserDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserConfigUserDtoBuilder();
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


