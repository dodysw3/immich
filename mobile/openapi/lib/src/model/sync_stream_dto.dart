//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/sync_request_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_stream_dto.g.dart';

/// SyncStreamDto
///
/// Properties:
/// * [reset] - Reset sync state
/// * [types] - Sync request types
@BuiltValue()
abstract class SyncStreamDto implements Built<SyncStreamDto, SyncStreamDtoBuilder> {
  /// Reset sync state
  @BuiltValueField(wireName: r'reset')
  bool? get reset;

  /// Sync request types
  @BuiltValueField(wireName: r'types')
  BuiltList<SyncRequestType> get types;

  SyncStreamDto._();

  factory SyncStreamDto([void updates(SyncStreamDtoBuilder b)]) = _$SyncStreamDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncStreamDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncStreamDto> get serializer => _$SyncStreamDtoSerializer();
}

class _$SyncStreamDtoSerializer implements PrimitiveSerializer<SyncStreamDto> {
  @override
  final Iterable<Type> types = const [SyncStreamDto, _$SyncStreamDto];

  @override
  final String wireName = r'SyncStreamDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncStreamDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.reset != null) {
      yield r'reset';
      yield serializers.serialize(
        object.reset,
        specifiedType: const FullType(bool),
      );
    }
    yield r'types';
    yield serializers.serialize(
      object.types,
      specifiedType: const FullType(BuiltList, [FullType(SyncRequestType)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncStreamDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncStreamDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reset':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.reset = valueDes;
          break;
        case r'types':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SyncRequestType)]),
          ) as BuiltList<SyncRequestType>;
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
  SyncStreamDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncStreamDtoBuilder();
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


