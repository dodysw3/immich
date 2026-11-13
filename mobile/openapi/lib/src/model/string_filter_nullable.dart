//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'string_filter_nullable.g.dart';

/// StringFilterNullable
///
/// Properties:
/// * [eq] 
/// * [in_] 
/// * [ne] 
/// * [notIn] 
@BuiltValue()
abstract class StringFilterNullable implements Built<StringFilterNullable, StringFilterNullableBuilder> {
  @BuiltValueField(wireName: r'eq')
  String? get eq;

  @BuiltValueField(wireName: r'in')
  BuiltList<String>? get in_;

  @BuiltValueField(wireName: r'ne')
  String? get ne;

  @BuiltValueField(wireName: r'notIn')
  BuiltList<String>? get notIn;

  StringFilterNullable._();

  factory StringFilterNullable([void updates(StringFilterNullableBuilder b)]) = _$StringFilterNullable;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StringFilterNullableBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StringFilterNullable> get serializer => _$StringFilterNullableSerializer();
}

class _$StringFilterNullableSerializer implements PrimitiveSerializer<StringFilterNullable> {
  @override
  final Iterable<Type> types = const [StringFilterNullable, _$StringFilterNullable];

  @override
  final String wireName = r'StringFilterNullable';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StringFilterNullable object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.eq != null) {
      yield r'eq';
      yield serializers.serialize(
        object.eq,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.in_ != null) {
      yield r'in';
      yield serializers.serialize(
        object.in_,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.ne != null) {
      yield r'ne';
      yield serializers.serialize(
        object.ne,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.notIn != null) {
      yield r'notIn';
      yield serializers.serialize(
        object.notIn,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    StringFilterNullable object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StringFilterNullableBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'eq':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.eq = valueDes;
          break;
        case r'in':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.in_.replace(valueDes);
          break;
        case r'ne':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.ne = valueDes;
          break;
        case r'notIn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
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
  StringFilterNullable deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StringFilterNullableBuilder();
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


