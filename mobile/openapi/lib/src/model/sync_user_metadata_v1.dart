//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user_metadata_key.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_user_metadata_v1.g.dart';

/// SyncUserMetadataV1
///
/// Properties:
/// * [key] 
/// * [userId] - User ID
/// * [value] - User metadata value
@BuiltValue()
abstract class SyncUserMetadataV1 implements Built<SyncUserMetadataV1, SyncUserMetadataV1Builder> {
  @BuiltValueField(wireName: r'key')
  UserMetadataKey get key;
  // enum keyEnum {  preferences,  license,  onboarding,  };

  /// User ID
  @BuiltValueField(wireName: r'userId')
  String get userId;

  /// User metadata value
  @BuiltValueField(wireName: r'value')
  BuiltMap<String, JsonObject?> get value;

  SyncUserMetadataV1._();

  factory SyncUserMetadataV1([void updates(SyncUserMetadataV1Builder b)]) = _$SyncUserMetadataV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncUserMetadataV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncUserMetadataV1> get serializer => _$SyncUserMetadataV1Serializer();
}

class _$SyncUserMetadataV1Serializer implements PrimitiveSerializer<SyncUserMetadataV1> {
  @override
  final Iterable<Type> types = const [SyncUserMetadataV1, _$SyncUserMetadataV1];

  @override
  final String wireName = r'SyncUserMetadataV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncUserMetadataV1 object, {
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
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncUserMetadataV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncUserMetadataV1Builder result,
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
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.value.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncUserMetadataV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncUserMetadataV1Builder();
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


