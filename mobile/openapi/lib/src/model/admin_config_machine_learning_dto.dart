//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/admin_config_clip_dto.dart';
import 'package:openapi/src/model/admin_config_machine_learning_availability_checks_dto.dart';
import 'package:openapi/src/model/admin_config_duplicate_detection_dto.dart';
import 'package:openapi/src/model/admin_config_ocr_dto.dart';
import 'package:openapi/src/model/admin_config_facial_recognition_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_machine_learning_dto.g.dart';

/// AdminConfigMachineLearningDto
///
/// Properties:
/// * [availabilityChecks] 
/// * [clip] 
/// * [duplicateDetection] 
/// * [enabled] - Enabled
/// * [facialRecognition] 
/// * [ocr] 
/// * [urls] - ML service URLs
@BuiltValue()
abstract class AdminConfigMachineLearningDto implements Built<AdminConfigMachineLearningDto, AdminConfigMachineLearningDtoBuilder> {
  @BuiltValueField(wireName: r'availabilityChecks')
  AdminConfigMachineLearningAvailabilityChecksDto get availabilityChecks;

  @BuiltValueField(wireName: r'clip')
  AdminConfigClipDto get clip;

  @BuiltValueField(wireName: r'duplicateDetection')
  AdminConfigDuplicateDetectionDto get duplicateDetection;

  /// Enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'facialRecognition')
  AdminConfigFacialRecognitionDto get facialRecognition;

  @BuiltValueField(wireName: r'ocr')
  AdminConfigOcrDto get ocr;

  /// ML service URLs
  @BuiltValueField(wireName: r'urls')
  BuiltList<String> get urls;

  AdminConfigMachineLearningDto._();

  factory AdminConfigMachineLearningDto([void updates(AdminConfigMachineLearningDtoBuilder b)]) = _$AdminConfigMachineLearningDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigMachineLearningDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigMachineLearningDto> get serializer => _$AdminConfigMachineLearningDtoSerializer();
}

class _$AdminConfigMachineLearningDtoSerializer implements PrimitiveSerializer<AdminConfigMachineLearningDto> {
  @override
  final Iterable<Type> types = const [AdminConfigMachineLearningDto, _$AdminConfigMachineLearningDto];

  @override
  final String wireName = r'AdminConfigMachineLearningDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigMachineLearningDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'availabilityChecks';
    yield serializers.serialize(
      object.availabilityChecks,
      specifiedType: const FullType(AdminConfigMachineLearningAvailabilityChecksDto),
    );
    yield r'clip';
    yield serializers.serialize(
      object.clip,
      specifiedType: const FullType(AdminConfigClipDto),
    );
    yield r'duplicateDetection';
    yield serializers.serialize(
      object.duplicateDetection,
      specifiedType: const FullType(AdminConfigDuplicateDetectionDto),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'facialRecognition';
    yield serializers.serialize(
      object.facialRecognition,
      specifiedType: const FullType(AdminConfigFacialRecognitionDto),
    );
    yield r'ocr';
    yield serializers.serialize(
      object.ocr,
      specifiedType: const FullType(AdminConfigOcrDto),
    );
    yield r'urls';
    yield serializers.serialize(
      object.urls,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigMachineLearningDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigMachineLearningDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'availabilityChecks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigMachineLearningAvailabilityChecksDto),
          ) as AdminConfigMachineLearningAvailabilityChecksDto;
          result.availabilityChecks.replace(valueDes);
          break;
        case r'clip':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigClipDto),
          ) as AdminConfigClipDto;
          result.clip.replace(valueDes);
          break;
        case r'duplicateDetection':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigDuplicateDetectionDto),
          ) as AdminConfigDuplicateDetectionDto;
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
            specifiedType: const FullType(AdminConfigFacialRecognitionDto),
          ) as AdminConfigFacialRecognitionDto;
          result.facialRecognition.replace(valueDes);
          break;
        case r'ocr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigOcrDto),
          ) as AdminConfigOcrDto;
          result.ocr.replace(valueDes);
          break;
        case r'urls':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.urls.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigMachineLearningDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigMachineLearningDtoBuilder();
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


