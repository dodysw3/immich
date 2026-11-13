//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/album_user_add_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'add_users_dto.g.dart';

/// AddUsersDto
///
/// Properties:
/// * [albumUsers] - Album users to add
@BuiltValue()
abstract class AddUsersDto implements Built<AddUsersDto, AddUsersDtoBuilder> {
  /// Album users to add
  @BuiltValueField(wireName: r'albumUsers')
  BuiltList<AlbumUserAddDto> get albumUsers;

  AddUsersDto._();

  factory AddUsersDto([void updates(AddUsersDtoBuilder b)]) = _$AddUsersDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AddUsersDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AddUsersDto> get serializer => _$AddUsersDtoSerializer();
}

class _$AddUsersDtoSerializer implements PrimitiveSerializer<AddUsersDto> {
  @override
  final Iterable<Type> types = const [AddUsersDto, _$AddUsersDto];

  @override
  final String wireName = r'AddUsersDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AddUsersDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'albumUsers';
    yield serializers.serialize(
      object.albumUsers,
      specifiedType: const FullType(BuiltList, [FullType(AlbumUserAddDto)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AddUsersDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AddUsersDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'albumUsers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AlbumUserAddDto)]),
          ) as BuiltList<AlbumUserAddDto>;
          result.albumUsers.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AddUsersDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AddUsersDtoBuilder();
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


