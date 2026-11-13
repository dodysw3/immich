//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notification_update_dto.g.dart';

/// NotificationUpdateDto
///
/// Properties:
/// * [readAt] - Date when notification was read
@BuiltValue()
abstract class NotificationUpdateDto implements Built<NotificationUpdateDto, NotificationUpdateDtoBuilder> {
  /// Date when notification was read
  @BuiltValueField(wireName: r'readAt')
  DateTime? get readAt;

  NotificationUpdateDto._();

  factory NotificationUpdateDto([void updates(NotificationUpdateDtoBuilder b)]) = _$NotificationUpdateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificationUpdateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotificationUpdateDto> get serializer => _$NotificationUpdateDtoSerializer();
}

class _$NotificationUpdateDtoSerializer implements PrimitiveSerializer<NotificationUpdateDto> {
  @override
  final Iterable<Type> types = const [NotificationUpdateDto, _$NotificationUpdateDto];

  @override
  final String wireName = r'NotificationUpdateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotificationUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    NotificationUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NotificationUpdateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  NotificationUpdateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationUpdateDtoBuilder();
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


