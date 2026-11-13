//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/asset_type_enum.dart';
import 'package:openapi/src/model/asset_visibility.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_asset_v1.g.dart';

/// SyncAssetV1
///
/// Properties:
/// * [checksum] - Checksum
/// * [createdAt] - Uploaded to Immich at
/// * [deletedAt] - Deleted at
/// * [duration] - Duration
/// * [fileCreatedAt] - File created at
/// * [fileModifiedAt] - File modified at
/// * [height] - Asset height
/// * [id] - Asset ID
/// * [isEdited] - Is edited
/// * [isFavorite] - Is favorite
/// * [libraryId] - Library ID
/// * [livePhotoVideoId] - Live photo video ID
/// * [localDateTime] - Local date time
/// * [originalFileName] - Original file name
/// * [ownerId] - Owner ID
/// * [stackId] - Stack ID
/// * [thumbhash] - Thumbhash
/// * [type] 
/// * [visibility] 
/// * [width] - Asset width
@BuiltValue()
abstract class SyncAssetV1 implements Built<SyncAssetV1, SyncAssetV1Builder> {
  /// Checksum
  @BuiltValueField(wireName: r'checksum')
  String get checksum;

  /// Uploaded to Immich at
  @BuiltValueField(wireName: r'createdAt')
  DateTime? get createdAt;

  /// Deleted at
  @BuiltValueField(wireName: r'deletedAt')
  DateTime? get deletedAt;

  /// Duration
  @BuiltValueField(wireName: r'duration')
  String? get duration;

  /// File created at
  @BuiltValueField(wireName: r'fileCreatedAt')
  DateTime? get fileCreatedAt;

  /// File modified at
  @BuiltValueField(wireName: r'fileModifiedAt')
  DateTime? get fileModifiedAt;

  /// Asset height
  @BuiltValueField(wireName: r'height')
  int? get height;

  /// Asset ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Is edited
  @BuiltValueField(wireName: r'isEdited')
  bool get isEdited;

  /// Is favorite
  @BuiltValueField(wireName: r'isFavorite')
  bool get isFavorite;

  /// Library ID
  @BuiltValueField(wireName: r'libraryId')
  String? get libraryId;

  /// Live photo video ID
  @BuiltValueField(wireName: r'livePhotoVideoId')
  String? get livePhotoVideoId;

  /// Local date time
  @BuiltValueField(wireName: r'localDateTime')
  DateTime? get localDateTime;

  /// Original file name
  @BuiltValueField(wireName: r'originalFileName')
  String get originalFileName;

  /// Owner ID
  @BuiltValueField(wireName: r'ownerId')
  String get ownerId;

  /// Stack ID
  @BuiltValueField(wireName: r'stackId')
  String? get stackId;

  /// Thumbhash
  @BuiltValueField(wireName: r'thumbhash')
  String? get thumbhash;

  @BuiltValueField(wireName: r'type')
  AssetTypeEnum get type;
  // enum typeEnum {  IMAGE,  VIDEO,  AUDIO,  OTHER,  };

  @BuiltValueField(wireName: r'visibility')
  AssetVisibility get visibility;
  // enum visibilityEnum {  archive,  timeline,  hidden,  locked,  };

  /// Asset width
  @BuiltValueField(wireName: r'width')
  int? get width;

  SyncAssetV1._();

  factory SyncAssetV1([void updates(SyncAssetV1Builder b)]) = _$SyncAssetV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncAssetV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncAssetV1> get serializer => _$SyncAssetV1Serializer();
}

class _$SyncAssetV1Serializer implements PrimitiveSerializer<SyncAssetV1> {
  @override
  final Iterable<Type> types = const [SyncAssetV1, _$SyncAssetV1];

  @override
  final String wireName = r'SyncAssetV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncAssetV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'checksum';
    yield serializers.serialize(
      object.checksum,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield object.createdAt == null ? null : serializers.serialize(
      object.createdAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'deletedAt';
    yield object.deletedAt == null ? null : serializers.serialize(
      object.deletedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'duration';
    yield object.duration == null ? null : serializers.serialize(
      object.duration,
      specifiedType: const FullType.nullable(String),
    );
    yield r'fileCreatedAt';
    yield object.fileCreatedAt == null ? null : serializers.serialize(
      object.fileCreatedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'fileModifiedAt';
    yield object.fileModifiedAt == null ? null : serializers.serialize(
      object.fileModifiedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'height';
    yield object.height == null ? null : serializers.serialize(
      object.height,
      specifiedType: const FullType.nullable(int),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'isEdited';
    yield serializers.serialize(
      object.isEdited,
      specifiedType: const FullType(bool),
    );
    yield r'isFavorite';
    yield serializers.serialize(
      object.isFavorite,
      specifiedType: const FullType(bool),
    );
    yield r'libraryId';
    yield object.libraryId == null ? null : serializers.serialize(
      object.libraryId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'livePhotoVideoId';
    yield object.livePhotoVideoId == null ? null : serializers.serialize(
      object.livePhotoVideoId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'localDateTime';
    yield object.localDateTime == null ? null : serializers.serialize(
      object.localDateTime,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'originalFileName';
    yield serializers.serialize(
      object.originalFileName,
      specifiedType: const FullType(String),
    );
    yield r'ownerId';
    yield serializers.serialize(
      object.ownerId,
      specifiedType: const FullType(String),
    );
    yield r'stackId';
    yield object.stackId == null ? null : serializers.serialize(
      object.stackId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'thumbhash';
    yield object.thumbhash == null ? null : serializers.serialize(
      object.thumbhash,
      specifiedType: const FullType.nullable(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(AssetTypeEnum),
    );
    yield r'visibility';
    yield serializers.serialize(
      object.visibility,
      specifiedType: const FullType(AssetVisibility),
    );
    yield r'width';
    yield object.width == null ? null : serializers.serialize(
      object.width,
      specifiedType: const FullType.nullable(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncAssetV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncAssetV1Builder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'checksum':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.checksum = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        case r'deletedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.deletedAt = valueDes;
          break;
        case r'duration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.duration = valueDes;
          break;
        case r'fileCreatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.fileCreatedAt = valueDes;
          break;
        case r'fileModifiedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.fileModifiedAt = valueDes;
          break;
        case r'height':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.height = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'isEdited':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isEdited = valueDes;
          break;
        case r'isFavorite':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isFavorite = valueDes;
          break;
        case r'libraryId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.libraryId = valueDes;
          break;
        case r'livePhotoVideoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.livePhotoVideoId = valueDes;
          break;
        case r'localDateTime':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.localDateTime = valueDes;
          break;
        case r'originalFileName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.originalFileName = valueDes;
          break;
        case r'ownerId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ownerId = valueDes;
          break;
        case r'stackId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.stackId = valueDes;
          break;
        case r'thumbhash':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.thumbhash = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AssetTypeEnum),
          ) as AssetTypeEnum;
          result.type = valueDes;
          break;
        case r'visibility':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AssetVisibility),
          ) as AssetVisibility;
          result.visibility = valueDes;
          break;
        case r'width':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.width = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncAssetV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncAssetV1Builder();
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


