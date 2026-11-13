//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user_avatar_color.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'avatar_update.g.dart';

/// AvatarUpdate
///
/// Properties:
/// * [color] 
@BuiltValue()
abstract class AvatarUpdate implements Built<AvatarUpdate, AvatarUpdateBuilder> {
  @BuiltValueField(wireName: r'color')
  UserAvatarColor? get color;
  // enum colorEnum {  primary,  pink,  red,  yellow,  blue,  green,  purple,  orange,  gray,  amber,  };

  AvatarUpdate._();

  factory AvatarUpdate([void updates(AvatarUpdateBuilder b)]) = _$AvatarUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AvatarUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AvatarUpdate> get serializer => _$AvatarUpdateSerializer();
}

class _$AvatarUpdateSerializer implements PrimitiveSerializer<AvatarUpdate> {
  @override
  final Iterable<Type> types = const [AvatarUpdate, _$AvatarUpdate];

  @override
  final String wireName = r'AvatarUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AvatarUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.color != null) {
      yield r'color';
      yield serializers.serialize(
        object.color,
        specifiedType: const FullType(UserAvatarColor),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AvatarUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AvatarUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'color':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(UserAvatarColor),
          ) as UserAvatarColor?;
          if (valueDes == null) continue;
          result.color = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AvatarUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AvatarUpdateBuilder();
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


