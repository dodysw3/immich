//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'server_about_response_dto.g.dart';

/// ServerAboutResponseDto
///
/// Properties:
/// * [build] - Build identifier
/// * [buildImage] - Build image name
/// * [buildImageUrl] - Build image URL
/// * [buildUrl] - Build URL
/// * [exiftool] - ExifTool version
/// * [ffmpeg] - FFmpeg version
/// * [imagemagick] - ImageMagick version
/// * [libvips] - libvips version
/// * [licensed] - Whether the server is licensed
/// * [nodejs] - Node.js version
/// * [repository] - Repository name
/// * [repositoryUrl] - Repository URL
/// * [sourceCommit] - Source commit hash
/// * [sourceRef] - Source reference (branch/tag)
/// * [sourceUrl] - Source URL
/// * [thirdPartyBugFeatureUrl] - Third-party bug/feature URL
/// * [thirdPartyDocumentationUrl] - Third-party documentation URL
/// * [thirdPartySourceUrl] - Third-party source URL
/// * [thirdPartySupportUrl] - Third-party support URL
/// * [version] - Server version
/// * [versionUrl] - URL to version information
@BuiltValue()
abstract class ServerAboutResponseDto implements Built<ServerAboutResponseDto, ServerAboutResponseDtoBuilder> {
  /// Build identifier
  @BuiltValueField(wireName: r'build')
  String? get build;

  /// Build image name
  @BuiltValueField(wireName: r'buildImage')
  String? get buildImage;

  /// Build image URL
  @BuiltValueField(wireName: r'buildImageUrl')
  String? get buildImageUrl;

  /// Build URL
  @BuiltValueField(wireName: r'buildUrl')
  String? get buildUrl;

  /// ExifTool version
  @BuiltValueField(wireName: r'exiftool')
  String? get exiftool;

  /// FFmpeg version
  @BuiltValueField(wireName: r'ffmpeg')
  String? get ffmpeg;

  /// ImageMagick version
  @BuiltValueField(wireName: r'imagemagick')
  String? get imagemagick;

  /// libvips version
  @BuiltValueField(wireName: r'libvips')
  String? get libvips;

  /// Whether the server is licensed
  @BuiltValueField(wireName: r'licensed')
  bool get licensed;

  /// Node.js version
  @BuiltValueField(wireName: r'nodejs')
  String? get nodejs;

  /// Repository name
  @BuiltValueField(wireName: r'repository')
  String? get repository;

  /// Repository URL
  @BuiltValueField(wireName: r'repositoryUrl')
  String? get repositoryUrl;

  /// Source commit hash
  @BuiltValueField(wireName: r'sourceCommit')
  String? get sourceCommit;

  /// Source reference (branch/tag)
  @BuiltValueField(wireName: r'sourceRef')
  String? get sourceRef;

  /// Source URL
  @BuiltValueField(wireName: r'sourceUrl')
  String? get sourceUrl;

  /// Third-party bug/feature URL
  @BuiltValueField(wireName: r'thirdPartyBugFeatureUrl')
  String? get thirdPartyBugFeatureUrl;

  /// Third-party documentation URL
  @BuiltValueField(wireName: r'thirdPartyDocumentationUrl')
  String? get thirdPartyDocumentationUrl;

  /// Third-party source URL
  @BuiltValueField(wireName: r'thirdPartySourceUrl')
  String? get thirdPartySourceUrl;

  /// Third-party support URL
  @BuiltValueField(wireName: r'thirdPartySupportUrl')
  String? get thirdPartySupportUrl;

  /// Server version
  @BuiltValueField(wireName: r'version')
  String get version;

  /// URL to version information
  @BuiltValueField(wireName: r'versionUrl')
  String get versionUrl;

  ServerAboutResponseDto._();

  factory ServerAboutResponseDto([void updates(ServerAboutResponseDtoBuilder b)]) = _$ServerAboutResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ServerAboutResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ServerAboutResponseDto> get serializer => _$ServerAboutResponseDtoSerializer();
}

class _$ServerAboutResponseDtoSerializer implements PrimitiveSerializer<ServerAboutResponseDto> {
  @override
  final Iterable<Type> types = const [ServerAboutResponseDto, _$ServerAboutResponseDto];

  @override
  final String wireName = r'ServerAboutResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ServerAboutResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.build != null) {
      yield r'build';
      yield serializers.serialize(
        object.build,
        specifiedType: const FullType(String),
      );
    }
    if (object.buildImage != null) {
      yield r'buildImage';
      yield serializers.serialize(
        object.buildImage,
        specifiedType: const FullType(String),
      );
    }
    if (object.buildImageUrl != null) {
      yield r'buildImageUrl';
      yield serializers.serialize(
        object.buildImageUrl,
        specifiedType: const FullType(String),
      );
    }
    if (object.buildUrl != null) {
      yield r'buildUrl';
      yield serializers.serialize(
        object.buildUrl,
        specifiedType: const FullType(String),
      );
    }
    if (object.exiftool != null) {
      yield r'exiftool';
      yield serializers.serialize(
        object.exiftool,
        specifiedType: const FullType(String),
      );
    }
    if (object.ffmpeg != null) {
      yield r'ffmpeg';
      yield serializers.serialize(
        object.ffmpeg,
        specifiedType: const FullType(String),
      );
    }
    if (object.imagemagick != null) {
      yield r'imagemagick';
      yield serializers.serialize(
        object.imagemagick,
        specifiedType: const FullType(String),
      );
    }
    if (object.libvips != null) {
      yield r'libvips';
      yield serializers.serialize(
        object.libvips,
        specifiedType: const FullType(String),
      );
    }
    yield r'licensed';
    yield serializers.serialize(
      object.licensed,
      specifiedType: const FullType(bool),
    );
    if (object.nodejs != null) {
      yield r'nodejs';
      yield serializers.serialize(
        object.nodejs,
        specifiedType: const FullType(String),
      );
    }
    if (object.repository != null) {
      yield r'repository';
      yield serializers.serialize(
        object.repository,
        specifiedType: const FullType(String),
      );
    }
    if (object.repositoryUrl != null) {
      yield r'repositoryUrl';
      yield serializers.serialize(
        object.repositoryUrl,
        specifiedType: const FullType(String),
      );
    }
    if (object.sourceCommit != null) {
      yield r'sourceCommit';
      yield serializers.serialize(
        object.sourceCommit,
        specifiedType: const FullType(String),
      );
    }
    if (object.sourceRef != null) {
      yield r'sourceRef';
      yield serializers.serialize(
        object.sourceRef,
        specifiedType: const FullType(String),
      );
    }
    if (object.sourceUrl != null) {
      yield r'sourceUrl';
      yield serializers.serialize(
        object.sourceUrl,
        specifiedType: const FullType(String),
      );
    }
    if (object.thirdPartyBugFeatureUrl != null) {
      yield r'thirdPartyBugFeatureUrl';
      yield serializers.serialize(
        object.thirdPartyBugFeatureUrl,
        specifiedType: const FullType(String),
      );
    }
    if (object.thirdPartyDocumentationUrl != null) {
      yield r'thirdPartyDocumentationUrl';
      yield serializers.serialize(
        object.thirdPartyDocumentationUrl,
        specifiedType: const FullType(String),
      );
    }
    if (object.thirdPartySourceUrl != null) {
      yield r'thirdPartySourceUrl';
      yield serializers.serialize(
        object.thirdPartySourceUrl,
        specifiedType: const FullType(String),
      );
    }
    if (object.thirdPartySupportUrl != null) {
      yield r'thirdPartySupportUrl';
      yield serializers.serialize(
        object.thirdPartySupportUrl,
        specifiedType: const FullType(String),
      );
    }
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(String),
    );
    yield r'versionUrl';
    yield serializers.serialize(
      object.versionUrl,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ServerAboutResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ServerAboutResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'build':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.build = valueDes;
          break;
        case r'buildImage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.buildImage = valueDes;
          break;
        case r'buildImageUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.buildImageUrl = valueDes;
          break;
        case r'buildUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.buildUrl = valueDes;
          break;
        case r'exiftool':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.exiftool = valueDes;
          break;
        case r'ffmpeg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.ffmpeg = valueDes;
          break;
        case r'imagemagick':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.imagemagick = valueDes;
          break;
        case r'libvips':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.libvips = valueDes;
          break;
        case r'licensed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.licensed = valueDes;
          break;
        case r'nodejs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nodejs = valueDes;
          break;
        case r'repository':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.repository = valueDes;
          break;
        case r'repositoryUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.repositoryUrl = valueDes;
          break;
        case r'sourceCommit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.sourceCommit = valueDes;
          break;
        case r'sourceRef':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.sourceRef = valueDes;
          break;
        case r'sourceUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.sourceUrl = valueDes;
          break;
        case r'thirdPartyBugFeatureUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.thirdPartyBugFeatureUrl = valueDes;
          break;
        case r'thirdPartyDocumentationUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.thirdPartyDocumentationUrl = valueDes;
          break;
        case r'thirdPartySourceUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.thirdPartySourceUrl = valueDes;
          break;
        case r'thirdPartySupportUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.thirdPartySupportUrl = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.version = valueDes;
          break;
        case r'versionUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.versionUrl = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ServerAboutResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ServerAboutResponseDtoBuilder();
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


