//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_map_dto.g.dart';

/// AdminConfigMapDto
///
/// Properties:
/// * [darkStyle] - Dark map style URL
/// * [enabled] - Enabled
/// * [lightStyle] - Light map style URL
@BuiltValue()
abstract class AdminConfigMapDto implements Built<AdminConfigMapDto, AdminConfigMapDtoBuilder> {
  /// Dark map style URL
  @BuiltValueField(wireName: r'darkStyle')
  String get darkStyle;

  /// Enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// Light map style URL
  @BuiltValueField(wireName: r'lightStyle')
  String get lightStyle;

  AdminConfigMapDto._();

  factory AdminConfigMapDto([void updates(AdminConfigMapDtoBuilder b)]) = _$AdminConfigMapDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigMapDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigMapDto> get serializer => _$AdminConfigMapDtoSerializer();
}

class _$AdminConfigMapDtoSerializer implements PrimitiveSerializer<AdminConfigMapDto> {
  @override
  final Iterable<Type> types = const [AdminConfigMapDto, _$AdminConfigMapDto];

  @override
  final String wireName = r'AdminConfigMapDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigMapDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'darkStyle';
    yield serializers.serialize(
      object.darkStyle,
      specifiedType: const FullType(String),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'lightStyle';
    yield serializers.serialize(
      object.lightStyle,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigMapDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigMapDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'darkStyle':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.darkStyle = valueDes;
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'lightStyle':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.lightStyle = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigMapDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigMapDtoBuilder();
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


