//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/audio_codec.dart';
import 'package:openapi/src/model/video_container.dart';
import 'package:openapi/src/model/transcode_hw_accel.dart';
import 'package:openapi/src/model/admin_config_f_fmpeg_realtime_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/video_codec.dart';
import 'package:openapi/src/model/transcode_policy.dart';
import 'package:openapi/src/model/cq_mode.dart';
import 'package:openapi/src/model/tone_mapping.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_f_fmpeg_dto.g.dart';

/// AdminConfigFFmpegDto
///
/// Properties:
/// * [accel] 
/// * [accelDecode] - Accelerated decode
/// * [acceptedAudioCodecs] - Accepted audio codecs
/// * [acceptedContainers] - Accepted containers
/// * [acceptedVideoCodecs] - Accepted video codecs
/// * [bframes] - B-frames
/// * [cqMode] 
/// * [crf] - CRF
/// * [gopSize] - GOP size
/// * [maxBitrate] - Max bitrate
/// * [preferredHwDevice] - Preferred hardware device
/// * [preset] - Preset
/// * [realtime] 
/// * [refs] - References
/// * [targetAudioCodec] 
/// * [targetResolution] - Target resolution
/// * [targetVideoCodec] 
/// * [temporalAQ] - Temporal AQ
/// * [threads] - Threads
/// * [tonemap] 
/// * [transcode] 
/// * [twoPass] - Two pass
@BuiltValue()
abstract class AdminConfigFFmpegDto implements Built<AdminConfigFFmpegDto, AdminConfigFFmpegDtoBuilder> {
  @BuiltValueField(wireName: r'accel')
  TranscodeHWAccel get accel;
  // enum accelEnum {  nvenc,  qsv,  vaapi,  rkmpp,  disabled,  };

  /// Accelerated decode
  @BuiltValueField(wireName: r'accelDecode')
  bool get accelDecode;

  /// Accepted audio codecs
  @BuiltValueField(wireName: r'acceptedAudioCodecs')
  BuiltList<AudioCodec> get acceptedAudioCodecs;

  /// Accepted containers
  @BuiltValueField(wireName: r'acceptedContainers')
  BuiltList<VideoContainer> get acceptedContainers;

  /// Accepted video codecs
  @BuiltValueField(wireName: r'acceptedVideoCodecs')
  BuiltList<VideoCodec> get acceptedVideoCodecs;

  /// B-frames
  @BuiltValueField(wireName: r'bframes')
  int get bframes;

  @BuiltValueField(wireName: r'cqMode')
  CQMode get cqMode;
  // enum cqModeEnum {  auto,  cqp,  icq,  };

  /// CRF
  @BuiltValueField(wireName: r'crf')
  int get crf;

  /// GOP size
  @BuiltValueField(wireName: r'gopSize')
  int get gopSize;

  /// Max bitrate
  @BuiltValueField(wireName: r'maxBitrate')
  String get maxBitrate;

  /// Preferred hardware device
  @BuiltValueField(wireName: r'preferredHwDevice')
  String get preferredHwDevice;

  /// Preset
  @BuiltValueField(wireName: r'preset')
  String get preset;

  @BuiltValueField(wireName: r'realtime')
  AdminConfigFFmpegRealtimeDto get realtime;

  /// References
  @BuiltValueField(wireName: r'refs')
  int get refs;

  @BuiltValueField(wireName: r'targetAudioCodec')
  AudioCodec get targetAudioCodec;
  // enum targetAudioCodecEnum {  mp3,  aac,  opus,  pcm_s16le,  };

  /// Target resolution
  @BuiltValueField(wireName: r'targetResolution')
  String get targetResolution;

  @BuiltValueField(wireName: r'targetVideoCodec')
  VideoCodec get targetVideoCodec;
  // enum targetVideoCodecEnum {  h264,  hevc,  vp9,  av1,  };

  /// Temporal AQ
  @BuiltValueField(wireName: r'temporalAQ')
  bool get temporalAQ;

  /// Threads
  @BuiltValueField(wireName: r'threads')
  int get threads;

  @BuiltValueField(wireName: r'tonemap')
  ToneMapping get tonemap;
  // enum tonemapEnum {  hable,  mobius,  reinhard,  disabled,  };

  @BuiltValueField(wireName: r'transcode')
  TranscodePolicy get transcode;
  // enum transcodeEnum {  all,  optimal,  bitrate,  required,  disabled,  };

  /// Two pass
  @BuiltValueField(wireName: r'twoPass')
  bool get twoPass;

  AdminConfigFFmpegDto._();

  factory AdminConfigFFmpegDto([void updates(AdminConfigFFmpegDtoBuilder b)]) = _$AdminConfigFFmpegDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigFFmpegDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigFFmpegDto> get serializer => _$AdminConfigFFmpegDtoSerializer();
}

class _$AdminConfigFFmpegDtoSerializer implements PrimitiveSerializer<AdminConfigFFmpegDto> {
  @override
  final Iterable<Type> types = const [AdminConfigFFmpegDto, _$AdminConfigFFmpegDto];

  @override
  final String wireName = r'AdminConfigFFmpegDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigFFmpegDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accel';
    yield serializers.serialize(
      object.accel,
      specifiedType: const FullType(TranscodeHWAccel),
    );
    yield r'accelDecode';
    yield serializers.serialize(
      object.accelDecode,
      specifiedType: const FullType(bool),
    );
    yield r'acceptedAudioCodecs';
    yield serializers.serialize(
      object.acceptedAudioCodecs,
      specifiedType: const FullType(BuiltList, [FullType(AudioCodec)]),
    );
    yield r'acceptedContainers';
    yield serializers.serialize(
      object.acceptedContainers,
      specifiedType: const FullType(BuiltList, [FullType(VideoContainer)]),
    );
    yield r'acceptedVideoCodecs';
    yield serializers.serialize(
      object.acceptedVideoCodecs,
      specifiedType: const FullType(BuiltList, [FullType(VideoCodec)]),
    );
    yield r'bframes';
    yield serializers.serialize(
      object.bframes,
      specifiedType: const FullType(int),
    );
    yield r'cqMode';
    yield serializers.serialize(
      object.cqMode,
      specifiedType: const FullType(CQMode),
    );
    yield r'crf';
    yield serializers.serialize(
      object.crf,
      specifiedType: const FullType(int),
    );
    yield r'gopSize';
    yield serializers.serialize(
      object.gopSize,
      specifiedType: const FullType(int),
    );
    yield r'maxBitrate';
    yield serializers.serialize(
      object.maxBitrate,
      specifiedType: const FullType(String),
    );
    yield r'preferredHwDevice';
    yield serializers.serialize(
      object.preferredHwDevice,
      specifiedType: const FullType(String),
    );
    yield r'preset';
    yield serializers.serialize(
      object.preset,
      specifiedType: const FullType(String),
    );
    yield r'realtime';
    yield serializers.serialize(
      object.realtime,
      specifiedType: const FullType(AdminConfigFFmpegRealtimeDto),
    );
    yield r'refs';
    yield serializers.serialize(
      object.refs,
      specifiedType: const FullType(int),
    );
    yield r'targetAudioCodec';
    yield serializers.serialize(
      object.targetAudioCodec,
      specifiedType: const FullType(AudioCodec),
    );
    yield r'targetResolution';
    yield serializers.serialize(
      object.targetResolution,
      specifiedType: const FullType(String),
    );
    yield r'targetVideoCodec';
    yield serializers.serialize(
      object.targetVideoCodec,
      specifiedType: const FullType(VideoCodec),
    );
    yield r'temporalAQ';
    yield serializers.serialize(
      object.temporalAQ,
      specifiedType: const FullType(bool),
    );
    yield r'threads';
    yield serializers.serialize(
      object.threads,
      specifiedType: const FullType(int),
    );
    yield r'tonemap';
    yield serializers.serialize(
      object.tonemap,
      specifiedType: const FullType(ToneMapping),
    );
    yield r'transcode';
    yield serializers.serialize(
      object.transcode,
      specifiedType: const FullType(TranscodePolicy),
    );
    yield r'twoPass';
    yield serializers.serialize(
      object.twoPass,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigFFmpegDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigFFmpegDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TranscodeHWAccel),
          ) as TranscodeHWAccel;
          result.accel = valueDes;
          break;
        case r'accelDecode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.accelDecode = valueDes;
          break;
        case r'acceptedAudioCodecs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AudioCodec)]),
          ) as BuiltList<AudioCodec>;
          result.acceptedAudioCodecs.replace(valueDes);
          break;
        case r'acceptedContainers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VideoContainer)]),
          ) as BuiltList<VideoContainer>;
          result.acceptedContainers.replace(valueDes);
          break;
        case r'acceptedVideoCodecs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VideoCodec)]),
          ) as BuiltList<VideoCodec>;
          result.acceptedVideoCodecs.replace(valueDes);
          break;
        case r'bframes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.bframes = valueDes;
          break;
        case r'cqMode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CQMode),
          ) as CQMode;
          result.cqMode = valueDes;
          break;
        case r'crf':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.crf = valueDes;
          break;
        case r'gopSize':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.gopSize = valueDes;
          break;
        case r'maxBitrate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.maxBitrate = valueDes;
          break;
        case r'preferredHwDevice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.preferredHwDevice = valueDes;
          break;
        case r'preset':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.preset = valueDes;
          break;
        case r'realtime':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigFFmpegRealtimeDto),
          ) as AdminConfigFFmpegRealtimeDto;
          result.realtime.replace(valueDes);
          break;
        case r'refs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refs = valueDes;
          break;
        case r'targetAudioCodec':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AudioCodec),
          ) as AudioCodec;
          result.targetAudioCodec = valueDes;
          break;
        case r'targetResolution':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.targetResolution = valueDes;
          break;
        case r'targetVideoCodec':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VideoCodec),
          ) as VideoCodec;
          result.targetVideoCodec = valueDes;
          break;
        case r'temporalAQ':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.temporalAQ = valueDes;
          break;
        case r'threads':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.threads = valueDes;
          break;
        case r'tonemap':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ToneMapping),
          ) as ToneMapping;
          result.tonemap = valueDes;
          break;
        case r'transcode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TranscodePolicy),
          ) as TranscodePolicy;
          result.transcode = valueDes;
          break;
        case r'twoPass':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.twoPass = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigFFmpegDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigFFmpegDtoBuilder();
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


