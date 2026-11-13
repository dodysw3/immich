//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'session_create_response_dto.g.dart';

/// SessionCreateResponseDto
///
/// Properties:
/// * [appVersion] - App version
/// * [createdAt] - Creation date
/// * [current] - Is current session
/// * [deviceOS] - Device OS
/// * [deviceType] - Device type
/// * [expiresAt] - Expiration date
/// * [id] - Session ID
/// * [isPendingSyncReset] - Is pending sync reset
/// * [token] - Session token
/// * [updatedAt] - Last update date
@BuiltValue()
abstract class SessionCreateResponseDto implements Built<SessionCreateResponseDto, SessionCreateResponseDtoBuilder> {
  /// App version
  @BuiltValueField(wireName: r'appVersion')
  String? get appVersion;

  /// Creation date
  @BuiltValueField(wireName: r'createdAt')
  String get createdAt;

  /// Is current session
  @BuiltValueField(wireName: r'current')
  bool get current;

  /// Device OS
  @BuiltValueField(wireName: r'deviceOS')
  String get deviceOS;

  /// Device type
  @BuiltValueField(wireName: r'deviceType')
  String get deviceType;

  /// Expiration date
  @BuiltValueField(wireName: r'expiresAt')
  String? get expiresAt;

  /// Session ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Is pending sync reset
  @BuiltValueField(wireName: r'isPendingSyncReset')
  bool get isPendingSyncReset;

  /// Session token
  @BuiltValueField(wireName: r'token')
  String get token;

  /// Last update date
  @BuiltValueField(wireName: r'updatedAt')
  String get updatedAt;

  SessionCreateResponseDto._();

  factory SessionCreateResponseDto([void updates(SessionCreateResponseDtoBuilder b)]) = _$SessionCreateResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SessionCreateResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SessionCreateResponseDto> get serializer => _$SessionCreateResponseDtoSerializer();
}

class _$SessionCreateResponseDtoSerializer implements PrimitiveSerializer<SessionCreateResponseDto> {
  @override
  final Iterable<Type> types = const [SessionCreateResponseDto, _$SessionCreateResponseDto];

  @override
  final String wireName = r'SessionCreateResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SessionCreateResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'appVersion';
    yield object.appVersion == null ? null : serializers.serialize(
      object.appVersion,
      specifiedType: const FullType.nullable(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(String),
    );
    yield r'current';
    yield serializers.serialize(
      object.current,
      specifiedType: const FullType(bool),
    );
    yield r'deviceOS';
    yield serializers.serialize(
      object.deviceOS,
      specifiedType: const FullType(String),
    );
    yield r'deviceType';
    yield serializers.serialize(
      object.deviceType,
      specifiedType: const FullType(String),
    );
    if (object.expiresAt != null) {
      yield r'expiresAt';
      yield serializers.serialize(
        object.expiresAt,
        specifiedType: const FullType(String),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'isPendingSyncReset';
    yield serializers.serialize(
      object.isPendingSyncReset,
      specifiedType: const FullType(bool),
    );
    yield r'token';
    yield serializers.serialize(
      object.token,
      specifiedType: const FullType(String),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SessionCreateResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SessionCreateResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'appVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.appVersion = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.createdAt = valueDes;
          break;
        case r'current':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.current = valueDes;
          break;
        case r'deviceOS':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.deviceOS = valueDes;
          break;
        case r'deviceType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.deviceType = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.expiresAt = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'isPendingSyncReset':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isPendingSyncReset = valueDes;
          break;
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.token = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SessionCreateResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SessionCreateResponseDtoBuilder();
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


