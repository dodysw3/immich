//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/album_user_role.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'album_user_add_dto.g.dart';

/// AlbumUserAddDto
///
/// Properties:
/// * [role] 
/// * [userId] - User ID
@BuiltValue()
abstract class AlbumUserAddDto implements Built<AlbumUserAddDto, AlbumUserAddDtoBuilder> {
  @BuiltValueField(wireName: r'role')
  AlbumUserRole? get role;
  // enum roleEnum {  editor,  owner,  viewer,  };

  /// User ID
  @BuiltValueField(wireName: r'userId')
  String get userId;

  AlbumUserAddDto._();

  factory AlbumUserAddDto([void updates(AlbumUserAddDtoBuilder b)]) = _$AlbumUserAddDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AlbumUserAddDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AlbumUserAddDto> get serializer => _$AlbumUserAddDtoSerializer();
}

class _$AlbumUserAddDtoSerializer implements PrimitiveSerializer<AlbumUserAddDto> {
  @override
  final Iterable<Type> types = const [AlbumUserAddDto, _$AlbumUserAddDto];

  @override
  final String wireName = r'AlbumUserAddDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AlbumUserAddDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.role != null) {
      yield r'role';
      yield serializers.serialize(
        object.role,
        specifiedType: const FullType(AlbumUserRole),
      );
    }
    yield r'userId';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AlbumUserAddDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AlbumUserAddDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AlbumUserRole),
          ) as AlbumUserRole?;
          if (valueDes == null) continue;
          result.role = valueDes;
          break;
        case r'userId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AlbumUserAddDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AlbumUserAddDtoBuilder();
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


