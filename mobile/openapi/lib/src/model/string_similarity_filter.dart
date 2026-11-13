//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'string_similarity_filter.g.dart';

/// StringSimilarityFilter
///
/// Properties:
/// * [matches] 
@BuiltValue()
abstract class StringSimilarityFilter implements Built<StringSimilarityFilter, StringSimilarityFilterBuilder> {
  @BuiltValueField(wireName: r'matches')
  String get matches;

  StringSimilarityFilter._();

  factory StringSimilarityFilter([void updates(StringSimilarityFilterBuilder b)]) = _$StringSimilarityFilter;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StringSimilarityFilterBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StringSimilarityFilter> get serializer => _$StringSimilarityFilterSerializer();
}

class _$StringSimilarityFilterSerializer implements PrimitiveSerializer<StringSimilarityFilter> {
  @override
  final Iterable<Type> types = const [StringSimilarityFilter, _$StringSimilarityFilter];

  @override
  final String wireName = r'StringSimilarityFilter';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StringSimilarityFilter object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'matches';
    yield serializers.serialize(
      object.matches,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StringSimilarityFilter object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StringSimilarityFilterBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'matches':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.matches = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StringSimilarityFilter deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StringSimilarityFilterBuilder();
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


