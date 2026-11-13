//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_user_delete_v1.g.dart';

/// SyncUserDeleteV1
///
/// Properties:
/// * [userId] - User ID
@BuiltValue()
abstract class SyncUserDeleteV1 implements Built<SyncUserDeleteV1, SyncUserDeleteV1Builder> {
  /// User ID
  @BuiltValueField(wireName: r'userId')
  String get userId;

  SyncUserDeleteV1._();

  factory SyncUserDeleteV1([void updates(SyncUserDeleteV1Builder b)]) = _$SyncUserDeleteV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncUserDeleteV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncUserDeleteV1> get serializer => _$SyncUserDeleteV1Serializer();
}

class _$SyncUserDeleteV1Serializer implements PrimitiveSerializer<SyncUserDeleteV1> {
  @override
  final Iterable<Type> types = const [SyncUserDeleteV1, _$SyncUserDeleteV1];

  @override
  final String wireName = r'SyncUserDeleteV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncUserDeleteV1 object, {
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
    SyncUserDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncUserDeleteV1Builder result,
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
  SyncUserDeleteV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncUserDeleteV1Builder();
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


