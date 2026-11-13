//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'shared_link_login_dto.g.dart';

/// SharedLinkLoginDto
///
/// Properties:
/// * [password] - Shared link password
@BuiltValue()
abstract class SharedLinkLoginDto implements Built<SharedLinkLoginDto, SharedLinkLoginDtoBuilder> {
  /// Shared link password
  @BuiltValueField(wireName: r'password')
  String get password;

  SharedLinkLoginDto._();

  factory SharedLinkLoginDto([void updates(SharedLinkLoginDtoBuilder b)]) = _$SharedLinkLoginDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SharedLinkLoginDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SharedLinkLoginDto> get serializer => _$SharedLinkLoginDtoSerializer();
}

class _$SharedLinkLoginDtoSerializer implements PrimitiveSerializer<SharedLinkLoginDto> {
  @override
  final Iterable<Type> types = const [SharedLinkLoginDto, _$SharedLinkLoginDto];

  @override
  final String wireName = r'SharedLinkLoginDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SharedLinkLoginDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'password';
    yield serializers.serialize(
      object.password,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SharedLinkLoginDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SharedLinkLoginDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.password = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SharedLinkLoginDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SharedLinkLoginDtoBuilder();
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


