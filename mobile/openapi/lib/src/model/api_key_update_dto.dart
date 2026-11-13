//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/permission.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_key_update_dto.g.dart';

/// ApiKeyUpdateDto
///
/// Properties:
/// * [name] - API key name
/// * [permissions] - List of permissions
@BuiltValue()
abstract class ApiKeyUpdateDto implements Built<ApiKeyUpdateDto, ApiKeyUpdateDtoBuilder> {
  /// API key name
  @BuiltValueField(wireName: r'name')
  String? get name;

  /// List of permissions
  @BuiltValueField(wireName: r'permissions')
  BuiltList<Permission>? get permissions;

  ApiKeyUpdateDto._();

  factory ApiKeyUpdateDto([void updates(ApiKeyUpdateDtoBuilder b)]) = _$ApiKeyUpdateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiKeyUpdateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiKeyUpdateDto> get serializer => _$ApiKeyUpdateDtoSerializer();
}

class _$ApiKeyUpdateDtoSerializer implements PrimitiveSerializer<ApiKeyUpdateDto> {
  @override
  final Iterable<Type> types = const [ApiKeyUpdateDto, _$ApiKeyUpdateDto];

  @override
  final String wireName = r'ApiKeyUpdateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiKeyUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.permissions != null) {
      yield r'permissions';
      yield serializers.serialize(
        object.permissions,
        specifiedType: const FullType(BuiltList, [FullType(Permission)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiKeyUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiKeyUpdateDtoBuilder result,
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
            specifiedType: const FullType.nullable(BuiltList, [FullType(Permission)]),
          ) as BuiltList<Permission>?;
          if (valueDes == null) continue;
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
  ApiKeyUpdateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiKeyUpdateDtoBuilder();
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


