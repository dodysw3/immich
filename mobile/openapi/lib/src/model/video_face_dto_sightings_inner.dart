//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'video_face_dto_sightings_inner.g.dart';

/// VideoFaceDtoSightingsInner
///
/// Properties:
/// * [imageHeight] 
/// * [imageWidth] - Decoded frame dimensions the box is relative to
/// * [score] - Detection score
/// * [timeMs] - Decoded presentation timestamp of the sighting
/// * [x1] - Pixel box in the decoded frame (≤1440px long edge)
/// * [x2] 
/// * [y1] 
/// * [y2] 
@BuiltValue()
abstract class VideoFaceDtoSightingsInner implements Built<VideoFaceDtoSightingsInner, VideoFaceDtoSightingsInnerBuilder> {
  @BuiltValueField(wireName: r'imageHeight')
  int get imageHeight;

  /// Decoded frame dimensions the box is relative to
  @BuiltValueField(wireName: r'imageWidth')
  int get imageWidth;

  /// Detection score
  @BuiltValueField(wireName: r'score')
  num get score;

  /// Decoded presentation timestamp of the sighting
  @BuiltValueField(wireName: r'timeMs')
  int get timeMs;

  /// Pixel box in the decoded frame (≤1440px long edge)
  @BuiltValueField(wireName: r'x1')
  int get x1;

  @BuiltValueField(wireName: r'x2')
  int get x2;

  @BuiltValueField(wireName: r'y1')
  int get y1;

  @BuiltValueField(wireName: r'y2')
  int get y2;

  VideoFaceDtoSightingsInner._();

  factory VideoFaceDtoSightingsInner([void updates(VideoFaceDtoSightingsInnerBuilder b)]) = _$VideoFaceDtoSightingsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VideoFaceDtoSightingsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VideoFaceDtoSightingsInner> get serializer => _$VideoFaceDtoSightingsInnerSerializer();
}

class _$VideoFaceDtoSightingsInnerSerializer implements PrimitiveSerializer<VideoFaceDtoSightingsInner> {
  @override
  final Iterable<Type> types = const [VideoFaceDtoSightingsInner, _$VideoFaceDtoSightingsInner];

  @override
  final String wireName = r'VideoFaceDtoSightingsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VideoFaceDtoSightingsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'imageHeight';
    yield serializers.serialize(
      object.imageHeight,
      specifiedType: const FullType(int),
    );
    yield r'imageWidth';
    yield serializers.serialize(
      object.imageWidth,
      specifiedType: const FullType(int),
    );
    yield r'score';
    yield serializers.serialize(
      object.score,
      specifiedType: const FullType(num),
    );
    yield r'timeMs';
    yield serializers.serialize(
      object.timeMs,
      specifiedType: const FullType(int),
    );
    yield r'x1';
    yield serializers.serialize(
      object.x1,
      specifiedType: const FullType(int),
    );
    yield r'x2';
    yield serializers.serialize(
      object.x2,
      specifiedType: const FullType(int),
    );
    yield r'y1';
    yield serializers.serialize(
      object.y1,
      specifiedType: const FullType(int),
    );
    yield r'y2';
    yield serializers.serialize(
      object.y2,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VideoFaceDtoSightingsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VideoFaceDtoSightingsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'imageHeight':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.imageHeight = valueDes;
          break;
        case r'imageWidth':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.imageWidth = valueDes;
          break;
        case r'score':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.score = valueDes;
          break;
        case r'timeMs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.timeMs = valueDes;
          break;
        case r'x1':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.x1 = valueDes;
          break;
        case r'x2':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.x2 = valueDes;
          break;
        case r'y1':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.y1 = valueDes;
          break;
        case r'y2':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.y2 = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VideoFaceDtoSightingsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VideoFaceDtoSightingsInnerBuilder();
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


