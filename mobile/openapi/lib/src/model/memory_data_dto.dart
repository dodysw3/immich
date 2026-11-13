//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'memory_data_dto.g.dart';

/// MemoryDataDto
///
/// Properties:
/// * [personId] - Person ID (birthday memories)
/// * [personName] - Name of the person when the memory was created (birthday memories)
/// * [year] - Year of the memory
@BuiltValue()
abstract class MemoryDataDto implements Built<MemoryDataDto, MemoryDataDtoBuilder> {
  /// Person ID (birthday memories)
  @BuiltValueField(wireName: r'personId')
  String? get personId;

  /// Name of the person when the memory was created (birthday memories)
  @BuiltValueField(wireName: r'personName')
  String? get personName;

  /// Year of the memory
  @BuiltValueField(wireName: r'year')
  int get year;

  MemoryDataDto._();

  factory MemoryDataDto([void updates(MemoryDataDtoBuilder b)]) = _$MemoryDataDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MemoryDataDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MemoryDataDto> get serializer => _$MemoryDataDtoSerializer();
}

class _$MemoryDataDtoSerializer implements PrimitiveSerializer<MemoryDataDto> {
  @override
  final Iterable<Type> types = const [MemoryDataDto, _$MemoryDataDto];

  @override
  final String wireName = r'MemoryDataDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MemoryDataDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.personId != null) {
      yield r'personId';
      yield serializers.serialize(
        object.personId,
        specifiedType: const FullType(String),
      );
    }
    if (object.personName != null) {
      yield r'personName';
      yield serializers.serialize(
        object.personName,
        specifiedType: const FullType(String),
      );
    }
    yield r'year';
    yield serializers.serialize(
      object.year,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MemoryDataDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MemoryDataDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'personId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.personId = valueDes;
          break;
        case r'personName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.personName = valueDes;
          break;
        case r'year':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.year = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MemoryDataDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MemoryDataDtoBuilder();
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


