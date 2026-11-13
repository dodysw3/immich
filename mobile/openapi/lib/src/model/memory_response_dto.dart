//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/memory_type.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/asset_response_dto.dart';
import 'package:openapi/src/model/memory_data_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'memory_response_dto.g.dart';

/// MemoryResponseDto
///
/// Properties:
/// * [assets] 
/// * [createdAt] - Creation date
/// * [data] 
/// * [deletedAt] - Deletion date
/// * [hideAt] - Date when memory should be hidden
/// * [id] - Memory ID
/// * [isSaved] - Is memory saved
/// * [memoryAt] - Memory date
/// * [ownerId] - Owner user ID
/// * [seenAt] - Date when memory was seen
/// * [showAt] - Date when memory should be shown
/// * [type] 
/// * [updatedAt] - Last update date
@BuiltValue()
abstract class MemoryResponseDto implements Built<MemoryResponseDto, MemoryResponseDtoBuilder> {
  @BuiltValueField(wireName: r'assets')
  BuiltList<AssetResponseDto> get assets;

  /// Creation date
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'data')
  MemoryDataDto get data;

  /// Deletion date
  @BuiltValueField(wireName: r'deletedAt')
  DateTime? get deletedAt;

  /// Date when memory should be hidden
  @BuiltValueField(wireName: r'hideAt')
  DateTime? get hideAt;

  /// Memory ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Is memory saved
  @BuiltValueField(wireName: r'isSaved')
  bool get isSaved;

  /// Memory date
  @BuiltValueField(wireName: r'memoryAt')
  DateTime get memoryAt;

  /// Owner user ID
  @BuiltValueField(wireName: r'ownerId')
  String get ownerId;

  /// Date when memory was seen
  @BuiltValueField(wireName: r'seenAt')
  DateTime? get seenAt;

  /// Date when memory should be shown
  @BuiltValueField(wireName: r'showAt')
  DateTime? get showAt;

  @BuiltValueField(wireName: r'type')
  MemoryType get type;
  // enum typeEnum {  on_this_day,  birthday,  };

  /// Last update date
  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  MemoryResponseDto._();

  factory MemoryResponseDto([void updates(MemoryResponseDtoBuilder b)]) = _$MemoryResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MemoryResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MemoryResponseDto> get serializer => _$MemoryResponseDtoSerializer();
}

class _$MemoryResponseDtoSerializer implements PrimitiveSerializer<MemoryResponseDto> {
  @override
  final Iterable<Type> types = const [MemoryResponseDto, _$MemoryResponseDto];

  @override
  final String wireName = r'MemoryResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MemoryResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assets';
    yield serializers.serialize(
      object.assets,
      specifiedType: const FullType(BuiltList, [FullType(AssetResponseDto)]),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(MemoryDataDto),
    );
    if (object.deletedAt != null) {
      yield r'deletedAt';
      yield serializers.serialize(
        object.deletedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.hideAt != null) {
      yield r'hideAt';
      yield serializers.serialize(
        object.hideAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'isSaved';
    yield serializers.serialize(
      object.isSaved,
      specifiedType: const FullType(bool),
    );
    yield r'memoryAt';
    yield serializers.serialize(
      object.memoryAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'ownerId';
    yield serializers.serialize(
      object.ownerId,
      specifiedType: const FullType(String),
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
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MemoryResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MemoryResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AssetResponseDto)]),
          ) as BuiltList<AssetResponseDto>;
          result.assets.replace(valueDes);
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MemoryDataDto),
          ) as MemoryDataDto;
          result.data.replace(valueDes);
          break;
        case r'deletedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.deletedAt = valueDes;
          break;
        case r'hideAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.hideAt = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'isSaved':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isSaved = valueDes;
          break;
        case r'memoryAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.memoryAt = valueDes;
          break;
        case r'ownerId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ownerId = valueDes;
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
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MemoryResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MemoryResponseDtoBuilder();
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


