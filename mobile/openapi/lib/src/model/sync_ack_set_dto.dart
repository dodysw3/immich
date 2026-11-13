//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_ack_set_dto.g.dart';

/// SyncAckSetDto
///
/// Properties:
/// * [acks] - Acknowledgment IDs (max 1000)
@BuiltValue()
abstract class SyncAckSetDto implements Built<SyncAckSetDto, SyncAckSetDtoBuilder> {
  /// Acknowledgment IDs (max 1000)
  @BuiltValueField(wireName: r'acks')
  BuiltList<String> get acks;

  SyncAckSetDto._();

  factory SyncAckSetDto([void updates(SyncAckSetDtoBuilder b)]) = _$SyncAckSetDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncAckSetDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncAckSetDto> get serializer => _$SyncAckSetDtoSerializer();
}

class _$SyncAckSetDtoSerializer implements PrimitiveSerializer<SyncAckSetDto> {
  @override
  final Iterable<Type> types = const [SyncAckSetDto, _$SyncAckSetDto];

  @override
  final String wireName = r'SyncAckSetDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncAckSetDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'acks';
    yield serializers.serialize(
      object.acks,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncAckSetDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncAckSetDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'acks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.acks.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncAckSetDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncAckSetDtoBuilder();
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


