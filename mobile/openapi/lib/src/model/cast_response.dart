//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cast_response.g.dart';

/// CastResponse
///
/// Properties:
/// * [gCastEnabled] - Whether Google Cast is enabled
@BuiltValue()
abstract class CastResponse implements Built<CastResponse, CastResponseBuilder> {
  /// Whether Google Cast is enabled
  @BuiltValueField(wireName: r'gCastEnabled')
  bool get gCastEnabled;

  CastResponse._();

  factory CastResponse([void updates(CastResponseBuilder b)]) = _$CastResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CastResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CastResponse> get serializer => _$CastResponseSerializer();
}

class _$CastResponseSerializer implements PrimitiveSerializer<CastResponse> {
  @override
  final Iterable<Type> types = const [CastResponse, _$CastResponse];

  @override
  final String wireName = r'CastResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CastResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'gCastEnabled';
    yield serializers.serialize(
      object.gCastEnabled,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CastResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CastResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'gCastEnabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
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
  CastResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CastResponseBuilder();
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


