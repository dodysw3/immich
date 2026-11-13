//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_request_type.g.dart';

/// Sync request type
class SyncRequestType extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AlbumsV1')
  static const SyncRequestType albumsV1 = _$albumsV1;
  @BuiltValueEnumConst(wireName: r'AlbumsV2')
  static const SyncRequestType albumsV2 = _$albumsV2;
  @BuiltValueEnumConst(wireName: r'AlbumUsersV1')
  static const SyncRequestType albumUsersV1 = _$albumUsersV1;
  @BuiltValueEnumConst(wireName: r'AlbumToAssetsV1')
  static const SyncRequestType albumToAssetsV1 = _$albumToAssetsV1;
  @BuiltValueEnumConst(wireName: r'AlbumAssetsV1')
  static const SyncRequestType albumAssetsV1 = _$albumAssetsV1;
  @BuiltValueEnumConst(wireName: r'AlbumAssetsV2')
  static const SyncRequestType albumAssetsV2 = _$albumAssetsV2;
  @BuiltValueEnumConst(wireName: r'AlbumAssetExifsV1')
  static const SyncRequestType albumAssetExifsV1 = _$albumAssetExifsV1;
  @BuiltValueEnumConst(wireName: r'AssetsV1')
  static const SyncRequestType assetsV1 = _$assetsV1;
  @BuiltValueEnumConst(wireName: r'AssetsV2')
  static const SyncRequestType assetsV2 = _$assetsV2;
  @BuiltValueEnumConst(wireName: r'AssetExifsV1')
  static const SyncRequestType assetExifsV1 = _$assetExifsV1;
  @BuiltValueEnumConst(wireName: r'AssetEditsV1')
  static const SyncRequestType assetEditsV1 = _$assetEditsV1;
  @BuiltValueEnumConst(wireName: r'AssetMetadataV1')
  static const SyncRequestType assetMetadataV1 = _$assetMetadataV1;
  @BuiltValueEnumConst(wireName: r'AssetOcrV1')
  static const SyncRequestType assetOcrV1 = _$assetOcrV1;
  @BuiltValueEnumConst(wireName: r'AuthUsersV1')
  static const SyncRequestType authUsersV1 = _$authUsersV1;
  @BuiltValueEnumConst(wireName: r'AuthUsersV2')
  static const SyncRequestType authUsersV2 = _$authUsersV2;
  @BuiltValueEnumConst(wireName: r'MemoriesV1')
  static const SyncRequestType memoriesV1 = _$memoriesV1;
  @BuiltValueEnumConst(wireName: r'MemoriesV2')
  static const SyncRequestType memoriesV2 = _$memoriesV2;
  @BuiltValueEnumConst(wireName: r'MemoryToAssetsV1')
  static const SyncRequestType memoryToAssetsV1 = _$memoryToAssetsV1;
  @BuiltValueEnumConst(wireName: r'MemoryToAssetsV2')
  static const SyncRequestType memoryToAssetsV2 = _$memoryToAssetsV2;
  @BuiltValueEnumConst(wireName: r'PartnersV1')
  static const SyncRequestType partnersV1 = _$partnersV1;
  @BuiltValueEnumConst(wireName: r'PartnerAssetsV1')
  static const SyncRequestType partnerAssetsV1 = _$partnerAssetsV1;
  @BuiltValueEnumConst(wireName: r'PartnerAssetsV2')
  static const SyncRequestType partnerAssetsV2 = _$partnerAssetsV2;
  @BuiltValueEnumConst(wireName: r'PartnerAssetExifsV1')
  static const SyncRequestType partnerAssetExifsV1 = _$partnerAssetExifsV1;
  @BuiltValueEnumConst(wireName: r'PartnerStacksV1')
  static const SyncRequestType partnerStacksV1 = _$partnerStacksV1;
  @BuiltValueEnumConst(wireName: r'StacksV1')
  static const SyncRequestType stacksV1 = _$stacksV1;
  @BuiltValueEnumConst(wireName: r'UsersV1')
  static const SyncRequestType usersV1 = _$usersV1;
  @BuiltValueEnumConst(wireName: r'PeopleV1')
  static const SyncRequestType peopleV1 = _$peopleV1;
  @BuiltValueEnumConst(wireName: r'AssetFacesV1')
  static const SyncRequestType assetFacesV1 = _$assetFacesV1;
  @BuiltValueEnumConst(wireName: r'AssetFacesV2')
  static const SyncRequestType assetFacesV2 = _$assetFacesV2;
  @BuiltValueEnumConst(wireName: r'AssetFacesV3')
  static const SyncRequestType assetFacesV3 = _$assetFacesV3;
  @BuiltValueEnumConst(wireName: r'UserMetadataV1')
  static const SyncRequestType userMetadataV1 = _$userMetadataV1;

  static Serializer<SyncRequestType> get serializer => _$syncRequestTypeSerializer;

  const SyncRequestType._(String name): super(name);

  static BuiltSet<SyncRequestType> get values => _$values;
  static SyncRequestType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class SyncRequestTypeMixin = Object with _$SyncRequestTypeMixin;

