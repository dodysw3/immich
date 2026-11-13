//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cluster_group_request_response_dto.g.dart';

/// ClusterGroupRequestResponseDto
///
/// Properties:
/// * [clusterGroupId] - Cluster group the user is invited to join
/// * [createdAt] - Creation date
/// * [id] - Request ID
/// * [userId] - User the request was created for
@BuiltValue()
abstract class ClusterGroupRequestResponseDto implements Built<ClusterGroupRequestResponseDto, ClusterGroupRequestResponseDtoBuilder> {
  /// Cluster group the user is invited to join
  @BuiltValueField(wireName: r'clusterGroupId')
  String get clusterGroupId;

  /// Creation date
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// Request ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// User the request was created for
  @BuiltValueField(wireName: r'userId')
  String get userId;

  ClusterGroupRequestResponseDto._();

  factory ClusterGroupRequestResponseDto([void updates(ClusterGroupRequestResponseDtoBuilder b)]) = _$ClusterGroupRequestResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ClusterGroupRequestResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ClusterGroupRequestResponseDto> get serializer => _$ClusterGroupRequestResponseDtoSerializer();
}

class _$ClusterGroupRequestResponseDtoSerializer implements PrimitiveSerializer<ClusterGroupRequestResponseDto> {
  @override
  final Iterable<Type> types = const [ClusterGroupRequestResponseDto, _$ClusterGroupRequestResponseDto];

  @override
  final String wireName = r'ClusterGroupRequestResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ClusterGroupRequestResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'clusterGroupId';
    yield serializers.serialize(
      object.clusterGroupId,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'userId';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ClusterGroupRequestResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ClusterGroupRequestResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'clusterGroupId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.clusterGroupId = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
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
  ClusterGroupRequestResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ClusterGroupRequestResponseDtoBuilder();
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


