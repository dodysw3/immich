//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_admin_delete_dto.g.dart';

/// UserAdminDeleteDto
///
/// Properties:
/// * [force] - Force delete even if user has assets
@BuiltValue()
abstract class UserAdminDeleteDto implements Built<UserAdminDeleteDto, UserAdminDeleteDtoBuilder> {
  /// Force delete even if user has assets
  @BuiltValueField(wireName: r'force')
  bool? get force;

  UserAdminDeleteDto._();

  factory UserAdminDeleteDto([void updates(UserAdminDeleteDtoBuilder b)]) = _$UserAdminDeleteDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserAdminDeleteDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserAdminDeleteDto> get serializer => _$UserAdminDeleteDtoSerializer();
}

class _$UserAdminDeleteDtoSerializer implements PrimitiveSerializer<UserAdminDeleteDto> {
  @override
  final Iterable<Type> types = const [UserAdminDeleteDto, _$UserAdminDeleteDto];

  @override
  final String wireName = r'UserAdminDeleteDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserAdminDeleteDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.force != null) {
      yield r'force';
      yield serializers.serialize(
        object.force,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UserAdminDeleteDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserAdminDeleteDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'force':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.force = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserAdminDeleteDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserAdminDeleteDtoBuilder();
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


