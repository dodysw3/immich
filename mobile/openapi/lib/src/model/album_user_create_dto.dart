//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/album_user_role.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'album_user_create_dto.g.dart';

/// AlbumUserCreateDto
///
/// Properties:
/// * [role] 
/// * [userId] - User ID
@BuiltValue()
abstract class AlbumUserCreateDto implements Built<AlbumUserCreateDto, AlbumUserCreateDtoBuilder> {
  @BuiltValueField(wireName: r'role')
  AlbumUserRole get role;
  // enum roleEnum {  editor,  owner,  viewer,  };

  /// User ID
  @BuiltValueField(wireName: r'userId')
  String get userId;

  AlbumUserCreateDto._();

  factory AlbumUserCreateDto([void updates(AlbumUserCreateDtoBuilder b)]) = _$AlbumUserCreateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AlbumUserCreateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AlbumUserCreateDto> get serializer => _$AlbumUserCreateDtoSerializer();
}

class _$AlbumUserCreateDtoSerializer implements PrimitiveSerializer<AlbumUserCreateDto> {
  @override
  final Iterable<Type> types = const [AlbumUserCreateDto, _$AlbumUserCreateDto];

  @override
  final String wireName = r'AlbumUserCreateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AlbumUserCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(AlbumUserRole),
    );
    yield r'userId';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AlbumUserCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AlbumUserCreateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AlbumUserRole),
          ) as AlbumUserRole;
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
  AlbumUserCreateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AlbumUserCreateDtoBuilder();
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


