//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'album_statistics_response_dto.g.dart';

/// AlbumStatisticsResponseDto
///
/// Properties:
/// * [notShared] - Number of non-shared albums
/// * [owned] - Number of owned albums
/// * [shared] - Number of shared albums
@BuiltValue()
abstract class AlbumStatisticsResponseDto implements Built<AlbumStatisticsResponseDto, AlbumStatisticsResponseDtoBuilder> {
  /// Number of non-shared albums
  @BuiltValueField(wireName: r'notShared')
  int get notShared;

  /// Number of owned albums
  @BuiltValueField(wireName: r'owned')
  int get owned;

  /// Number of shared albums
  @BuiltValueField(wireName: r'shared')
  int get shared;

  AlbumStatisticsResponseDto._();

  factory AlbumStatisticsResponseDto([void updates(AlbumStatisticsResponseDtoBuilder b)]) = _$AlbumStatisticsResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AlbumStatisticsResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AlbumStatisticsResponseDto> get serializer => _$AlbumStatisticsResponseDtoSerializer();
}

class _$AlbumStatisticsResponseDtoSerializer implements PrimitiveSerializer<AlbumStatisticsResponseDto> {
  @override
  final Iterable<Type> types = const [AlbumStatisticsResponseDto, _$AlbumStatisticsResponseDto];

  @override
  final String wireName = r'AlbumStatisticsResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AlbumStatisticsResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'notShared';
    yield serializers.serialize(
      object.notShared,
      specifiedType: const FullType(int),
    );
    yield r'owned';
    yield serializers.serialize(
      object.owned,
      specifiedType: const FullType(int),
    );
    yield r'shared';
    yield serializers.serialize(
      object.shared,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AlbumStatisticsResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AlbumStatisticsResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'notShared':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.notShared = valueDes;
          break;
        case r'owned':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.owned = valueDes;
          break;
        case r'shared':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.shared = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AlbumStatisticsResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AlbumStatisticsResponseDtoBuilder();
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


