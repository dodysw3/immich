//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'date_filter_nullable.g.dart';

/// DateFilterNullable
///
/// Properties:
/// * [eq] 
/// * [gt] 
/// * [gte] 
/// * [lt] 
/// * [lte] 
/// * [ne] 
@BuiltValue()
abstract class DateFilterNullable implements Built<DateFilterNullable, DateFilterNullableBuilder> {
  @BuiltValueField(wireName: r'eq')
  DateTime? get eq;

  @BuiltValueField(wireName: r'gt')
  DateTime? get gt;

  @BuiltValueField(wireName: r'gte')
  DateTime? get gte;

  @BuiltValueField(wireName: r'lt')
  DateTime? get lt;

  @BuiltValueField(wireName: r'lte')
  DateTime? get lte;

  @BuiltValueField(wireName: r'ne')
  DateTime? get ne;

  DateFilterNullable._();

  factory DateFilterNullable([void updates(DateFilterNullableBuilder b)]) = _$DateFilterNullable;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DateFilterNullableBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DateFilterNullable> get serializer => _$DateFilterNullableSerializer();
}

class _$DateFilterNullableSerializer implements PrimitiveSerializer<DateFilterNullable> {
  @override
  final Iterable<Type> types = const [DateFilterNullable, _$DateFilterNullable];

  @override
  final String wireName = r'DateFilterNullable';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DateFilterNullable object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.eq != null) {
      yield r'eq';
      yield serializers.serialize(
        object.eq,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.gt != null) {
      yield r'gt';
      yield serializers.serialize(
        object.gt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.gte != null) {
      yield r'gte';
      yield serializers.serialize(
        object.gte,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.lt != null) {
      yield r'lt';
      yield serializers.serialize(
        object.lt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.lte != null) {
      yield r'lte';
      yield serializers.serialize(
        object.lte,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.ne != null) {
      yield r'ne';
      yield serializers.serialize(
        object.ne,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DateFilterNullable object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DateFilterNullableBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'eq':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.eq = valueDes;
          break;
        case r'gt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.gt = valueDes;
          break;
        case r'gte':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.gte = valueDes;
          break;
        case r'lt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lt = valueDes;
          break;
        case r'lte':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lte = valueDes;
          break;
        case r'ne':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.ne = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DateFilterNullable deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DateFilterNullableBuilder();
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


