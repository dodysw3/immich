//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/sync_entity_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_ack_dto.g.dart';

/// SyncAckDto
///
/// Properties:
/// * [ack] - Acknowledgment ID
/// * [type] 
@BuiltValue()
abstract class SyncAckDto implements Built<SyncAckDto, SyncAckDtoBuilder> {
  /// Acknowledgment ID
  @BuiltValueField(wireName: r'ack')
  String get ack;

  @BuiltValueField(wireName: r'type')
  SyncEntityType get type;
  // enum typeEnum {  AuthUserV1,  AuthUserV2,  UserV1,  UserDeleteV1,  AssetV1,  AssetV2,  AssetDeleteV1,  AssetExifV1,  AssetEditV1,  AssetEditDeleteV1,  AssetMetadataV1,  AssetMetadataDeleteV1,  AssetOcrV1,  AssetOcrDeleteV1,  PartnerV1,  PartnerDeleteV1,  PartnerAssetV1,  PartnerAssetV2,  PartnerAssetBackfillV1,  PartnerAssetBackfillV2,  PartnerAssetDeleteV1,  PartnerAssetExifV1,  PartnerAssetExifBackfillV1,  PartnerStackBackfillV1,  PartnerStackDeleteV1,  PartnerStackV1,  AlbumV1,  AlbumV2,  AlbumDeleteV1,  AlbumUserV1,  AlbumUserBackfillV1,  AlbumUserDeleteV1,  AlbumAssetCreateV1,  AlbumAssetCreateV2,  AlbumAssetUpdateV1,  AlbumAssetUpdateV2,  AlbumAssetBackfillV1,  AlbumAssetBackfillV2,  AlbumAssetExifCreateV1,  AlbumAssetExifUpdateV1,  AlbumAssetExifBackfillV1,  AlbumToAssetV1,  AlbumToAssetDeleteV1,  AlbumToAssetBackfillV1,  MemoryV1,  MemoryV2,  MemoryDeleteV1,  MemoryToAssetV1,  MemoryToAssetV2,  MemoryToAssetDeleteV1,  StackV1,  StackDeleteV1,  PersonV1,  PersonDeleteV1,  AssetFaceV1,  AssetFaceV2,  AssetFaceV3,  AssetFaceDeleteV1,  UserMetadataV1,  UserMetadataDeleteV1,  SyncAckV1,  SyncResetV1,  SyncCompleteV1,  };

  SyncAckDto._();

  factory SyncAckDto([void updates(SyncAckDtoBuilder b)]) = _$SyncAckDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncAckDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncAckDto> get serializer => _$SyncAckDtoSerializer();
}

class _$SyncAckDtoSerializer implements PrimitiveSerializer<SyncAckDto> {
  @override
  final Iterable<Type> types = const [SyncAckDto, _$SyncAckDto];

  @override
  final String wireName = r'SyncAckDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncAckDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ack';
    yield serializers.serialize(
      object.ack,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(SyncEntityType),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncAckDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncAckDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ack':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ack = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SyncEntityType),
          ) as SyncEntityType;
          result.type = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncAckDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncAckDtoBuilder();
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


