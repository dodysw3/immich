//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'dart:core';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/any_of.dart';

part 'download_asset_annotated_layers_parameter.g.dart';

/// DownloadAssetAnnotatedLayersParameter
@BuiltValue()
abstract class DownloadAssetAnnotatedLayersParameter implements Built<DownloadAssetAnnotatedLayersParameter, DownloadAssetAnnotatedLayersParameterBuilder> {
  /// Any Of [BuiltList<String>], [String]
  AnyOf get anyOf;

  DownloadAssetAnnotatedLayersParameter._();

  factory DownloadAssetAnnotatedLayersParameter([void updates(DownloadAssetAnnotatedLayersParameterBuilder b)]) = _$DownloadAssetAnnotatedLayersParameter;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DownloadAssetAnnotatedLayersParameterBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DownloadAssetAnnotatedLayersParameter> get serializer => _$DownloadAssetAnnotatedLayersParameterSerializer();
}

class _$DownloadAssetAnnotatedLayersParameterSerializer implements PrimitiveSerializer<DownloadAssetAnnotatedLayersParameter> {
  @override
  final Iterable<Type> types = const [DownloadAssetAnnotatedLayersParameter, _$DownloadAssetAnnotatedLayersParameter];

  @override
  final String wireName = r'DownloadAssetAnnotatedLayersParameter';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DownloadAssetAnnotatedLayersParameter object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
  }

  @override
  Object serialize(
    Serializers serializers,
    DownloadAssetAnnotatedLayersParameter object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final anyOf = object.anyOf;
    return serializers.serialize(anyOf, specifiedType: FullType(AnyOf, anyOf.types.map((type) => FullType(type)).toList()))!;
  }

  @override
  DownloadAssetAnnotatedLayersParameter deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DownloadAssetAnnotatedLayersParameterBuilder();
    Object? anyOfDataSrc;
    final targetType = const FullType(AnyOf, [FullType(AnyOf0Enum), FullType(BuiltList, [FullType(AnyOf1Enum)]), ]);
    anyOfDataSrc = serialized;
    result.anyOf = serializers.deserialize(anyOfDataSrc, specifiedType: targetType) as AnyOf;
    return result.build();
  }
}


