//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'string_pattern_filter.g.dart';

/// StringPatternFilter
///
/// Properties:
/// * [endsWith] 
/// * [eq] 
/// * [in_] 
/// * [like] 
/// * [ne] 
/// * [notIn] 
/// * [notLike] 
/// * [startsWith] 
@BuiltValue()
abstract class StringPatternFilter implements Built<StringPatternFilter, StringPatternFilterBuilder> {
  @BuiltValueField(wireName: r'endsWith')
  String? get endsWith;

  @BuiltValueField(wireName: r'eq')
  String? get eq;

  @BuiltValueField(wireName: r'in')
  BuiltList<String>? get in_;

  @BuiltValueField(wireName: r'like')
  String? get like;

  @BuiltValueField(wireName: r'ne')
  String? get ne;

  @BuiltValueField(wireName: r'notIn')
  BuiltList<String>? get notIn;

  @BuiltValueField(wireName: r'notLike')
  String? get notLike;

  @BuiltValueField(wireName: r'startsWith')
  String? get startsWith;

  StringPatternFilter._();

  factory StringPatternFilter([void updates(StringPatternFilterBuilder b)]) = _$StringPatternFilter;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StringPatternFilterBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StringPatternFilter> get serializer => _$StringPatternFilterSerializer();
}

class _$StringPatternFilterSerializer implements PrimitiveSerializer<StringPatternFilter> {
  @override
  final Iterable<Type> types = const [StringPatternFilter, _$StringPatternFilter];

  @override
  final String wireName = r'StringPatternFilter';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StringPatternFilter object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.endsWith != null) {
      yield r'endsWith';
      yield serializers.serialize(
        object.endsWith,
        specifiedType: const FullType(String),
      );
    }
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
    if (object.like != null) {
      yield r'like';
      yield serializers.serialize(
        object.like,
        specifiedType: const FullType(String),
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
    if (object.notLike != null) {
      yield r'notLike';
      yield serializers.serialize(
        object.notLike,
        specifiedType: const FullType(String),
      );
    }
    if (object.startsWith != null) {
      yield r'startsWith';
      yield serializers.serialize(
        object.startsWith,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    StringPatternFilter object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StringPatternFilterBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'endsWith':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.endsWith = valueDes;
          break;
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
        case r'like':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.like = valueDes;
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
        case r'notLike':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.notLike = valueDes;
          break;
        case r'startsWith':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.startsWith = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StringPatternFilter deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StringPatternFilterBuilder();
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


