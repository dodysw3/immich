# openapi.model.AlbumResponseDto

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**albumName** | **String** | Album name | 
**albumThumbnailAssetId** | **String** | Thumbnail asset ID | 
**albumUsers** | [**BuiltList&lt;AlbumUserResponseDto&gt;**](AlbumUserResponseDto.md) | First entry is always the album owner. Second entry is the auth user, if it differs from the owner. The rest are ordered alphabetically. | 
**assetCount** | **int** | Number of assets | 
**contributorCounts** | [**BuiltList&lt;ContributorCountResponseDto&gt;**](ContributorCountResponseDto.md) |  | [optional] 
**createdAt** | [**DateTime**](DateTime.md) | Creation date | 
**description** | **String** | Album description | 
**endDate** | [**DateTime**](DateTime.md) | UTC representation of (local) end date (latest asset) | [optional] 
**hasSharedLink** | **bool** | Has shared link | 
**id** | **String** | Album ID | 
**isActivityEnabled** | **bool** | Activity feed enabled | 
**lastModifiedAssetTimestamp** | [**DateTime**](DateTime.md) | Last modified asset timestamp | [optional] 
**order** | [**AssetOrder**](AssetOrder.md) |  | [optional] 
**shared** | **bool** | Is shared album | 
**startDate** | [**DateTime**](DateTime.md) | UTC representation of (local) start date (earliest asset) | [optional] 
**updatedAt** | [**DateTime**](DateTime.md) | Last update date | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


