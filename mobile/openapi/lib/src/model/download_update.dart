//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'download_update.g.dart';

/// DownloadUpdate
///
/// Properties:
/// * [archiveSize] - Maximum archive size in bytes
/// * [includeEmbeddedVideos] - Whether to include embedded videos in downloads
@BuiltValue()
abstract class DownloadUpdate implements Built<DownloadUpdate, DownloadUpdateBuilder> {
  /// Maximum archive size in bytes
  @BuiltValueField(wireName: r'archiveSize')
  int? get archiveSize;

  /// Whether to include embedded videos in downloads
  @BuiltValueField(wireName: r'includeEmbeddedVideos')
  bool? get includeEmbeddedVideos;

  DownloadUpdate._();

  factory DownloadUpdate([void updates(DownloadUpdateBuilder b)]) = _$DownloadUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DownloadUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DownloadUpdate> get serializer => _$DownloadUpdateSerializer();
}

class _$DownloadUpdateSerializer implements PrimitiveSerializer<DownloadUpdate> {
  @override
  final Iterable<Type> types = const [DownloadUpdate, _$DownloadUpdate];

  @override
  final String wireName = r'DownloadUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DownloadUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.archiveSize != null) {
      yield r'archiveSize';
      yield serializers.serialize(
        object.archiveSize,
        specifiedType: const FullType(int),
      );
    }
    if (object.includeEmbeddedVideos != null) {
      yield r'includeEmbeddedVideos';
      yield serializers.serialize(
        object.includeEmbeddedVideos,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DownloadUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DownloadUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'archiveSize':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.archiveSize = valueDes;
          break;
        case r'includeEmbeddedVideos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
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
  DownloadUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DownloadUpdateBuilder();
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


