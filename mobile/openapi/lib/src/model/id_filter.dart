//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'id_filter.g.dart';

/// IdFilter
///
/// Properties:
/// * [eq] 
/// * [ne] 
@BuiltValue()
abstract class IdFilter implements Built<IdFilter, IdFilterBuilder> {
  @BuiltValueField(wireName: r'eq')
  String? get eq;

  @BuiltValueField(wireName: r'ne')
  String? get ne;

  IdFilter._();

  factory IdFilter([void updates(IdFilterBuilder b)]) = _$IdFilter;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IdFilterBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<IdFilter> get serializer => _$IdFilterSerializer();
}

class _$IdFilterSerializer implements PrimitiveSerializer<IdFilter> {
  @override
  final Iterable<Type> types = const [IdFilter, _$IdFilter];

  @override
  final String wireName = r'IdFilter';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IdFilter object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.eq != null) {
      yield r'eq';
      yield serializers.serialize(
        object.eq,
        specifiedType: const FullType(String),
      );
    }
    if (object.ne != null) {
      yield r'ne';
      yield serializers.serialize(
        object.ne,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    IdFilter object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required IdFilterBuilder result,
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
  IdFilter deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IdFilterBuilder();
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


