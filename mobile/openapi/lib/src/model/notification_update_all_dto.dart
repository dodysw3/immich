//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notification_update_all_dto.g.dart';

/// NotificationUpdateAllDto
///
/// Properties:
/// * [ids] - Notification IDs to update
/// * [readAt] - Date when notifications were read
@BuiltValue()
abstract class NotificationUpdateAllDto implements Built<NotificationUpdateAllDto, NotificationUpdateAllDtoBuilder> {
  /// Notification IDs to update
  @BuiltValueField(wireName: r'ids')
  BuiltList<String> get ids;

  /// Date when notifications were read
  @BuiltValueField(wireName: r'readAt')
  DateTime? get readAt;

  NotificationUpdateAllDto._();

  factory NotificationUpdateAllDto([void updates(NotificationUpdateAllDtoBuilder b)]) = _$NotificationUpdateAllDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificationUpdateAllDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotificationUpdateAllDto> get serializer => _$NotificationUpdateAllDtoSerializer();
}

class _$NotificationUpdateAllDtoSerializer implements PrimitiveSerializer<NotificationUpdateAllDto> {
  @override
  final Iterable<Type> types = const [NotificationUpdateAllDto, _$NotificationUpdateAllDto];

  @override
  final String wireName = r'NotificationUpdateAllDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotificationUpdateAllDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ids';
    yield serializers.serialize(
      object.ids,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    if (object.readAt != null) {
      yield r'readAt';
      yield serializers.serialize(
        object.readAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    NotificationUpdateAllDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NotificationUpdateAllDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.ids.replace(valueDes);
          break;
        case r'readAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.readAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NotificationUpdateAllDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationUpdateAllDtoBuilder();
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


