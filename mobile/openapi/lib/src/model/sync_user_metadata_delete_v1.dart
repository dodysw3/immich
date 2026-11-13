//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user_metadata_key.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_user_metadata_delete_v1.g.dart';

/// SyncUserMetadataDeleteV1
///
/// Properties:
/// * [key] 
/// * [userId] - User ID
@BuiltValue()
abstract class SyncUserMetadataDeleteV1 implements Built<SyncUserMetadataDeleteV1, SyncUserMetadataDeleteV1Builder> {
  @BuiltValueField(wireName: r'key')
  UserMetadataKey get key;
  // enum keyEnum {  preferences,  license,  onboarding,  };

  /// User ID
  @BuiltValueField(wireName: r'userId')
  String get userId;

  SyncUserMetadataDeleteV1._();

  factory SyncUserMetadataDeleteV1([void updates(SyncUserMetadataDeleteV1Builder b)]) = _$SyncUserMetadataDeleteV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncUserMetadataDeleteV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncUserMetadataDeleteV1> get serializer => _$SyncUserMetadataDeleteV1Serializer();
}

class _$SyncUserMetadataDeleteV1Serializer implements PrimitiveSerializer<SyncUserMetadataDeleteV1> {
  @override
  final Iterable<Type> types = const [SyncUserMetadataDeleteV1, _$SyncUserMetadataDeleteV1];

  @override
  final String wireName = r'SyncUserMetadataDeleteV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncUserMetadataDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(UserMetadataKey),
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
    SyncUserMetadataDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncUserMetadataDeleteV1Builder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserMetadataKey),
          ) as UserMetadataKey;
          result.key = valueDes;
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
  SyncUserMetadataDeleteV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncUserMetadataDeleteV1Builder();
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


