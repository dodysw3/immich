//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/server_version_response_dto.dart';
import 'package:openapi/src/model/release_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'release_event_v1.g.dart';

/// ReleaseEventV1
///
/// Properties:
/// * [checkedAt] - When the server last checked for a latest version. As an ISO timestamp
/// * [isAvailable] - Whether a new version is available
/// * [releaseVersion] 
/// * [serverVersion] 
/// * [type] 
@BuiltValue()
abstract class ReleaseEventV1 implements Built<ReleaseEventV1, ReleaseEventV1Builder> {
  /// When the server last checked for a latest version. As an ISO timestamp
  @BuiltValueField(wireName: r'checkedAt')
  String get checkedAt;

  /// Whether a new version is available
  @BuiltValueField(wireName: r'isAvailable')
  bool get isAvailable;

  @BuiltValueField(wireName: r'releaseVersion')
  ServerVersionResponseDto get releaseVersion;

  @BuiltValueField(wireName: r'serverVersion')
  ServerVersionResponseDto get serverVersion;

  @BuiltValueField(wireName: r'type')
  ReleaseType get type;
  // enum typeEnum {  major,  premajor,  minor,  preminor,  patch,  prepatch,  prerelease,  };

  ReleaseEventV1._();

  factory ReleaseEventV1([void updates(ReleaseEventV1Builder b)]) = _$ReleaseEventV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReleaseEventV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReleaseEventV1> get serializer => _$ReleaseEventV1Serializer();
}

class _$ReleaseEventV1Serializer implements PrimitiveSerializer<ReleaseEventV1> {
  @override
  final Iterable<Type> types = const [ReleaseEventV1, _$ReleaseEventV1];

  @override
  final String wireName = r'ReleaseEventV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReleaseEventV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'checkedAt';
    yield serializers.serialize(
      object.checkedAt,
      specifiedType: const FullType(String),
    );
    yield r'isAvailable';
    yield serializers.serialize(
      object.isAvailable,
      specifiedType: const FullType(bool),
    );
    yield r'releaseVersion';
    yield serializers.serialize(
      object.releaseVersion,
      specifiedType: const FullType(ServerVersionResponseDto),
    );
    yield r'serverVersion';
    yield serializers.serialize(
      object.serverVersion,
      specifiedType: const FullType(ServerVersionResponseDto),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(ReleaseType),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReleaseEventV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReleaseEventV1Builder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'checkedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.checkedAt = valueDes;
          break;
        case r'isAvailable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isAvailable = valueDes;
          break;
        case r'releaseVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ServerVersionResponseDto),
          ) as ServerVersionResponseDto;
          result.releaseVersion.replace(valueDes);
          break;
        case r'serverVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ServerVersionResponseDto),
          ) as ServerVersionResponseDto;
          result.serverVersion.replace(valueDes);
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReleaseType),
          ) as ReleaseType;
          result.type = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReleaseEventV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReleaseEventV1Builder();
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


