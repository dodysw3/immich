//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_partner_v1.g.dart';

/// SyncPartnerV1
///
/// Properties:
/// * [inTimeline] - In timeline
/// * [sharedById] - Shared by ID
/// * [sharedWithId] - Shared with ID
@BuiltValue()
abstract class SyncPartnerV1 implements Built<SyncPartnerV1, SyncPartnerV1Builder> {
  /// In timeline
  @BuiltValueField(wireName: r'inTimeline')
  bool get inTimeline;

  /// Shared by ID
  @BuiltValueField(wireName: r'sharedById')
  String get sharedById;

  /// Shared with ID
  @BuiltValueField(wireName: r'sharedWithId')
  String get sharedWithId;

  SyncPartnerV1._();

  factory SyncPartnerV1([void updates(SyncPartnerV1Builder b)]) = _$SyncPartnerV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncPartnerV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncPartnerV1> get serializer => _$SyncPartnerV1Serializer();
}

class _$SyncPartnerV1Serializer implements PrimitiveSerializer<SyncPartnerV1> {
  @override
  final Iterable<Type> types = const [SyncPartnerV1, _$SyncPartnerV1];

  @override
  final String wireName = r'SyncPartnerV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncPartnerV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'inTimeline';
    yield serializers.serialize(
      object.inTimeline,
      specifiedType: const FullType(bool),
    );
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
    SyncPartnerV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncPartnerV1Builder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'inTimeline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.inTimeline = valueDes;
          break;
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
  SyncPartnerV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncPartnerV1Builder();
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


