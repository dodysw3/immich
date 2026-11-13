//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'change_password_dto.g.dart';

/// ChangePasswordDto
///
/// Properties:
/// * [invalidateSessions] - Invalidate all other sessions
/// * [newPassword] - New password (min 8 characters)
/// * [password] - Current password
@BuiltValue()
abstract class ChangePasswordDto implements Built<ChangePasswordDto, ChangePasswordDtoBuilder> {
  /// Invalidate all other sessions
  @BuiltValueField(wireName: r'invalidateSessions')
  bool? get invalidateSessions;

  /// New password (min 8 characters)
  @BuiltValueField(wireName: r'newPassword')
  String get newPassword;

  /// Current password
  @BuiltValueField(wireName: r'password')
  String get password;

  ChangePasswordDto._();

  factory ChangePasswordDto([void updates(ChangePasswordDtoBuilder b)]) = _$ChangePasswordDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChangePasswordDtoBuilder b) => b
      ..invalidateSessions = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChangePasswordDto> get serializer => _$ChangePasswordDtoSerializer();
}

class _$ChangePasswordDtoSerializer implements PrimitiveSerializer<ChangePasswordDto> {
  @override
  final Iterable<Type> types = const [ChangePasswordDto, _$ChangePasswordDto];

  @override
  final String wireName = r'ChangePasswordDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChangePasswordDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.invalidateSessions != null) {
      yield r'invalidateSessions';
      yield serializers.serialize(
        object.invalidateSessions,
        specifiedType: const FullType(bool),
      );
    }
    yield r'newPassword';
    yield serializers.serialize(
      object.newPassword,
      specifiedType: const FullType(String),
    );
    yield r'password';
    yield serializers.serialize(
      object.password,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChangePasswordDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChangePasswordDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'invalidateSessions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.invalidateSessions = valueDes;
          break;
        case r'newPassword':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.newPassword = valueDes;
          break;
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.password = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChangePasswordDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChangePasswordDtoBuilder();
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


