//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/bulk_id_error_reason.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'albums_add_assets_response_dto.g.dart';

/// AlbumsAddAssetsResponseDto
///
/// Properties:
/// * [error] 
/// * [success] - Operation success
@BuiltValue()
abstract class AlbumsAddAssetsResponseDto implements Built<AlbumsAddAssetsResponseDto, AlbumsAddAssetsResponseDtoBuilder> {
  @BuiltValueField(wireName: r'error')
  BulkIdErrorReason? get error;
  // enum errorEnum {  duplicate,  no_permission,  not_found,  unknown,  validation,  };

  /// Operation success
  @BuiltValueField(wireName: r'success')
  bool get success;

  AlbumsAddAssetsResponseDto._();

  factory AlbumsAddAssetsResponseDto([void updates(AlbumsAddAssetsResponseDtoBuilder b)]) = _$AlbumsAddAssetsResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AlbumsAddAssetsResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AlbumsAddAssetsResponseDto> get serializer => _$AlbumsAddAssetsResponseDtoSerializer();
}

class _$AlbumsAddAssetsResponseDtoSerializer implements PrimitiveSerializer<AlbumsAddAssetsResponseDto> {
  @override
  final Iterable<Type> types = const [AlbumsAddAssetsResponseDto, _$AlbumsAddAssetsResponseDto];

  @override
  final String wireName = r'AlbumsAddAssetsResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AlbumsAddAssetsResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.error != null) {
      yield r'error';
      yield serializers.serialize(
        object.error,
        specifiedType: const FullType(BulkIdErrorReason),
      );
    }
    yield r'success';
    yield serializers.serialize(
      object.success,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AlbumsAddAssetsResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AlbumsAddAssetsResponseDtoBuilder result,
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
  AlbumsAddAssetsResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AlbumsAddAssetsResponseDtoBuilder();
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


