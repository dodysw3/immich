//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_config_o_auth_dto.g.dart';

/// UserConfigOAuthDto
///
/// Properties:
/// * [accountManagementUrl] - Account management URL
/// * [autoLaunch] - Auto launch
/// * [buttonText] - Button text
/// * [enabled] - Enabled
@BuiltValue()
abstract class UserConfigOAuthDto implements Built<UserConfigOAuthDto, UserConfigOAuthDtoBuilder> {
  /// Account management URL
  @BuiltValueField(wireName: r'accountManagementUrl')
  String? get accountManagementUrl;

  /// Auto launch
  @BuiltValueField(wireName: r'autoLaunch')
  bool get autoLaunch;

  /// Button text
  @BuiltValueField(wireName: r'buttonText')
  String get buttonText;

  /// Enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  UserConfigOAuthDto._();

  factory UserConfigOAuthDto([void updates(UserConfigOAuthDtoBuilder b)]) = _$UserConfigOAuthDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserConfigOAuthDtoBuilder b) => b
      ..accountManagementUrl = '';

  @BuiltValueSerializer(custom: true)
  static Serializer<UserConfigOAuthDto> get serializer => _$UserConfigOAuthDtoSerializer();
}

class _$UserConfigOAuthDtoSerializer implements PrimitiveSerializer<UserConfigOAuthDto> {
  @override
  final Iterable<Type> types = const [UserConfigOAuthDto, _$UserConfigOAuthDto];

  @override
  final String wireName = r'UserConfigOAuthDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserConfigOAuthDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.accountManagementUrl != null) {
      yield r'accountManagementUrl';
      yield serializers.serialize(
        object.accountManagementUrl,
        specifiedType: const FullType(String),
      );
    }
    yield r'autoLaunch';
    yield serializers.serialize(
      object.autoLaunch,
      specifiedType: const FullType(bool),
    );
    yield r'buttonText';
    yield serializers.serialize(
      object.buttonText,
      specifiedType: const FullType(String),
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
    UserConfigOAuthDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserConfigOAuthDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accountManagementUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.accountManagementUrl = valueDes;
          break;
        case r'autoLaunch':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.autoLaunch = valueDes;
          break;
        case r'buttonText':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.buttonText = valueDes;
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
  UserConfigOAuthDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserConfigOAuthDtoBuilder();
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


