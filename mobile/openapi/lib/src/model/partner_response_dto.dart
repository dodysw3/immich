//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user_avatar_color.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'partner_response_dto.g.dart';

/// Partner response
///
/// Properties:
/// * [avatarColor] 
/// * [email] - User email
/// * [id] - User ID
/// * [inTimeline] - Show in timeline
/// * [name] - User name
/// * [profileChangedAt] - Profile change date
/// * [profileImagePath] - Profile image path
@BuiltValue()
abstract class PartnerResponseDto implements Built<PartnerResponseDto, PartnerResponseDtoBuilder> {
  @BuiltValueField(wireName: r'avatarColor')
  UserAvatarColor get avatarColor;
  // enum avatarColorEnum {  primary,  pink,  red,  yellow,  blue,  green,  purple,  orange,  gray,  amber,  };

  /// User email
  @BuiltValueField(wireName: r'email')
  String get email;

  /// User ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Show in timeline
  @BuiltValueField(wireName: r'inTimeline')
  bool? get inTimeline;

  /// User name
  @BuiltValueField(wireName: r'name')
  String get name;

  /// Profile change date
  @BuiltValueField(wireName: r'profileChangedAt')
  DateTime get profileChangedAt;

  /// Profile image path
  @BuiltValueField(wireName: r'profileImagePath')
  String get profileImagePath;

  PartnerResponseDto._();

  factory PartnerResponseDto([void updates(PartnerResponseDtoBuilder b)]) = _$PartnerResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PartnerResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PartnerResponseDto> get serializer => _$PartnerResponseDtoSerializer();
}

class _$PartnerResponseDtoSerializer implements PrimitiveSerializer<PartnerResponseDto> {
  @override
  final Iterable<Type> types = const [PartnerResponseDto, _$PartnerResponseDto];

  @override
  final String wireName = r'PartnerResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PartnerResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'avatarColor';
    yield serializers.serialize(
      object.avatarColor,
      specifiedType: const FullType(UserAvatarColor),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    if (object.inTimeline != null) {
      yield r'inTimeline';
      yield serializers.serialize(
        object.inTimeline,
        specifiedType: const FullType(bool),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'profileChangedAt';
    yield serializers.serialize(
      object.profileChangedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'profileImagePath';
    yield serializers.serialize(
      object.profileImagePath,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PartnerResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PartnerResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'avatarColor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserAvatarColor),
          ) as UserAvatarColor;
          result.avatarColor = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'inTimeline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.inTimeline = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'profileChangedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.profileChangedAt = valueDes;
          break;
        case r'profileImagePath':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.profileImagePath = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PartnerResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PartnerResponseDtoBuilder();
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


