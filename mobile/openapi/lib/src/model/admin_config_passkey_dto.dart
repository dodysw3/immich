//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_passkey_dto.g.dart';

/// AdminConfigPasskeyDto
///
/// Properties:
/// * [additionalDomains] - Additional domains
/// * [domain] - Passkey domain
/// * [enabled] - Enabled
@BuiltValue()
abstract class AdminConfigPasskeyDto implements Built<AdminConfigPasskeyDto, AdminConfigPasskeyDtoBuilder> {
  /// Additional domains
  @BuiltValueField(wireName: r'additionalDomains')
  BuiltList<String> get additionalDomains;

  /// Passkey domain
  @BuiltValueField(wireName: r'domain')
  String? get domain;

  /// Enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  AdminConfigPasskeyDto._();

  factory AdminConfigPasskeyDto([void updates(AdminConfigPasskeyDtoBuilder b)]) = _$AdminConfigPasskeyDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigPasskeyDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigPasskeyDto> get serializer => _$AdminConfigPasskeyDtoSerializer();
}

class _$AdminConfigPasskeyDtoSerializer implements PrimitiveSerializer<AdminConfigPasskeyDto> {
  @override
  final Iterable<Type> types = const [AdminConfigPasskeyDto, _$AdminConfigPasskeyDto];

  @override
  final String wireName = r'AdminConfigPasskeyDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigPasskeyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'additionalDomains';
    yield serializers.serialize(
      object.additionalDomains,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'domain';
    yield object.domain == null ? null : serializers.serialize(
      object.domain,
      specifiedType: const FullType.nullable(String),
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
    AdminConfigPasskeyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigPasskeyDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'additionalDomains':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.additionalDomains.replace(valueDes);
          break;
        case r'domain':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.domain = valueDes;
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
  AdminConfigPasskeyDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigPasskeyDtoBuilder();
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


