//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/sync_entity_type.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_ack_delete_dto.g.dart';

/// SyncAckDeleteDto
///
/// Properties:
/// * [types] - Sync entity types to delete acks for
@BuiltValue()
abstract class SyncAckDeleteDto implements Built<SyncAckDeleteDto, SyncAckDeleteDtoBuilder> {
  /// Sync entity types to delete acks for
  @BuiltValueField(wireName: r'types')
  BuiltList<SyncEntityType>? get types;

  SyncAckDeleteDto._();

  factory SyncAckDeleteDto([void updates(SyncAckDeleteDtoBuilder b)]) = _$SyncAckDeleteDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncAckDeleteDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncAckDeleteDto> get serializer => _$SyncAckDeleteDtoSerializer();
}

class _$SyncAckDeleteDtoSerializer implements PrimitiveSerializer<SyncAckDeleteDto> {
  @override
  final Iterable<Type> types = const [SyncAckDeleteDto, _$SyncAckDeleteDto];

  @override
  final String wireName = r'SyncAckDeleteDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncAckDeleteDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.types != null) {
      yield r'types';
      yield serializers.serialize(
        object.types,
        specifiedType: const FullType(BuiltList, [FullType(SyncEntityType)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncAckDeleteDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncAckDeleteDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'types':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(SyncEntityType)]),
          ) as BuiltList<SyncEntityType>?;
          if (valueDes == null) continue;
          result.types.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncAckDeleteDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncAckDeleteDtoBuilder();
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


