//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/memory_type.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/memory_data_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'memory_create_dto.g.dart';

/// MemoryCreateDto
///
/// Properties:
/// * [assetIds] - Asset IDs to associate with memory
/// * [data] 
/// * [hideAt] - Date when memory should be hidden
/// * [isSaved] - Is memory saved
/// * [memoryAt] - Memory date
/// * [seenAt] - Date when memory was seen
/// * [showAt] - Date when memory should be shown
/// * [type] 
@BuiltValue()
abstract class MemoryCreateDto implements Built<MemoryCreateDto, MemoryCreateDtoBuilder> {
  /// Asset IDs to associate with memory
  @BuiltValueField(wireName: r'assetIds')
  BuiltList<String>? get assetIds;

  @BuiltValueField(wireName: r'data')
  MemoryDataDto get data;

  /// Date when memory should be hidden
  @BuiltValueField(wireName: r'hideAt')
  DateTime? get hideAt;

  /// Is memory saved
  @BuiltValueField(wireName: r'isSaved')
  bool? get isSaved;

  /// Memory date
  @BuiltValueField(wireName: r'memoryAt')
  DateTime get memoryAt;

  /// Date when memory was seen
  @BuiltValueField(wireName: r'seenAt')
  DateTime? get seenAt;

  /// Date when memory should be shown
  @BuiltValueField(wireName: r'showAt')
  DateTime? get showAt;

  @BuiltValueField(wireName: r'type')
  MemoryType get type;
  // enum typeEnum {  on_this_day,  birthday,  };

  MemoryCreateDto._();

  factory MemoryCreateDto([void updates(MemoryCreateDtoBuilder b)]) = _$MemoryCreateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MemoryCreateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MemoryCreateDto> get serializer => _$MemoryCreateDtoSerializer();
}

class _$MemoryCreateDtoSerializer implements PrimitiveSerializer<MemoryCreateDto> {
  @override
  final Iterable<Type> types = const [MemoryCreateDto, _$MemoryCreateDto];

  @override
  final String wireName = r'MemoryCreateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MemoryCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.assetIds != null) {
      yield r'assetIds';
      yield serializers.serialize(
        object.assetIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(MemoryDataDto),
    );
    if (object.hideAt != null) {
      yield r'hideAt';
      yield serializers.serialize(
        object.hideAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.isSaved != null) {
      yield r'isSaved';
      yield serializers.serialize(
        object.isSaved,
        specifiedType: const FullType(bool),
      );
    }
    yield r'memoryAt';
    yield serializers.serialize(
      object.memoryAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.seenAt != null) {
      yield r'seenAt';
      yield serializers.serialize(
        object.seenAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.showAt != null) {
      yield r'showAt';
      yield serializers.serialize(
        object.showAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(MemoryType),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MemoryCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MemoryCreateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assetIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.assetIds.replace(valueDes);
          break;
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MemoryDataDto),
          ) as MemoryDataDto;
          result.data.replace(valueDes);
          break;
        case r'hideAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.hideAt = valueDes;
          break;
        case r'isSaved':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isSaved = valueDes;
          break;
        case r'memoryAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.memoryAt = valueDes;
          break;
        case r'seenAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.seenAt = valueDes;
          break;
        case r'showAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.showAt = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MemoryType),
          ) as MemoryType;
          result.type = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MemoryCreateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MemoryCreateDtoBuilder();
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


