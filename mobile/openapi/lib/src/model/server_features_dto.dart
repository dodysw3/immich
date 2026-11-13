//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'server_features_dto.g.dart';

/// ServerFeaturesDto
///
/// Properties:
/// * [aiInterpretSearch] - Whether AI interpretation search is enabled
/// * [backups] - Whether the backups feature is enabled
/// * [configFile] - Whether config file is available
/// * [duplicateDetection] - Whether duplicate detection is enabled
/// * [email] - Whether email notifications are enabled
/// * [facialRecognition] - Whether facial recognition is enabled
/// * [importFaces] - Whether face import is enabled
/// * [map] - Whether map feature is enabled
/// * [oauth] - Whether OAuth is enabled
/// * [oauthAutoLaunch] - Whether OAuth auto-launch is enabled
/// * [ocr] - Whether OCR is enabled
/// * [passwordLogin] - Whether password login is enabled
/// * [realtimeTranscoding] - Whether real-time transcoding is enabled
/// * [reverseGeocoding] - Whether reverse geocoding is enabled
/// * [search] - Whether search is enabled
/// * [sidecar] - Whether sidecar files are supported
/// * [smartSearch] - Whether smart search is enabled
/// * [trash] - Whether trash feature is enabled
@BuiltValue()
abstract class ServerFeaturesDto implements Built<ServerFeaturesDto, ServerFeaturesDtoBuilder> {
  /// Whether AI interpretation search is enabled
  @BuiltValueField(wireName: r'aiInterpretSearch')
  bool get aiInterpretSearch;

  /// Whether the backups feature is enabled
  @BuiltValueField(wireName: r'backups')
  bool get backups;

  /// Whether config file is available
  @BuiltValueField(wireName: r'configFile')
  bool get configFile;

  /// Whether duplicate detection is enabled
  @BuiltValueField(wireName: r'duplicateDetection')
  bool get duplicateDetection;

  /// Whether email notifications are enabled
  @BuiltValueField(wireName: r'email')
  bool get email;

  /// Whether facial recognition is enabled
  @BuiltValueField(wireName: r'facialRecognition')
  bool get facialRecognition;

  /// Whether face import is enabled
  @BuiltValueField(wireName: r'importFaces')
  bool get importFaces;

  /// Whether map feature is enabled
  @BuiltValueField(wireName: r'map')
  bool get map;

  /// Whether OAuth is enabled
  @BuiltValueField(wireName: r'oauth')
  bool get oauth;

  /// Whether OAuth auto-launch is enabled
  @BuiltValueField(wireName: r'oauthAutoLaunch')
  bool get oauthAutoLaunch;

  /// Whether OCR is enabled
  @BuiltValueField(wireName: r'ocr')
  bool get ocr;

  /// Whether password login is enabled
  @BuiltValueField(wireName: r'passwordLogin')
  bool get passwordLogin;

  /// Whether real-time transcoding is enabled
  @BuiltValueField(wireName: r'realtimeTranscoding')
  bool get realtimeTranscoding;

  /// Whether reverse geocoding is enabled
  @BuiltValueField(wireName: r'reverseGeocoding')
  bool get reverseGeocoding;

  /// Whether search is enabled
  @BuiltValueField(wireName: r'search')
  bool get search;

  /// Whether sidecar files are supported
  @BuiltValueField(wireName: r'sidecar')
  bool get sidecar;

  /// Whether smart search is enabled
  @BuiltValueField(wireName: r'smartSearch')
  bool get smartSearch;

  /// Whether trash feature is enabled
  @BuiltValueField(wireName: r'trash')
  bool get trash;

  ServerFeaturesDto._();

  factory ServerFeaturesDto([void updates(ServerFeaturesDtoBuilder b)]) = _$ServerFeaturesDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ServerFeaturesDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ServerFeaturesDto> get serializer => _$ServerFeaturesDtoSerializer();
}

class _$ServerFeaturesDtoSerializer implements PrimitiveSerializer<ServerFeaturesDto> {
  @override
  final Iterable<Type> types = const [ServerFeaturesDto, _$ServerFeaturesDto];

  @override
  final String wireName = r'ServerFeaturesDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ServerFeaturesDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'aiInterpretSearch';
    yield serializers.serialize(
      object.aiInterpretSearch,
      specifiedType: const FullType(bool),
    );
    yield r'backups';
    yield serializers.serialize(
      object.backups,
      specifiedType: const FullType(bool),
    );
    yield r'configFile';
    yield serializers.serialize(
      object.configFile,
      specifiedType: const FullType(bool),
    );
    yield r'duplicateDetection';
    yield serializers.serialize(
      object.duplicateDetection,
      specifiedType: const FullType(bool),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(bool),
    );
    yield r'facialRecognition';
    yield serializers.serialize(
      object.facialRecognition,
      specifiedType: const FullType(bool),
    );
    yield r'importFaces';
    yield serializers.serialize(
      object.importFaces,
      specifiedType: const FullType(bool),
    );
    yield r'map';
    yield serializers.serialize(
      object.map,
      specifiedType: const FullType(bool),
    );
    yield r'oauth';
    yield serializers.serialize(
      object.oauth,
      specifiedType: const FullType(bool),
    );
    yield r'oauthAutoLaunch';
    yield serializers.serialize(
      object.oauthAutoLaunch,
      specifiedType: const FullType(bool),
    );
    yield r'ocr';
    yield serializers.serialize(
      object.ocr,
      specifiedType: const FullType(bool),
    );
    yield r'passwordLogin';
    yield serializers.serialize(
      object.passwordLogin,
      specifiedType: const FullType(bool),
    );
    yield r'realtimeTranscoding';
    yield serializers.serialize(
      object.realtimeTranscoding,
      specifiedType: const FullType(bool),
    );
    yield r'reverseGeocoding';
    yield serializers.serialize(
      object.reverseGeocoding,
      specifiedType: const FullType(bool),
    );
    yield r'search';
    yield serializers.serialize(
      object.search,
      specifiedType: const FullType(bool),
    );
    yield r'sidecar';
    yield serializers.serialize(
      object.sidecar,
      specifiedType: const FullType(bool),
    );
    yield r'smartSearch';
    yield serializers.serialize(
      object.smartSearch,
      specifiedType: const FullType(bool),
    );
    yield r'trash';
    yield serializers.serialize(
      object.trash,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ServerFeaturesDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ServerFeaturesDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'aiInterpretSearch':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.aiInterpretSearch = valueDes;
          break;
        case r'backups':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.backups = valueDes;
          break;
        case r'configFile':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.configFile = valueDes;
          break;
        case r'duplicateDetection':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.duplicateDetection = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.email = valueDes;
          break;
        case r'facialRecognition':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.facialRecognition = valueDes;
          break;
        case r'importFaces':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.importFaces = valueDes;
          break;
        case r'map':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.map = valueDes;
          break;
        case r'oauth':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.oauth = valueDes;
          break;
        case r'oauthAutoLaunch':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.oauthAutoLaunch = valueDes;
          break;
        case r'ocr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.ocr = valueDes;
          break;
        case r'passwordLogin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.passwordLogin = valueDes;
          break;
        case r'realtimeTranscoding':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.realtimeTranscoding = valueDes;
          break;
        case r'reverseGeocoding':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.reverseGeocoding = valueDes;
          break;
        case r'search':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.search = valueDes;
          break;
        case r'sidecar':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.sidecar = valueDes;
          break;
        case r'smartSearch':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.smartSearch = valueDes;
          break;
        case r'trash':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.trash = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ServerFeaturesDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ServerFeaturesDtoBuilder();
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


