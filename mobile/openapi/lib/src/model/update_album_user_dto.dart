//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/album_user_role.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_album_user_dto.g.dart';

/// UpdateAlbumUserDto
///
/// Properties:
/// * [role] 
@BuiltValue()
abstract class UpdateAlbumUserDto implements Built<UpdateAlbumUserDto, UpdateAlbumUserDtoBuilder> {
  @BuiltValueField(wireName: r'role')
  AlbumUserRole get role;
  // enum roleEnum {  editor,  owner,  viewer,  };

  UpdateAlbumUserDto._();

  factory UpdateAlbumUserDto([void updates(UpdateAlbumUserDtoBuilder b)]) = _$UpdateAlbumUserDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateAlbumUserDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateAlbumUserDto> get serializer => _$UpdateAlbumUserDtoSerializer();
}

class _$UpdateAlbumUserDtoSerializer implements PrimitiveSerializer<UpdateAlbumUserDto> {
  @override
  final Iterable<Type> types = const [UpdateAlbumUserDto, _$UpdateAlbumUserDto];

  @override
  final String wireName = r'UpdateAlbumUserDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateAlbumUserDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(AlbumUserRole),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateAlbumUserDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateAlbumUserDtoBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateAlbumUserDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateAlbumUserDtoBuilder();
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


