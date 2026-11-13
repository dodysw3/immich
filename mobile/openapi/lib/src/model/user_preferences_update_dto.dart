//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/avatar_update.dart';
import 'package:openapi/src/model/purchase_update.dart';
import 'package:openapi/src/model/email_notifications_update.dart';
import 'package:openapi/src/model/cast_update.dart';
import 'package:openapi/src/model/folders_update.dart';
import 'package:openapi/src/model/people_update.dart';
import 'package:openapi/src/model/tags_update.dart';
import 'package:openapi/src/model/ratings_update.dart';
import 'package:openapi/src/model/recently_added_update.dart';
import 'package:openapi/src/model/download_update.dart';
import 'package:openapi/src/model/albums_update.dart';
import 'package:openapi/src/model/memories_update.dart';
import 'package:openapi/src/model/shared_links_update.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_preferences_update_dto.g.dart';

/// UserPreferencesUpdateDto
///
/// Properties:
/// * [albums] 
/// * [avatar] 
/// * [cast] 
/// * [download] 
/// * [emailNotifications] 
/// * [folders] 
/// * [memories] 
/// * [people] 
/// * [purchase] 
/// * [ratings] 
/// * [recentlyAdded] 
/// * [sharedLinks] 
/// * [tags] 
@BuiltValue()
abstract class UserPreferencesUpdateDto implements Built<UserPreferencesUpdateDto, UserPreferencesUpdateDtoBuilder> {
  @BuiltValueField(wireName: r'albums')
  AlbumsUpdate? get albums;

  @BuiltValueField(wireName: r'avatar')
  AvatarUpdate? get avatar;

  @BuiltValueField(wireName: r'cast')
  CastUpdate? get cast;

  @BuiltValueField(wireName: r'download')
  DownloadUpdate? get download;

  @BuiltValueField(wireName: r'emailNotifications')
  EmailNotificationsUpdate? get emailNotifications;

  @BuiltValueField(wireName: r'folders')
  FoldersUpdate? get folders;

  @BuiltValueField(wireName: r'memories')
  MemoriesUpdate? get memories;

  @BuiltValueField(wireName: r'people')
  PeopleUpdate? get people;

  @BuiltValueField(wireName: r'purchase')
  PurchaseUpdate? get purchase;

  @BuiltValueField(wireName: r'ratings')
  RatingsUpdate? get ratings;

  @BuiltValueField(wireName: r'recentlyAdded')
  RecentlyAddedUpdate? get recentlyAdded;

  @BuiltValueField(wireName: r'sharedLinks')
  SharedLinksUpdate? get sharedLinks;

  @BuiltValueField(wireName: r'tags')
  TagsUpdate? get tags;

  UserPreferencesUpdateDto._();

  factory UserPreferencesUpdateDto([void updates(UserPreferencesUpdateDtoBuilder b)]) = _$UserPreferencesUpdateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserPreferencesUpdateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserPreferencesUpdateDto> get serializer => _$UserPreferencesUpdateDtoSerializer();
}

class _$UserPreferencesUpdateDtoSerializer implements PrimitiveSerializer<UserPreferencesUpdateDto> {
  @override
  final Iterable<Type> types = const [UserPreferencesUpdateDto, _$UserPreferencesUpdateDto];

  @override
  final String wireName = r'UserPreferencesUpdateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserPreferencesUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.albums != null) {
      yield r'albums';
      yield serializers.serialize(
        object.albums,
        specifiedType: const FullType(AlbumsUpdate),
      );
    }
    if (object.avatar != null) {
      yield r'avatar';
      yield serializers.serialize(
        object.avatar,
        specifiedType: const FullType(AvatarUpdate),
      );
    }
    if (object.cast != null) {
      yield r'cast';
      yield serializers.serialize(
        object.cast,
        specifiedType: const FullType(CastUpdate),
      );
    }
    if (object.download != null) {
      yield r'download';
      yield serializers.serialize(
        object.download,
        specifiedType: const FullType(DownloadUpdate),
      );
    }
    if (object.emailNotifications != null) {
      yield r'emailNotifications';
      yield serializers.serialize(
        object.emailNotifications,
        specifiedType: const FullType(EmailNotificationsUpdate),
      );
    }
    if (object.folders != null) {
      yield r'folders';
      yield serializers.serialize(
        object.folders,
        specifiedType: const FullType(FoldersUpdate),
      );
    }
    if (object.memories != null) {
      yield r'memories';
      yield serializers.serialize(
        object.memories,
        specifiedType: const FullType(MemoriesUpdate),
      );
    }
    if (object.people != null) {
      yield r'people';
      yield serializers.serialize(
        object.people,
        specifiedType: const FullType(PeopleUpdate),
      );
    }
    if (object.purchase != null) {
      yield r'purchase';
      yield serializers.serialize(
        object.purchase,
        specifiedType: const FullType(PurchaseUpdate),
      );
    }
    if (object.ratings != null) {
      yield r'ratings';
      yield serializers.serialize(
        object.ratings,
        specifiedType: const FullType(RatingsUpdate),
      );
    }
    if (object.recentlyAdded != null) {
      yield r'recentlyAdded';
      yield serializers.serialize(
        object.recentlyAdded,
        specifiedType: const FullType(RecentlyAddedUpdate),
      );
    }
    if (object.sharedLinks != null) {
      yield r'sharedLinks';
      yield serializers.serialize(
        object.sharedLinks,
        specifiedType: const FullType(SharedLinksUpdate),
      );
    }
    if (object.tags != null) {
      yield r'tags';
      yield serializers.serialize(
        object.tags,
        specifiedType: const FullType(TagsUpdate),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UserPreferencesUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserPreferencesUpdateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'albums':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AlbumsUpdate),
          ) as AlbumsUpdate?;
          if (valueDes == null) continue;
          result.albums.replace(valueDes);
          break;
        case r'avatar':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AvatarUpdate),
          ) as AvatarUpdate?;
          if (valueDes == null) continue;
          result.avatar.replace(valueDes);
          break;
        case r'cast':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CastUpdate),
          ) as CastUpdate?;
          if (valueDes == null) continue;
          result.cast.replace(valueDes);
          break;
        case r'download':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DownloadUpdate),
          ) as DownloadUpdate?;
          if (valueDes == null) continue;
          result.download.replace(valueDes);
          break;
        case r'emailNotifications':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(EmailNotificationsUpdate),
          ) as EmailNotificationsUpdate?;
          if (valueDes == null) continue;
          result.emailNotifications.replace(valueDes);
          break;
        case r'folders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(FoldersUpdate),
          ) as FoldersUpdate?;
          if (valueDes == null) continue;
          result.folders.replace(valueDes);
          break;
        case r'memories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MemoriesUpdate),
          ) as MemoriesUpdate?;
          if (valueDes == null) continue;
          result.memories.replace(valueDes);
          break;
        case r'people':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PeopleUpdate),
          ) as PeopleUpdate?;
          if (valueDes == null) continue;
          result.people.replace(valueDes);
          break;
        case r'purchase':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PurchaseUpdate),
          ) as PurchaseUpdate?;
          if (valueDes == null) continue;
          result.purchase.replace(valueDes);
          break;
        case r'ratings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(RatingsUpdate),
          ) as RatingsUpdate?;
          if (valueDes == null) continue;
          result.ratings.replace(valueDes);
          break;
        case r'recentlyAdded':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(RecentlyAddedUpdate),
          ) as RecentlyAddedUpdate?;
          if (valueDes == null) continue;
          result.recentlyAdded.replace(valueDes);
          break;
        case r'sharedLinks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SharedLinksUpdate),
          ) as SharedLinksUpdate?;
          if (valueDes == null) continue;
          result.sharedLinks.replace(valueDes);
          break;
        case r'tags':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(TagsUpdate),
          ) as TagsUpdate?;
          if (valueDes == null) continue;
          result.tags.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserPreferencesUpdateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserPreferencesUpdateDtoBuilder();
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


