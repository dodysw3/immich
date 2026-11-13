//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'download_archive_dto.g.dart';

/// DownloadArchiveDto
///
/// Properties:
/// * [archiveName] - The name of the archive to download, without extension
/// * [assetIds] - Asset IDs
/// * [edited] - Download edited asset if available
@BuiltValue()
abstract class DownloadArchiveDto implements Built<DownloadArchiveDto, DownloadArchiveDtoBuilder> {
  /// The name of the archive to download, without extension
  @BuiltValueField(wireName: r'archiveName')
  String? get archiveName;

  /// Asset IDs
  @BuiltValueField(wireName: r'assetIds')
  BuiltList<String> get assetIds;

  /// Download edited asset if available
  @BuiltValueField(wireName: r'edited')
  bool? get edited;

  DownloadArchiveDto._();

  factory DownloadArchiveDto([void updates(DownloadArchiveDtoBuilder b)]) = _$DownloadArchiveDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DownloadArchiveDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DownloadArchiveDto> get serializer => _$DownloadArchiveDtoSerializer();
}

class _$DownloadArchiveDtoSerializer implements PrimitiveSerializer<DownloadArchiveDto> {
  @override
  final Iterable<Type> types = const [DownloadArchiveDto, _$DownloadArchiveDto];

  @override
  final String wireName = r'DownloadArchiveDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DownloadArchiveDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.archiveName != null) {
      yield r'archiveName';
      yield serializers.serialize(
        object.archiveName,
        specifiedType: const FullType(String),
      );
    }
    yield r'assetIds';
    yield serializers.serialize(
      object.assetIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    if (object.edited != null) {
      yield r'edited';
      yield serializers.serialize(
        object.edited,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DownloadArchiveDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DownloadArchiveDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'archiveName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.archiveName = valueDes;
          break;
        case r'assetIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.assetIds.replace(valueDes);
          break;
        case r'edited':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.edited = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DownloadArchiveDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DownloadArchiveDtoBuilder();
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


