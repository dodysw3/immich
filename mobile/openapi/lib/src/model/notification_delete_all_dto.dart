//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notification_delete_all_dto.g.dart';

/// NotificationDeleteAllDto
///
/// Properties:
/// * [ids] - Notification IDs to delete
@BuiltValue()
abstract class NotificationDeleteAllDto implements Built<NotificationDeleteAllDto, NotificationDeleteAllDtoBuilder> {
  /// Notification IDs to delete
  @BuiltValueField(wireName: r'ids')
  BuiltList<String> get ids;

  NotificationDeleteAllDto._();

  factory NotificationDeleteAllDto([void updates(NotificationDeleteAllDtoBuilder b)]) = _$NotificationDeleteAllDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificationDeleteAllDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotificationDeleteAllDto> get serializer => _$NotificationDeleteAllDtoSerializer();
}

class _$NotificationDeleteAllDtoSerializer implements PrimitiveSerializer<NotificationDeleteAllDto> {
  @override
  final Iterable<Type> types = const [NotificationDeleteAllDto, _$NotificationDeleteAllDto];

  @override
  final String wireName = r'NotificationDeleteAllDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotificationDeleteAllDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ids';
    yield serializers.serialize(
      object.ids,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NotificationDeleteAllDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NotificationDeleteAllDtoBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NotificationDeleteAllDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationDeleteAllDtoBuilder();
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


