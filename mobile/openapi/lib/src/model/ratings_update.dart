//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ratings_update.g.dart';

/// RatingsUpdate
///
/// Properties:
/// * [enabled] - Whether ratings are enabled
@BuiltValue()
abstract class RatingsUpdate implements Built<RatingsUpdate, RatingsUpdateBuilder> {
  /// Whether ratings are enabled
  @BuiltValueField(wireName: r'enabled')
  bool? get enabled;

  RatingsUpdate._();

  factory RatingsUpdate([void updates(RatingsUpdateBuilder b)]) = _$RatingsUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RatingsUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RatingsUpdate> get serializer => _$RatingsUpdateSerializer();
}

class _$RatingsUpdateSerializer implements PrimitiveSerializer<RatingsUpdate> {
  @override
  final Iterable<Type> types = const [RatingsUpdate, _$RatingsUpdate];

  @override
  final String wireName = r'RatingsUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RatingsUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.enabled != null) {
      yield r'enabled';
      yield serializers.serialize(
        object.enabled,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RatingsUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RatingsUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.enabled = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RatingsUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RatingsUpdateBuilder();
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


