//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'download_info_dto.g.dart';

/// DownloadInfoDto
///
/// Properties:
/// * [albumId] - Album ID to download
/// * [archiveSize] - Archive size limit in bytes
/// * [assetIds] - Asset IDs to download
/// * [userId] - User ID to download assets from
@BuiltValue()
abstract class DownloadInfoDto implements Built<DownloadInfoDto, DownloadInfoDtoBuilder> {
  /// Album ID to download
  @BuiltValueField(wireName: r'albumId')
  String? get albumId;

  /// Archive size limit in bytes
  @BuiltValueField(wireName: r'archiveSize')
  int? get archiveSize;

  /// Asset IDs to download
  @BuiltValueField(wireName: r'assetIds')
  BuiltList<String>? get assetIds;

  /// User ID to download assets from
  @BuiltValueField(wireName: r'userId')
  String? get userId;

  DownloadInfoDto._();

  factory DownloadInfoDto([void updates(DownloadInfoDtoBuilder b)]) = _$DownloadInfoDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DownloadInfoDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DownloadInfoDto> get serializer => _$DownloadInfoDtoSerializer();
}

class _$DownloadInfoDtoSerializer implements PrimitiveSerializer<DownloadInfoDto> {
  @override
  final Iterable<Type> types = const [DownloadInfoDto, _$DownloadInfoDto];

  @override
  final String wireName = r'DownloadInfoDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DownloadInfoDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.albumId != null) {
      yield r'albumId';
      yield serializers.serialize(
        object.albumId,
        specifiedType: const FullType(String),
      );
    }
    if (object.archiveSize != null) {
      yield r'archiveSize';
      yield serializers.serialize(
        object.archiveSize,
        specifiedType: const FullType(int),
      );
    }
    if (object.assetIds != null) {
      yield r'assetIds';
      yield serializers.serialize(
        object.assetIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.userId != null) {
      yield r'userId';
      yield serializers.serialize(
        object.userId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DownloadInfoDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DownloadInfoDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'albumId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.albumId = valueDes;
          break;
        case r'archiveSize':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.archiveSize = valueDes;
          break;
        case r'assetIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.assetIds.replace(valueDes);
          break;
        case r'userId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.userId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DownloadInfoDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DownloadInfoDtoBuilder();
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


