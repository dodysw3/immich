//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'session_update_dto.g.dart';

/// SessionUpdateDto
///
/// Properties:
/// * [isPendingSyncReset] - Reset pending sync state
@BuiltValue()
abstract class SessionUpdateDto implements Built<SessionUpdateDto, SessionUpdateDtoBuilder> {
  /// Reset pending sync state
  @BuiltValueField(wireName: r'isPendingSyncReset')
  bool? get isPendingSyncReset;

  SessionUpdateDto._();

  factory SessionUpdateDto([void updates(SessionUpdateDtoBuilder b)]) = _$SessionUpdateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SessionUpdateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SessionUpdateDto> get serializer => _$SessionUpdateDtoSerializer();
}

class _$SessionUpdateDtoSerializer implements PrimitiveSerializer<SessionUpdateDto> {
  @override
  final Iterable<Type> types = const [SessionUpdateDto, _$SessionUpdateDto];

  @override
  final String wireName = r'SessionUpdateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SessionUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.isPendingSyncReset != null) {
      yield r'isPendingSyncReset';
      yield serializers.serialize(
        object.isPendingSyncReset,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SessionUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SessionUpdateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'isPendingSyncReset':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isPendingSyncReset = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SessionUpdateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SessionUpdateDtoBuilder();
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


