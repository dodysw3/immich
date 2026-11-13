//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_config_trash_dto.g.dart';

/// UserConfigTrashDto
///
/// Properties:
/// * [days] - Days
/// * [enabled] - Enabled
@BuiltValue()
abstract class UserConfigTrashDto implements Built<UserConfigTrashDto, UserConfigTrashDtoBuilder> {
  /// Days
  @BuiltValueField(wireName: r'days')
  int get days;

  /// Enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  UserConfigTrashDto._();

  factory UserConfigTrashDto([void updates(UserConfigTrashDtoBuilder b)]) = _$UserConfigTrashDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserConfigTrashDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserConfigTrashDto> get serializer => _$UserConfigTrashDtoSerializer();
}

class _$UserConfigTrashDtoSerializer implements PrimitiveSerializer<UserConfigTrashDto> {
  @override
  final Iterable<Type> types = const [UserConfigTrashDto, _$UserConfigTrashDto];

  @override
  final String wireName = r'UserConfigTrashDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserConfigTrashDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'days';
    yield serializers.serialize(
      object.days,
      specifiedType: const FullType(int),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserConfigTrashDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserConfigTrashDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.days = valueDes;
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserConfigTrashDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserConfigTrashDtoBuilder();
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


