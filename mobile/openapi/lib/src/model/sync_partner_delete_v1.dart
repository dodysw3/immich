//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_partner_delete_v1.g.dart';

/// SyncPartnerDeleteV1
///
/// Properties:
/// * [sharedById] - Shared by ID
/// * [sharedWithId] - Shared with ID
@BuiltValue()
abstract class SyncPartnerDeleteV1 implements Built<SyncPartnerDeleteV1, SyncPartnerDeleteV1Builder> {
  /// Shared by ID
  @BuiltValueField(wireName: r'sharedById')
  String get sharedById;

  /// Shared with ID
  @BuiltValueField(wireName: r'sharedWithId')
  String get sharedWithId;

  SyncPartnerDeleteV1._();

  factory SyncPartnerDeleteV1([void updates(SyncPartnerDeleteV1Builder b)]) = _$SyncPartnerDeleteV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncPartnerDeleteV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncPartnerDeleteV1> get serializer => _$SyncPartnerDeleteV1Serializer();
}

class _$SyncPartnerDeleteV1Serializer implements PrimitiveSerializer<SyncPartnerDeleteV1> {
  @override
  final Iterable<Type> types = const [SyncPartnerDeleteV1, _$SyncPartnerDeleteV1];

  @override
  final String wireName = r'SyncPartnerDeleteV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncPartnerDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sharedById';
    yield serializers.serialize(
      object.sharedById,
      specifiedType: const FullType(String),
    );
    yield r'sharedWithId';
    yield serializers.serialize(
      object.sharedWithId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncPartnerDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncPartnerDeleteV1Builder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sharedById':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sharedById = valueDes;
          break;
        case r'sharedWithId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sharedWithId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncPartnerDeleteV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncPartnerDeleteV1Builder();
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


