//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'server_storage_response_dto.g.dart';

/// ServerStorageResponseDto
///
/// Properties:
/// * [diskAvailable] - Available disk space (human-readable format)
/// * [diskAvailableRaw] - Available disk space in bytes
/// * [diskSize] - Total disk size (human-readable format)
/// * [diskSizeRaw] - Total disk size in bytes
/// * [diskUsagePercentage] - Disk usage percentage (0-100)
/// * [diskUse] - Used disk space (human-readable format)
/// * [diskUseRaw] - Used disk space in bytes
@BuiltValue()
abstract class ServerStorageResponseDto implements Built<ServerStorageResponseDto, ServerStorageResponseDtoBuilder> {
  /// Available disk space (human-readable format)
  @BuiltValueField(wireName: r'diskAvailable')
  String get diskAvailable;

  /// Available disk space in bytes
  @BuiltValueField(wireName: r'diskAvailableRaw')
  int get diskAvailableRaw;

  /// Total disk size (human-readable format)
  @BuiltValueField(wireName: r'diskSize')
  String get diskSize;

  /// Total disk size in bytes
  @BuiltValueField(wireName: r'diskSizeRaw')
  int get diskSizeRaw;

  /// Disk usage percentage (0-100)
  @BuiltValueField(wireName: r'diskUsagePercentage')
  double get diskUsagePercentage;

  /// Used disk space (human-readable format)
  @BuiltValueField(wireName: r'diskUse')
  String get diskUse;

  /// Used disk space in bytes
  @BuiltValueField(wireName: r'diskUseRaw')
  int get diskUseRaw;

  ServerStorageResponseDto._();

  factory ServerStorageResponseDto([void updates(ServerStorageResponseDtoBuilder b)]) = _$ServerStorageResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ServerStorageResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ServerStorageResponseDto> get serializer => _$ServerStorageResponseDtoSerializer();
}

class _$ServerStorageResponseDtoSerializer implements PrimitiveSerializer<ServerStorageResponseDto> {
  @override
  final Iterable<Type> types = const [ServerStorageResponseDto, _$ServerStorageResponseDto];

  @override
  final String wireName = r'ServerStorageResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ServerStorageResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'diskAvailable';
    yield serializers.serialize(
      object.diskAvailable,
      specifiedType: const FullType(String),
    );
    yield r'diskAvailableRaw';
    yield serializers.serialize(
      object.diskAvailableRaw,
      specifiedType: const FullType(int),
    );
    yield r'diskSize';
    yield serializers.serialize(
      object.diskSize,
      specifiedType: const FullType(String),
    );
    yield r'diskSizeRaw';
    yield serializers.serialize(
      object.diskSizeRaw,
      specifiedType: const FullType(int),
    );
    yield r'diskUsagePercentage';
    yield serializers.serialize(
      object.diskUsagePercentage,
      specifiedType: const FullType(double),
    );
    yield r'diskUse';
    yield serializers.serialize(
      object.diskUse,
      specifiedType: const FullType(String),
    );
    yield r'diskUseRaw';
    yield serializers.serialize(
      object.diskUseRaw,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ServerStorageResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ServerStorageResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'diskAvailable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.diskAvailable = valueDes;
          break;
        case r'diskAvailableRaw':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.diskAvailableRaw = valueDes;
          break;
        case r'diskSize':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.diskSize = valueDes;
          break;
        case r'diskSizeRaw':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.diskSizeRaw = valueDes;
          break;
        case r'diskUsagePercentage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.diskUsagePercentage = valueDes;
          break;
        case r'diskUse':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.diskUse = valueDes;
          break;
        case r'diskUseRaw':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.diskUseRaw = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ServerStorageResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ServerStorageResponseDtoBuilder();
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


