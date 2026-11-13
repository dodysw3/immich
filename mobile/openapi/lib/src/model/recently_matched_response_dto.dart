//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/recently_matched_item_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recently_matched_response_dto.g.dart';

/// RecentlyMatchedResponseDto
///
/// Properties:
/// * [items] - Asset-person pairs ordered by recognition recency
/// * [total] - Total number of recent asset-person pairs
@BuiltValue()
abstract class RecentlyMatchedResponseDto implements Built<RecentlyMatchedResponseDto, RecentlyMatchedResponseDtoBuilder> {
  /// Asset-person pairs ordered by recognition recency
  @BuiltValueField(wireName: r'items')
  BuiltList<RecentlyMatchedItemDto> get items;

  /// Total number of recent asset-person pairs
  @BuiltValueField(wireName: r'total')
  int get total;

  RecentlyMatchedResponseDto._();

  factory RecentlyMatchedResponseDto([void updates(RecentlyMatchedResponseDtoBuilder b)]) = _$RecentlyMatchedResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecentlyMatchedResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecentlyMatchedResponseDto> get serializer => _$RecentlyMatchedResponseDtoSerializer();
}

class _$RecentlyMatchedResponseDtoSerializer implements PrimitiveSerializer<RecentlyMatchedResponseDto> {
  @override
  final Iterable<Type> types = const [RecentlyMatchedResponseDto, _$RecentlyMatchedResponseDto];

  @override
  final String wireName = r'RecentlyMatchedResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecentlyMatchedResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(RecentlyMatchedItemDto)]),
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
    RecentlyMatchedResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RecentlyMatchedResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(RecentlyMatchedItemDto)]),
          ) as BuiltList<RecentlyMatchedItemDto>;
          result.items.replace(valueDes);
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
  RecentlyMatchedResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecentlyMatchedResponseDtoBuilder();
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


