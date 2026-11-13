//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'crop_parameters.g.dart';

/// CropParameters
///
/// Properties:
/// * [height] - Height of the crop
/// * [width] - Width of the crop
/// * [x] - Top-Left X coordinate of crop
/// * [y] - Top-Left Y coordinate of crop
@BuiltValue()
abstract class CropParameters implements Built<CropParameters, CropParametersBuilder> {
  /// Height of the crop
  @BuiltValueField(wireName: r'height')
  int get height;

  /// Width of the crop
  @BuiltValueField(wireName: r'width')
  int get width;

  /// Top-Left X coordinate of crop
  @BuiltValueField(wireName: r'x')
  int get x;

  /// Top-Left Y coordinate of crop
  @BuiltValueField(wireName: r'y')
  int get y;

  CropParameters._();

  factory CropParameters([void updates(CropParametersBuilder b)]) = _$CropParameters;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CropParametersBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CropParameters> get serializer => _$CropParametersSerializer();
}

class _$CropParametersSerializer implements PrimitiveSerializer<CropParameters> {
  @override
  final Iterable<Type> types = const [CropParameters, _$CropParameters];

  @override
  final String wireName = r'CropParameters';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CropParameters object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'height';
    yield serializers.serialize(
      object.height,
      specifiedType: const FullType(int),
    );
    yield r'width';
    yield serializers.serialize(
      object.width,
      specifiedType: const FullType(int),
    );
    yield r'x';
    yield serializers.serialize(
      object.x,
      specifiedType: const FullType(int),
    );
    yield r'y';
    yield serializers.serialize(
      object.y,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CropParameters object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CropParametersBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'height':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.height = valueDes;
          break;
        case r'width':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.width = valueDes;
          break;
        case r'x':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.x = valueDes;
          break;
        case r'y':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.y = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CropParameters deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CropParametersBuilder();
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


