//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/video_face_run_dto.dart';
import 'package:openapi/src/model/video_face_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'video_faces_response_dto.g.dart';

/// VideoFacesResponseDto
///
/// Properties:
/// * [faces] 
/// * [run] - Latest scan run, null when never scanned
@BuiltValue()
abstract class VideoFacesResponseDto implements Built<VideoFacesResponseDto, VideoFacesResponseDtoBuilder> {
  @BuiltValueField(wireName: r'faces')
  BuiltList<VideoFaceDto> get faces;

  /// Latest scan run, null when never scanned
  @BuiltValueField(wireName: r'run')
  VideoFaceRunDto? get run;

  VideoFacesResponseDto._();

  factory VideoFacesResponseDto([void updates(VideoFacesResponseDtoBuilder b)]) = _$VideoFacesResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VideoFacesResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VideoFacesResponseDto> get serializer => _$VideoFacesResponseDtoSerializer();
}

class _$VideoFacesResponseDtoSerializer implements PrimitiveSerializer<VideoFacesResponseDto> {
  @override
  final Iterable<Type> types = const [VideoFacesResponseDto, _$VideoFacesResponseDto];

  @override
  final String wireName = r'VideoFacesResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VideoFacesResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'faces';
    yield serializers.serialize(
      object.faces,
      specifiedType: const FullType(BuiltList, [FullType(VideoFaceDto)]),
    );
    yield r'run';
    yield object.run == null ? null : serializers.serialize(
      object.run,
      specifiedType: const FullType.nullable(VideoFaceRunDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VideoFacesResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VideoFacesResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'faces':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VideoFaceDto)]),
          ) as BuiltList<VideoFaceDto>;
          result.faces.replace(valueDes);
          break;
        case r'run':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VideoFaceRunDto),
          ) as VideoFaceRunDto?;
          if (valueDes == null) continue;
          result.run.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VideoFacesResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VideoFacesResponseDtoBuilder();
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


