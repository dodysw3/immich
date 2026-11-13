//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/asset_response_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ai_interpret_search_item_dto.g.dart';

/// AiInterpretSearchItemDto
///
/// Properties:
/// * [asset] 
/// * [branch] - Search branch that contributed the best rank for this result
/// * [score] - Reciprocal rank fusion score of this result
@BuiltValue()
abstract class AiInterpretSearchItemDto implements Built<AiInterpretSearchItemDto, AiInterpretSearchItemDtoBuilder> {
  @BuiltValueField(wireName: r'asset')
  AssetResponseDto get asset;

  /// Search branch that contributed the best rank for this result
  @BuiltValueField(wireName: r'branch')
  AiInterpretSearchItemDtoBranchEnum get branch;
  // enum branchEnum {  dense,  lexical,  };

  /// Reciprocal rank fusion score of this result
  @BuiltValueField(wireName: r'score')
  double get score;

  AiInterpretSearchItemDto._();

  factory AiInterpretSearchItemDto([void updates(AiInterpretSearchItemDtoBuilder b)]) = _$AiInterpretSearchItemDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AiInterpretSearchItemDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AiInterpretSearchItemDto> get serializer => _$AiInterpretSearchItemDtoSerializer();
}

class _$AiInterpretSearchItemDtoSerializer implements PrimitiveSerializer<AiInterpretSearchItemDto> {
  @override
  final Iterable<Type> types = const [AiInterpretSearchItemDto, _$AiInterpretSearchItemDto];

  @override
  final String wireName = r'AiInterpretSearchItemDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AiInterpretSearchItemDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'asset';
    yield serializers.serialize(
      object.asset,
      specifiedType: const FullType(AssetResponseDto),
    );
    yield r'branch';
    yield serializers.serialize(
      object.branch,
      specifiedType: const FullType(AiInterpretSearchItemDtoBranchEnum),
    );
    yield r'score';
    yield serializers.serialize(
      object.score,
      specifiedType: const FullType(double),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AiInterpretSearchItemDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AiInterpretSearchItemDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'asset':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AssetResponseDto),
          ) as AssetResponseDto;
          result.asset.replace(valueDes);
          break;
        case r'branch':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AiInterpretSearchItemDtoBranchEnum),
          ) as AiInterpretSearchItemDtoBranchEnum;
          result.branch = valueDes;
          break;
        case r'score':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.score = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AiInterpretSearchItemDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AiInterpretSearchItemDtoBuilder();
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


/// Search branch that contributed the best rank for this result
class AiInterpretSearchItemDtoBranchEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'dense')
  static const AiInterpretSearchItemDtoBranchEnum dense = _$aiInterpretSearchItemDtoBranchEnum_dense;
  @BuiltValueEnumConst(wireName: r'lexical')
  static const AiInterpretSearchItemDtoBranchEnum lexical = _$aiInterpretSearchItemDtoBranchEnum_lexical;

  static Serializer<AiInterpretSearchItemDtoBranchEnum> get serializer => _$aiInterpretSearchItemDtoBranchEnumSerializer;

  const AiInterpretSearchItemDtoBranchEnum._(String name): super(name);

  static BuiltSet<AiInterpretSearchItemDtoBranchEnum> get values => _$aiInterpretSearchItemDtoBranchEnumValues;
  static AiInterpretSearchItemDtoBranchEnum valueOf(String name) => _$aiInterpretSearchItemDtoBranchEnumValueOf(name);
}

