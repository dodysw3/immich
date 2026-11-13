//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_template_emails_dto.g.dart';

/// AdminConfigTemplateEmailsDto
///
/// Properties:
/// * [albumInviteTemplate] - Album invite template
/// * [albumUpdateTemplate] - Album update template
/// * [welcomeTemplate] - Welcome template
@BuiltValue()
abstract class AdminConfigTemplateEmailsDto implements Built<AdminConfigTemplateEmailsDto, AdminConfigTemplateEmailsDtoBuilder> {
  /// Album invite template
  @BuiltValueField(wireName: r'albumInviteTemplate')
  String get albumInviteTemplate;

  /// Album update template
  @BuiltValueField(wireName: r'albumUpdateTemplate')
  String get albumUpdateTemplate;

  /// Welcome template
  @BuiltValueField(wireName: r'welcomeTemplate')
  String get welcomeTemplate;

  AdminConfigTemplateEmailsDto._();

  factory AdminConfigTemplateEmailsDto([void updates(AdminConfigTemplateEmailsDtoBuilder b)]) = _$AdminConfigTemplateEmailsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigTemplateEmailsDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigTemplateEmailsDto> get serializer => _$AdminConfigTemplateEmailsDtoSerializer();
}

class _$AdminConfigTemplateEmailsDtoSerializer implements PrimitiveSerializer<AdminConfigTemplateEmailsDto> {
  @override
  final Iterable<Type> types = const [AdminConfigTemplateEmailsDto, _$AdminConfigTemplateEmailsDto];

  @override
  final String wireName = r'AdminConfigTemplateEmailsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigTemplateEmailsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'albumInviteTemplate';
    yield serializers.serialize(
      object.albumInviteTemplate,
      specifiedType: const FullType(String),
    );
    yield r'albumUpdateTemplate';
    yield serializers.serialize(
      object.albumUpdateTemplate,
      specifiedType: const FullType(String),
    );
    yield r'welcomeTemplate';
    yield serializers.serialize(
      object.welcomeTemplate,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigTemplateEmailsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigTemplateEmailsDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'albumInviteTemplate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.albumInviteTemplate = valueDes;
          break;
        case r'albumUpdateTemplate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.albumUpdateTemplate = valueDes;
          break;
        case r'welcomeTemplate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.welcomeTemplate = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigTemplateEmailsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigTemplateEmailsDtoBuilder();
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


