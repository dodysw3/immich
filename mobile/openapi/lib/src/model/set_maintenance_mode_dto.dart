//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/maintenance_action.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'set_maintenance_mode_dto.g.dart';

/// SetMaintenanceModeDto
///
/// Properties:
/// * [action] 
/// * [restoreBackupFilename] - Restore backup filename
/// * [rollbackRepositoryId] - Rollback repository ID
/// * [rollbackSnapshotId] - Rollback snapshot ID
@BuiltValue()
abstract class SetMaintenanceModeDto implements Built<SetMaintenanceModeDto, SetMaintenanceModeDtoBuilder> {
  @BuiltValueField(wireName: r'action')
  MaintenanceAction get action;
  // enum actionEnum {  start,  end,  select_database_restore,  restore_database,  rollback,  };

  /// Restore backup filename
  @BuiltValueField(wireName: r'restoreBackupFilename')
  String? get restoreBackupFilename;

  /// Rollback repository ID
  @BuiltValueField(wireName: r'rollbackRepositoryId')
  String? get rollbackRepositoryId;

  /// Rollback snapshot ID
  @BuiltValueField(wireName: r'rollbackSnapshotId')
  String? get rollbackSnapshotId;

  SetMaintenanceModeDto._();

  factory SetMaintenanceModeDto([void updates(SetMaintenanceModeDtoBuilder b)]) = _$SetMaintenanceModeDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SetMaintenanceModeDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SetMaintenanceModeDto> get serializer => _$SetMaintenanceModeDtoSerializer();
}

class _$SetMaintenanceModeDtoSerializer implements PrimitiveSerializer<SetMaintenanceModeDto> {
  @override
  final Iterable<Type> types = const [SetMaintenanceModeDto, _$SetMaintenanceModeDto];

  @override
  final String wireName = r'SetMaintenanceModeDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SetMaintenanceModeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(MaintenanceAction),
    );
    if (object.restoreBackupFilename != null) {
      yield r'restoreBackupFilename';
      yield serializers.serialize(
        object.restoreBackupFilename,
        specifiedType: const FullType(String),
      );
    }
    if (object.rollbackRepositoryId != null) {
      yield r'rollbackRepositoryId';
      yield serializers.serialize(
        object.rollbackRepositoryId,
        specifiedType: const FullType(String),
      );
    }
    if (object.rollbackSnapshotId != null) {
      yield r'rollbackSnapshotId';
      yield serializers.serialize(
        object.rollbackSnapshotId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SetMaintenanceModeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SetMaintenanceModeDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MaintenanceAction),
          ) as MaintenanceAction;
          result.action = valueDes;
          break;
        case r'restoreBackupFilename':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.restoreBackupFilename = valueDes;
          break;
        case r'rollbackRepositoryId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.rollbackRepositoryId = valueDes;
          break;
        case r'rollbackSnapshotId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.rollbackSnapshotId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SetMaintenanceModeDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SetMaintenanceModeDtoBuilder();
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


