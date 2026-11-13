//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/maintenance_action.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'maintenance_status_response_dto.g.dart';

/// MaintenanceStatusResponseDto
///
/// Properties:
/// * [action] 
/// * [active] 
/// * [error] 
/// * [futoBackupsJobId] - FUTO Backups job ID
/// * [progress] 
/// * [task] 
@BuiltValue()
abstract class MaintenanceStatusResponseDto implements Built<MaintenanceStatusResponseDto, MaintenanceStatusResponseDtoBuilder> {
  @BuiltValueField(wireName: r'action')
  MaintenanceAction get action;
  // enum actionEnum {  start,  end,  select_database_restore,  restore_database,  rollback,  };

  @BuiltValueField(wireName: r'active')
  bool get active;

  @BuiltValueField(wireName: r'error')
  String? get error;

  /// FUTO Backups job ID
  @BuiltValueField(wireName: r'futoBackupsJobId')
  String? get futoBackupsJobId;

  @BuiltValueField(wireName: r'progress')
  int? get progress;

  @BuiltValueField(wireName: r'task')
  String? get task;

  MaintenanceStatusResponseDto._();

  factory MaintenanceStatusResponseDto([void updates(MaintenanceStatusResponseDtoBuilder b)]) = _$MaintenanceStatusResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MaintenanceStatusResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MaintenanceStatusResponseDto> get serializer => _$MaintenanceStatusResponseDtoSerializer();
}

class _$MaintenanceStatusResponseDtoSerializer implements PrimitiveSerializer<MaintenanceStatusResponseDto> {
  @override
  final Iterable<Type> types = const [MaintenanceStatusResponseDto, _$MaintenanceStatusResponseDto];

  @override
  final String wireName = r'MaintenanceStatusResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MaintenanceStatusResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(MaintenanceAction),
    );
    yield r'active';
    yield serializers.serialize(
      object.active,
      specifiedType: const FullType(bool),
    );
    if (object.error != null) {
      yield r'error';
      yield serializers.serialize(
        object.error,
        specifiedType: const FullType(String),
      );
    }
    if (object.futoBackupsJobId != null) {
      yield r'futoBackupsJobId';
      yield serializers.serialize(
        object.futoBackupsJobId,
        specifiedType: const FullType(String),
      );
    }
    if (object.progress != null) {
      yield r'progress';
      yield serializers.serialize(
        object.progress,
        specifiedType: const FullType(int),
      );
    }
    if (object.task != null) {
      yield r'task';
      yield serializers.serialize(
        object.task,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MaintenanceStatusResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MaintenanceStatusResponseDtoBuilder result,
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
        case r'active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.active = valueDes;
          break;
        case r'error':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.error = valueDes;
          break;
        case r'futoBackupsJobId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.futoBackupsJobId = valueDes;
          break;
        case r'progress':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.progress = valueDes;
          break;
        case r'task':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.task = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MaintenanceStatusResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MaintenanceStatusResponseDtoBuilder();
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


