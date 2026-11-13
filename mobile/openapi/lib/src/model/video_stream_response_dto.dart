//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'video_stream_response_dto.g.dart';

/// Video stream metadata
///
/// Properties:
/// * [bitrate] - Video bitrate in bits per second
/// * [codecName] - Video codec name
/// * [dvLevel] - Dolby Vision level
/// * [dvProfile] - Dolby Vision profile
/// * [formatLongName] - Container format long name
/// * [formatName] - Container format name
/// * [frameCount] - Frame count
/// * [level] - Codec level number
/// * [pixelFormat] - Pixel format
/// * [profile] - Codec profile number
@BuiltValue()
abstract class VideoStreamResponseDto implements Built<VideoStreamResponseDto, VideoStreamResponseDtoBuilder> {
  /// Video bitrate in bits per second
  @BuiltValueField(wireName: r'bitrate')
  int? get bitrate;

  /// Video codec name
  @BuiltValueField(wireName: r'codecName')
  String? get codecName;

  /// Dolby Vision level
  @BuiltValueField(wireName: r'dvLevel')
  int? get dvLevel;

  /// Dolby Vision profile
  @BuiltValueField(wireName: r'dvProfile')
  int? get dvProfile;

  /// Container format long name
  @BuiltValueField(wireName: r'formatLongName')
  String? get formatLongName;

  /// Container format name
  @BuiltValueField(wireName: r'formatName')
  String? get formatName;

  /// Frame count
  @BuiltValueField(wireName: r'frameCount')
  int? get frameCount;

  /// Codec level number
  @BuiltValueField(wireName: r'level')
  int? get level;

  /// Pixel format
  @BuiltValueField(wireName: r'pixelFormat')
  String? get pixelFormat;

  /// Codec profile number
  @BuiltValueField(wireName: r'profile')
  int? get profile;

  VideoStreamResponseDto._();

  factory VideoStreamResponseDto([void updates(VideoStreamResponseDtoBuilder b)]) = _$VideoStreamResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VideoStreamResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VideoStreamResponseDto> get serializer => _$VideoStreamResponseDtoSerializer();
}

class _$VideoStreamResponseDtoSerializer implements PrimitiveSerializer<VideoStreamResponseDto> {
  @override
  final Iterable<Type> types = const [VideoStreamResponseDto, _$VideoStreamResponseDto];

  @override
  final String wireName = r'VideoStreamResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VideoStreamResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.bitrate != null) {
      yield r'bitrate';
      yield serializers.serialize(
        object.bitrate,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.codecName != null) {
      yield r'codecName';
      yield serializers.serialize(
        object.codecName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.dvLevel != null) {
      yield r'dvLevel';
      yield serializers.serialize(
        object.dvLevel,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.dvProfile != null) {
      yield r'dvProfile';
      yield serializers.serialize(
        object.dvProfile,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.formatLongName != null) {
      yield r'formatLongName';
      yield serializers.serialize(
        object.formatLongName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.formatName != null) {
      yield r'formatName';
      yield serializers.serialize(
        object.formatName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.frameCount != null) {
      yield r'frameCount';
      yield serializers.serialize(
        object.frameCount,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.level != null) {
      yield r'level';
      yield serializers.serialize(
        object.level,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.pixelFormat != null) {
      yield r'pixelFormat';
      yield serializers.serialize(
        object.pixelFormat,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.profile != null) {
      yield r'profile';
      yield serializers.serialize(
        object.profile,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VideoStreamResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VideoStreamResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'bitrate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.bitrate = valueDes;
          break;
        case r'codecName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.codecName = valueDes;
          break;
        case r'dvLevel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.dvLevel = valueDes;
          break;
        case r'dvProfile':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.dvProfile = valueDes;
          break;
        case r'formatLongName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.formatLongName = valueDes;
          break;
        case r'formatName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.formatName = valueDes;
          break;
        case r'frameCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.frameCount = valueDes;
          break;
        case r'level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.level = valueDes;
          break;
        case r'pixelFormat':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.pixelFormat = valueDes;
          break;
        case r'profile':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.profile = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VideoStreamResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VideoStreamResponseDtoBuilder();
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


