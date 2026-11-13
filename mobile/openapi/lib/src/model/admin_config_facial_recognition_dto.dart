//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/admin_config_tiling_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_facial_recognition_dto.g.dart';

/// AdminConfigFacialRecognitionDto
///
/// Properties:
/// * [enabled] - Whether the task is enabled
/// * [importNamesFromOtherAccounts] - Import person names from other accounts in the same recognition cluster
/// * [maxDistance] - Maximum distance threshold for face recognition
/// * [minFaceSize] - Minimum bounding box pixel dimension for face recognition
/// * [minFaces] - Minimum number of faces required for recognition
/// * [minScore] - Minimum confidence score for face detection
/// * [minVerifyScore] - Minimum detector score when each face is re-checked on a standard crop around it (0 disables the re-check)
/// * [modelName] - Name of the model to use
/// * [tiling] 
@BuiltValue()
abstract class AdminConfigFacialRecognitionDto implements Built<AdminConfigFacialRecognitionDto, AdminConfigFacialRecognitionDtoBuilder> {
  /// Whether the task is enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// Import person names from other accounts in the same recognition cluster
  @BuiltValueField(wireName: r'importNamesFromOtherAccounts')
  bool get importNamesFromOtherAccounts;

  /// Maximum distance threshold for face recognition
  @BuiltValueField(wireName: r'maxDistance')
  double get maxDistance;

  /// Minimum bounding box pixel dimension for face recognition
  @BuiltValueField(wireName: r'minFaceSize')
  int get minFaceSize;

  /// Minimum number of faces required for recognition
  @BuiltValueField(wireName: r'minFaces')
  int get minFaces;

  /// Minimum confidence score for face detection
  @BuiltValueField(wireName: r'minScore')
  double get minScore;

  /// Minimum detector score when each face is re-checked on a standard crop around it (0 disables the re-check)
  @BuiltValueField(wireName: r'minVerifyScore')
  double get minVerifyScore;

  /// Name of the model to use
  @BuiltValueField(wireName: r'modelName')
  String get modelName;

  @BuiltValueField(wireName: r'tiling')
  AdminConfigTilingDto get tiling;

  AdminConfigFacialRecognitionDto._();

  factory AdminConfigFacialRecognitionDto([void updates(AdminConfigFacialRecognitionDtoBuilder b)]) = _$AdminConfigFacialRecognitionDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigFacialRecognitionDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigFacialRecognitionDto> get serializer => _$AdminConfigFacialRecognitionDtoSerializer();
}

class _$AdminConfigFacialRecognitionDtoSerializer implements PrimitiveSerializer<AdminConfigFacialRecognitionDto> {
  @override
  final Iterable<Type> types = const [AdminConfigFacialRecognitionDto, _$AdminConfigFacialRecognitionDto];

  @override
  final String wireName = r'AdminConfigFacialRecognitionDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigFacialRecognitionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'importNamesFromOtherAccounts';
    yield serializers.serialize(
      object.importNamesFromOtherAccounts,
      specifiedType: const FullType(bool),
    );
    yield r'maxDistance';
    yield serializers.serialize(
      object.maxDistance,
      specifiedType: const FullType(double),
    );
    yield r'minFaceSize';
    yield serializers.serialize(
      object.minFaceSize,
      specifiedType: const FullType(int),
    );
    yield r'minFaces';
    yield serializers.serialize(
      object.minFaces,
      specifiedType: const FullType(int),
    );
    yield r'minScore';
    yield serializers.serialize(
      object.minScore,
      specifiedType: const FullType(double),
    );
    yield r'minVerifyScore';
    yield serializers.serialize(
      object.minVerifyScore,
      specifiedType: const FullType(double),
    );
    yield r'modelName';
    yield serializers.serialize(
      object.modelName,
      specifiedType: const FullType(String),
    );
    yield r'tiling';
    yield serializers.serialize(
      object.tiling,
      specifiedType: const FullType(AdminConfigTilingDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigFacialRecognitionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigFacialRecognitionDtoBuilder result,
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
        case r'importNamesFromOtherAccounts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.importNamesFromOtherAccounts = valueDes;
          break;
        case r'maxDistance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.maxDistance = valueDes;
          break;
        case r'minFaceSize':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.minFaceSize = valueDes;
          break;
        case r'minFaces':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.minFaces = valueDes;
          break;
        case r'minScore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.minScore = valueDes;
          break;
        case r'minVerifyScore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.minVerifyScore = valueDes;
          break;
        case r'modelName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.modelName = valueDes;
          break;
        case r'tiling':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigTilingDto),
          ) as AdminConfigTilingDto;
          result.tiling.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigFacialRecognitionDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigFacialRecognitionDtoBuilder();
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


