//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/bulk_id_error_reason.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'bulk_id_response_dto.g.dart';

/// BulkIdResponseDto
///
/// Properties:
/// * [error] 
/// * [errorMessage] 
/// * [id] - ID
/// * [success] - Whether operation succeeded
@BuiltValue()
abstract class BulkIdResponseDto implements Built<BulkIdResponseDto, BulkIdResponseDtoBuilder> {
  @BuiltValueField(wireName: r'error')
  BulkIdErrorReason? get error;
  // enum errorEnum {  duplicate,  no_permission,  not_found,  unknown,  validation,  };

  @BuiltValueField(wireName: r'errorMessage')
  String? get errorMessage;

  /// ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Whether operation succeeded
  @BuiltValueField(wireName: r'success')
  bool get success;

  BulkIdResponseDto._();

  factory BulkIdResponseDto([void updates(BulkIdResponseDtoBuilder b)]) = _$BulkIdResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BulkIdResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BulkIdResponseDto> get serializer => _$BulkIdResponseDtoSerializer();
}

class _$BulkIdResponseDtoSerializer implements PrimitiveSerializer<BulkIdResponseDto> {
  @override
  final Iterable<Type> types = const [BulkIdResponseDto, _$BulkIdResponseDto];

  @override
  final String wireName = r'BulkIdResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BulkIdResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.error != null) {
      yield r'error';
      yield serializers.serialize(
        object.error,
        specifiedType: const FullType(BulkIdErrorReason),
      );
    }
    if (object.errorMessage != null) {
      yield r'errorMessage';
      yield serializers.serialize(
        object.errorMessage,
        specifiedType: const FullType(String),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'success';
    yield serializers.serialize(
      object.success,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BulkIdResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BulkIdResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'error':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BulkIdErrorReason),
          ) as BulkIdErrorReason?;
          if (valueDes == null) continue;
          result.error = valueDes;
          break;
        case r'errorMessage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.errorMessage = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'success':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.success = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BulkIdResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BulkIdResponseDtoBuilder();
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


