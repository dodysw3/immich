//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/external_ocr_line_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'external_ocr_result_dto.g.dart';

/// ExternalOcrResultDto
///
/// Properties:
/// * [language] - Language hint
/// * [lines] - OCR result lines
/// * [mode] - OCR write mode
/// * [model] - Model family/name
/// * [modelRevision] - Model revision for reprocessing control
/// * [processedAt] - External OCR completion timestamp (ISO 8601)
/// * [provider] - External OCR provider identifier
/// * [searchText] - Pre-tokenized search text
/// * [sourceChecksum] - SHA256 of original source bytes
@BuiltValue()
abstract class ExternalOcrResultDto implements Built<ExternalOcrResultDto, ExternalOcrResultDtoBuilder> {
  /// Language hint
  @BuiltValueField(wireName: r'language')
  String? get language;

  /// OCR result lines
  @BuiltValueField(wireName: r'lines')
  BuiltList<ExternalOcrLineDto> get lines;

  /// OCR write mode
  @BuiltValueField(wireName: r'mode')
  ExternalOcrResultDtoModeEnum get mode;
  // enum modeEnum {  replace,  merge,  };

  /// Model family/name
  @BuiltValueField(wireName: r'model')
  String get model;

  /// Model revision for reprocessing control
  @BuiltValueField(wireName: r'modelRevision')
  String get modelRevision;

  /// External OCR completion timestamp (ISO 8601)
  @BuiltValueField(wireName: r'processedAt')
  String get processedAt;

  /// External OCR provider identifier
  @BuiltValueField(wireName: r'provider')
  String get provider;

  /// Pre-tokenized search text
  @BuiltValueField(wireName: r'searchText')
  String? get searchText;

  /// SHA256 of original source bytes
  @BuiltValueField(wireName: r'sourceChecksum')
  String get sourceChecksum;

  ExternalOcrResultDto._();

  factory ExternalOcrResultDto([void updates(ExternalOcrResultDtoBuilder b)]) = _$ExternalOcrResultDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExternalOcrResultDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ExternalOcrResultDto> get serializer => _$ExternalOcrResultDtoSerializer();
}

class _$ExternalOcrResultDtoSerializer implements PrimitiveSerializer<ExternalOcrResultDto> {
  @override
  final Iterable<Type> types = const [ExternalOcrResultDto, _$ExternalOcrResultDto];

  @override
  final String wireName = r'ExternalOcrResultDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ExternalOcrResultDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.language != null) {
      yield r'language';
      yield serializers.serialize(
        object.language,
        specifiedType: const FullType(String),
      );
    }
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(ExternalOcrLineDto)]),
    );
    yield r'mode';
    yield serializers.serialize(
      object.mode,
      specifiedType: const FullType(ExternalOcrResultDtoModeEnum),
    );
    yield r'model';
    yield serializers.serialize(
      object.model,
      specifiedType: const FullType(String),
    );
    yield r'modelRevision';
    yield serializers.serialize(
      object.modelRevision,
      specifiedType: const FullType(String),
    );
    yield r'processedAt';
    yield serializers.serialize(
      object.processedAt,
      specifiedType: const FullType(String),
    );
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(String),
    );
    if (object.searchText != null) {
      yield r'searchText';
      yield serializers.serialize(
        object.searchText,
        specifiedType: const FullType(String),
      );
    }
    yield r'sourceChecksum';
    yield serializers.serialize(
      object.sourceChecksum,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ExternalOcrResultDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ExternalOcrResultDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'language':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.language = valueDes;
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ExternalOcrLineDto)]),
          ) as BuiltList<ExternalOcrLineDto>;
          result.lines.replace(valueDes);
          break;
        case r'mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ExternalOcrResultDtoModeEnum),
          ) as ExternalOcrResultDtoModeEnum;
          result.mode = valueDes;
          break;
        case r'model':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.model = valueDes;
          break;
        case r'modelRevision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.modelRevision = valueDes;
          break;
        case r'processedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.processedAt = valueDes;
          break;
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.provider = valueDes;
          break;
        case r'searchText':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.searchText = valueDes;
          break;
        case r'sourceChecksum':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sourceChecksum = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ExternalOcrResultDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExternalOcrResultDtoBuilder();
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


/// OCR write mode
class ExternalOcrResultDtoModeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'replace')
  static const ExternalOcrResultDtoModeEnum replace = _$externalOcrResultDtoModeEnum_replace;
  @BuiltValueEnumConst(wireName: r'merge')
  static const ExternalOcrResultDtoModeEnum merge = _$externalOcrResultDtoModeEnum_merge;

  static Serializer<ExternalOcrResultDtoModeEnum> get serializer => _$externalOcrResultDtoModeEnumSerializer;

  const ExternalOcrResultDtoModeEnum._(String name): super(name);

  static BuiltSet<ExternalOcrResultDtoModeEnum> get values => _$externalOcrResultDtoModeEnumValues;
  static ExternalOcrResultDtoModeEnum valueOf(String name) => _$externalOcrResultDtoModeEnumValueOf(name);
}

