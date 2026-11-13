//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'session_create_dto.g.dart';

/// SessionCreateDto
///
/// Properties:
/// * [deviceOS] - Device OS
/// * [deviceType] - Device type
/// * [duration] - Session duration in seconds
@BuiltValue()
abstract class SessionCreateDto implements Built<SessionCreateDto, SessionCreateDtoBuilder> {
  /// Device OS
  @BuiltValueField(wireName: r'deviceOS')
  String? get deviceOS;

  /// Device type
  @BuiltValueField(wireName: r'deviceType')
  String? get deviceType;

  /// Session duration in seconds
  @BuiltValueField(wireName: r'duration')
  int? get duration;

  SessionCreateDto._();

  factory SessionCreateDto([void updates(SessionCreateDtoBuilder b)]) = _$SessionCreateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SessionCreateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SessionCreateDto> get serializer => _$SessionCreateDtoSerializer();
}

class _$SessionCreateDtoSerializer implements PrimitiveSerializer<SessionCreateDto> {
  @override
  final Iterable<Type> types = const [SessionCreateDto, _$SessionCreateDto];

  @override
  final String wireName = r'SessionCreateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SessionCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.deviceOS != null) {
      yield r'deviceOS';
      yield serializers.serialize(
        object.deviceOS,
        specifiedType: const FullType(String),
      );
    }
    if (object.deviceType != null) {
      yield r'deviceType';
      yield serializers.serialize(
        object.deviceType,
        specifiedType: const FullType(String),
      );
    }
    if (object.duration != null) {
      yield r'duration';
      yield serializers.serialize(
        object.duration,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SessionCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SessionCreateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'deviceOS':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.deviceOS = valueDes;
          break;
        case r'deviceType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.deviceType = valueDes;
          break;
        case r'duration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.duration = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SessionCreateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SessionCreateDtoBuilder();
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


