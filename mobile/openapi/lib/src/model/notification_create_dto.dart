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

part 'notification_create_dto.g.dart';

/// NotificationCreateDto
///
/// Properties:
/// * [data] - Additional notification data
/// * [description] - Notification description
/// * [level] 
/// * [readAt] - Date when notification was read
/// * [title] - Notification title
/// * [type] 
/// * [userId] - User ID to send notification to
@BuiltValue()
abstract class NotificationCreateDto implements Built<NotificationCreateDto, NotificationCreateDtoBuilder> {
  /// Additional notification data
  @BuiltValueField(wireName: r'data')
  BuiltMap<String, JsonObject?>? get data;

  /// Notification description
  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'level')
  NotificationLevel? get level;
  // enum levelEnum {  success,  error,  warning,  info,  };

  /// Date when notification was read
  @BuiltValueField(wireName: r'readAt')
  DateTime? get readAt;

  /// Notification title
  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'type')
  NotificationType? get type;
  // enum typeEnum {  JobFailed,  BackupFailed,  SystemMessage,  AlbumInvite,  AlbumUpdate,  ClusterGroupRequest,  Custom,  };

  /// User ID to send notification to
  @BuiltValueField(wireName: r'userId')
  String get userId;

  NotificationCreateDto._();

  factory NotificationCreateDto([void updates(NotificationCreateDtoBuilder b)]) = _$NotificationCreateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificationCreateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotificationCreateDto> get serializer => _$NotificationCreateDtoSerializer();
}

class _$NotificationCreateDtoSerializer implements PrimitiveSerializer<NotificationCreateDto> {
  @override
  final Iterable<Type> types = const [NotificationCreateDto, _$NotificationCreateDto];

  @override
  final String wireName = r'NotificationCreateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotificationCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.level != null) {
      yield r'level';
      yield serializers.serialize(
        object.level,
        specifiedType: const FullType(NotificationLevel),
      );
    }
    if (object.readAt != null) {
      yield r'readAt';
      yield serializers.serialize(
        object.readAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    if (object.type != null) {
      yield r'type';
      yield serializers.serialize(
        object.type,
        specifiedType: const FullType(NotificationType),
      );
    }
    yield r'userId';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NotificationCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NotificationCreateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(NotificationLevel),
          ) as NotificationLevel?;
          if (valueDes == null) continue;
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
            specifiedType: const FullType.nullable(NotificationType),
          ) as NotificationType?;
          if (valueDes == null) continue;
          result.type = valueDes;
          break;
        case r'userId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NotificationCreateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationCreateDtoBuilder();
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


