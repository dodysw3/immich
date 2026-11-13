//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'server_config_dto.g.dart';

/// ServerConfigDto
///
/// Properties:
/// * [externalDomain] - External domain URL
/// * [isInitialized] - Whether the server has been initialized
/// * [isOnboarded] - Whether the admin has completed onboarding
/// * [loginPageMessage] - Login page message
/// * [maintenanceMode] - Whether maintenance mode is active
/// * [mapDarkStyleUrl] - Map dark style URL
/// * [mapLightStyleUrl] - Map light style URL
/// * [minFaces] - People min faces server default
/// * [oauthAccountManagementUrl] - OAuth account management URL
/// * [oauthButtonText] - OAuth button text
/// * [publicUsers] - Whether public user registration is enabled
/// * [trashDays] - Number of days before trashed assets are permanently deleted
/// * [userDeleteDelay] - Delay in days before deleted users are permanently removed
@BuiltValue()
abstract class ServerConfigDto implements Built<ServerConfigDto, ServerConfigDtoBuilder> {
  /// External domain URL
  @BuiltValueField(wireName: r'externalDomain')
  String get externalDomain;

  /// Whether the server has been initialized
  @BuiltValueField(wireName: r'isInitialized')
  bool get isInitialized;

  /// Whether the admin has completed onboarding
  @BuiltValueField(wireName: r'isOnboarded')
  bool get isOnboarded;

  /// Login page message
  @BuiltValueField(wireName: r'loginPageMessage')
  String get loginPageMessage;

  /// Whether maintenance mode is active
  @BuiltValueField(wireName: r'maintenanceMode')
  bool get maintenanceMode;

  /// Map dark style URL
  @BuiltValueField(wireName: r'mapDarkStyleUrl')
  String get mapDarkStyleUrl;

  /// Map light style URL
  @BuiltValueField(wireName: r'mapLightStyleUrl')
  String get mapLightStyleUrl;

  /// People min faces server default
  @BuiltValueField(wireName: r'minFaces')
  int get minFaces;

  /// OAuth account management URL
  @BuiltValueField(wireName: r'oauthAccountManagementUrl')
  String? get oauthAccountManagementUrl;

  /// OAuth button text
  @BuiltValueField(wireName: r'oauthButtonText')
  String get oauthButtonText;

  /// Whether public user registration is enabled
  @BuiltValueField(wireName: r'publicUsers')
  bool get publicUsers;

  /// Number of days before trashed assets are permanently deleted
  @BuiltValueField(wireName: r'trashDays')
  int get trashDays;

  /// Delay in days before deleted users are permanently removed
  @BuiltValueField(wireName: r'userDeleteDelay')
  int get userDeleteDelay;

  ServerConfigDto._();

  factory ServerConfigDto([void updates(ServerConfigDtoBuilder b)]) = _$ServerConfigDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ServerConfigDtoBuilder b) => b
      ..oauthAccountManagementUrl = '';

  @BuiltValueSerializer(custom: true)
  static Serializer<ServerConfigDto> get serializer => _$ServerConfigDtoSerializer();
}

class _$ServerConfigDtoSerializer implements PrimitiveSerializer<ServerConfigDto> {
  @override
  final Iterable<Type> types = const [ServerConfigDto, _$ServerConfigDto];

  @override
  final String wireName = r'ServerConfigDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ServerConfigDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'externalDomain';
    yield serializers.serialize(
      object.externalDomain,
      specifiedType: const FullType(String),
    );
    yield r'isInitialized';
    yield serializers.serialize(
      object.isInitialized,
      specifiedType: const FullType(bool),
    );
    yield r'isOnboarded';
    yield serializers.serialize(
      object.isOnboarded,
      specifiedType: const FullType(bool),
    );
    yield r'loginPageMessage';
    yield serializers.serialize(
      object.loginPageMessage,
      specifiedType: const FullType(String),
    );
    yield r'maintenanceMode';
    yield serializers.serialize(
      object.maintenanceMode,
      specifiedType: const FullType(bool),
    );
    yield r'mapDarkStyleUrl';
    yield serializers.serialize(
      object.mapDarkStyleUrl,
      specifiedType: const FullType(String),
    );
    yield r'mapLightStyleUrl';
    yield serializers.serialize(
      object.mapLightStyleUrl,
      specifiedType: const FullType(String),
    );
    yield r'minFaces';
    yield serializers.serialize(
      object.minFaces,
      specifiedType: const FullType(int),
    );
    if (object.oauthAccountManagementUrl != null) {
      yield r'oauthAccountManagementUrl';
      yield serializers.serialize(
        object.oauthAccountManagementUrl,
        specifiedType: const FullType(String),
      );
    }
    yield r'oauthButtonText';
    yield serializers.serialize(
      object.oauthButtonText,
      specifiedType: const FullType(String),
    );
    yield r'publicUsers';
    yield serializers.serialize(
      object.publicUsers,
      specifiedType: const FullType(bool),
    );
    yield r'trashDays';
    yield serializers.serialize(
      object.trashDays,
      specifiedType: const FullType(int),
    );
    yield r'userDeleteDelay';
    yield serializers.serialize(
      object.userDeleteDelay,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ServerConfigDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ServerConfigDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'externalDomain':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.externalDomain = valueDes;
          break;
        case r'isInitialized':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isInitialized = valueDes;
          break;
        case r'isOnboarded':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isOnboarded = valueDes;
          break;
        case r'loginPageMessage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.loginPageMessage = valueDes;
          break;
        case r'maintenanceMode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.maintenanceMode = valueDes;
          break;
        case r'mapDarkStyleUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mapDarkStyleUrl = valueDes;
          break;
        case r'mapLightStyleUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mapLightStyleUrl = valueDes;
          break;
        case r'minFaces':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.minFaces = valueDes;
          break;
        case r'oauthAccountManagementUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.oauthAccountManagementUrl = valueDes;
          break;
        case r'oauthButtonText':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.oauthButtonText = valueDes;
          break;
        case r'publicUsers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.publicUsers = valueDes;
          break;
        case r'trashDays':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.trashDays = valueDes;
          break;
        case r'userDeleteDelay':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.userDeleteDelay = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ServerConfigDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ServerConfigDtoBuilder();
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


