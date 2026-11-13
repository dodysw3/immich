//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'template_response_dto.g.dart';

/// TemplateResponseDto
///
/// Properties:
/// * [html] - Template HTML content
/// * [name] - Template name
@BuiltValue()
abstract class TemplateResponseDto implements Built<TemplateResponseDto, TemplateResponseDtoBuilder> {
  /// Template HTML content
  @BuiltValueField(wireName: r'html')
  String get html;

  /// Template name
  @BuiltValueField(wireName: r'name')
  String get name;

  TemplateResponseDto._();

  factory TemplateResponseDto([void updates(TemplateResponseDtoBuilder b)]) = _$TemplateResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TemplateResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TemplateResponseDto> get serializer => _$TemplateResponseDtoSerializer();
}

class _$TemplateResponseDtoSerializer implements PrimitiveSerializer<TemplateResponseDto> {
  @override
  final Iterable<Type> types = const [TemplateResponseDto, _$TemplateResponseDto];

  @override
  final String wireName = r'TemplateResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TemplateResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'html';
    yield serializers.serialize(
      object.html,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TemplateResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TemplateResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'html':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.html = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TemplateResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TemplateResponseDtoBuilder();
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


