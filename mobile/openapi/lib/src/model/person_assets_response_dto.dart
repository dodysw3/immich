//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/person_assets_response_dto_assets_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'person_assets_response_dto.g.dart';

/// PersonAssetsResponseDto
///
/// Properties:
/// * [assets] - Assets sorted by recognition time
/// * [total] - Total number of assets
@BuiltValue()
abstract class PersonAssetsResponseDto implements Built<PersonAssetsResponseDto, PersonAssetsResponseDtoBuilder> {
  /// Assets sorted by recognition time
  @BuiltValueField(wireName: r'assets')
  BuiltList<PersonAssetsResponseDtoAssetsInner> get assets;

  /// Total number of assets
  @BuiltValueField(wireName: r'total')
  int get total;

  PersonAssetsResponseDto._();

  factory PersonAssetsResponseDto([void updates(PersonAssetsResponseDtoBuilder b)]) = _$PersonAssetsResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PersonAssetsResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PersonAssetsResponseDto> get serializer => _$PersonAssetsResponseDtoSerializer();
}

class _$PersonAssetsResponseDtoSerializer implements PrimitiveSerializer<PersonAssetsResponseDto> {
  @override
  final Iterable<Type> types = const [PersonAssetsResponseDto, _$PersonAssetsResponseDto];

  @override
  final String wireName = r'PersonAssetsResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PersonAssetsResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assets';
    yield serializers.serialize(
      object.assets,
      specifiedType: const FullType(BuiltList, [FullType(PersonAssetsResponseDtoAssetsInner)]),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PersonAssetsResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PersonAssetsResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PersonAssetsResponseDtoAssetsInner)]),
          ) as BuiltList<PersonAssetsResponseDtoAssetsInner>;
          result.assets.replace(valueDes);
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PersonAssetsResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PersonAssetsResponseDtoBuilder();
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


