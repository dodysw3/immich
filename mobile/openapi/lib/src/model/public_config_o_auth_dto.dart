//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_config_o_auth_dto.g.dart';

/// PublicConfigOAuthDto
///
/// Properties:
/// * [autoLaunch] - Auto launch
/// * [buttonText] - Button text
/// * [enabled] - Enabled
@BuiltValue()
abstract class PublicConfigOAuthDto implements Built<PublicConfigOAuthDto, PublicConfigOAuthDtoBuilder> {
  /// Auto launch
  @BuiltValueField(wireName: r'autoLaunch')
  bool get autoLaunch;

  /// Button text
  @BuiltValueField(wireName: r'buttonText')
  String get buttonText;

  /// Enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  PublicConfigOAuthDto._();

  factory PublicConfigOAuthDto([void updates(PublicConfigOAuthDtoBuilder b)]) = _$PublicConfigOAuthDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicConfigOAuthDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicConfigOAuthDto> get serializer => _$PublicConfigOAuthDtoSerializer();
}

class _$PublicConfigOAuthDtoSerializer implements PrimitiveSerializer<PublicConfigOAuthDto> {
  @override
  final Iterable<Type> types = const [PublicConfigOAuthDto, _$PublicConfigOAuthDto];

  @override
  final String wireName = r'PublicConfigOAuthDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicConfigOAuthDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    PublicConfigOAuthDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicConfigOAuthDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  PublicConfigOAuthDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicConfigOAuthDtoBuilder();
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


