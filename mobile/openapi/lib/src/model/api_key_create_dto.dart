//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/permission.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_key_create_dto.g.dart';

/// ApiKeyCreateDto
///
/// Properties:
/// * [name] - API key name
/// * [permissions] - List of permissions
@BuiltValue()
abstract class ApiKeyCreateDto implements Built<ApiKeyCreateDto, ApiKeyCreateDtoBuilder> {
  /// API key name
  @BuiltValueField(wireName: r'name')
  String? get name;

  /// List of permissions
  @BuiltValueField(wireName: r'permissions')
  BuiltList<Permission> get permissions;

  ApiKeyCreateDto._();

  factory ApiKeyCreateDto([void updates(ApiKeyCreateDtoBuilder b)]) = _$ApiKeyCreateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiKeyCreateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiKeyCreateDto> get serializer => _$ApiKeyCreateDtoSerializer();
}

class _$ApiKeyCreateDtoSerializer implements PrimitiveSerializer<ApiKeyCreateDto> {
  @override
  final Iterable<Type> types = const [ApiKeyCreateDto, _$ApiKeyCreateDto];

  @override
  final String wireName = r'ApiKeyCreateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiKeyCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    yield r'permissions';
    yield serializers.serialize(
      object.permissions,
      specifiedType: const FullType(BuiltList, [FullType(Permission)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiKeyCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiKeyCreateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'permissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Permission)]),
          ) as BuiltList<Permission>;
          result.permissions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiKeyCreateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiKeyCreateDtoBuilder();
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


