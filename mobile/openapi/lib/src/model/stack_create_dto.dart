//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stack_create_dto.g.dart';

/// StackCreateDto
///
/// Properties:
/// * [assetIds] - Asset IDs (first becomes primary, min 2)
@BuiltValue()
abstract class StackCreateDto implements Built<StackCreateDto, StackCreateDtoBuilder> {
  /// Asset IDs (first becomes primary, min 2)
  @BuiltValueField(wireName: r'assetIds')
  BuiltList<String> get assetIds;

  StackCreateDto._();

  factory StackCreateDto([void updates(StackCreateDtoBuilder b)]) = _$StackCreateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StackCreateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StackCreateDto> get serializer => _$StackCreateDtoSerializer();
}

class _$StackCreateDtoSerializer implements PrimitiveSerializer<StackCreateDto> {
  @override
  final Iterable<Type> types = const [StackCreateDto, _$StackCreateDto];

  @override
  final String wireName = r'StackCreateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StackCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assetIds';
    yield serializers.serialize(
      object.assetIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StackCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StackCreateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assetIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.assetIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StackCreateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StackCreateDtoBuilder();
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


