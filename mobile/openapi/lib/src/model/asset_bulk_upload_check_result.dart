//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/asset_reject_reason.dart';
import 'package:openapi/src/model/asset_upload_action.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_bulk_upload_check_result.g.dart';

/// AssetBulkUploadCheckResult
///
/// Properties:
/// * [action] 
/// * [assetId] - Existing asset ID if duplicate
/// * [id] - Client-side identifier echoed from the request to match results to inputs
/// * [isTrashed] - Whether existing asset is trashed
/// * [reason] 
@BuiltValue()
abstract class AssetBulkUploadCheckResult implements Built<AssetBulkUploadCheckResult, AssetBulkUploadCheckResultBuilder> {
  @BuiltValueField(wireName: r'action')
  AssetUploadAction get action;
  // enum actionEnum {  accept,  reject,  };

  /// Existing asset ID if duplicate
  @BuiltValueField(wireName: r'assetId')
  String? get assetId;

  /// Client-side identifier echoed from the request to match results to inputs
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Whether existing asset is trashed
  @BuiltValueField(wireName: r'isTrashed')
  bool? get isTrashed;

  @BuiltValueField(wireName: r'reason')
  AssetRejectReason? get reason;
  // enum reasonEnum {  duplicate,  unsupported-format,  };

  AssetBulkUploadCheckResult._();

  factory AssetBulkUploadCheckResult([void updates(AssetBulkUploadCheckResultBuilder b)]) = _$AssetBulkUploadCheckResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetBulkUploadCheckResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetBulkUploadCheckResult> get serializer => _$AssetBulkUploadCheckResultSerializer();
}

class _$AssetBulkUploadCheckResultSerializer implements PrimitiveSerializer<AssetBulkUploadCheckResult> {
  @override
  final Iterable<Type> types = const [AssetBulkUploadCheckResult, _$AssetBulkUploadCheckResult];

  @override
  final String wireName = r'AssetBulkUploadCheckResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetBulkUploadCheckResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(AssetUploadAction),
    );
    if (object.assetId != null) {
      yield r'assetId';
      yield serializers.serialize(
        object.assetId,
        specifiedType: const FullType(String),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    if (object.isTrashed != null) {
      yield r'isTrashed';
      yield serializers.serialize(
        object.isTrashed,
        specifiedType: const FullType(bool),
      );
    }
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(AssetRejectReason),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AssetBulkUploadCheckResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssetBulkUploadCheckResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AssetUploadAction),
          ) as AssetUploadAction;
          result.action = valueDes;
          break;
        case r'assetId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.assetId = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'isTrashed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isTrashed = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AssetRejectReason),
          ) as AssetRejectReason?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AssetBulkUploadCheckResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetBulkUploadCheckResultBuilder();
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


