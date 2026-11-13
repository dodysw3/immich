//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cast_update.g.dart';

/// CastUpdate
///
/// Properties:
/// * [gCastEnabled] - Whether Google Cast is enabled
@BuiltValue()
abstract class CastUpdate implements Built<CastUpdate, CastUpdateBuilder> {
  /// Whether Google Cast is enabled
  @BuiltValueField(wireName: r'gCastEnabled')
  bool? get gCastEnabled;

  CastUpdate._();

  factory CastUpdate([void updates(CastUpdateBuilder b)]) = _$CastUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CastUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CastUpdate> get serializer => _$CastUpdateSerializer();
}

class _$CastUpdateSerializer implements PrimitiveSerializer<CastUpdate> {
  @override
  final Iterable<Type> types = const [CastUpdate, _$CastUpdate];

  @override
  final String wireName = r'CastUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CastUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.gCastEnabled != null) {
      yield r'gCastEnabled';
      yield serializers.serialize(
        object.gCastEnabled,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CastUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CastUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'gCastEnabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.gCastEnabled = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CastUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CastUpdateBuilder();
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


