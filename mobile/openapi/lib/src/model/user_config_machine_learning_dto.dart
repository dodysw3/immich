//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user_config_clip_dto.dart';
import 'package:openapi/src/model/user_config_duplicate_detection_dto.dart';
import 'package:openapi/src/model/user_config_facial_recognition_dto.dart';
import 'package:openapi/src/model/user_config_ocr_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_config_machine_learning_dto.g.dart';

/// UserConfigMachineLearningDto
///
/// Properties:
/// * [clip] 
/// * [duplicateDetection] 
/// * [enabled] - Enabled
/// * [facialRecognition] 
/// * [ocr] 
@BuiltValue()
abstract class UserConfigMachineLearningDto implements Built<UserConfigMachineLearningDto, UserConfigMachineLearningDtoBuilder> {
  @BuiltValueField(wireName: r'clip')
  UserConfigClipDto get clip;

  @BuiltValueField(wireName: r'duplicateDetection')
  UserConfigDuplicateDetectionDto get duplicateDetection;

  /// Enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'facialRecognition')
  UserConfigFacialRecognitionDto get facialRecognition;

  @BuiltValueField(wireName: r'ocr')
  UserConfigOcrDto get ocr;

  UserConfigMachineLearningDto._();

  factory UserConfigMachineLearningDto([void updates(UserConfigMachineLearningDtoBuilder b)]) = _$UserConfigMachineLearningDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserConfigMachineLearningDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserConfigMachineLearningDto> get serializer => _$UserConfigMachineLearningDtoSerializer();
}

class _$UserConfigMachineLearningDtoSerializer implements PrimitiveSerializer<UserConfigMachineLearningDto> {
  @override
  final Iterable<Type> types = const [UserConfigMachineLearningDto, _$UserConfigMachineLearningDto];

  @override
  final String wireName = r'UserConfigMachineLearningDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserConfigMachineLearningDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'clip';
    yield serializers.serialize(
      object.clip,
      specifiedType: const FullType(UserConfigClipDto),
    );
    yield r'duplicateDetection';
    yield serializers.serialize(
      object.duplicateDetection,
      specifiedType: const FullType(UserConfigDuplicateDetectionDto),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'facialRecognition';
    yield serializers.serialize(
      object.facialRecognition,
      specifiedType: const FullType(UserConfigFacialRecognitionDto),
    );
    yield r'ocr';
    yield serializers.serialize(
      object.ocr,
      specifiedType: const FullType(UserConfigOcrDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserConfigMachineLearningDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserConfigMachineLearningDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'clip':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserConfigClipDto),
          ) as UserConfigClipDto;
          result.clip.replace(valueDes);
          break;
        case r'duplicateDetection':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserConfigDuplicateDetectionDto),
          ) as UserConfigDuplicateDetectionDto;
          result.duplicateDetection.replace(valueDes);
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'facialRecognition':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserConfigFacialRecognitionDto),
          ) as UserConfigFacialRecognitionDto;
          result.facialRecognition.replace(valueDes);
          break;
        case r'ocr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserConfigOcrDto),
          ) as UserConfigOcrDto;
          result.ocr.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserConfigMachineLearningDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserConfigMachineLearningDtoBuilder();
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


