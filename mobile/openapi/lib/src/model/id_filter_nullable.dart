//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'id_filter_nullable.g.dart';

/// IdFilterNullable
///
/// Properties:
/// * [eq] 
/// * [ne] 
@BuiltValue()
abstract class IdFilterNullable implements Built<IdFilterNullable, IdFilterNullableBuilder> {
  @BuiltValueField(wireName: r'eq')
  String? get eq;

  @BuiltValueField(wireName: r'ne')
  String? get ne;

  IdFilterNullable._();

  factory IdFilterNullable([void updates(IdFilterNullableBuilder b)]) = _$IdFilterNullable;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IdFilterNullableBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<IdFilterNullable> get serializer => _$IdFilterNullableSerializer();
}

class _$IdFilterNullableSerializer implements PrimitiveSerializer<IdFilterNullable> {
  @override
  final Iterable<Type> types = const [IdFilterNullable, _$IdFilterNullable];

  @override
  final String wireName = r'IdFilterNullable';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IdFilterNullable object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.eq != null) {
      yield r'eq';
      yield serializers.serialize(
        object.eq,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.ne != null) {
      yield r'ne';
      yield serializers.serialize(
        object.ne,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    IdFilterNullable object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required IdFilterNullableBuilder result,
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
        case r'ne':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
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
  IdFilterNullable deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IdFilterNullableBuilder();
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


