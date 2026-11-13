//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/admin_config_database_backup_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_backups_dto.g.dart';

/// AdminConfigBackupsDto
///
/// Properties:
/// * [beta] - Whether the backups feature is enabled
/// * [database] 
@BuiltValue()
abstract class AdminConfigBackupsDto implements Built<AdminConfigBackupsDto, AdminConfigBackupsDtoBuilder> {
  /// Whether the backups feature is enabled
  @BuiltValueField(wireName: r'beta')
  bool? get beta;

  @BuiltValueField(wireName: r'database')
  AdminConfigDatabaseBackupDto get database;

  AdminConfigBackupsDto._();

  factory AdminConfigBackupsDto([void updates(AdminConfigBackupsDtoBuilder b)]) = _$AdminConfigBackupsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigBackupsDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigBackupsDto> get serializer => _$AdminConfigBackupsDtoSerializer();
}

class _$AdminConfigBackupsDtoSerializer implements PrimitiveSerializer<AdminConfigBackupsDto> {
  @override
  final Iterable<Type> types = const [AdminConfigBackupsDto, _$AdminConfigBackupsDto];

  @override
  final String wireName = r'AdminConfigBackupsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigBackupsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.beta != null) {
      yield r'beta';
      yield serializers.serialize(
        object.beta,
        specifiedType: const FullType(bool),
      );
    }
    yield r'database';
    yield serializers.serialize(
      object.database,
      specifiedType: const FullType(AdminConfigDatabaseBackupDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigBackupsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigBackupsDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'beta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.beta = valueDes;
          break;
        case r'database':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigDatabaseBackupDto),
          ) as AdminConfigDatabaseBackupDto;
          result.database.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigBackupsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigBackupsDtoBuilder();
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


