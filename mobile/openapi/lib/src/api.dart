//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:dio/dio.dart';
import 'package:built_value/serializer.dart';
import 'package:openapi/src/serializers.dart';
import 'package:openapi/src/auth/api_key_auth.dart';
import 'package:openapi/src/auth/basic_auth.dart';
import 'package:openapi/src/auth/bearer_auth.dart';
import 'package:openapi/src/auth/oauth.dart';
import 'package:openapi/src/api/api_keys_api.dart';
import 'package:openapi/src/api/activities_api.dart';
import 'package:openapi/src/api/albums_api.dart';
import 'package:openapi/src/api/asset_files_api.dart';
import 'package:openapi/src/api/assets_api.dart';
import 'package:openapi/src/api/authentication_api.dart';
import 'package:openapi/src/api/authentication_admin_api.dart';
import 'package:openapi/src/api/cluster_groups_api.dart';
import 'package:openapi/src/api/config_admin_api.dart';
import 'package:openapi/src/api/config_public_api.dart';
import 'package:openapi/src/api/config_user_api.dart';
import 'package:openapi/src/api/database_backups_admin_api.dart';
import 'package:openapi/src/api/deprecated_api.dart';
import 'package:openapi/src/api/documents_api.dart';
import 'package:openapi/src/api/download_api.dart';
import 'package:openapi/src/api/duplicates_api.dart';
import 'package:openapi/src/api/faces_api.dart';
import 'package:openapi/src/api/jobs_api.dart';
import 'package:openapi/src/api/libraries_api.dart';
import 'package:openapi/src/api/maintenance_admin_api.dart';
import 'package:openapi/src/api/map_api.dart';
import 'package:openapi/src/api/memories_api.dart';
import 'package:openapi/src/api/notifications_api.dart';
import 'package:openapi/src/api/notifications_admin_api.dart';
import 'package:openapi/src/api/partners_api.dart';
import 'package:openapi/src/api/passkeys_api.dart';
import 'package:openapi/src/api/people_api.dart';
import 'package:openapi/src/api/plugins_api.dart';
import 'package:openapi/src/api/queues_api.dart';
import 'package:openapi/src/api/search_api.dart';
import 'package:openapi/src/api/server_api.dart';
import 'package:openapi/src/api/sessions_api.dart';
import 'package:openapi/src/api/shared_links_api.dart';
import 'package:openapi/src/api/stacks_api.dart';
import 'package:openapi/src/api/sync_api.dart';
import 'package:openapi/src/api/system_config_api.dart';
import 'package:openapi/src/api/system_metadata_api.dart';
import 'package:openapi/src/api/tags_api.dart';
import 'package:openapi/src/api/timeline_api.dart';
import 'package:openapi/src/api/trash_api.dart';
import 'package:openapi/src/api/users_api.dart';
import 'package:openapi/src/api/users_admin_api.dart';
import 'package:openapi/src/api/views_api.dart';
import 'package:openapi/src/api/workflows_api.dart';

class Openapi {
  static const String basePath = r'/api';

  final Dio dio;
  final Serializers serializers;

  Openapi({
    Dio? dio,
    Serializers? serializers,
    String? basePathOverride,
    List<Interceptor>? interceptors,
  })  : this.serializers = serializers ?? standardSerializers,
        this.dio = dio ??
            Dio(BaseOptions(
              baseUrl: basePathOverride ?? basePath,
              connectTimeout: const Duration(milliseconds: 5000),
              receiveTimeout: const Duration(milliseconds: 3000),
            )) {
    if (interceptors == null) {
      this.dio.interceptors.addAll([
        OAuthInterceptor(),
        BasicAuthInterceptor(),
        BearerAuthInterceptor(),
        ApiKeyAuthInterceptor(),
      ]);
    } else {
      this.dio.interceptors.addAll(interceptors);
    }
  }

  void setOAuthToken(String name, String token) {
    if (this.dio.interceptors.any((i) => i is OAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is OAuthInterceptor) as OAuthInterceptor).tokens[name] = token;
    }
  }

  /// Removes the OAuth token associated with the given [name].
  ///
  /// If no [OAuthInterceptor] is registered or no token exists for the given
  /// [name], this method has no effect.
  void removeOAuthToken(String name) {
    if (this.dio.interceptors.any((i) => i is OAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is OAuthInterceptor) as OAuthInterceptor).tokens.remove(name);
    }
  }

  void setBearerAuth(String name, String token) {
    if (this.dio.interceptors.any((i) => i is BearerAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BearerAuthInterceptor) as BearerAuthInterceptor).tokens[name] = token;
    }
  }

  /// Removes the bearer authentication token associated with the given [name].
  ///
  /// If no [BearerAuthInterceptor] is registered or no token exists for the
  /// given [name], this method has no effect.
  void removeBearerAuth(String name) {
    if (this.dio.interceptors.any((i) => i is BearerAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BearerAuthInterceptor) as BearerAuthInterceptor).tokens.remove(name);
    }
  }

  void setBasicAuth(String name, String username, String password) {
    if (this.dio.interceptors.any((i) => i is BasicAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BasicAuthInterceptor) as BasicAuthInterceptor).authInfo[name] = BasicAuthInfo(username, password);
    }
  }

  /// Removes the basic authentication credentials associated with the given [name].
  ///
  /// If no [BasicAuthInterceptor] is registered or no credentials exist for the
  /// given [name], this method has no effect.
  void removeBasicAuth(String name) {
    if (this.dio.interceptors.any((i) => i is BasicAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BasicAuthInterceptor) as BasicAuthInterceptor).authInfo.remove(name);
    }
  }

  void setApiKey(String name, String apiKey) {
    if (this.dio.interceptors.any((i) => i is ApiKeyAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((element) => element is ApiKeyAuthInterceptor) as ApiKeyAuthInterceptor).apiKeys[name] = apiKey;
    }
  }

  /// Removes the API key associated with the given [name].
  ///
  /// If no [ApiKeyAuthInterceptor] is registered or no API key exists for the
  /// given [name], this method has no effect.
  void removeApiKey(String name) {
    if (this.dio.interceptors.any((i) => i is ApiKeyAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((element) => element is ApiKeyAuthInterceptor) as ApiKeyAuthInterceptor).apiKeys.remove(name);
    }
  }

  /// Get APIKeysApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  APIKeysApi getAPIKeysApi() {
    return APIKeysApi(dio, serializers);
  }

  /// Get ActivitiesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ActivitiesApi getActivitiesApi() {
    return ActivitiesApi(dio, serializers);
  }

  /// Get AlbumsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AlbumsApi getAlbumsApi() {
    return AlbumsApi(dio, serializers);
  }

  /// Get AssetFilesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AssetFilesApi getAssetFilesApi() {
    return AssetFilesApi(dio, serializers);
  }

  /// Get AssetsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AssetsApi getAssetsApi() {
    return AssetsApi(dio, serializers);
  }

  /// Get AuthenticationApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AuthenticationApi getAuthenticationApi() {
    return AuthenticationApi(dio, serializers);
  }

  /// Get AuthenticationAdminApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AuthenticationAdminApi getAuthenticationAdminApi() {
    return AuthenticationAdminApi(dio, serializers);
  }

  /// Get ClusterGroupsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ClusterGroupsApi getClusterGroupsApi() {
    return ClusterGroupsApi(dio, serializers);
  }

  /// Get ConfigAdminApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ConfigAdminApi getConfigAdminApi() {
    return ConfigAdminApi(dio, serializers);
  }

  /// Get ConfigPublicApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ConfigPublicApi getConfigPublicApi() {
    return ConfigPublicApi(dio, serializers);
  }

  /// Get ConfigUserApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ConfigUserApi getConfigUserApi() {
    return ConfigUserApi(dio, serializers);
  }

  /// Get DatabaseBackupsAdminApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DatabaseBackupsAdminApi getDatabaseBackupsAdminApi() {
    return DatabaseBackupsAdminApi(dio, serializers);
  }

  /// Get DeprecatedApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DeprecatedApi getDeprecatedApi() {
    return DeprecatedApi(dio, serializers);
  }

  /// Get DocumentsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DocumentsApi getDocumentsApi() {
    return DocumentsApi(dio, serializers);
  }

  /// Get DownloadApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DownloadApi getDownloadApi() {
    return DownloadApi(dio, serializers);
  }

  /// Get DuplicatesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DuplicatesApi getDuplicatesApi() {
    return DuplicatesApi(dio, serializers);
  }

  /// Get FacesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  FacesApi getFacesApi() {
    return FacesApi(dio, serializers);
  }

  /// Get JobsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  JobsApi getJobsApi() {
    return JobsApi(dio, serializers);
  }

  /// Get LibrariesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  LibrariesApi getLibrariesApi() {
    return LibrariesApi(dio, serializers);
  }

  /// Get MaintenanceAdminApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  MaintenanceAdminApi getMaintenanceAdminApi() {
    return MaintenanceAdminApi(dio, serializers);
  }

  /// Get MapApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  MapApi getMapApi() {
    return MapApi(dio, serializers);
  }

  /// Get MemoriesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  MemoriesApi getMemoriesApi() {
    return MemoriesApi(dio, serializers);
  }

  /// Get NotificationsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  NotificationsApi getNotificationsApi() {
    return NotificationsApi(dio, serializers);
  }

  /// Get NotificationsAdminApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  NotificationsAdminApi getNotificationsAdminApi() {
    return NotificationsAdminApi(dio, serializers);
  }

  /// Get PartnersApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  PartnersApi getPartnersApi() {
    return PartnersApi(dio, serializers);
  }

  /// Get PasskeysApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  PasskeysApi getPasskeysApi() {
    return PasskeysApi(dio, serializers);
  }

  /// Get PeopleApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  PeopleApi getPeopleApi() {
    return PeopleApi(dio, serializers);
  }

  /// Get PluginsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  PluginsApi getPluginsApi() {
    return PluginsApi(dio, serializers);
  }

  /// Get QueuesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  QueuesApi getQueuesApi() {
    return QueuesApi(dio, serializers);
  }

  /// Get SearchApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  SearchApi getSearchApi() {
    return SearchApi(dio, serializers);
  }

  /// Get ServerApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ServerApi getServerApi() {
    return ServerApi(dio, serializers);
  }

  /// Get SessionsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  SessionsApi getSessionsApi() {
    return SessionsApi(dio, serializers);
  }

  /// Get SharedLinksApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  SharedLinksApi getSharedLinksApi() {
    return SharedLinksApi(dio, serializers);
  }

  /// Get StacksApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  StacksApi getStacksApi() {
    return StacksApi(dio, serializers);
  }

  /// Get SyncApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  SyncApi getSyncApi() {
    return SyncApi(dio, serializers);
  }

  /// Get SystemConfigApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  SystemConfigApi getSystemConfigApi() {
    return SystemConfigApi(dio, serializers);
  }

  /// Get SystemMetadataApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  SystemMetadataApi getSystemMetadataApi() {
    return SystemMetadataApi(dio, serializers);
  }

  /// Get TagsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  TagsApi getTagsApi() {
    return TagsApi(dio, serializers);
  }

  /// Get TimelineApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  TimelineApi getTimelineApi() {
    return TimelineApi(dio, serializers);
  }

  /// Get TrashApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  TrashApi getTrashApi() {
    return TrashApi(dio, serializers);
  }

  /// Get UsersApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  UsersApi getUsersApi() {
    return UsersApi(dio, serializers);
  }

  /// Get UsersAdminApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  UsersAdminApi getUsersAdminApi() {
    return UsersAdminApi(dio, serializers);
  }

  /// Get ViewsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ViewsApi getViewsApi() {
    return ViewsApi(dio, serializers);
  }

  /// Get WorkflowsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  WorkflowsApi getWorkflowsApi() {
    return WorkflowsApi(dio, serializers);
  }
}
