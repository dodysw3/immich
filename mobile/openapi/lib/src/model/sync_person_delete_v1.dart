//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_person_delete_v1.g.dart';

/// SyncPersonDeleteV1
///
/// Properties:
/// * [personId] - Person ID
@BuiltValue()
abstract class SyncPersonDeleteV1 implements Built<SyncPersonDeleteV1, SyncPersonDeleteV1Builder> {
  /// Person ID
  @BuiltValueField(wireName: r'personId')
  String get personId;

  SyncPersonDeleteV1._();

  factory SyncPersonDeleteV1([void updates(SyncPersonDeleteV1Builder b)]) = _$SyncPersonDeleteV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncPersonDeleteV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncPersonDeleteV1> get serializer => _$SyncPersonDeleteV1Serializer();
}

class _$SyncPersonDeleteV1Serializer implements PrimitiveSerializer<SyncPersonDeleteV1> {
  @override
  final Iterable<Type> types = const [SyncPersonDeleteV1, _$SyncPersonDeleteV1];

  @override
  final String wireName = r'SyncPersonDeleteV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncPersonDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'personId';
    yield serializers.serialize(
      object.personId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncPersonDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncPersonDeleteV1Builder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'personId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.personId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncPersonDeleteV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncPersonDeleteV1Builder();
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


