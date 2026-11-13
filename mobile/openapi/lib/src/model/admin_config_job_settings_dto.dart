//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_job_settings_dto.g.dart';

/// AdminConfigJobSettingsDto
///
/// Properties:
/// * [concurrency] - Concurrency
@BuiltValue()
abstract class AdminConfigJobSettingsDto implements Built<AdminConfigJobSettingsDto, AdminConfigJobSettingsDtoBuilder> {
  /// Concurrency
  @BuiltValueField(wireName: r'concurrency')
  int get concurrency;

  AdminConfigJobSettingsDto._();

  factory AdminConfigJobSettingsDto([void updates(AdminConfigJobSettingsDtoBuilder b)]) = _$AdminConfigJobSettingsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigJobSettingsDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigJobSettingsDto> get serializer => _$AdminConfigJobSettingsDtoSerializer();
}

class _$AdminConfigJobSettingsDtoSerializer implements PrimitiveSerializer<AdminConfigJobSettingsDto> {
  @override
  final Iterable<Type> types = const [AdminConfigJobSettingsDto, _$AdminConfigJobSettingsDto];

  @override
  final String wireName = r'AdminConfigJobSettingsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigJobSettingsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'concurrency';
    yield serializers.serialize(
      object.concurrency,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigJobSettingsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigJobSettingsDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'concurrency':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.concurrency = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigJobSettingsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigJobSettingsDtoBuilder();
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


