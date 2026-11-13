//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/log_level.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_logging_dto.g.dart';

/// AdminConfigLoggingDto
///
/// Properties:
/// * [enabled] - Enabled
/// * [level] 
@BuiltValue()
abstract class AdminConfigLoggingDto implements Built<AdminConfigLoggingDto, AdminConfigLoggingDtoBuilder> {
  /// Enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'level')
  LogLevel get level;
  // enum levelEnum {  verbose,  debug,  log,  warn,  error,  fatal,  };

  AdminConfigLoggingDto._();

  factory AdminConfigLoggingDto([void updates(AdminConfigLoggingDtoBuilder b)]) = _$AdminConfigLoggingDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigLoggingDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigLoggingDto> get serializer => _$AdminConfigLoggingDtoSerializer();
}

class _$AdminConfigLoggingDtoSerializer implements PrimitiveSerializer<AdminConfigLoggingDto> {
  @override
  final Iterable<Type> types = const [AdminConfigLoggingDto, _$AdminConfigLoggingDto];

  @override
  final String wireName = r'AdminConfigLoggingDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigLoggingDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'level';
    yield serializers.serialize(
      object.level,
      specifiedType: const FullType(LogLevel),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigLoggingDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigLoggingDtoBuilder result,
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
        case r'level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LogLevel),
          ) as LogLevel;
          result.level = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigLoggingDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigLoggingDtoBuilder();
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


