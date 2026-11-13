//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_album_user_delete_v1.g.dart';

/// SyncAlbumUserDeleteV1
///
/// Properties:
/// * [albumId] - Album ID
/// * [userId] - User ID
@BuiltValue()
abstract class SyncAlbumUserDeleteV1 implements Built<SyncAlbumUserDeleteV1, SyncAlbumUserDeleteV1Builder> {
  /// Album ID
  @BuiltValueField(wireName: r'albumId')
  String get albumId;

  /// User ID
  @BuiltValueField(wireName: r'userId')
  String get userId;

  SyncAlbumUserDeleteV1._();

  factory SyncAlbumUserDeleteV1([void updates(SyncAlbumUserDeleteV1Builder b)]) = _$SyncAlbumUserDeleteV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncAlbumUserDeleteV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncAlbumUserDeleteV1> get serializer => _$SyncAlbumUserDeleteV1Serializer();
}

class _$SyncAlbumUserDeleteV1Serializer implements PrimitiveSerializer<SyncAlbumUserDeleteV1> {
  @override
  final Iterable<Type> types = const [SyncAlbumUserDeleteV1, _$SyncAlbumUserDeleteV1];

  @override
  final String wireName = r'SyncAlbumUserDeleteV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncAlbumUserDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'albumId';
    yield serializers.serialize(
      object.albumId,
      specifiedType: const FullType(String),
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
    SyncAlbumUserDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncAlbumUserDeleteV1Builder result,
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
  SyncAlbumUserDeleteV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncAlbumUserDeleteV1Builder();
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


