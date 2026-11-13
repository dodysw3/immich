//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_storage_template_dto.g.dart';

/// AdminConfigStorageTemplateDto
///
/// Properties:
/// * [enabled] - Enabled
/// * [hashVerificationEnabled] - Hash verification enabled
/// * [template] - Template
@BuiltValue()
abstract class AdminConfigStorageTemplateDto implements Built<AdminConfigStorageTemplateDto, AdminConfigStorageTemplateDtoBuilder> {
  /// Enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// Hash verification enabled
  @BuiltValueField(wireName: r'hashVerificationEnabled')
  bool get hashVerificationEnabled;

  /// Template
  @BuiltValueField(wireName: r'template')
  String get template;

  AdminConfigStorageTemplateDto._();

  factory AdminConfigStorageTemplateDto([void updates(AdminConfigStorageTemplateDtoBuilder b)]) = _$AdminConfigStorageTemplateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigStorageTemplateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigStorageTemplateDto> get serializer => _$AdminConfigStorageTemplateDtoSerializer();
}

class _$AdminConfigStorageTemplateDtoSerializer implements PrimitiveSerializer<AdminConfigStorageTemplateDto> {
  @override
  final Iterable<Type> types = const [AdminConfigStorageTemplateDto, _$AdminConfigStorageTemplateDto];

  @override
  final String wireName = r'AdminConfigStorageTemplateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigStorageTemplateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'hashVerificationEnabled';
    yield serializers.serialize(
      object.hashVerificationEnabled,
      specifiedType: const FullType(bool),
    );
    yield r'template';
    yield serializers.serialize(
      object.template,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigStorageTemplateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigStorageTemplateDtoBuilder result,
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
        case r'hashVerificationEnabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hashVerificationEnabled = valueDes;
          break;
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
  AdminConfigStorageTemplateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigStorageTemplateDtoBuilder();
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


