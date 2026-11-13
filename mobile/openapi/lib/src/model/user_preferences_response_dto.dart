//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/download_response.dart';
import 'package:openapi/src/model/people_response.dart';
import 'package:openapi/src/model/folders_response.dart';
import 'package:openapi/src/model/purchase_response.dart';
import 'package:openapi/src/model/recently_added_response.dart';
import 'package:openapi/src/model/cast_response.dart';
import 'package:openapi/src/model/shared_links_response.dart';
import 'package:openapi/src/model/albums_response.dart';
import 'package:openapi/src/model/email_notifications_response.dart';
import 'package:openapi/src/model/ratings_response.dart';
import 'package:openapi/src/model/memories_response.dart';
import 'package:openapi/src/model/tags_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_preferences_response_dto.g.dart';

/// UserPreferencesResponseDto
///
/// Properties:
/// * [albums] 
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
abstract class UserPreferencesResponseDto implements Built<UserPreferencesResponseDto, UserPreferencesResponseDtoBuilder> {
  @BuiltValueField(wireName: r'albums')
  AlbumsResponse get albums;

  @BuiltValueField(wireName: r'cast')
  CastResponse get cast;

  @BuiltValueField(wireName: r'download')
  DownloadResponse get download;

  @BuiltValueField(wireName: r'emailNotifications')
  EmailNotificationsResponse get emailNotifications;

  @BuiltValueField(wireName: r'folders')
  FoldersResponse get folders;

  @BuiltValueField(wireName: r'memories')
  MemoriesResponse get memories;

  @BuiltValueField(wireName: r'people')
  PeopleResponse get people;

  @BuiltValueField(wireName: r'purchase')
  PurchaseResponse get purchase;

  @BuiltValueField(wireName: r'ratings')
  RatingsResponse get ratings;

  @BuiltValueField(wireName: r'recentlyAdded')
  RecentlyAddedResponse get recentlyAdded;

  @BuiltValueField(wireName: r'sharedLinks')
  SharedLinksResponse get sharedLinks;

  @BuiltValueField(wireName: r'tags')
  TagsResponse get tags;

  UserPreferencesResponseDto._();

  factory UserPreferencesResponseDto([void updates(UserPreferencesResponseDtoBuilder b)]) = _$UserPreferencesResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserPreferencesResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserPreferencesResponseDto> get serializer => _$UserPreferencesResponseDtoSerializer();
}

class _$UserPreferencesResponseDtoSerializer implements PrimitiveSerializer<UserPreferencesResponseDto> {
  @override
  final Iterable<Type> types = const [UserPreferencesResponseDto, _$UserPreferencesResponseDto];

  @override
  final String wireName = r'UserPreferencesResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserPreferencesResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'albums';
    yield serializers.serialize(
      object.albums,
      specifiedType: const FullType(AlbumsResponse),
    );
    yield r'cast';
    yield serializers.serialize(
      object.cast,
      specifiedType: const FullType(CastResponse),
    );
    yield r'download';
    yield serializers.serialize(
      object.download,
      specifiedType: const FullType(DownloadResponse),
    );
    yield r'emailNotifications';
    yield serializers.serialize(
      object.emailNotifications,
      specifiedType: const FullType(EmailNotificationsResponse),
    );
    yield r'folders';
    yield serializers.serialize(
      object.folders,
      specifiedType: const FullType(FoldersResponse),
    );
    yield r'memories';
    yield serializers.serialize(
      object.memories,
      specifiedType: const FullType(MemoriesResponse),
    );
    yield r'people';
    yield serializers.serialize(
      object.people,
      specifiedType: const FullType(PeopleResponse),
    );
    yield r'purchase';
    yield serializers.serialize(
      object.purchase,
      specifiedType: const FullType(PurchaseResponse),
    );
    yield r'ratings';
    yield serializers.serialize(
      object.ratings,
      specifiedType: const FullType(RatingsResponse),
    );
    yield r'recentlyAdded';
    yield serializers.serialize(
      object.recentlyAdded,
      specifiedType: const FullType(RecentlyAddedResponse),
    );
    yield r'sharedLinks';
    yield serializers.serialize(
      object.sharedLinks,
      specifiedType: const FullType(SharedLinksResponse),
    );
    yield r'tags';
    yield serializers.serialize(
      object.tags,
      specifiedType: const FullType(TagsResponse),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserPreferencesResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserPreferencesResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'albums':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AlbumsResponse),
          ) as AlbumsResponse;
          result.albums.replace(valueDes);
          break;
        case r'cast':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CastResponse),
          ) as CastResponse;
          result.cast.replace(valueDes);
          break;
        case r'download':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DownloadResponse),
          ) as DownloadResponse;
          result.download.replace(valueDes);
          break;
        case r'emailNotifications':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EmailNotificationsResponse),
          ) as EmailNotificationsResponse;
          result.emailNotifications.replace(valueDes);
          break;
        case r'folders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FoldersResponse),
          ) as FoldersResponse;
          result.folders.replace(valueDes);
          break;
        case r'memories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MemoriesResponse),
          ) as MemoriesResponse;
          result.memories.replace(valueDes);
          break;
        case r'people':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PeopleResponse),
          ) as PeopleResponse;
          result.people.replace(valueDes);
          break;
        case r'purchase':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PurchaseResponse),
          ) as PurchaseResponse;
          result.purchase.replace(valueDes);
          break;
        case r'ratings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RatingsResponse),
          ) as RatingsResponse;
          result.ratings.replace(valueDes);
          break;
        case r'recentlyAdded':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RecentlyAddedResponse),
          ) as RecentlyAddedResponse;
          result.recentlyAdded.replace(valueDes);
          break;
        case r'sharedLinks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SharedLinksResponse),
          ) as SharedLinksResponse;
          result.sharedLinks.replace(valueDes);
          break;
        case r'tags':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TagsResponse),
          ) as TagsResponse;
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
  UserPreferencesResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserPreferencesResponseDtoBuilder();
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


