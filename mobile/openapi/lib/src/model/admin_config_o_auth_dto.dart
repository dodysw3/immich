//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/o_auth_token_endpoint_auth_method.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_o_auth_dto.g.dart';

/// AdminConfigOAuthDto
///
/// Properties:
/// * [accountManagementUrl] - Account management URL
/// * [allowInsecureRequests] - Allow insecure requests
/// * [autoLaunch] - Auto launch
/// * [autoRegister] - Auto register
/// * [buttonText] - Button text
/// * [clientId] - Client ID
/// * [clientSecret] - Client secret
/// * [defaultStorageQuota] - Default storage quota
/// * [enabled] - Enabled
/// * [endSessionEndpoint] - End session endpoint
/// * [issuerUrl] - Issuer URL
/// * [mobileOverrideEnabled] - Mobile override enabled
/// * [mobileRedirectUri] - Mobile redirect URI (set to empty string to disable)
/// * [profileSigningAlgorithm] - Profile signing algorithm
/// * [prompt] - OAuth prompt parameter (e.g. select_account, login, consent)
/// * [roleClaim] - Role claim
/// * [scope] - Scope
/// * [signingAlgorithm] - Signing algorithm
/// * [storageLabelClaim] - Storage label claim
/// * [storageQuotaClaim] - Storage quota claim
/// * [timeout] - Timeout
/// * [tokenEndpointAuthMethod] 
@BuiltValue()
abstract class AdminConfigOAuthDto implements Built<AdminConfigOAuthDto, AdminConfigOAuthDtoBuilder> {
  /// Account management URL
  @BuiltValueField(wireName: r'accountManagementUrl')
  String? get accountManagementUrl;

  /// Allow insecure requests
  @BuiltValueField(wireName: r'allowInsecureRequests')
  bool get allowInsecureRequests;

  /// Auto launch
  @BuiltValueField(wireName: r'autoLaunch')
  bool get autoLaunch;

  /// Auto register
  @BuiltValueField(wireName: r'autoRegister')
  bool get autoRegister;

  /// Button text
  @BuiltValueField(wireName: r'buttonText')
  String get buttonText;

  /// Client ID
  @BuiltValueField(wireName: r'clientId')
  String get clientId;

  /// Client secret
  @BuiltValueField(wireName: r'clientSecret')
  String get clientSecret;

  /// Default storage quota
  @BuiltValueField(wireName: r'defaultStorageQuota')
  int? get defaultStorageQuota;

  /// Enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// End session endpoint
  @BuiltValueField(wireName: r'endSessionEndpoint')
  String get endSessionEndpoint;

  /// Issuer URL
  @BuiltValueField(wireName: r'issuerUrl')
  String get issuerUrl;

  /// Mobile override enabled
  @BuiltValueField(wireName: r'mobileOverrideEnabled')
  bool get mobileOverrideEnabled;

  /// Mobile redirect URI (set to empty string to disable)
  @BuiltValueField(wireName: r'mobileRedirectUri')
  String get mobileRedirectUri;

  /// Profile signing algorithm
  @BuiltValueField(wireName: r'profileSigningAlgorithm')
  String get profileSigningAlgorithm;

  /// OAuth prompt parameter (e.g. select_account, login, consent)
  @BuiltValueField(wireName: r'prompt')
  String get prompt;

  /// Role claim
  @BuiltValueField(wireName: r'roleClaim')
  String get roleClaim;

  /// Scope
  @BuiltValueField(wireName: r'scope')
  String get scope;

  /// Signing algorithm
  @BuiltValueField(wireName: r'signingAlgorithm')
  String get signingAlgorithm;

  /// Storage label claim
  @BuiltValueField(wireName: r'storageLabelClaim')
  String get storageLabelClaim;

  /// Storage quota claim
  @BuiltValueField(wireName: r'storageQuotaClaim')
  String get storageQuotaClaim;

  /// Timeout
  @BuiltValueField(wireName: r'timeout')
  int get timeout;

  @BuiltValueField(wireName: r'tokenEndpointAuthMethod')
  OAuthTokenEndpointAuthMethod get tokenEndpointAuthMethod;
  // enum tokenEndpointAuthMethodEnum {  client_secret_post,  client_secret_basic,  };

  AdminConfigOAuthDto._();

  factory AdminConfigOAuthDto([void updates(AdminConfigOAuthDtoBuilder b)]) = _$AdminConfigOAuthDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigOAuthDtoBuilder b) => b
      ..accountManagementUrl = '';

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigOAuthDto> get serializer => _$AdminConfigOAuthDtoSerializer();
}

class _$AdminConfigOAuthDtoSerializer implements PrimitiveSerializer<AdminConfigOAuthDto> {
  @override
  final Iterable<Type> types = const [AdminConfigOAuthDto, _$AdminConfigOAuthDto];

  @override
  final String wireName = r'AdminConfigOAuthDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigOAuthDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.accountManagementUrl != null) {
      yield r'accountManagementUrl';
      yield serializers.serialize(
        object.accountManagementUrl,
        specifiedType: const FullType(String),
      );
    }
    yield r'allowInsecureRequests';
    yield serializers.serialize(
      object.allowInsecureRequests,
      specifiedType: const FullType(bool),
    );
    yield r'autoLaunch';
    yield serializers.serialize(
      object.autoLaunch,
      specifiedType: const FullType(bool),
    );
    yield r'autoRegister';
    yield serializers.serialize(
      object.autoRegister,
      specifiedType: const FullType(bool),
    );
    yield r'buttonText';
    yield serializers.serialize(
      object.buttonText,
      specifiedType: const FullType(String),
    );
    yield r'clientId';
    yield serializers.serialize(
      object.clientId,
      specifiedType: const FullType(String),
    );
    yield r'clientSecret';
    yield serializers.serialize(
      object.clientSecret,
      specifiedType: const FullType(String),
    );
    yield r'defaultStorageQuota';
    yield object.defaultStorageQuota == null ? null : serializers.serialize(
      object.defaultStorageQuota,
      specifiedType: const FullType.nullable(int),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'endSessionEndpoint';
    yield serializers.serialize(
      object.endSessionEndpoint,
      specifiedType: const FullType(String),
    );
    yield r'issuerUrl';
    yield serializers.serialize(
      object.issuerUrl,
      specifiedType: const FullType(String),
    );
    yield r'mobileOverrideEnabled';
    yield serializers.serialize(
      object.mobileOverrideEnabled,
      specifiedType: const FullType(bool),
    );
    yield r'mobileRedirectUri';
    yield serializers.serialize(
      object.mobileRedirectUri,
      specifiedType: const FullType(String),
    );
    yield r'profileSigningAlgorithm';
    yield serializers.serialize(
      object.profileSigningAlgorithm,
      specifiedType: const FullType(String),
    );
    yield r'prompt';
    yield serializers.serialize(
      object.prompt,
      specifiedType: const FullType(String),
    );
    yield r'roleClaim';
    yield serializers.serialize(
      object.roleClaim,
      specifiedType: const FullType(String),
    );
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(String),
    );
    yield r'signingAlgorithm';
    yield serializers.serialize(
      object.signingAlgorithm,
      specifiedType: const FullType(String),
    );
    yield r'storageLabelClaim';
    yield serializers.serialize(
      object.storageLabelClaim,
      specifiedType: const FullType(String),
    );
    yield r'storageQuotaClaim';
    yield serializers.serialize(
      object.storageQuotaClaim,
      specifiedType: const FullType(String),
    );
    yield r'timeout';
    yield serializers.serialize(
      object.timeout,
      specifiedType: const FullType(int),
    );
    yield r'tokenEndpointAuthMethod';
    yield serializers.serialize(
      object.tokenEndpointAuthMethod,
      specifiedType: const FullType(OAuthTokenEndpointAuthMethod),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigOAuthDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigOAuthDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accountManagementUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.accountManagementUrl = valueDes;
          break;
        case r'allowInsecureRequests':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.allowInsecureRequests = valueDes;
          break;
        case r'autoLaunch':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.autoLaunch = valueDes;
          break;
        case r'autoRegister':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.autoRegister = valueDes;
          break;
        case r'buttonText':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.buttonText = valueDes;
          break;
        case r'clientId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.clientId = valueDes;
          break;
        case r'clientSecret':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.clientSecret = valueDes;
          break;
        case r'defaultStorageQuota':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.defaultStorageQuota = valueDes;
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'endSessionEndpoint':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.endSessionEndpoint = valueDes;
          break;
        case r'issuerUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.issuerUrl = valueDes;
          break;
        case r'mobileOverrideEnabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.mobileOverrideEnabled = valueDes;
          break;
        case r'mobileRedirectUri':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mobileRedirectUri = valueDes;
          break;
        case r'profileSigningAlgorithm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.profileSigningAlgorithm = valueDes;
          break;
        case r'prompt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.prompt = valueDes;
          break;
        case r'roleClaim':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.roleClaim = valueDes;
          break;
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.scope = valueDes;
          break;
        case r'signingAlgorithm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.signingAlgorithm = valueDes;
          break;
        case r'storageLabelClaim':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.storageLabelClaim = valueDes;
          break;
        case r'storageQuotaClaim':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.storageQuotaClaim = valueDes;
          break;
        case r'timeout':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.timeout = valueDes;
          break;
        case r'tokenEndpointAuthMethod':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OAuthTokenEndpointAuthMethod),
          ) as OAuthTokenEndpointAuthMethod;
          result.tokenEndpointAuthMethod = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigOAuthDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigOAuthDtoBuilder();
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


