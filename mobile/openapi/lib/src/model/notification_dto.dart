//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/notification_type.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/notification_level.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notification_dto.g.dart';

/// NotificationDto
///
/// Properties:
/// * [createdAt] - Creation date
/// * [data] - Additional notification data
/// * [description] - Notification description
/// * [id] - Notification ID
/// * [level] 
/// * [readAt] - Date when notification was read
/// * [title] - Notification title
/// * [type] 
@BuiltValue()
abstract class NotificationDto implements Built<NotificationDto, NotificationDtoBuilder> {
  /// Creation date
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// Additional notification data
  @BuiltValueField(wireName: r'data')
  BuiltMap<String, JsonObject?>? get data;

  /// Notification description
  @BuiltValueField(wireName: r'description')
  String? get description;

  /// Notification ID
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'level')
  NotificationLevel get level;
  // enum levelEnum {  success,  error,  warning,  info,  };

  /// Date when notification was read
  @BuiltValueField(wireName: r'readAt')
  DateTime? get readAt;

  /// Notification title
  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'type')
  NotificationType get type;
  // enum typeEnum {  JobFailed,  BackupFailed,  SystemMessage,  AlbumInvite,  AlbumUpdate,  ClusterGroupRequest,  Custom,  };

  NotificationDto._();

  factory NotificationDto([void updates(NotificationDtoBuilder b)]) = _$NotificationDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificationDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotificationDto> get serializer => _$NotificationDtoSerializer();
}

class _$NotificationDtoSerializer implements PrimitiveSerializer<NotificationDto> {
  @override
  final Iterable<Type> types = const [NotificationDto, _$NotificationDto];

  @override
  final String wireName = r'NotificationDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotificationDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.data != null) {
      yield r'data';
      yield serializers.serialize(
        object.data,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'level';
    yield serializers.serialize(
      object.level,
      specifiedType: const FullType(NotificationLevel),
    );
    if (object.readAt != null) {
      yield r'readAt';
      yield serializers.serialize(
        object.readAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(NotificationType),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NotificationDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NotificationDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.data.replace(valueDes);
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(NotificationLevel),
          ) as NotificationLevel;
          result.level = valueDes;
          break;
        case r'readAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.readAt = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(NotificationType),
          ) as NotificationType;
          result.type = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NotificationDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationDtoBuilder();
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


