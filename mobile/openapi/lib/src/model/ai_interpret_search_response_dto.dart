//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/ai_interpret_search_item_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ai_interpret_search_response_dto.g.dart';

/// AiInterpretSearchResponseDto
///
/// Properties:
/// * [count] - Number of results on this page
/// * [items] 
/// * [nextPage] - Next page number, if more results are available
/// * [total] - Total number of fused results in the current window
@BuiltValue()
abstract class AiInterpretSearchResponseDto implements Built<AiInterpretSearchResponseDto, AiInterpretSearchResponseDtoBuilder> {
  /// Number of results on this page
  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'items')
  BuiltList<AiInterpretSearchItemDto> get items;

  /// Next page number, if more results are available
  @BuiltValueField(wireName: r'nextPage')
  String? get nextPage;

  /// Total number of fused results in the current window
  @BuiltValueField(wireName: r'total')
  int get total;

  AiInterpretSearchResponseDto._();

  factory AiInterpretSearchResponseDto([void updates(AiInterpretSearchResponseDtoBuilder b)]) = _$AiInterpretSearchResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AiInterpretSearchResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AiInterpretSearchResponseDto> get serializer => _$AiInterpretSearchResponseDtoSerializer();
}

class _$AiInterpretSearchResponseDtoSerializer implements PrimitiveSerializer<AiInterpretSearchResponseDto> {
  @override
  final Iterable<Type> types = const [AiInterpretSearchResponseDto, _$AiInterpretSearchResponseDto];

  @override
  final String wireName = r'AiInterpretSearchResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AiInterpretSearchResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AiInterpretSearchItemDto)]),
    );
    yield r'nextPage';
    yield object.nextPage == null ? null : serializers.serialize(
      object.nextPage,
      specifiedType: const FullType.nullable(String),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AiInterpretSearchResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AiInterpretSearchResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AiInterpretSearchItemDto)]),
          ) as BuiltList<AiInterpretSearchItemDto>;
          result.items.replace(valueDes);
          break;
        case r'nextPage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextPage = valueDes;
          break;
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
  AiInterpretSearchResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AiInterpretSearchResponseDtoBuilder();
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


