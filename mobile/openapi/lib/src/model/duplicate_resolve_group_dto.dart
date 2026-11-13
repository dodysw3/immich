//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'duplicate_resolve_group_dto.g.dart';

/// DuplicateResolveGroupDto
///
/// Properties:
/// * [duplicateId] 
/// * [keepAssetIds] - Asset IDs to keep
/// * [trashAssetIds] - Asset IDs to trash or delete
@BuiltValue()
abstract class DuplicateResolveGroupDto implements Built<DuplicateResolveGroupDto, DuplicateResolveGroupDtoBuilder> {
  @BuiltValueField(wireName: r'duplicateId')
  String get duplicateId;

  /// Asset IDs to keep
  @BuiltValueField(wireName: r'keepAssetIds')
  BuiltList<String> get keepAssetIds;

  /// Asset IDs to trash or delete
  @BuiltValueField(wireName: r'trashAssetIds')
  BuiltList<String> get trashAssetIds;

  DuplicateResolveGroupDto._();

  factory DuplicateResolveGroupDto([void updates(DuplicateResolveGroupDtoBuilder b)]) = _$DuplicateResolveGroupDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DuplicateResolveGroupDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DuplicateResolveGroupDto> get serializer => _$DuplicateResolveGroupDtoSerializer();
}

class _$DuplicateResolveGroupDtoSerializer implements PrimitiveSerializer<DuplicateResolveGroupDto> {
  @override
  final Iterable<Type> types = const [DuplicateResolveGroupDto, _$DuplicateResolveGroupDto];

  @override
  final String wireName = r'DuplicateResolveGroupDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DuplicateResolveGroupDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'duplicateId';
    yield serializers.serialize(
      object.duplicateId,
      specifiedType: const FullType(String),
    );
    yield r'keepAssetIds';
    yield serializers.serialize(
      object.keepAssetIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'trashAssetIds';
    yield serializers.serialize(
      object.trashAssetIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DuplicateResolveGroupDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DuplicateResolveGroupDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'duplicateId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.duplicateId = valueDes;
          break;
        case r'keepAssetIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.keepAssetIds.replace(valueDes);
          break;
        case r'trashAssetIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.trashAssetIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DuplicateResolveGroupDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DuplicateResolveGroupDtoBuilder();
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


