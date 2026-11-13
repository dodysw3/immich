//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_password_login_dto.g.dart';

/// AdminConfigPasswordLoginDto
///
/// Properties:
/// * [enabled] - Enabled
@BuiltValue()
abstract class AdminConfigPasswordLoginDto implements Built<AdminConfigPasswordLoginDto, AdminConfigPasswordLoginDtoBuilder> {
  /// Enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  AdminConfigPasswordLoginDto._();

  factory AdminConfigPasswordLoginDto([void updates(AdminConfigPasswordLoginDtoBuilder b)]) = _$AdminConfigPasswordLoginDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigPasswordLoginDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigPasswordLoginDto> get serializer => _$AdminConfigPasswordLoginDtoSerializer();
}

class _$AdminConfigPasswordLoginDtoSerializer implements PrimitiveSerializer<AdminConfigPasswordLoginDto> {
  @override
  final Iterable<Type> types = const [AdminConfigPasswordLoginDto, _$AdminConfigPasswordLoginDto];

  @override
  final String wireName = r'AdminConfigPasswordLoginDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigPasswordLoginDto object, {
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
    AdminConfigPasswordLoginDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigPasswordLoginDtoBuilder result,
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
  AdminConfigPasswordLoginDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigPasswordLoginDtoBuilder();
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


