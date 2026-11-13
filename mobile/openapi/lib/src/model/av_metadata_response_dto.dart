//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/audio_stream_response_dto.dart';
import 'package:openapi/src/model/video_stream_response_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'av_metadata_response_dto.g.dart';

/// Audio/video stream metadata probed from the original file
///
/// Properties:
/// * [audioStream] 
/// * [videoStream] 
@BuiltValue()
abstract class AvMetadataResponseDto implements Built<AvMetadataResponseDto, AvMetadataResponseDtoBuilder> {
  @BuiltValueField(wireName: r'audioStream')
  AudioStreamResponseDto? get audioStream;

  @BuiltValueField(wireName: r'videoStream')
  VideoStreamResponseDto? get videoStream;

  AvMetadataResponseDto._();

  factory AvMetadataResponseDto([void updates(AvMetadataResponseDtoBuilder b)]) = _$AvMetadataResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AvMetadataResponseDtoBuilder b) => b
      ..audioStream = null
      ..videoStream = null;

  @BuiltValueSerializer(custom: true)
  static Serializer<AvMetadataResponseDto> get serializer => _$AvMetadataResponseDtoSerializer();
}

class _$AvMetadataResponseDtoSerializer implements PrimitiveSerializer<AvMetadataResponseDto> {
  @override
  final Iterable<Type> types = const [AvMetadataResponseDto, _$AvMetadataResponseDto];

  @override
  final String wireName = r'AvMetadataResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AvMetadataResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.audioStream != null) {
      yield r'audioStream';
      yield serializers.serialize(
        object.audioStream,
        specifiedType: const FullType.nullable(AudioStreamResponseDto),
      );
    }
    if (object.videoStream != null) {
      yield r'videoStream';
      yield serializers.serialize(
        object.videoStream,
        specifiedType: const FullType.nullable(VideoStreamResponseDto),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AvMetadataResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AvMetadataResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'audioStream':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AudioStreamResponseDto),
          ) as AudioStreamResponseDto?;
          if (valueDes == null) continue;
          result.audioStream.replace(valueDes);
          break;
        case r'videoStream':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VideoStreamResponseDto),
          ) as VideoStreamResponseDto?;
          if (valueDes == null) continue;
          result.videoStream.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AvMetadataResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AvMetadataResponseDtoBuilder();
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


