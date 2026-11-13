//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/mirror_axis.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mirror_parameters.g.dart';

/// MirrorParameters
///
/// Properties:
/// * [axis] 
@BuiltValue()
abstract class MirrorParameters implements Built<MirrorParameters, MirrorParametersBuilder> {
  @BuiltValueField(wireName: r'axis')
  MirrorAxis get axis;
  // enum axisEnum {  horizontal,  vertical,  };

  MirrorParameters._();

  factory MirrorParameters([void updates(MirrorParametersBuilder b)]) = _$MirrorParameters;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MirrorParametersBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MirrorParameters> get serializer => _$MirrorParametersSerializer();
}

class _$MirrorParametersSerializer implements PrimitiveSerializer<MirrorParameters> {
  @override
  final Iterable<Type> types = const [MirrorParameters, _$MirrorParameters];

  @override
  final String wireName = r'MirrorParameters';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MirrorParameters object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'axis';
    yield serializers.serialize(
      object.axis,
      specifiedType: const FullType(MirrorAxis),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MirrorParameters object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MirrorParametersBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'axis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MirrorAxis),
          ) as MirrorAxis;
          result.axis = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MirrorParameters deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MirrorParametersBuilder();
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


