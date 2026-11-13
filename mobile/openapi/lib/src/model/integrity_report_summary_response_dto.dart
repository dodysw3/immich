//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'integrity_report_summary_response_dto.g.dart';

/// IntegrityReportSummaryResponseDto
///
/// Properties:
/// * [checksumMismatch] 
/// * [missingFile] 
/// * [untrackedFile] 
@BuiltValue()
abstract class IntegrityReportSummaryResponseDto implements Built<IntegrityReportSummaryResponseDto, IntegrityReportSummaryResponseDtoBuilder> {
  @BuiltValueField(wireName: r'checksum_mismatch')
  int get checksumMismatch;

  @BuiltValueField(wireName: r'missing_file')
  int get missingFile;

  @BuiltValueField(wireName: r'untracked_file')
  int get untrackedFile;

  IntegrityReportSummaryResponseDto._();

  factory IntegrityReportSummaryResponseDto([void updates(IntegrityReportSummaryResponseDtoBuilder b)]) = _$IntegrityReportSummaryResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IntegrityReportSummaryResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<IntegrityReportSummaryResponseDto> get serializer => _$IntegrityReportSummaryResponseDtoSerializer();
}

class _$IntegrityReportSummaryResponseDtoSerializer implements PrimitiveSerializer<IntegrityReportSummaryResponseDto> {
  @override
  final Iterable<Type> types = const [IntegrityReportSummaryResponseDto, _$IntegrityReportSummaryResponseDto];

  @override
  final String wireName = r'IntegrityReportSummaryResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IntegrityReportSummaryResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'checksum_mismatch';
    yield serializers.serialize(
      object.checksumMismatch,
      specifiedType: const FullType(int),
    );
    yield r'missing_file';
    yield serializers.serialize(
      object.missingFile,
      specifiedType: const FullType(int),
    );
    yield r'untracked_file';
    yield serializers.serialize(
      object.untrackedFile,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    IntegrityReportSummaryResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required IntegrityReportSummaryResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'checksum_mismatch':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.checksumMismatch = valueDes;
          break;
        case r'missing_file':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.missingFile = valueDes;
          break;
        case r'untracked_file':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.untrackedFile = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  IntegrityReportSummaryResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IntegrityReportSummaryResponseDtoBuilder();
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


