//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/duplicate_resolve_group_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'duplicate_resolve_dto.g.dart';

/// DuplicateResolveDto
///
/// Properties:
/// * [groups] - List of duplicate groups to resolve
@BuiltValue()
abstract class DuplicateResolveDto implements Built<DuplicateResolveDto, DuplicateResolveDtoBuilder> {
  /// List of duplicate groups to resolve
  @BuiltValueField(wireName: r'groups')
  BuiltList<DuplicateResolveGroupDto> get groups;

  DuplicateResolveDto._();

  factory DuplicateResolveDto([void updates(DuplicateResolveDtoBuilder b)]) = _$DuplicateResolveDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DuplicateResolveDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DuplicateResolveDto> get serializer => _$DuplicateResolveDtoSerializer();
}

class _$DuplicateResolveDtoSerializer implements PrimitiveSerializer<DuplicateResolveDto> {
  @override
  final Iterable<Type> types = const [DuplicateResolveDto, _$DuplicateResolveDto];

  @override
  final String wireName = r'DuplicateResolveDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DuplicateResolveDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'groups';
    yield serializers.serialize(
      object.groups,
      specifiedType: const FullType(BuiltList, [FullType(DuplicateResolveGroupDto)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DuplicateResolveDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DuplicateResolveDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'groups':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DuplicateResolveGroupDto)]),
          ) as BuiltList<DuplicateResolveGroupDto>;
          result.groups.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DuplicateResolveDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DuplicateResolveDtoBuilder();
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


