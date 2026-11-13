//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stack_update_dto.g.dart';

/// StackUpdateDto
///
/// Properties:
/// * [primaryAssetId] - Primary asset ID
@BuiltValue()
abstract class StackUpdateDto implements Built<StackUpdateDto, StackUpdateDtoBuilder> {
  /// Primary asset ID
  @BuiltValueField(wireName: r'primaryAssetId')
  String? get primaryAssetId;

  StackUpdateDto._();

  factory StackUpdateDto([void updates(StackUpdateDtoBuilder b)]) = _$StackUpdateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StackUpdateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StackUpdateDto> get serializer => _$StackUpdateDtoSerializer();
}

class _$StackUpdateDtoSerializer implements PrimitiveSerializer<StackUpdateDto> {
  @override
  final Iterable<Type> types = const [StackUpdateDto, _$StackUpdateDto];

  @override
  final String wireName = r'StackUpdateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StackUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.primaryAssetId != null) {
      yield r'primaryAssetId';
      yield serializers.serialize(
        object.primaryAssetId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    StackUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StackUpdateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'primaryAssetId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.primaryAssetId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StackUpdateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StackUpdateDtoBuilder();
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


