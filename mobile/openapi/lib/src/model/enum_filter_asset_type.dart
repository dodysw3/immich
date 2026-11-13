//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/asset_type_enum.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'enum_filter_asset_type.g.dart';

/// EnumFilterAssetType
///
/// Properties:
/// * [eq] 
/// * [in_] 
/// * [ne] 
/// * [notIn] 
@BuiltValue()
abstract class EnumFilterAssetType implements Built<EnumFilterAssetType, EnumFilterAssetTypeBuilder> {
  @BuiltValueField(wireName: r'eq')
  AssetTypeEnum? get eq;
  // enum eqEnum {  IMAGE,  VIDEO,  AUDIO,  OTHER,  };

  @BuiltValueField(wireName: r'in')
  BuiltList<AssetTypeEnum>? get in_;

  @BuiltValueField(wireName: r'ne')
  AssetTypeEnum? get ne;
  // enum neEnum {  IMAGE,  VIDEO,  AUDIO,  OTHER,  };

  @BuiltValueField(wireName: r'notIn')
  BuiltList<AssetTypeEnum>? get notIn;

  EnumFilterAssetType._();

  factory EnumFilterAssetType([void updates(EnumFilterAssetTypeBuilder b)]) = _$EnumFilterAssetType;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EnumFilterAssetTypeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EnumFilterAssetType> get serializer => _$EnumFilterAssetTypeSerializer();
}

class _$EnumFilterAssetTypeSerializer implements PrimitiveSerializer<EnumFilterAssetType> {
  @override
  final Iterable<Type> types = const [EnumFilterAssetType, _$EnumFilterAssetType];

  @override
  final String wireName = r'EnumFilterAssetType';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EnumFilterAssetType object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.eq != null) {
      yield r'eq';
      yield serializers.serialize(
        object.eq,
        specifiedType: const FullType(AssetTypeEnum),
      );
    }
    if (object.in_ != null) {
      yield r'in';
      yield serializers.serialize(
        object.in_,
        specifiedType: const FullType(BuiltList, [FullType(AssetTypeEnum)]),
      );
    }
    if (object.ne != null) {
      yield r'ne';
      yield serializers.serialize(
        object.ne,
        specifiedType: const FullType(AssetTypeEnum),
      );
    }
    if (object.notIn != null) {
      yield r'notIn';
      yield serializers.serialize(
        object.notIn,
        specifiedType: const FullType(BuiltList, [FullType(AssetTypeEnum)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    EnumFilterAssetType object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EnumFilterAssetTypeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'eq':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AssetTypeEnum),
          ) as AssetTypeEnum?;
          if (valueDes == null) continue;
          result.eq = valueDes;
          break;
        case r'in':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(AssetTypeEnum)]),
          ) as BuiltList<AssetTypeEnum>?;
          if (valueDes == null) continue;
          result.in_.replace(valueDes);
          break;
        case r'ne':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AssetTypeEnum),
          ) as AssetTypeEnum?;
          if (valueDes == null) continue;
          result.ne = valueDes;
          break;
        case r'notIn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(AssetTypeEnum)]),
          ) as BuiltList<AssetTypeEnum>?;
          if (valueDes == null) continue;
          result.notIn.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EnumFilterAssetType deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EnumFilterAssetTypeBuilder();
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


