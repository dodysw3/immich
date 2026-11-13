//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_database_backup_dto.g.dart';

/// AdminConfigDatabaseBackupDto
///
/// Properties:
/// * [cronExpression] - Cron expression
/// * [enabled] - Enabled
/// * [keepLastAmount] - Keep last amount
@BuiltValue()
abstract class AdminConfigDatabaseBackupDto implements Built<AdminConfigDatabaseBackupDto, AdminConfigDatabaseBackupDtoBuilder> {
  /// Cron expression
  @BuiltValueField(wireName: r'cronExpression')
  String get cronExpression;

  /// Enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// Keep last amount
  @BuiltValueField(wireName: r'keepLastAmount')
  int get keepLastAmount;

  AdminConfigDatabaseBackupDto._();

  factory AdminConfigDatabaseBackupDto([void updates(AdminConfigDatabaseBackupDtoBuilder b)]) = _$AdminConfigDatabaseBackupDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigDatabaseBackupDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigDatabaseBackupDto> get serializer => _$AdminConfigDatabaseBackupDtoSerializer();
}

class _$AdminConfigDatabaseBackupDtoSerializer implements PrimitiveSerializer<AdminConfigDatabaseBackupDto> {
  @override
  final Iterable<Type> types = const [AdminConfigDatabaseBackupDto, _$AdminConfigDatabaseBackupDto];

  @override
  final String wireName = r'AdminConfigDatabaseBackupDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigDatabaseBackupDto object, {
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
    yield r'keepLastAmount';
    yield serializers.serialize(
      object.keepLastAmount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigDatabaseBackupDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigDatabaseBackupDtoBuilder result,
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
        case r'keepLastAmount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.keepLastAmount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigDatabaseBackupDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigDatabaseBackupDtoBuilder();
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


