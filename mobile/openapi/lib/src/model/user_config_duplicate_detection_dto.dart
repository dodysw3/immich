//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_config_duplicate_detection_dto.g.dart';

/// UserConfigDuplicateDetectionDto
///
/// Properties:
/// * [enabled] - Whether the task is enabled
@BuiltValue()
abstract class UserConfigDuplicateDetectionDto implements Built<UserConfigDuplicateDetectionDto, UserConfigDuplicateDetectionDtoBuilder> {
  /// Whether the task is enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  UserConfigDuplicateDetectionDto._();

  factory UserConfigDuplicateDetectionDto([void updates(UserConfigDuplicateDetectionDtoBuilder b)]) = _$UserConfigDuplicateDetectionDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserConfigDuplicateDetectionDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserConfigDuplicateDetectionDto> get serializer => _$UserConfigDuplicateDetectionDtoSerializer();
}

class _$UserConfigDuplicateDetectionDtoSerializer implements PrimitiveSerializer<UserConfigDuplicateDetectionDto> {
  @override
  final Iterable<Type> types = const [UserConfigDuplicateDetectionDto, _$UserConfigDuplicateDetectionDto];

  @override
  final String wireName = r'UserConfigDuplicateDetectionDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserConfigDuplicateDetectionDto object, {
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
    UserConfigDuplicateDetectionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserConfigDuplicateDetectionDtoBuilder result,
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
  UserConfigDuplicateDetectionDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserConfigDuplicateDetectionDtoBuilder();
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


