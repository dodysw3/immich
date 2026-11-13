//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/reaction_type.dart';
import 'package:openapi/src/model/user_response_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'activity_response_dto.g.dart';

/// ActivityResponseDto
///
/// Properties:
/// * [assetId] - Asset ID (if activity is for an asset)
/// * [comment] - Comment text (for comment activities)
/// * [createdAt] - Creation date
/// * [id] - Activity ID
/// * [type] 
/// * [user] 
@BuiltValue()
abstract class ActivityResponseDto implements Built<ActivityResponseDto, ActivityResponseDtoBuilder> {
  /// Asset ID (if activity is for an asset)
  @BuiltValueField(wireName: r'assetId')
  String? get assetId;

  /// Comment text (for comment activities)
  @BuiltValueField(wireName: r'comment')
  String? get comment;

  /// Creation date
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// Activity ID
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'type')
  ReactionType get type;
  // enum typeEnum {  comment,  like,  };

  @BuiltValueField(wireName: r'user')
  UserResponseDto get user;

  ActivityResponseDto._();

  factory ActivityResponseDto([void updates(ActivityResponseDtoBuilder b)]) = _$ActivityResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ActivityResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ActivityResponseDto> get serializer => _$ActivityResponseDtoSerializer();
}

class _$ActivityResponseDtoSerializer implements PrimitiveSerializer<ActivityResponseDto> {
  @override
  final Iterable<Type> types = const [ActivityResponseDto, _$ActivityResponseDto];

  @override
  final String wireName = r'ActivityResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ActivityResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assetId';
    yield object.assetId == null ? null : serializers.serialize(
      object.assetId,
      specifiedType: const FullType.nullable(String),
    );
    if (object.comment != null) {
      yield r'comment';
      yield serializers.serialize(
        object.comment,
        specifiedType: const FullType.nullable(String),
      );
    }
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
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(ReactionType),
    );
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(UserResponseDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ActivityResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ActivityResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assetId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.assetId = valueDes;
          break;
        case r'comment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.comment = valueDes;
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
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReactionType),
          ) as ReactionType;
          result.type = valueDes;
          break;
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserResponseDto),
          ) as UserResponseDto;
          result.user.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ActivityResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ActivityResponseDtoBuilder();
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


