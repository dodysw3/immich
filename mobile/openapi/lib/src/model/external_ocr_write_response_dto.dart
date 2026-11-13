//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'external_ocr_write_response_dto.g.dart';

/// ExternalOcrWriteResponseDto
///
/// Properties:
/// * [searchTextLength] - Length of generated search text
/// * [written] - Number of records written
@BuiltValue()
abstract class ExternalOcrWriteResponseDto implements Built<ExternalOcrWriteResponseDto, ExternalOcrWriteResponseDtoBuilder> {
  /// Length of generated search text
  @BuiltValueField(wireName: r'searchTextLength')
  int get searchTextLength;

  /// Number of records written
  @BuiltValueField(wireName: r'written')
  int get written;

  ExternalOcrWriteResponseDto._();

  factory ExternalOcrWriteResponseDto([void updates(ExternalOcrWriteResponseDtoBuilder b)]) = _$ExternalOcrWriteResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExternalOcrWriteResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ExternalOcrWriteResponseDto> get serializer => _$ExternalOcrWriteResponseDtoSerializer();
}

class _$ExternalOcrWriteResponseDtoSerializer implements PrimitiveSerializer<ExternalOcrWriteResponseDto> {
  @override
  final Iterable<Type> types = const [ExternalOcrWriteResponseDto, _$ExternalOcrWriteResponseDto];

  @override
  final String wireName = r'ExternalOcrWriteResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ExternalOcrWriteResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'searchTextLength';
    yield serializers.serialize(
      object.searchTextLength,
      specifiedType: const FullType(int),
    );
    yield r'written';
    yield serializers.serialize(
      object.written,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ExternalOcrWriteResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ExternalOcrWriteResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'searchTextLength':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.searchTextLength = valueDes;
          break;
        case r'written':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.written = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ExternalOcrWriteResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExternalOcrWriteResponseDtoBuilder();
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


