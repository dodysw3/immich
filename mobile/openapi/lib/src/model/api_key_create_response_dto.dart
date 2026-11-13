//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/permission.dart';
import 'package:openapi/src/model/api_key_response_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_key_create_response_dto.g.dart';

/// ApiKeyCreateResponseDto
///
/// Properties:
/// * [apiKey] 
/// * [createdAt] - Creation date
/// * [id] - API key ID
/// * [name] - API key name
/// * [permissions] - List of permissions
/// * [secret] - API key secret (only shown once)
/// * [updatedAt] - Last update date
@BuiltValue()
abstract class ApiKeyCreateResponseDto implements Built<ApiKeyCreateResponseDto, ApiKeyCreateResponseDtoBuilder> {
  @BuiltValueField(wireName: r'apiKey')
  ApiKeyResponseDto get apiKey;

  /// Creation date
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// API key ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// API key name
  @BuiltValueField(wireName: r'name')
  String get name;

  /// List of permissions
  @BuiltValueField(wireName: r'permissions')
  BuiltList<Permission> get permissions;

  /// API key secret (only shown once)
  @BuiltValueField(wireName: r'secret')
  String get secret;

  /// Last update date
  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  ApiKeyCreateResponseDto._();

  factory ApiKeyCreateResponseDto([void updates(ApiKeyCreateResponseDtoBuilder b)]) = _$ApiKeyCreateResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiKeyCreateResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiKeyCreateResponseDto> get serializer => _$ApiKeyCreateResponseDtoSerializer();
}

class _$ApiKeyCreateResponseDtoSerializer implements PrimitiveSerializer<ApiKeyCreateResponseDto> {
  @override
  final Iterable<Type> types = const [ApiKeyCreateResponseDto, _$ApiKeyCreateResponseDto];

  @override
  final String wireName = r'ApiKeyCreateResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiKeyCreateResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'apiKey';
    yield serializers.serialize(
      object.apiKey,
      specifiedType: const FullType(ApiKeyResponseDto),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'permissions';
    yield serializers.serialize(
      object.permissions,
      specifiedType: const FullType(BuiltList, [FullType(Permission)]),
    );
    yield r'secret';
    yield serializers.serialize(
      object.secret,
      specifiedType: const FullType(String),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiKeyCreateResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiKeyCreateResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'apiKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiKeyResponseDto),
          ) as ApiKeyResponseDto;
          result.apiKey.replace(valueDes);
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'permissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Permission)]),
          ) as BuiltList<Permission>;
          result.permissions.replace(valueDes);
          break;
        case r'secret':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.secret = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiKeyCreateResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiKeyCreateResponseDtoBuilder();
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


