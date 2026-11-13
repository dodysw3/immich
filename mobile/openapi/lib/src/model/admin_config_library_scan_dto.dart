//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_library_scan_dto.g.dart';

/// AdminConfigLibraryScanDto
///
/// Properties:
/// * [cronExpression] - Cron expression
/// * [enabled] - Enabled
@BuiltValue()
abstract class AdminConfigLibraryScanDto implements Built<AdminConfigLibraryScanDto, AdminConfigLibraryScanDtoBuilder> {
  /// Cron expression
  @BuiltValueField(wireName: r'cronExpression')
  String get cronExpression;

  /// Enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  AdminConfigLibraryScanDto._();

  factory AdminConfigLibraryScanDto([void updates(AdminConfigLibraryScanDtoBuilder b)]) = _$AdminConfigLibraryScanDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigLibraryScanDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigLibraryScanDto> get serializer => _$AdminConfigLibraryScanDtoSerializer();
}

class _$AdminConfigLibraryScanDtoSerializer implements PrimitiveSerializer<AdminConfigLibraryScanDto> {
  @override
  final Iterable<Type> types = const [AdminConfigLibraryScanDto, _$AdminConfigLibraryScanDto];

  @override
  final String wireName = r'AdminConfigLibraryScanDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigLibraryScanDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cronExpression';
    yield serializers.serialize(
      object.cronExpression,
      specifiedType: const FullType(String),
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
    AdminConfigLibraryScanDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigLibraryScanDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cronExpression':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.cronExpression = valueDes;
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
  AdminConfigLibraryScanDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigLibraryScanDtoBuilder();
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


