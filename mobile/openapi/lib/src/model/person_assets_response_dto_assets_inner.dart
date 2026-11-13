//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/asset_type_enum.dart';
import 'package:openapi/src/model/asset_visibility.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/asset_stack_response_dto.dart';
import 'package:openapi/src/model/exif_response_dto.dart';
import 'package:openapi/src/model/user_response_dto.dart';
import 'package:openapi/src/model/tag_response_dto.dart';
import 'package:openapi/src/model/person_response_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'person_assets_response_dto_assets_inner.g.dart';

/// PersonAssetsResponseDtoAssetsInner
///
/// Properties:
/// * [checksum] - Base64 encoded SHA1 hash
/// * [createdAt] - The UTC timestamp when the asset was originally uploaded to Immich.
/// * [duplicateId] - Duplicate group ID
/// * [duration] - Video/gif duration in milliseconds (null for static images)
/// * [exifInfo] 
/// * [fileCreatedAt] - The actual UTC timestamp when the file was created/captured, preserving timezone information. This is the authoritative timestamp for chronological sorting within timeline groups. Combined with timezone data, this can be used to determine the exact moment the photo was taken.
/// * [fileModifiedAt] - The UTC timestamp when the file was last modified on the filesystem. This reflects the last time the physical file was changed, which may be different from when the photo was originally taken.
/// * [hasMetadata] - Whether asset has metadata
/// * [height] - Asset height
/// * [id] - Asset ID
/// * [isArchived] - Is archived
/// * [isEdited] - Is edited
/// * [isFavorite] - Is favorite
/// * [isOffline] - Is offline
/// * [isTrashed] - Is trashed
/// * [libraryId] - Library ID
/// * [livePhotoVideoId] - Live photo video ID
/// * [localDateTime] - The local date and time when the photo/video was taken, derived from EXIF metadata. This represents the photographer's local time regardless of timezone, stored as a timezone-agnostic timestamp. Used for timeline grouping by \"local\" days and months.
/// * [originalFileName] - Original file name
/// * [originalMimeType] - Original MIME type
/// * [originalPath] - Original file path
/// * [owner] 
/// * [ownerId] - Owner user ID
/// * [people] 
/// * [recognizedAt] - When the face was matched to this person
/// * [resized] - Is resized
/// * [stack] 
/// * [tags] 
/// * [thumbhash] - Thumbhash for thumbnail generation (base64) also used as the c query param for thumbnail cache busting.
/// * [type] 
/// * [updatedAt] - The UTC timestamp when the asset record was last updated in the database. This is automatically maintained by the database and reflects when any field in the asset was last modified.
/// * [visibility] 
/// * [width] - Asset width
@BuiltValue()
abstract class PersonAssetsResponseDtoAssetsInner implements Built<PersonAssetsResponseDtoAssetsInner, PersonAssetsResponseDtoAssetsInnerBuilder> {
  /// Base64 encoded SHA1 hash
  @BuiltValueField(wireName: r'checksum')
  String get checksum;

  /// The UTC timestamp when the asset was originally uploaded to Immich.
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// Duplicate group ID
  @BuiltValueField(wireName: r'duplicateId')
  String? get duplicateId;

  /// Video/gif duration in milliseconds (null for static images)
  @BuiltValueField(wireName: r'duration')
  int? get duration;

  @BuiltValueField(wireName: r'exifInfo')
  ExifResponseDto? get exifInfo;

  /// The actual UTC timestamp when the file was created/captured, preserving timezone information. This is the authoritative timestamp for chronological sorting within timeline groups. Combined with timezone data, this can be used to determine the exact moment the photo was taken.
  @BuiltValueField(wireName: r'fileCreatedAt')
  DateTime get fileCreatedAt;

  /// The UTC timestamp when the file was last modified on the filesystem. This reflects the last time the physical file was changed, which may be different from when the photo was originally taken.
  @BuiltValueField(wireName: r'fileModifiedAt')
  DateTime get fileModifiedAt;

  /// Whether asset has metadata
  @BuiltValueField(wireName: r'hasMetadata')
  bool get hasMetadata;

  /// Asset height
  @BuiltValueField(wireName: r'height')
  int? get height;

  /// Asset ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Is archived
  @BuiltValueField(wireName: r'isArchived')
  bool get isArchived;

  /// Is edited
  @BuiltValueField(wireName: r'isEdited')
  bool get isEdited;

  /// Is favorite
  @BuiltValueField(wireName: r'isFavorite')
  bool get isFavorite;

  /// Is offline
  @BuiltValueField(wireName: r'isOffline')
  bool get isOffline;

  /// Is trashed
  @BuiltValueField(wireName: r'isTrashed')
  bool get isTrashed;

  /// Library ID
  @BuiltValueField(wireName: r'libraryId')
  String? get libraryId;

  /// Live photo video ID
  @BuiltValueField(wireName: r'livePhotoVideoId')
  String? get livePhotoVideoId;

  /// The local date and time when the photo/video was taken, derived from EXIF metadata. This represents the photographer's local time regardless of timezone, stored as a timezone-agnostic timestamp. Used for timeline grouping by \"local\" days and months.
  @BuiltValueField(wireName: r'localDateTime')
  DateTime get localDateTime;

  /// Original file name
  @BuiltValueField(wireName: r'originalFileName')
  String get originalFileName;

  /// Original MIME type
  @BuiltValueField(wireName: r'originalMimeType')
  String? get originalMimeType;

  /// Original file path
  @BuiltValueField(wireName: r'originalPath')
  String get originalPath;

  @BuiltValueField(wireName: r'owner')
  UserResponseDto? get owner;

  /// Owner user ID
  @BuiltValueField(wireName: r'ownerId')
  String get ownerId;

  @BuiltValueField(wireName: r'people')
  BuiltList<PersonResponseDto>? get people;

  /// When the face was matched to this person
  @BuiltValueField(wireName: r'recognizedAt')
  DateTime get recognizedAt;

  /// Is resized
  @BuiltValueField(wireName: r'resized')
  bool? get resized;

  @BuiltValueField(wireName: r'stack')
  AssetStackResponseDto? get stack;

  @BuiltValueField(wireName: r'tags')
  BuiltList<TagResponseDto>? get tags;

  /// Thumbhash for thumbnail generation (base64) also used as the c query param for thumbnail cache busting.
  @BuiltValueField(wireName: r'thumbhash')
  String? get thumbhash;

  @BuiltValueField(wireName: r'type')
  AssetTypeEnum get type;
  // enum typeEnum {  IMAGE,  VIDEO,  AUDIO,  OTHER,  };

  /// The UTC timestamp when the asset record was last updated in the database. This is automatically maintained by the database and reflects when any field in the asset was last modified.
  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'visibility')
  AssetVisibility get visibility;
  // enum visibilityEnum {  archive,  timeline,  hidden,  locked,  };

  /// Asset width
  @BuiltValueField(wireName: r'width')
  int? get width;

  PersonAssetsResponseDtoAssetsInner._();

  factory PersonAssetsResponseDtoAssetsInner([void updates(PersonAssetsResponseDtoAssetsInnerBuilder b)]) = _$PersonAssetsResponseDtoAssetsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PersonAssetsResponseDtoAssetsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PersonAssetsResponseDtoAssetsInner> get serializer => _$PersonAssetsResponseDtoAssetsInnerSerializer();
}

class _$PersonAssetsResponseDtoAssetsInnerSerializer implements PrimitiveSerializer<PersonAssetsResponseDtoAssetsInner> {
  @override
  final Iterable<Type> types = const [PersonAssetsResponseDtoAssetsInner, _$PersonAssetsResponseDtoAssetsInner];

  @override
  final String wireName = r'PersonAssetsResponseDtoAssetsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PersonAssetsResponseDtoAssetsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'checksum';
    yield serializers.serialize(
      object.checksum,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.duplicateId != null) {
      yield r'duplicateId';
      yield serializers.serialize(
        object.duplicateId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'duration';
    yield object.duration == null ? null : serializers.serialize(
      object.duration,
      specifiedType: const FullType.nullable(int),
    );
    if (object.exifInfo != null) {
      yield r'exifInfo';
      yield serializers.serialize(
        object.exifInfo,
        specifiedType: const FullType(ExifResponseDto),
      );
    }
    yield r'fileCreatedAt';
    yield serializers.serialize(
      object.fileCreatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'fileModifiedAt';
    yield serializers.serialize(
      object.fileModifiedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'hasMetadata';
    yield serializers.serialize(
      object.hasMetadata,
      specifiedType: const FullType(bool),
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
    yield r'isArchived';
    yield serializers.serialize(
      object.isArchived,
      specifiedType: const FullType(bool),
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
    yield r'isOffline';
    yield serializers.serialize(
      object.isOffline,
      specifiedType: const FullType(bool),
    );
    yield r'isTrashed';
    yield serializers.serialize(
      object.isTrashed,
      specifiedType: const FullType(bool),
    );
    if (object.libraryId != null) {
      yield r'libraryId';
      yield serializers.serialize(
        object.libraryId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.livePhotoVideoId != null) {
      yield r'livePhotoVideoId';
      yield serializers.serialize(
        object.livePhotoVideoId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'localDateTime';
    yield serializers.serialize(
      object.localDateTime,
      specifiedType: const FullType(DateTime),
    );
    yield r'originalFileName';
    yield serializers.serialize(
      object.originalFileName,
      specifiedType: const FullType(String),
    );
    if (object.originalMimeType != null) {
      yield r'originalMimeType';
      yield serializers.serialize(
        object.originalMimeType,
        specifiedType: const FullType(String),
      );
    }
    yield r'originalPath';
    yield serializers.serialize(
      object.originalPath,
      specifiedType: const FullType(String),
    );
    if (object.owner != null) {
      yield r'owner';
      yield serializers.serialize(
        object.owner,
        specifiedType: const FullType(UserResponseDto),
      );
    }
    yield r'ownerId';
    yield serializers.serialize(
      object.ownerId,
      specifiedType: const FullType(String),
    );
    if (object.people != null) {
      yield r'people';
      yield serializers.serialize(
        object.people,
        specifiedType: const FullType(BuiltList, [FullType(PersonResponseDto)]),
      );
    }
    yield r'recognizedAt';
    yield serializers.serialize(
      object.recognizedAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.resized != null) {
      yield r'resized';
      yield serializers.serialize(
        object.resized,
        specifiedType: const FullType(bool),
      );
    }
    if (object.stack != null) {
      yield r'stack';
      yield serializers.serialize(
        object.stack,
        specifiedType: const FullType.nullable(AssetStackResponseDto),
      );
    }
    if (object.tags != null) {
      yield r'tags';
      yield serializers.serialize(
        object.tags,
        specifiedType: const FullType(BuiltList, [FullType(TagResponseDto)]),
      );
    }
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
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
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
    PersonAssetsResponseDtoAssetsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PersonAssetsResponseDtoAssetsInnerBuilder result,
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
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'duplicateId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.duplicateId = valueDes;
          break;
        case r'duration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.duration = valueDes;
          break;
        case r'exifInfo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ExifResponseDto),
          ) as ExifResponseDto?;
          if (valueDes == null) continue;
          result.exifInfo.replace(valueDes);
          break;
        case r'fileCreatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.fileCreatedAt = valueDes;
          break;
        case r'fileModifiedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.fileModifiedAt = valueDes;
          break;
        case r'hasMetadata':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasMetadata = valueDes;
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
        case r'isArchived':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isArchived = valueDes;
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
        case r'isOffline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isOffline = valueDes;
          break;
        case r'isTrashed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isTrashed = valueDes;
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
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.localDateTime = valueDes;
          break;
        case r'originalFileName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.originalFileName = valueDes;
          break;
        case r'originalMimeType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.originalMimeType = valueDes;
          break;
        case r'originalPath':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.originalPath = valueDes;
          break;
        case r'owner':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(UserResponseDto),
          ) as UserResponseDto?;
          if (valueDes == null) continue;
          result.owner.replace(valueDes);
          break;
        case r'ownerId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ownerId = valueDes;
          break;
        case r'people':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(PersonResponseDto)]),
          ) as BuiltList<PersonResponseDto>?;
          if (valueDes == null) continue;
          result.people.replace(valueDes);
          break;
        case r'recognizedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.recognizedAt = valueDes;
          break;
        case r'resized':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.resized = valueDes;
          break;
        case r'stack':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AssetStackResponseDto),
          ) as AssetStackResponseDto?;
          if (valueDes == null) continue;
          result.stack.replace(valueDes);
          break;
        case r'tags':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(TagResponseDto)]),
          ) as BuiltList<TagResponseDto>?;
          if (valueDes == null) continue;
          result.tags.replace(valueDes);
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
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
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
  PersonAssetsResponseDtoAssetsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PersonAssetsResponseDtoAssetsInnerBuilder();
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


