//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/asset_edit_action.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_asset_edit_v1.g.dart';

/// SyncAssetEditV1
///
/// Properties:
/// * [action] 
/// * [assetId] - Asset ID
/// * [id] - Edit ID
/// * [parameters] - Edit parameters
/// * [sequence] - Edit sequence
@BuiltValue()
abstract class SyncAssetEditV1 implements Built<SyncAssetEditV1, SyncAssetEditV1Builder> {
  @BuiltValueField(wireName: r'action')
  AssetEditAction get action;
  // enum actionEnum {  crop,  rotate,  mirror,  };

  /// Asset ID
  @BuiltValueField(wireName: r'assetId')
  String get assetId;

  /// Edit ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Edit parameters
  @BuiltValueField(wireName: r'parameters')
  BuiltMap<String, JsonObject?> get parameters;

  /// Edit sequence
  @BuiltValueField(wireName: r'sequence')
  int get sequence;

  SyncAssetEditV1._();

  factory SyncAssetEditV1([void updates(SyncAssetEditV1Builder b)]) = _$SyncAssetEditV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncAssetEditV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncAssetEditV1> get serializer => _$SyncAssetEditV1Serializer();
}

class _$SyncAssetEditV1Serializer implements PrimitiveSerializer<SyncAssetEditV1> {
  @override
  final Iterable<Type> types = const [SyncAssetEditV1, _$SyncAssetEditV1];

  @override
  final String wireName = r'SyncAssetEditV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncAssetEditV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(AssetEditAction),
    );
    yield r'assetId';
    yield serializers.serialize(
      object.assetId,
      specifiedType: const FullType(String),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'parameters';
    yield serializers.serialize(
      object.parameters,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'sequence';
    yield serializers.serialize(
      object.sequence,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncAssetEditV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncAssetEditV1Builder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AssetEditAction),
          ) as AssetEditAction;
          result.action = valueDes;
          break;
        case r'assetId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.assetId = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'parameters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.parameters.replace(valueDes);
          break;
        case r'sequence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sequence = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncAssetEditV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncAssetEditV1Builder();
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


