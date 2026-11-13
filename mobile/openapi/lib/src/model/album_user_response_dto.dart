//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/album_user_role.dart';
import 'package:openapi/src/model/user_response_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'album_user_response_dto.g.dart';

/// AlbumUserResponseDto
///
/// Properties:
/// * [role] 
/// * [user] 
@BuiltValue()
abstract class AlbumUserResponseDto implements Built<AlbumUserResponseDto, AlbumUserResponseDtoBuilder> {
  @BuiltValueField(wireName: r'role')
  AlbumUserRole get role;
  // enum roleEnum {  editor,  owner,  viewer,  };

  @BuiltValueField(wireName: r'user')
  UserResponseDto get user;

  AlbumUserResponseDto._();

  factory AlbumUserResponseDto([void updates(AlbumUserResponseDtoBuilder b)]) = _$AlbumUserResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AlbumUserResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AlbumUserResponseDto> get serializer => _$AlbumUserResponseDtoSerializer();
}

class _$AlbumUserResponseDtoSerializer implements PrimitiveSerializer<AlbumUserResponseDto> {
  @override
  final Iterable<Type> types = const [AlbumUserResponseDto, _$AlbumUserResponseDto];

  @override
  final String wireName = r'AlbumUserResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AlbumUserResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(AlbumUserRole),
    );
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(UserResponseDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AlbumUserResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AlbumUserResponseDtoBuilder result,
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
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserResponseDto),
          ) as UserResponseDto;
          result.user.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AlbumUserResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AlbumUserResponseDtoBuilder();
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


