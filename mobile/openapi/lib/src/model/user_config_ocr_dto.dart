//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_config_ocr_dto.g.dart';

/// UserConfigOcrDto
///
/// Properties:
/// * [enabled] - Whether the task is enabled
@BuiltValue()
abstract class UserConfigOcrDto implements Built<UserConfigOcrDto, UserConfigOcrDtoBuilder> {
  /// Whether the task is enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  UserConfigOcrDto._();

  factory UserConfigOcrDto([void updates(UserConfigOcrDtoBuilder b)]) = _$UserConfigOcrDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserConfigOcrDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserConfigOcrDto> get serializer => _$UserConfigOcrDtoSerializer();
}

class _$UserConfigOcrDtoSerializer implements PrimitiveSerializer<UserConfigOcrDto> {
  @override
  final Iterable<Type> types = const [UserConfigOcrDto, _$UserConfigOcrDto];

  @override
  final String wireName = r'UserConfigOcrDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserConfigOcrDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserConfigOcrDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserConfigOcrDtoBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserConfigOcrDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserConfigOcrDtoBuilder();
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


