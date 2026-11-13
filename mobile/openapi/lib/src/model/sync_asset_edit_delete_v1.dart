//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_asset_edit_delete_v1.g.dart';

/// SyncAssetEditDeleteV1
///
/// Properties:
/// * [editId] - Edit ID
@BuiltValue()
abstract class SyncAssetEditDeleteV1 implements Built<SyncAssetEditDeleteV1, SyncAssetEditDeleteV1Builder> {
  /// Edit ID
  @BuiltValueField(wireName: r'editId')
  String get editId;

  SyncAssetEditDeleteV1._();

  factory SyncAssetEditDeleteV1([void updates(SyncAssetEditDeleteV1Builder b)]) = _$SyncAssetEditDeleteV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncAssetEditDeleteV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncAssetEditDeleteV1> get serializer => _$SyncAssetEditDeleteV1Serializer();
}

class _$SyncAssetEditDeleteV1Serializer implements PrimitiveSerializer<SyncAssetEditDeleteV1> {
  @override
  final Iterable<Type> types = const [SyncAssetEditDeleteV1, _$SyncAssetEditDeleteV1];

  @override
  final String wireName = r'SyncAssetEditDeleteV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncAssetEditDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'editId';
    yield serializers.serialize(
      object.editId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncAssetEditDeleteV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncAssetEditDeleteV1Builder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'editId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.editId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncAssetEditDeleteV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncAssetEditDeleteV1Builder();
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


