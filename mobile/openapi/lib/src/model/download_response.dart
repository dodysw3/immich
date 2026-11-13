//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'download_response.g.dart';

/// DownloadResponse
///
/// Properties:
/// * [archiveSize] - Maximum archive size in bytes
/// * [includeEmbeddedVideos] - Whether to include embedded videos in downloads
@BuiltValue()
abstract class DownloadResponse implements Built<DownloadResponse, DownloadResponseBuilder> {
  /// Maximum archive size in bytes
  @BuiltValueField(wireName: r'archiveSize')
  int get archiveSize;

  /// Whether to include embedded videos in downloads
  @BuiltValueField(wireName: r'includeEmbeddedVideos')
  bool get includeEmbeddedVideos;

  DownloadResponse._();

  factory DownloadResponse([void updates(DownloadResponseBuilder b)]) = _$DownloadResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DownloadResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DownloadResponse> get serializer => _$DownloadResponseSerializer();
}

class _$DownloadResponseSerializer implements PrimitiveSerializer<DownloadResponse> {
  @override
  final Iterable<Type> types = const [DownloadResponse, _$DownloadResponse];

  @override
  final String wireName = r'DownloadResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DownloadResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'archiveSize';
    yield serializers.serialize(
      object.archiveSize,
      specifiedType: const FullType(int),
    );
    yield r'includeEmbeddedVideos';
    yield serializers.serialize(
      object.includeEmbeddedVideos,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DownloadResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DownloadResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'archiveSize':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.archiveSize = valueDes;
          break;
        case r'includeEmbeddedVideos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.includeEmbeddedVideos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DownloadResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DownloadResponseBuilder();
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


