//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'usage_by_user_dto.g.dart';

/// UsageByUserDto
///
/// Properties:
/// * [photos] - Number of photos
/// * [quotaSizeInBytes] - User quota size in bytes (null if unlimited)
/// * [usage] - Total storage usage in bytes
/// * [usagePhotos] - Storage usage for photos in bytes
/// * [usageVideos] - Storage usage for videos in bytes
/// * [userId] - User ID
/// * [userName] - User name
/// * [videos] - Number of videos
@BuiltValue()
abstract class UsageByUserDto implements Built<UsageByUserDto, UsageByUserDtoBuilder> {
  /// Number of photos
  @BuiltValueField(wireName: r'photos')
  int get photos;

  /// User quota size in bytes (null if unlimited)
  @BuiltValueField(wireName: r'quotaSizeInBytes')
  int? get quotaSizeInBytes;

  /// Total storage usage in bytes
  @BuiltValueField(wireName: r'usage')
  int get usage;

  /// Storage usage for photos in bytes
  @BuiltValueField(wireName: r'usagePhotos')
  int get usagePhotos;

  /// Storage usage for videos in bytes
  @BuiltValueField(wireName: r'usageVideos')
  int get usageVideos;

  /// User ID
  @BuiltValueField(wireName: r'userId')
  String get userId;

  /// User name
  @BuiltValueField(wireName: r'userName')
  String get userName;

  /// Number of videos
  @BuiltValueField(wireName: r'videos')
  int get videos;

  UsageByUserDto._();

  factory UsageByUserDto([void updates(UsageByUserDtoBuilder b)]) = _$UsageByUserDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UsageByUserDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UsageByUserDto> get serializer => _$UsageByUserDtoSerializer();
}

class _$UsageByUserDtoSerializer implements PrimitiveSerializer<UsageByUserDto> {
  @override
  final Iterable<Type> types = const [UsageByUserDto, _$UsageByUserDto];

  @override
  final String wireName = r'UsageByUserDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UsageByUserDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'photos';
    yield serializers.serialize(
      object.photos,
      specifiedType: const FullType(int),
    );
    yield r'quotaSizeInBytes';
    yield object.quotaSizeInBytes == null ? null : serializers.serialize(
      object.quotaSizeInBytes,
      specifiedType: const FullType.nullable(int),
    );
    yield r'usage';
    yield serializers.serialize(
      object.usage,
      specifiedType: const FullType(int),
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
    yield r'userId';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
    yield r'userName';
    yield serializers.serialize(
      object.userName,
      specifiedType: const FullType(String),
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
    UsageByUserDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UsageByUserDtoBuilder result,
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
        case r'quotaSizeInBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.quotaSizeInBytes = valueDes;
          break;
        case r'usage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.usage = valueDes;
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
        case r'userId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userId = valueDes;
          break;
        case r'userName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userName = valueDes;
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
  UsageByUserDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UsageByUserDtoBuilder();
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


