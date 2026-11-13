//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'number_filter.g.dart';

/// NumberFilter
///
/// Properties:
/// * [eq] 
/// * [gt] 
/// * [gte] 
/// * [in_] 
/// * [lt] 
/// * [lte] 
/// * [ne] 
/// * [notIn] 
@BuiltValue()
abstract class NumberFilter implements Built<NumberFilter, NumberFilterBuilder> {
  @BuiltValueField(wireName: r'eq')
  double? get eq;

  @BuiltValueField(wireName: r'gt')
  double? get gt;

  @BuiltValueField(wireName: r'gte')
  double? get gte;

  @BuiltValueField(wireName: r'in')
  BuiltList<double>? get in_;

  @BuiltValueField(wireName: r'lt')
  double? get lt;

  @BuiltValueField(wireName: r'lte')
  double? get lte;

  @BuiltValueField(wireName: r'ne')
  double? get ne;

  @BuiltValueField(wireName: r'notIn')
  BuiltList<double>? get notIn;

  NumberFilter._();

  factory NumberFilter([void updates(NumberFilterBuilder b)]) = _$NumberFilter;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NumberFilterBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NumberFilter> get serializer => _$NumberFilterSerializer();
}

class _$NumberFilterSerializer implements PrimitiveSerializer<NumberFilter> {
  @override
  final Iterable<Type> types = const [NumberFilter, _$NumberFilter];

  @override
  final String wireName = r'NumberFilter';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NumberFilter object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.eq != null) {
      yield r'eq';
      yield serializers.serialize(
        object.eq,
        specifiedType: const FullType(double),
      );
    }
    if (object.gt != null) {
      yield r'gt';
      yield serializers.serialize(
        object.gt,
        specifiedType: const FullType(double),
      );
    }
    if (object.gte != null) {
      yield r'gte';
      yield serializers.serialize(
        object.gte,
        specifiedType: const FullType(double),
      );
    }
    if (object.in_ != null) {
      yield r'in';
      yield serializers.serialize(
        object.in_,
        specifiedType: const FullType(BuiltList, [FullType(double)]),
      );
    }
    if (object.lt != null) {
      yield r'lt';
      yield serializers.serialize(
        object.lt,
        specifiedType: const FullType(double),
      );
    }
    if (object.lte != null) {
      yield r'lte';
      yield serializers.serialize(
        object.lte,
        specifiedType: const FullType(double),
      );
    }
    if (object.ne != null) {
      yield r'ne';
      yield serializers.serialize(
        object.ne,
        specifiedType: const FullType(double),
      );
    }
    if (object.notIn != null) {
      yield r'notIn';
      yield serializers.serialize(
        object.notIn,
        specifiedType: const FullType(BuiltList, [FullType(double)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    NumberFilter object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NumberFilterBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'eq':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.eq = valueDes;
          break;
        case r'gt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.gt = valueDes;
          break;
        case r'gte':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.gte = valueDes;
          break;
        case r'in':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(double)]),
          ) as BuiltList<double>?;
          if (valueDes == null) continue;
          result.in_.replace(valueDes);
          break;
        case r'lt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.lt = valueDes;
          break;
        case r'lte':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.lte = valueDes;
          break;
        case r'ne':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.ne = valueDes;
          break;
        case r'notIn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(double)]),
          ) as BuiltList<double>?;
          if (valueDes == null) continue;
          result.notIn.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NumberFilter deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NumberFilterBuilder();
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


