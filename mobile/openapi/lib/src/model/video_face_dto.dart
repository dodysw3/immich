//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/video_face_dto_sightings_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'video_face_dto.g.dart';

/// VideoFaceDto
///
/// Properties:
/// * [assetFaceId] 
/// * [bestFrameMs] - Timestamp of the representative frame
/// * [firstObservedMs] - Earliest sighting timestamp
/// * [flagged] - Single sighting below the stricter quality bar
/// * [id] 
/// * [lastObservedMs] - Latest sighting timestamp
/// * [personGroupId] 
/// * [personName] - Owner's person name, if assigned or matched
/// * [sightingCount] 
/// * [sightings] 
@BuiltValue()
abstract class VideoFaceDto implements Built<VideoFaceDto, VideoFaceDtoBuilder> {
  @BuiltValueField(wireName: r'assetFaceId')
  String? get assetFaceId;

  /// Timestamp of the representative frame
  @BuiltValueField(wireName: r'bestFrameMs')
  int get bestFrameMs;

  /// Earliest sighting timestamp
  @BuiltValueField(wireName: r'firstObservedMs')
  int get firstObservedMs;

  /// Single sighting below the stricter quality bar
  @BuiltValueField(wireName: r'flagged')
  bool get flagged;

  @BuiltValueField(wireName: r'id')
  String get id;

  /// Latest sighting timestamp
  @BuiltValueField(wireName: r'lastObservedMs')
  int get lastObservedMs;

  @BuiltValueField(wireName: r'personGroupId')
  String? get personGroupId;

  /// Owner's person name, if assigned or matched
  @BuiltValueField(wireName: r'personName')
  String? get personName;

  @BuiltValueField(wireName: r'sightingCount')
  int get sightingCount;

  @BuiltValueField(wireName: r'sightings')
  BuiltList<VideoFaceDtoSightingsInner> get sightings;

  VideoFaceDto._();

  factory VideoFaceDto([void updates(VideoFaceDtoBuilder b)]) = _$VideoFaceDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VideoFaceDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VideoFaceDto> get serializer => _$VideoFaceDtoSerializer();
}

class _$VideoFaceDtoSerializer implements PrimitiveSerializer<VideoFaceDto> {
  @override
  final Iterable<Type> types = const [VideoFaceDto, _$VideoFaceDto];

  @override
  final String wireName = r'VideoFaceDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VideoFaceDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assetFaceId';
    yield object.assetFaceId == null ? null : serializers.serialize(
      object.assetFaceId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'bestFrameMs';
    yield serializers.serialize(
      object.bestFrameMs,
      specifiedType: const FullType(int),
    );
    yield r'firstObservedMs';
    yield serializers.serialize(
      object.firstObservedMs,
      specifiedType: const FullType(int),
    );
    yield r'flagged';
    yield serializers.serialize(
      object.flagged,
      specifiedType: const FullType(bool),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'lastObservedMs';
    yield serializers.serialize(
      object.lastObservedMs,
      specifiedType: const FullType(int),
    );
    yield r'personGroupId';
    yield object.personGroupId == null ? null : serializers.serialize(
      object.personGroupId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'personName';
    yield object.personName == null ? null : serializers.serialize(
      object.personName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'sightingCount';
    yield serializers.serialize(
      object.sightingCount,
      specifiedType: const FullType(int),
    );
    yield r'sightings';
    yield serializers.serialize(
      object.sightings,
      specifiedType: const FullType(BuiltList, [FullType(VideoFaceDtoSightingsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VideoFaceDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VideoFaceDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assetFaceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.assetFaceId = valueDes;
          break;
        case r'bestFrameMs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.bestFrameMs = valueDes;
          break;
        case r'firstObservedMs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.firstObservedMs = valueDes;
          break;
        case r'flagged':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.flagged = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'lastObservedMs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lastObservedMs = valueDes;
          break;
        case r'personGroupId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.personGroupId = valueDes;
          break;
        case r'personName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.personName = valueDes;
          break;
        case r'sightingCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sightingCount = valueDes;
          break;
        case r'sightings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VideoFaceDtoSightingsInner)]),
          ) as BuiltList<VideoFaceDtoSightingsInner>;
          result.sightings.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VideoFaceDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VideoFaceDtoBuilder();
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


