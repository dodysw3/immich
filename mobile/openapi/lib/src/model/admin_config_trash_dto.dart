//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_trash_dto.g.dart';

/// AdminConfigTrashDto
///
/// Properties:
/// * [days] - Days
/// * [enabled] - Enabled
@BuiltValue()
abstract class AdminConfigTrashDto implements Built<AdminConfigTrashDto, AdminConfigTrashDtoBuilder> {
  /// Days
  @BuiltValueField(wireName: r'days')
  int get days;

  /// Enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  AdminConfigTrashDto._();

  factory AdminConfigTrashDto([void updates(AdminConfigTrashDtoBuilder b)]) = _$AdminConfigTrashDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigTrashDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigTrashDto> get serializer => _$AdminConfigTrashDtoSerializer();
}

class _$AdminConfigTrashDtoSerializer implements PrimitiveSerializer<AdminConfigTrashDto> {
  @override
  final Iterable<Type> types = const [AdminConfigTrashDto, _$AdminConfigTrashDto];

  @override
  final String wireName = r'AdminConfigTrashDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigTrashDto object, {
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
    AdminConfigTrashDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigTrashDtoBuilder result,
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
  AdminConfigTrashDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigTrashDtoBuilder();
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


