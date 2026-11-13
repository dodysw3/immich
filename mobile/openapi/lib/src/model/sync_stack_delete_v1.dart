//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_stack_delete_v1.g.dart';

/// SyncStackDeleteV1
///
/// Properties:
/// * [stackId] - Stack ID
@BuiltValue()
abstract class SyncStackDeleteV1 implements Built<SyncStackDeleteV1, SyncStackDeleteV1Builder> {
  /// Stack ID
  @BuiltValueField(wireName: r'stackId')
  String get stackId;

  SyncStackDeleteV1._();

  factory SyncStackDeleteV1([void updates(SyncStackDeleteV1Builder b)]) = _$SyncStackDeleteV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncStackDeleteV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncStackDeleteV1> get serializer => _$SyncStackDeleteV1Serializer();
}

class _$SyncStackDeleteV1Serializer implements PrimitiveSerializer<SyncStackDeleteV1> {
  @override
  final Iterable<Type> types = const [SyncStackDeleteV1, _$SyncStackDeleteV1];

  @override
  final String wireName = r'SyncStackDeleteV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncStackDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'stackId';
    yield serializers.serialize(
      object.stackId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncStackDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncStackDeleteV1Builder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'stackId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.stackId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncStackDeleteV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncStackDeleteV1Builder();
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


