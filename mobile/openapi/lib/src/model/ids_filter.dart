//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ids_filter.g.dart';

/// IdsFilter
///
/// Properties:
/// * [all] 
/// * [any] 
/// * [none] 
@BuiltValue()
abstract class IdsFilter implements Built<IdsFilter, IdsFilterBuilder> {
  @BuiltValueField(wireName: r'all')
  BuiltList<String>? get all;

  @BuiltValueField(wireName: r'any')
  BuiltList<String>? get any;

  @BuiltValueField(wireName: r'none')
  BuiltList<String>? get none;

  IdsFilter._();

  factory IdsFilter([void updates(IdsFilterBuilder b)]) = _$IdsFilter;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IdsFilterBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<IdsFilter> get serializer => _$IdsFilterSerializer();
}

class _$IdsFilterSerializer implements PrimitiveSerializer<IdsFilter> {
  @override
  final Iterable<Type> types = const [IdsFilter, _$IdsFilter];

  @override
  final String wireName = r'IdsFilter';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IdsFilter object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.all != null) {
      yield r'all';
      yield serializers.serialize(
        object.all,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.any != null) {
      yield r'any';
      yield serializers.serialize(
        object.any,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.none != null) {
      yield r'none';
      yield serializers.serialize(
        object.none,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    IdsFilter object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required IdsFilterBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'all':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.all.replace(valueDes);
          break;
        case r'any':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.any.replace(valueDes);
          break;
        case r'none':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.none.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  IdsFilter deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IdsFilterBuilder();
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


