//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_statistics_response_dto.g.dart';

/// SearchStatisticsResponseDto
///
/// Properties:
/// * [total] - Total number of matching assets
@BuiltValue()
abstract class SearchStatisticsResponseDto implements Built<SearchStatisticsResponseDto, SearchStatisticsResponseDtoBuilder> {
  /// Total number of matching assets
  @BuiltValueField(wireName: r'total')
  int get total;

  SearchStatisticsResponseDto._();

  factory SearchStatisticsResponseDto([void updates(SearchStatisticsResponseDtoBuilder b)]) = _$SearchStatisticsResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SearchStatisticsResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SearchStatisticsResponseDto> get serializer => _$SearchStatisticsResponseDtoSerializer();
}

class _$SearchStatisticsResponseDtoSerializer implements PrimitiveSerializer<SearchStatisticsResponseDto> {
  @override
  final Iterable<Type> types = const [SearchStatisticsResponseDto, _$SearchStatisticsResponseDto];

  @override
  final String wireName = r'SearchStatisticsResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SearchStatisticsResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SearchStatisticsResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SearchStatisticsResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SearchStatisticsResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SearchStatisticsResponseDtoBuilder();
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


