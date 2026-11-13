//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/album_user_create_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_album_dto.g.dart';

/// CreateAlbumDto
///
/// Properties:
/// * [albumName] - Album name
/// * [albumUsers] - Album users
/// * [assetIds] - Initial asset IDs
/// * [description] - Album description
@BuiltValue()
abstract class CreateAlbumDto implements Built<CreateAlbumDto, CreateAlbumDtoBuilder> {
  /// Album name
  @BuiltValueField(wireName: r'albumName')
  String get albumName;

  /// Album users
  @BuiltValueField(wireName: r'albumUsers')
  BuiltList<AlbumUserCreateDto>? get albumUsers;

  /// Initial asset IDs
  @BuiltValueField(wireName: r'assetIds')
  BuiltList<String>? get assetIds;

  /// Album description
  @BuiltValueField(wireName: r'description')
  String? get description;

  CreateAlbumDto._();

  factory CreateAlbumDto([void updates(CreateAlbumDtoBuilder b)]) = _$CreateAlbumDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateAlbumDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateAlbumDto> get serializer => _$CreateAlbumDtoSerializer();
}

class _$CreateAlbumDtoSerializer implements PrimitiveSerializer<CreateAlbumDto> {
  @override
  final Iterable<Type> types = const [CreateAlbumDto, _$CreateAlbumDto];

  @override
  final String wireName = r'CreateAlbumDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateAlbumDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'albumName';
    yield serializers.serialize(
      object.albumName,
      specifiedType: const FullType(String),
    );
    if (object.albumUsers != null) {
      yield r'albumUsers';
      yield serializers.serialize(
        object.albumUsers,
        specifiedType: const FullType(BuiltList, [FullType(AlbumUserCreateDto)]),
      );
    }
    if (object.assetIds != null) {
      yield r'assetIds';
      yield serializers.serialize(
        object.assetIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateAlbumDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateAlbumDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'albumName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.albumName = valueDes;
          break;
        case r'albumUsers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(AlbumUserCreateDto)]),
          ) as BuiltList<AlbumUserCreateDto>?;
          if (valueDes == null) continue;
          result.albumUsers.replace(valueDes);
          break;
        case r'assetIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.assetIds.replace(valueDes);
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateAlbumDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateAlbumDtoBuilder();
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


