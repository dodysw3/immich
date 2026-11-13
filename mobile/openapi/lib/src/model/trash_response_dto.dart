//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trash_response_dto.g.dart';

/// TrashResponseDto
///
/// Properties:
/// * [count] - Number of items in trash
@BuiltValue()
abstract class TrashResponseDto implements Built<TrashResponseDto, TrashResponseDtoBuilder> {
  /// Number of items in trash
  @BuiltValueField(wireName: r'count')
  int get count;

  TrashResponseDto._();

  factory TrashResponseDto([void updates(TrashResponseDtoBuilder b)]) = _$TrashResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TrashResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TrashResponseDto> get serializer => _$TrashResponseDtoSerializer();
}

class _$TrashResponseDtoSerializer implements PrimitiveSerializer<TrashResponseDto> {
  @override
  final Iterable<Type> types = const [TrashResponseDto, _$TrashResponseDto];

  @override
  final String wireName = r'TrashResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TrashResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TrashResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TrashResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TrashResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TrashResponseDtoBuilder();
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


