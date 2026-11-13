//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_config_map_dto.g.dart';

/// PublicConfigMapDto
///
/// Properties:
/// * [darkStyle] - Dark map style URL
/// * [enabled] - Enabled
/// * [lightStyle] - Light map style URL
@BuiltValue()
abstract class PublicConfigMapDto implements Built<PublicConfigMapDto, PublicConfigMapDtoBuilder> {
  /// Dark map style URL
  @BuiltValueField(wireName: r'darkStyle')
  String get darkStyle;

  /// Enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// Light map style URL
  @BuiltValueField(wireName: r'lightStyle')
  String get lightStyle;

  PublicConfigMapDto._();

  factory PublicConfigMapDto([void updates(PublicConfigMapDtoBuilder b)]) = _$PublicConfigMapDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicConfigMapDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicConfigMapDto> get serializer => _$PublicConfigMapDtoSerializer();
}

class _$PublicConfigMapDtoSerializer implements PrimitiveSerializer<PublicConfigMapDto> {
  @override
  final Iterable<Type> types = const [PublicConfigMapDto, _$PublicConfigMapDto];

  @override
  final String wireName = r'PublicConfigMapDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicConfigMapDto object, {
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
    PublicConfigMapDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicConfigMapDtoBuilder result,
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
  PublicConfigMapDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicConfigMapDtoBuilder();
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


