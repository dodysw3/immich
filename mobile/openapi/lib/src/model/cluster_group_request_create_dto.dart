//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cluster_group_request_create_dto.g.dart';

/// ClusterGroupRequestCreateDto
///
/// Properties:
/// * [userId] - User to invite into the cluster group
@BuiltValue()
abstract class ClusterGroupRequestCreateDto implements Built<ClusterGroupRequestCreateDto, ClusterGroupRequestCreateDtoBuilder> {
  /// User to invite into the cluster group
  @BuiltValueField(wireName: r'userId')
  String get userId;

  ClusterGroupRequestCreateDto._();

  factory ClusterGroupRequestCreateDto([void updates(ClusterGroupRequestCreateDtoBuilder b)]) = _$ClusterGroupRequestCreateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ClusterGroupRequestCreateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ClusterGroupRequestCreateDto> get serializer => _$ClusterGroupRequestCreateDtoSerializer();
}

class _$ClusterGroupRequestCreateDtoSerializer implements PrimitiveSerializer<ClusterGroupRequestCreateDto> {
  @override
  final Iterable<Type> types = const [ClusterGroupRequestCreateDto, _$ClusterGroupRequestCreateDto];

  @override
  final String wireName = r'ClusterGroupRequestCreateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ClusterGroupRequestCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'userId';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ClusterGroupRequestCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ClusterGroupRequestCreateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'userId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ClusterGroupRequestCreateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ClusterGroupRequestCreateDtoBuilder();
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


