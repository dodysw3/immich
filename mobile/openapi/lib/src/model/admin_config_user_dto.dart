//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_user_dto.g.dart';

/// AdminConfigUserDto
///
/// Properties:
/// * [deleteDelay] - Delete delay
@BuiltValue()
abstract class AdminConfigUserDto implements Built<AdminConfigUserDto, AdminConfigUserDtoBuilder> {
  /// Delete delay
  @BuiltValueField(wireName: r'deleteDelay')
  int get deleteDelay;

  AdminConfigUserDto._();

  factory AdminConfigUserDto([void updates(AdminConfigUserDtoBuilder b)]) = _$AdminConfigUserDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigUserDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigUserDto> get serializer => _$AdminConfigUserDtoSerializer();
}

class _$AdminConfigUserDtoSerializer implements PrimitiveSerializer<AdminConfigUserDto> {
  @override
  final Iterable<Type> types = const [AdminConfigUserDto, _$AdminConfigUserDto];

  @override
  final String wireName = r'AdminConfigUserDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigUserDto object, {
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
    AdminConfigUserDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigUserDtoBuilder result,
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
  AdminConfigUserDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigUserDtoBuilder();
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


