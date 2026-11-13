//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'rotate_parameters.g.dart';

/// RotateParameters
///
/// Properties:
/// * [angle] - Rotation angle in degrees
@BuiltValue()
abstract class RotateParameters implements Built<RotateParameters, RotateParametersBuilder> {
  /// Rotation angle in degrees
  @BuiltValueField(wireName: r'angle')
  int get angle;

  RotateParameters._();

  factory RotateParameters([void updates(RotateParametersBuilder b)]) = _$RotateParameters;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RotateParametersBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RotateParameters> get serializer => _$RotateParametersSerializer();
}

class _$RotateParametersSerializer implements PrimitiveSerializer<RotateParameters> {
  @override
  final Iterable<Type> types = const [RotateParameters, _$RotateParameters];

  @override
  final String wireName = r'RotateParameters';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RotateParameters object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'angle';
    yield serializers.serialize(
      object.angle,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RotateParameters object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RotateParametersBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'angle':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.angle = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RotateParameters deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RotateParametersBuilder();
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


