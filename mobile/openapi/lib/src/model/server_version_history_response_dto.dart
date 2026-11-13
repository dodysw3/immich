//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'server_version_history_response_dto.g.dart';

/// ServerVersionHistoryResponseDto
///
/// Properties:
/// * [createdAt] - When this version was first seen
/// * [id] - Version history entry ID
/// * [version] - Version string
@BuiltValue()
abstract class ServerVersionHistoryResponseDto implements Built<ServerVersionHistoryResponseDto, ServerVersionHistoryResponseDtoBuilder> {
  /// When this version was first seen
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// Version history entry ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Version string
  @BuiltValueField(wireName: r'version')
  String get version;

  ServerVersionHistoryResponseDto._();

  factory ServerVersionHistoryResponseDto([void updates(ServerVersionHistoryResponseDtoBuilder b)]) = _$ServerVersionHistoryResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ServerVersionHistoryResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ServerVersionHistoryResponseDto> get serializer => _$ServerVersionHistoryResponseDtoSerializer();
}

class _$ServerVersionHistoryResponseDtoSerializer implements PrimitiveSerializer<ServerVersionHistoryResponseDto> {
  @override
  final Iterable<Type> types = const [ServerVersionHistoryResponseDto, _$ServerVersionHistoryResponseDto];

  @override
  final String wireName = r'ServerVersionHistoryResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ServerVersionHistoryResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ServerVersionHistoryResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ServerVersionHistoryResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.version = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ServerVersionHistoryResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ServerVersionHistoryResponseDtoBuilder();
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


