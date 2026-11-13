//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'template_dto.g.dart';

/// TemplateDto
///
/// Properties:
/// * [template] - Template name
@BuiltValue()
abstract class TemplateDto implements Built<TemplateDto, TemplateDtoBuilder> {
  /// Template name
  @BuiltValueField(wireName: r'template')
  String get template;

  TemplateDto._();

  factory TemplateDto([void updates(TemplateDtoBuilder b)]) = _$TemplateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TemplateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TemplateDto> get serializer => _$TemplateDtoSerializer();
}

class _$TemplateDtoSerializer implements PrimitiveSerializer<TemplateDto> {
  @override
  final Iterable<Type> types = const [TemplateDto, _$TemplateDto];

  @override
  final String wireName = r'TemplateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TemplateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'template';
    yield serializers.serialize(
      object.template,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TemplateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TemplateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'template':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.template = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TemplateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TemplateDtoBuilder();
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


