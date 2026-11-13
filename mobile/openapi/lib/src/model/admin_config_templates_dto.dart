//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/admin_config_template_emails_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_templates_dto.g.dart';

/// AdminConfigTemplatesDto
///
/// Properties:
/// * [email] 
@BuiltValue()
abstract class AdminConfigTemplatesDto implements Built<AdminConfigTemplatesDto, AdminConfigTemplatesDtoBuilder> {
  @BuiltValueField(wireName: r'email')
  AdminConfigTemplateEmailsDto get email;

  AdminConfigTemplatesDto._();

  factory AdminConfigTemplatesDto([void updates(AdminConfigTemplatesDtoBuilder b)]) = _$AdminConfigTemplatesDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigTemplatesDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigTemplatesDto> get serializer => _$AdminConfigTemplatesDtoSerializer();
}

class _$AdminConfigTemplatesDtoSerializer implements PrimitiveSerializer<AdminConfigTemplatesDto> {
  @override
  final Iterable<Type> types = const [AdminConfigTemplatesDto, _$AdminConfigTemplatesDto];

  @override
  final String wireName = r'AdminConfigTemplatesDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigTemplatesDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(AdminConfigTemplateEmailsDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigTemplatesDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigTemplatesDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigTemplateEmailsDto),
          ) as AdminConfigTemplateEmailsDto;
          result.email.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigTemplatesDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigTemplatesDtoBuilder();
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


