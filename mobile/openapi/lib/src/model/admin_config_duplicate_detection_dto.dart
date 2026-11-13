//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/admin_config_video_near_dup_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_duplicate_detection_dto.g.dart';

/// AdminConfigDuplicateDetectionDto
///
/// Properties:
/// * [enabled] - Whether the task is enabled
/// * [maxDistance] - Maximum distance threshold for duplicate detection
/// * [ocrVeto] - Exclude duplicate candidates whose OCR text differs materially from the source asset
/// * [ocrVetoMaxTokenDiff] - Maximum OCR token-bag symmetric difference before a duplicate candidate is vetoed
/// * [pdfVeto] - Exclude duplicate PDF candidates whose page count or whole-document text differs from the source asset
/// * [pdfVetoMaxTokenDiff] - Maximum whole-document PDF text token-bag symmetric difference before a candidate is vetoed
/// * [videoNearDup] 
@BuiltValue()
abstract class AdminConfigDuplicateDetectionDto implements Built<AdminConfigDuplicateDetectionDto, AdminConfigDuplicateDetectionDtoBuilder> {
  /// Whether the task is enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// Maximum distance threshold for duplicate detection
  @BuiltValueField(wireName: r'maxDistance')
  double get maxDistance;

  /// Exclude duplicate candidates whose OCR text differs materially from the source asset
  @BuiltValueField(wireName: r'ocrVeto')
  bool get ocrVeto;

  /// Maximum OCR token-bag symmetric difference before a duplicate candidate is vetoed
  @BuiltValueField(wireName: r'ocrVetoMaxTokenDiff')
  int get ocrVetoMaxTokenDiff;

  /// Exclude duplicate PDF candidates whose page count or whole-document text differs from the source asset
  @BuiltValueField(wireName: r'pdfVeto')
  bool get pdfVeto;

  /// Maximum whole-document PDF text token-bag symmetric difference before a candidate is vetoed
  @BuiltValueField(wireName: r'pdfVetoMaxTokenDiff')
  int get pdfVetoMaxTokenDiff;

  @BuiltValueField(wireName: r'videoNearDup')
  AdminConfigVideoNearDupDto get videoNearDup;

  AdminConfigDuplicateDetectionDto._();

  factory AdminConfigDuplicateDetectionDto([void updates(AdminConfigDuplicateDetectionDtoBuilder b)]) = _$AdminConfigDuplicateDetectionDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigDuplicateDetectionDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigDuplicateDetectionDto> get serializer => _$AdminConfigDuplicateDetectionDtoSerializer();
}

class _$AdminConfigDuplicateDetectionDtoSerializer implements PrimitiveSerializer<AdminConfigDuplicateDetectionDto> {
  @override
  final Iterable<Type> types = const [AdminConfigDuplicateDetectionDto, _$AdminConfigDuplicateDetectionDto];

  @override
  final String wireName = r'AdminConfigDuplicateDetectionDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigDuplicateDetectionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'maxDistance';
    yield serializers.serialize(
      object.maxDistance,
      specifiedType: const FullType(double),
    );
    yield r'ocrVeto';
    yield serializers.serialize(
      object.ocrVeto,
      specifiedType: const FullType(bool),
    );
    yield r'ocrVetoMaxTokenDiff';
    yield serializers.serialize(
      object.ocrVetoMaxTokenDiff,
      specifiedType: const FullType(int),
    );
    yield r'pdfVeto';
    yield serializers.serialize(
      object.pdfVeto,
      specifiedType: const FullType(bool),
    );
    yield r'pdfVetoMaxTokenDiff';
    yield serializers.serialize(
      object.pdfVetoMaxTokenDiff,
      specifiedType: const FullType(int),
    );
    yield r'videoNearDup';
    yield serializers.serialize(
      object.videoNearDup,
      specifiedType: const FullType(AdminConfigVideoNearDupDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigDuplicateDetectionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigDuplicateDetectionDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'maxDistance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.maxDistance = valueDes;
          break;
        case r'ocrVeto':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.ocrVeto = valueDes;
          break;
        case r'ocrVetoMaxTokenDiff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ocrVetoMaxTokenDiff = valueDes;
          break;
        case r'pdfVeto':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.pdfVeto = valueDes;
          break;
        case r'pdfVetoMaxTokenDiff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pdfVetoMaxTokenDiff = valueDes;
          break;
        case r'videoNearDup':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigVideoNearDupDto),
          ) as AdminConfigVideoNearDupDto;
          result.videoNearDup.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigDuplicateDetectionDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigDuplicateDetectionDtoBuilder();
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


