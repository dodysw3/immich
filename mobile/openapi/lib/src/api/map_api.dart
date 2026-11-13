//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/api_util.dart';
import 'package:openapi/src/model/map_marker_response_dto.dart';
import 'package:openapi/src/model/map_reverse_geocode_response_dto.dart';

class MapApi {

  final Dio _dio;

  final Serializers _serializers;

  const MapApi(this._dio, this._serializers);

  /// Retrieve map markers
  /// Retrieve a list of latitude and longitude coordinates for every asset with location data.
  ///
  /// Parameters:
  /// * [fileCreatedAfter] - Filter assets created after this date
  /// * [fileCreatedBefore] - Filter assets created before this date
  /// * [isArchived] - Filter by archived status
  /// * [isFavorite] - Filter by favorite status
  /// * [withPartners] - Include partner assets
  /// * [withSharedAlbums] - Include shared album assets
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [BuiltList<MapMarkerResponseDto>] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<BuiltList<MapMarkerResponseDto>>> getMapMarkers({ 
    DateTime? fileCreatedAfter,
    DateTime? fileCreatedBefore,
    bool? isArchived,
    bool? isFavorite,
    bool? withPartners,
    bool? withSharedAlbums,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/map/markers';
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
      if (fileCreatedAfter != null) r'fileCreatedAfter': encodeQueryParameter(_serializers, fileCreatedAfter, const FullType(DateTime)),
      if (fileCreatedBefore != null) r'fileCreatedBefore': encodeQueryParameter(_serializers, fileCreatedBefore, const FullType(DateTime)),
      if (isArchived != null) r'isArchived': encodeQueryParameter(_serializers, isArchived, const FullType(bool)),
      if (isFavorite != null) r'isFavorite': encodeQueryParameter(_serializers, isFavorite, const FullType(bool)),
      if (withPartners != null) r'withPartners': encodeQueryParameter(_serializers, withPartners, const FullType(bool)),
      if (withSharedAlbums != null) r'withSharedAlbums': encodeQueryParameter(_serializers, withSharedAlbums, const FullType(bool)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    BuiltList<MapMarkerResponseDto>? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(BuiltList, [FullType(MapMarkerResponseDto)]),
      ) as BuiltList<MapMarkerResponseDto>;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<BuiltList<MapMarkerResponseDto>>(
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

  /// Reverse geocode coordinates
  /// Retrieve location information (e.g., city, country) for given latitude and longitude coordinates.
  ///
  /// Parameters:
  /// * [lat] - Latitude (-90 to 90)
  /// * [lon] - Longitude (-180 to 180)
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [BuiltList<MapReverseGeocodeResponseDto>] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<BuiltList<MapReverseGeocodeResponseDto>>> reverseGeocode({ 
    required double lat,
    required double lon,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/map/reverse-geocode';
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
      r'lat': encodeQueryParameter(_serializers, lat, const FullType(double)),
      r'lon': encodeQueryParameter(_serializers, lon, const FullType(double)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    BuiltList<MapReverseGeocodeResponseDto>? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(BuiltList, [FullType(MapReverseGeocodeResponseDto)]),
      ) as BuiltList<MapReverseGeocodeResponseDto>;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<BuiltList<MapReverseGeocodeResponseDto>>(
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
