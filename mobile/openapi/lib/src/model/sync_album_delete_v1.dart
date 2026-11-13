//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_album_delete_v1.g.dart';

/// SyncAlbumDeleteV1
///
/// Properties:
/// * [albumId] - Album ID
@BuiltValue()
abstract class SyncAlbumDeleteV1 implements Built<SyncAlbumDeleteV1, SyncAlbumDeleteV1Builder> {
  /// Album ID
  @BuiltValueField(wireName: r'albumId')
  String get albumId;

  SyncAlbumDeleteV1._();

  factory SyncAlbumDeleteV1([void updates(SyncAlbumDeleteV1Builder b)]) = _$SyncAlbumDeleteV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncAlbumDeleteV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncAlbumDeleteV1> get serializer => _$SyncAlbumDeleteV1Serializer();
}

class _$SyncAlbumDeleteV1Serializer implements PrimitiveSerializer<SyncAlbumDeleteV1> {
  @override
  final Iterable<Type> types = const [SyncAlbumDeleteV1, _$SyncAlbumDeleteV1];

  @override
  final String wireName = r'SyncAlbumDeleteV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncAlbumDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'albumId';
    yield serializers.serialize(
      object.albumId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncAlbumDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncAlbumDeleteV1Builder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncAlbumDeleteV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncAlbumDeleteV1Builder();
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


