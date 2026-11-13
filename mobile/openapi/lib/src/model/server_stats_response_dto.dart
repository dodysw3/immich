//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/usage_by_user_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'server_stats_response_dto.g.dart';

/// ServerStatsResponseDto
///
/// Properties:
/// * [photos] - Total number of photos
/// * [usage] - Total storage usage in bytes
/// * [usageByUser] - Array of usage for each user
/// * [usagePhotos] - Storage usage for photos in bytes
/// * [usageVideos] - Storage usage for videos in bytes
/// * [videos] - Total number of videos
@BuiltValue()
abstract class ServerStatsResponseDto implements Built<ServerStatsResponseDto, ServerStatsResponseDtoBuilder> {
  /// Total number of photos
  @BuiltValueField(wireName: r'photos')
  int get photos;

  /// Total storage usage in bytes
  @BuiltValueField(wireName: r'usage')
  int get usage;

  /// Array of usage for each user
  @BuiltValueField(wireName: r'usageByUser')
  BuiltList<UsageByUserDto> get usageByUser;

  /// Storage usage for photos in bytes
  @BuiltValueField(wireName: r'usagePhotos')
  int get usagePhotos;

  /// Storage usage for videos in bytes
  @BuiltValueField(wireName: r'usageVideos')
  int get usageVideos;

  /// Total number of videos
  @BuiltValueField(wireName: r'videos')
  int get videos;

  ServerStatsResponseDto._();

  factory ServerStatsResponseDto([void updates(ServerStatsResponseDtoBuilder b)]) = _$ServerStatsResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ServerStatsResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ServerStatsResponseDto> get serializer => _$ServerStatsResponseDtoSerializer();
}

class _$ServerStatsResponseDtoSerializer implements PrimitiveSerializer<ServerStatsResponseDto> {
  @override
  final Iterable<Type> types = const [ServerStatsResponseDto, _$ServerStatsResponseDto];

  @override
  final String wireName = r'ServerStatsResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ServerStatsResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'photos';
    yield serializers.serialize(
      object.photos,
      specifiedType: const FullType(int),
    );
    yield r'usage';
    yield serializers.serialize(
      object.usage,
      specifiedType: const FullType(int),
    );
    yield r'usageByUser';
    yield serializers.serialize(
      object.usageByUser,
      specifiedType: const FullType(BuiltList, [FullType(UsageByUserDto)]),
    );
    yield r'usagePhotos';
    yield serializers.serialize(
      object.usagePhotos,
      specifiedType: const FullType(int),
    );
    yield r'usageVideos';
    yield serializers.serialize(
      object.usageVideos,
      specifiedType: const FullType(int),
    );
    yield r'videos';
    yield serializers.serialize(
      object.videos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ServerStatsResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ServerStatsResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'photos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.photos = valueDes;
          break;
        case r'usage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.usage = valueDes;
          break;
        case r'usageByUser':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(UsageByUserDto)]),
          ) as BuiltList<UsageByUserDto>;
          result.usageByUser.replace(valueDes);
          break;
        case r'usagePhotos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.usagePhotos = valueDes;
          break;
        case r'usageVideos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.usageVideos = valueDes;
          break;
        case r'videos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.videos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ServerStatsResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ServerStatsResponseDtoBuilder();
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


