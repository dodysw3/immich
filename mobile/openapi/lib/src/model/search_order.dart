//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/asset_order.dart';
import 'package:openapi/src/model/search_order_field.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_order.g.dart';

/// SearchOrder
///
/// Properties:
/// * [direction] 
/// * [field] 
@BuiltValue()
abstract class SearchOrder implements Built<SearchOrder, SearchOrderBuilder> {
  @BuiltValueField(wireName: r'direction')
  AssetOrder? get direction;
  // enum directionEnum {  asc,  desc,  };

  @BuiltValueField(wireName: r'field')
  SearchOrderField? get field;
  // enum fieldEnum {  fileCreatedAt,  localDateTime,  fileSizeInBytes,  rating,  };

  SearchOrder._();

  factory SearchOrder([void updates(SearchOrderBuilder b)]) = _$SearchOrder;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SearchOrderBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SearchOrder> get serializer => _$SearchOrderSerializer();
}

class _$SearchOrderSerializer implements PrimitiveSerializer<SearchOrder> {
  @override
  final Iterable<Type> types = const [SearchOrder, _$SearchOrder];

  @override
  final String wireName = r'SearchOrder';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SearchOrder object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.direction != null) {
      yield r'direction';
      yield serializers.serialize(
        object.direction,
        specifiedType: const FullType(AssetOrder),
      );
    }
    if (object.field != null) {
      yield r'field';
      yield serializers.serialize(
        object.field,
        specifiedType: const FullType(SearchOrderField),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SearchOrder object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SearchOrderBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'direction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AssetOrder),
          ) as AssetOrder?;
          if (valueDes == null) continue;
          result.direction = valueDes;
          break;
        case r'field':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SearchOrderField),
          ) as SearchOrderField?;
          if (valueDes == null) continue;
          result.field = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SearchOrder deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SearchOrderBuilder();
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


