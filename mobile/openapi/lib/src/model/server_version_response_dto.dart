//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'server_version_response_dto.g.dart';

/// ServerVersionResponseDto
///
/// Properties:
/// * [featureLevel] - Highest feature level supported by the server, which increments independently of the release version
/// * [major] - Major version number
/// * [minor] - Minor version number
/// * [patch_] - Patch version number
/// * [prerelease] - Pre-release version number
@BuiltValue()
abstract class ServerVersionResponseDto implements Built<ServerVersionResponseDto, ServerVersionResponseDtoBuilder> {
  /// Highest feature level supported by the server, which increments independently of the release version
  @BuiltValueField(wireName: r'featureLevel')
  int get featureLevel;

  /// Major version number
  @BuiltValueField(wireName: r'major')
  int get major;

  /// Minor version number
  @BuiltValueField(wireName: r'minor')
  int get minor;

  /// Patch version number
  @BuiltValueField(wireName: r'patch')
  int get patch_;

  /// Pre-release version number
  @BuiltValueField(wireName: r'prerelease')
  int? get prerelease;

  ServerVersionResponseDto._();

  factory ServerVersionResponseDto([void updates(ServerVersionResponseDtoBuilder b)]) = _$ServerVersionResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ServerVersionResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ServerVersionResponseDto> get serializer => _$ServerVersionResponseDtoSerializer();
}

class _$ServerVersionResponseDtoSerializer implements PrimitiveSerializer<ServerVersionResponseDto> {
  @override
  final Iterable<Type> types = const [ServerVersionResponseDto, _$ServerVersionResponseDto];

  @override
  final String wireName = r'ServerVersionResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ServerVersionResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'featureLevel';
    yield serializers.serialize(
      object.featureLevel,
      specifiedType: const FullType(int),
    );
    yield r'major';
    yield serializers.serialize(
      object.major,
      specifiedType: const FullType(int),
    );
    yield r'minor';
    yield serializers.serialize(
      object.minor,
      specifiedType: const FullType(int),
    );
    yield r'patch';
    yield serializers.serialize(
      object.patch_,
      specifiedType: const FullType(int),
    );
    yield r'prerelease';
    yield object.prerelease == null ? null : serializers.serialize(
      object.prerelease,
      specifiedType: const FullType.nullable(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ServerVersionResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ServerVersionResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'featureLevel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.featureLevel = valueDes;
          break;
        case r'major':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.major = valueDes;
          break;
        case r'minor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.minor = valueDes;
          break;
        case r'patch':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.patch_ = valueDes;
          break;
        case r'prerelease':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.prerelease = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ServerVersionResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ServerVersionResponseDtoBuilder();
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


