//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_nightly_tasks_dto.g.dart';

/// AdminConfigNightlyTasksDto
///
/// Properties:
/// * [clusterNewFaces] - Cluster new faces
/// * [databaseCleanup] - Database cleanup
/// * [generateMemories] - Generate memories
/// * [missingThumbnails] - Missing thumbnails
/// * [startTime] - Start time (HH:MM)
/// * [syncQuotaUsage] - Sync quota usage
@BuiltValue()
abstract class AdminConfigNightlyTasksDto implements Built<AdminConfigNightlyTasksDto, AdminConfigNightlyTasksDtoBuilder> {
  /// Cluster new faces
  @BuiltValueField(wireName: r'clusterNewFaces')
  bool get clusterNewFaces;

  /// Database cleanup
  @BuiltValueField(wireName: r'databaseCleanup')
  bool get databaseCleanup;

  /// Generate memories
  @BuiltValueField(wireName: r'generateMemories')
  bool get generateMemories;

  /// Missing thumbnails
  @BuiltValueField(wireName: r'missingThumbnails')
  bool get missingThumbnails;

  /// Start time (HH:MM)
  @BuiltValueField(wireName: r'startTime')
  String get startTime;

  /// Sync quota usage
  @BuiltValueField(wireName: r'syncQuotaUsage')
  bool get syncQuotaUsage;

  AdminConfigNightlyTasksDto._();

  factory AdminConfigNightlyTasksDto([void updates(AdminConfigNightlyTasksDtoBuilder b)]) = _$AdminConfigNightlyTasksDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigNightlyTasksDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigNightlyTasksDto> get serializer => _$AdminConfigNightlyTasksDtoSerializer();
}

class _$AdminConfigNightlyTasksDtoSerializer implements PrimitiveSerializer<AdminConfigNightlyTasksDto> {
  @override
  final Iterable<Type> types = const [AdminConfigNightlyTasksDto, _$AdminConfigNightlyTasksDto];

  @override
  final String wireName = r'AdminConfigNightlyTasksDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigNightlyTasksDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'clusterNewFaces';
    yield serializers.serialize(
      object.clusterNewFaces,
      specifiedType: const FullType(bool),
    );
    yield r'databaseCleanup';
    yield serializers.serialize(
      object.databaseCleanup,
      specifiedType: const FullType(bool),
    );
    yield r'generateMemories';
    yield serializers.serialize(
      object.generateMemories,
      specifiedType: const FullType(bool),
    );
    yield r'missingThumbnails';
    yield serializers.serialize(
      object.missingThumbnails,
      specifiedType: const FullType(bool),
    );
    yield r'startTime';
    yield serializers.serialize(
      object.startTime,
      specifiedType: const FullType(String),
    );
    yield r'syncQuotaUsage';
    yield serializers.serialize(
      object.syncQuotaUsage,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigNightlyTasksDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigNightlyTasksDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'clusterNewFaces':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.clusterNewFaces = valueDes;
          break;
        case r'databaseCleanup':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.databaseCleanup = valueDes;
          break;
        case r'generateMemories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.generateMemories = valueDes;
          break;
        case r'missingThumbnails':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.missingThumbnails = valueDes;
          break;
        case r'startTime':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.startTime = valueDes;
          break;
        case r'syncQuotaUsage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.syncQuotaUsage = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigNightlyTasksDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigNightlyTasksDtoBuilder();
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


