//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/api_util.dart';
import 'package:openapi/src/model/asset_order.dart';
import 'package:openapi/src/model/asset_order_by.dart';
import 'package:openapi/src/model/asset_visibility.dart';
import 'package:openapi/src/model/time_bucket_asset_response_dto.dart';
import 'package:openapi/src/model/time_buckets_response_dto.dart';

class TimelineApi {

  final Dio _dio;

  final Serializers _serializers;

  const TimelineApi(this._dio, this._serializers);

  /// Get time bucket
  /// Retrieve a string of all asset ids in a given time bucket.
  ///
  /// Parameters:
  /// * [timeBucket] - Time bucket identifier in YYYY-MM-DDT00:00:00.000Z format
  /// * [albumId] - Filter assets belonging to a specific album
  /// * [bbox] - Bounding box coordinates as west,south,east,north (WGS84)
  /// * [isFavorite] - Filter by favorite status (true for favorites only, false for non-favorites only)
  /// * [isTrashed] - Filter by trash status (true for trashed assets only, false for non-trashed only)
  /// * [key] 
  /// * [order] - Sort order for assets within time buckets (ASC for oldest first, DESC for newest first)
  /// * [orderBy] - Date to group and order assets by (takenAt for date taken, createdAt for date added to Immich)
  /// * [personId] - Filter assets containing a specific person (face recognition)
  /// * [slug] 
  /// * [tagId] - Filter assets with a specific tag
  /// * [userId] - Filter assets by specific user ID
  /// * [visibility] - Filter by asset visibility status (ARCHIVE, TIMELINE, HIDDEN, LOCKED)
  /// * [withCoordinates] - Include location data in the response
  /// * [withPartners] - Include assets shared by partners
  /// * [withStacked] - Include stacked assets in the response. When true, only primary assets from stacks are returned.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [TimeBucketAssetResponseDto] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<TimeBucketAssetResponseDto>> getTimeBucket({ 
    required String timeBucket,
    String? albumId,
    String? bbox,
    bool? isFavorite,
    bool? isTrashed,
    String? key,
    AssetOrder? order,
    AssetOrderBy? orderBy,
    String? personId,
    String? slug,
    String? tagId,
    String? userId,
    AssetVisibility? visibility,
    bool? withCoordinates,
    bool? withPartners,
    bool? withStacked,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/timeline/bucket';
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'cookie',
            'keyName': 'immich_access_token',
            'where': '',
          },{
            'type': 'apiKey',
            'name': 'api_key',
            'keyName': 'x-api-key',
            'where': 'header',
          },{
            'type': 'http',
            'scheme': 'Bearer',
            'name': 'bearer',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      if (albumId != null) r'albumId': encodeQueryParameter(_serializers, albumId, const FullType(String)),
      if (bbox != null) r'bbox': encodeQueryParameter(_serializers, bbox, const FullType(String)),
      if (isFavorite != null) r'isFavorite': encodeQueryParameter(_serializers, isFavorite, const FullType(bool)),
      if (isTrashed != null) r'isTrashed': encodeQueryParameter(_serializers, isTrashed, const FullType(bool)),
      if (key != null) r'key': encodeQueryParameter(_serializers, key, const FullType(String)),
      if (order != null) r'order': encodeQueryParameter(_serializers, order, const FullType(AssetOrder)),
      if (orderBy != null) r'orderBy': encodeQueryParameter(_serializers, orderBy, const FullType(AssetOrderBy)),
      if (personId != null) r'personId': encodeQueryParameter(_serializers, personId, const FullType(String)),
      if (slug != null) r'slug': encodeQueryParameter(_serializers, slug, const FullType(String)),
      if (tagId != null) r'tagId': encodeQueryParameter(_serializers, tagId, const FullType(String)),
      r'timeBucket': encodeQueryParameter(_serializers, timeBucket, const FullType(String)),
      if (userId != null) r'userId': encodeQueryParameter(_serializers, userId, const FullType(String)),
      if (visibility != null) r'visibility': encodeQueryParameter(_serializers, visibility, const FullType(AssetVisibility)),
      if (withCoordinates != null) r'withCoordinates': encodeQueryParameter(_serializers, withCoordinates, const FullType(bool)),
      if (withPartners != null) r'withPartners': encodeQueryParameter(_serializers, withPartners, const FullType(bool)),
      if (withStacked != null) r'withStacked': encodeQueryParameter(_serializers, withStacked, const FullType(bool)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    TimeBucketAssetResponseDto? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(TimeBucketAssetResponseDto),
      ) as TimeBucketAssetResponseDto;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<TimeBucketAssetResponseDto>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// Get time buckets
  /// Retrieve a list of all minimal time buckets.
  ///
  /// Parameters:
  /// * [albumId] - Filter assets belonging to a specific album
  /// * [bbox] - Bounding box coordinates as west,south,east,north (WGS84)
  /// * [isFavorite] - Filter by favorite status (true for favorites only, false for non-favorites only)
  /// * [isTrashed] - Filter by trash status (true for trashed assets only, false for non-trashed only)
  /// * [key] 
  /// * [order] - Sort order for assets within time buckets (ASC for oldest first, DESC for newest first)
  /// * [orderBy] - Date to group and order assets by (takenAt for date taken, createdAt for date added to Immich)
  /// * [personId] - Filter assets containing a specific person (face recognition)
  /// * [slug] 
  /// * [tagId] - Filter assets with a specific tag
  /// * [userId] - Filter assets by specific user ID
  /// * [visibility] - Filter by asset visibility status (ARCHIVE, TIMELINE, HIDDEN, LOCKED)
  /// * [withCoordinates] - Include location data in the response
  /// * [withPartners] - Include assets shared by partners
  /// * [withStacked] - Include stacked assets in the response. When true, only primary assets from stacks are returned.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [BuiltList<TimeBucketsResponseDto>] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<BuiltList<TimeBucketsResponseDto>>> getTimeBuckets({ 
    String? albumId,
    String? bbox,
    bool? isFavorite,
    bool? isTrashed,
    String? key,
    AssetOrder? order,
    AssetOrderBy? orderBy,
    String? personId,
    String? slug,
    String? tagId,
    String? userId,
    AssetVisibility? visibility,
    bool? withCoordinates,
    bool? withPartners,
    bool? withStacked,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/timeline/buckets';
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'cookie',
            'keyName': 'immich_access_token',
            'where': '',
          },{
            'type': 'apiKey',
            'name': 'api_key',
            'keyName': 'x-api-key',
            'where': 'header',
          },{
            'type': 'http',
            'scheme': 'Bearer',
            'name': 'bearer',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      if (albumId != null) r'albumId': encodeQueryParameter(_serializers, albumId, const FullType(String)),
      if (bbox != null) r'bbox': encodeQueryParameter(_serializers, bbox, const FullType(String)),
      if (isFavorite != null) r'isFavorite': encodeQueryParameter(_serializers, isFavorite, const FullType(bool)),
      if (isTrashed != null) r'isTrashed': encodeQueryParameter(_serializers, isTrashed, const FullType(bool)),
      if (key != null) r'key': encodeQueryParameter(_serializers, key, const FullType(String)),
      if (order != null) r'order': encodeQueryParameter(_serializers, order, const FullType(AssetOrder)),
      if (orderBy != null) r'orderBy': encodeQueryParameter(_serializers, orderBy, const FullType(AssetOrderBy)),
      if (personId != null) r'personId': encodeQueryParameter(_serializers, personId, const FullType(String)),
      if (slug != null) r'slug': encodeQueryParameter(_serializers, slug, const FullType(String)),
      if (tagId != null) r'tagId': encodeQueryParameter(_serializers, tagId, const FullType(String)),
      if (userId != null) r'userId': encodeQueryParameter(_serializers, userId, const FullType(String)),
      if (visibility != null) r'visibility': encodeQueryParameter(_serializers, visibility, const FullType(AssetVisibility)),
      if (withCoordinates != null) r'withCoordinates': encodeQueryParameter(_serializers, withCoordinates, const FullType(bool)),
      if (withPartners != null) r'withPartners': encodeQueryParameter(_serializers, withPartners, const FullType(bool)),
      if (withStacked != null) r'withStacked': encodeQueryParameter(_serializers, withStacked, const FullType(bool)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    BuiltList<TimeBucketsResponseDto>? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(BuiltList, [FullType(TimeBucketsResponseDto)]),
      ) as BuiltList<TimeBucketsResponseDto>;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<BuiltList<TimeBucketsResponseDto>>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

}
