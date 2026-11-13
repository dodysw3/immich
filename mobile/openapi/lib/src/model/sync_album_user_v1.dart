//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/album_user_role.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_album_user_v1.g.dart';

/// SyncAlbumUserV1
///
/// Properties:
/// * [albumId] - Album ID
/// * [role] 
/// * [userId] - User ID
@BuiltValue()
abstract class SyncAlbumUserV1 implements Built<SyncAlbumUserV1, SyncAlbumUserV1Builder> {
  /// Album ID
  @BuiltValueField(wireName: r'albumId')
  String get albumId;

  @BuiltValueField(wireName: r'role')
  AlbumUserRole get role;
  // enum roleEnum {  editor,  owner,  viewer,  };

  /// User ID
  @BuiltValueField(wireName: r'userId')
  String get userId;

  SyncAlbumUserV1._();

  factory SyncAlbumUserV1([void updates(SyncAlbumUserV1Builder b)]) = _$SyncAlbumUserV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncAlbumUserV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncAlbumUserV1> get serializer => _$SyncAlbumUserV1Serializer();
}

class _$SyncAlbumUserV1Serializer implements PrimitiveSerializer<SyncAlbumUserV1> {
  @override
  final Iterable<Type> types = const [SyncAlbumUserV1, _$SyncAlbumUserV1];

  @override
  final String wireName = r'SyncAlbumUserV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncAlbumUserV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'albumId';
    yield serializers.serialize(
      object.albumId,
      specifiedType: const FullType(String),
    );
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
    SyncAlbumUserV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncAlbumUserV1Builder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'albumId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.albumId = valueDes;
          break;
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
  SyncAlbumUserV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncAlbumUserV1Builder();
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


