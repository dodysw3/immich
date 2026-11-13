//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'audio_stream_response_dto.g.dart';

/// Audio stream metadata
///
/// Properties:
/// * [bitrate] - Audio bitrate in bits per second
/// * [codecName] - Audio codec name
/// * [profile] - Audio codec profile number
@BuiltValue()
abstract class AudioStreamResponseDto implements Built<AudioStreamResponseDto, AudioStreamResponseDtoBuilder> {
  /// Audio bitrate in bits per second
  @BuiltValueField(wireName: r'bitrate')
  int? get bitrate;

  /// Audio codec name
  @BuiltValueField(wireName: r'codecName')
  String? get codecName;

  /// Audio codec profile number
  @BuiltValueField(wireName: r'profile')
  int? get profile;

  AudioStreamResponseDto._();

  factory AudioStreamResponseDto([void updates(AudioStreamResponseDtoBuilder b)]) = _$AudioStreamResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AudioStreamResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AudioStreamResponseDto> get serializer => _$AudioStreamResponseDtoSerializer();
}

class _$AudioStreamResponseDtoSerializer implements PrimitiveSerializer<AudioStreamResponseDto> {
  @override
  final Iterable<Type> types = const [AudioStreamResponseDto, _$AudioStreamResponseDto];

  @override
  final String wireName = r'AudioStreamResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AudioStreamResponseDto object, {
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
    AudioStreamResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AudioStreamResponseDtoBuilder result,
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
  AudioStreamResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AudioStreamResponseDtoBuilder();
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


