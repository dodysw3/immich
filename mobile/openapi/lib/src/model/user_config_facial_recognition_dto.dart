//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_config_facial_recognition_dto.g.dart';

/// UserConfigFacialRecognitionDto
///
/// Properties:
/// * [enabled] - Whether the task is enabled
/// * [minFaces] - Minimum number of faces required for recognition
@BuiltValue()
abstract class UserConfigFacialRecognitionDto implements Built<UserConfigFacialRecognitionDto, UserConfigFacialRecognitionDtoBuilder> {
  /// Whether the task is enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// Minimum number of faces required for recognition
  @BuiltValueField(wireName: r'minFaces')
  int get minFaces;

  UserConfigFacialRecognitionDto._();

  factory UserConfigFacialRecognitionDto([void updates(UserConfigFacialRecognitionDtoBuilder b)]) = _$UserConfigFacialRecognitionDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserConfigFacialRecognitionDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserConfigFacialRecognitionDto> get serializer => _$UserConfigFacialRecognitionDtoSerializer();
}

class _$UserConfigFacialRecognitionDtoSerializer implements PrimitiveSerializer<UserConfigFacialRecognitionDto> {
  @override
  final Iterable<Type> types = const [UserConfigFacialRecognitionDto, _$UserConfigFacialRecognitionDto];

  @override
  final String wireName = r'UserConfigFacialRecognitionDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserConfigFacialRecognitionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'minFaces';
    yield serializers.serialize(
      object.minFaces,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserConfigFacialRecognitionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserConfigFacialRecognitionDtoBuilder result,
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
        case r'minFaces':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.minFaces = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserConfigFacialRecognitionDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserConfigFacialRecognitionDtoBuilder();
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


