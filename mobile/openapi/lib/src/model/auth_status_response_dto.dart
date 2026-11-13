//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth_status_response_dto.g.dart';

/// AuthStatusResponseDto
///
/// Properties:
/// * [expiresAt] - Session expiration date
/// * [isElevated] - Is elevated session
/// * [password] - Has password set
/// * [pinCode] - Has PIN code set
/// * [pinExpiresAt] - PIN expiration date
@BuiltValue()
abstract class AuthStatusResponseDto implements Built<AuthStatusResponseDto, AuthStatusResponseDtoBuilder> {
  /// Session expiration date
  @BuiltValueField(wireName: r'expiresAt')
  String? get expiresAt;

  /// Is elevated session
  @BuiltValueField(wireName: r'isElevated')
  bool get isElevated;

  /// Has password set
  @BuiltValueField(wireName: r'password')
  bool get password;

  /// Has PIN code set
  @BuiltValueField(wireName: r'pinCode')
  bool get pinCode;

  /// PIN expiration date
  @BuiltValueField(wireName: r'pinExpiresAt')
  String? get pinExpiresAt;

  AuthStatusResponseDto._();

  factory AuthStatusResponseDto([void updates(AuthStatusResponseDtoBuilder b)]) = _$AuthStatusResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuthStatusResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuthStatusResponseDto> get serializer => _$AuthStatusResponseDtoSerializer();
}

class _$AuthStatusResponseDtoSerializer implements PrimitiveSerializer<AuthStatusResponseDto> {
  @override
  final Iterable<Type> types = const [AuthStatusResponseDto, _$AuthStatusResponseDto];

  @override
  final String wireName = r'AuthStatusResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuthStatusResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.expiresAt != null) {
      yield r'expiresAt';
      yield serializers.serialize(
        object.expiresAt,
        specifiedType: const FullType(String),
      );
    }
    yield r'isElevated';
    yield serializers.serialize(
      object.isElevated,
      specifiedType: const FullType(bool),
    );
    yield r'password';
    yield serializers.serialize(
      object.password,
      specifiedType: const FullType(bool),
    );
    yield r'pinCode';
    yield serializers.serialize(
      object.pinCode,
      specifiedType: const FullType(bool),
    );
    if (object.pinExpiresAt != null) {
      yield r'pinExpiresAt';
      yield serializers.serialize(
        object.pinExpiresAt,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AuthStatusResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AuthStatusResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.expiresAt = valueDes;
          break;
        case r'isElevated':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isElevated = valueDes;
          break;
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.password = valueDes;
          break;
        case r'pinCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.pinCode = valueDes;
          break;
        case r'pinExpiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.pinExpiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AuthStatusResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuthStatusResponseDtoBuilder();
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


