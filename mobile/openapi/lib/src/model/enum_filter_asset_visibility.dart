//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/asset_visibility.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'enum_filter_asset_visibility.g.dart';

/// EnumFilterAssetVisibility
///
/// Properties:
/// * [eq] 
/// * [in_] 
/// * [ne] 
/// * [notIn] 
@BuiltValue()
abstract class EnumFilterAssetVisibility implements Built<EnumFilterAssetVisibility, EnumFilterAssetVisibilityBuilder> {
  @BuiltValueField(wireName: r'eq')
  AssetVisibility? get eq;
  // enum eqEnum {  archive,  timeline,  hidden,  locked,  };

  @BuiltValueField(wireName: r'in')
  BuiltList<AssetVisibility>? get in_;

  @BuiltValueField(wireName: r'ne')
  AssetVisibility? get ne;
  // enum neEnum {  archive,  timeline,  hidden,  locked,  };

  @BuiltValueField(wireName: r'notIn')
  BuiltList<AssetVisibility>? get notIn;

  EnumFilterAssetVisibility._();

  factory EnumFilterAssetVisibility([void updates(EnumFilterAssetVisibilityBuilder b)]) = _$EnumFilterAssetVisibility;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EnumFilterAssetVisibilityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EnumFilterAssetVisibility> get serializer => _$EnumFilterAssetVisibilitySerializer();
}

class _$EnumFilterAssetVisibilitySerializer implements PrimitiveSerializer<EnumFilterAssetVisibility> {
  @override
  final Iterable<Type> types = const [EnumFilterAssetVisibility, _$EnumFilterAssetVisibility];

  @override
  final String wireName = r'EnumFilterAssetVisibility';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EnumFilterAssetVisibility object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.eq != null) {
      yield r'eq';
      yield serializers.serialize(
        object.eq,
        specifiedType: const FullType(AssetVisibility),
      );
    }
    if (object.in_ != null) {
      yield r'in';
      yield serializers.serialize(
        object.in_,
        specifiedType: const FullType(BuiltList, [FullType(AssetVisibility)]),
      );
    }
    if (object.ne != null) {
      yield r'ne';
      yield serializers.serialize(
        object.ne,
        specifiedType: const FullType(AssetVisibility),
      );
    }
    if (object.notIn != null) {
      yield r'notIn';
      yield serializers.serialize(
        object.notIn,
        specifiedType: const FullType(BuiltList, [FullType(AssetVisibility)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    EnumFilterAssetVisibility object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EnumFilterAssetVisibilityBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'eq':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AssetVisibility),
          ) as AssetVisibility?;
          if (valueDes == null) continue;
          result.eq = valueDes;
          break;
        case r'in':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(AssetVisibility)]),
          ) as BuiltList<AssetVisibility>?;
          if (valueDes == null) continue;
          result.in_.replace(valueDes);
          break;
        case r'ne':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AssetVisibility),
          ) as AssetVisibility?;
          if (valueDes == null) continue;
          result.ne = valueDes;
          break;
        case r'notIn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(AssetVisibility)]),
          ) as BuiltList<AssetVisibility>?;
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
  EnumFilterAssetVisibility deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EnumFilterAssetVisibilityBuilder();
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


