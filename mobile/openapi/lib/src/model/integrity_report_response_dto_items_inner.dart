//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/integrity_report.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'integrity_report_response_dto_items_inner.g.dart';

/// IntegrityReportResponseDtoItemsInner
///
/// Properties:
/// * [id] - Integrity report item id
/// * [path] - Integrity report item path
/// * [type] 
@BuiltValue()
abstract class IntegrityReportResponseDtoItemsInner implements Built<IntegrityReportResponseDtoItemsInner, IntegrityReportResponseDtoItemsInnerBuilder> {
  /// Integrity report item id
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Integrity report item path
  @BuiltValueField(wireName: r'path')
  String get path;

  @BuiltValueField(wireName: r'type')
  IntegrityReport get type;
  // enum typeEnum {  untracked_file,  missing_file,  checksum_mismatch,  };

  IntegrityReportResponseDtoItemsInner._();

  factory IntegrityReportResponseDtoItemsInner([void updates(IntegrityReportResponseDtoItemsInnerBuilder b)]) = _$IntegrityReportResponseDtoItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IntegrityReportResponseDtoItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<IntegrityReportResponseDtoItemsInner> get serializer => _$IntegrityReportResponseDtoItemsInnerSerializer();
}

class _$IntegrityReportResponseDtoItemsInnerSerializer implements PrimitiveSerializer<IntegrityReportResponseDtoItemsInner> {
  @override
  final Iterable<Type> types = const [IntegrityReportResponseDtoItemsInner, _$IntegrityReportResponseDtoItemsInner];

  @override
  final String wireName = r'IntegrityReportResponseDtoItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IntegrityReportResponseDtoItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'path';
    yield serializers.serialize(
      object.path,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(IntegrityReport),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    IntegrityReportResponseDtoItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required IntegrityReportResponseDtoItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'path':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.path = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(IntegrityReport),
          ) as IntegrityReport;
          result.type = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  IntegrityReportResponseDtoItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IntegrityReportResponseDtoItemsInnerBuilder();
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


