//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_theme_dto.g.dart';

/// AdminConfigThemeDto
///
/// Properties:
/// * [customCss] - Custom CSS for theming
@BuiltValue()
abstract class AdminConfigThemeDto implements Built<AdminConfigThemeDto, AdminConfigThemeDtoBuilder> {
  /// Custom CSS for theming
  @BuiltValueField(wireName: r'customCss')
  String get customCss;

  AdminConfigThemeDto._();

  factory AdminConfigThemeDto([void updates(AdminConfigThemeDtoBuilder b)]) = _$AdminConfigThemeDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigThemeDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigThemeDto> get serializer => _$AdminConfigThemeDtoSerializer();
}

class _$AdminConfigThemeDtoSerializer implements PrimitiveSerializer<AdminConfigThemeDto> {
  @override
  final Iterable<Type> types = const [AdminConfigThemeDto, _$AdminConfigThemeDto];

  @override
  final String wireName = r'AdminConfigThemeDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigThemeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'customCss';
    yield serializers.serialize(
      object.customCss,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigThemeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigThemeDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'customCss':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.customCss = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigThemeDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigThemeDtoBuilder();
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


