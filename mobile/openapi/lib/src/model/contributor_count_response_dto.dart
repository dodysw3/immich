//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'contributor_count_response_dto.g.dart';

/// ContributorCountResponseDto
///
/// Properties:
/// * [assetCount] - Number of assets contributed
/// * [userId] - User ID
@BuiltValue()
abstract class ContributorCountResponseDto implements Built<ContributorCountResponseDto, ContributorCountResponseDtoBuilder> {
  /// Number of assets contributed
  @BuiltValueField(wireName: r'assetCount')
  int get assetCount;

  /// User ID
  @BuiltValueField(wireName: r'userId')
  String get userId;

  ContributorCountResponseDto._();

  factory ContributorCountResponseDto([void updates(ContributorCountResponseDtoBuilder b)]) = _$ContributorCountResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContributorCountResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContributorCountResponseDto> get serializer => _$ContributorCountResponseDtoSerializer();
}

class _$ContributorCountResponseDtoSerializer implements PrimitiveSerializer<ContributorCountResponseDto> {
  @override
  final Iterable<Type> types = const [ContributorCountResponseDto, _$ContributorCountResponseDto];

  @override
  final String wireName = r'ContributorCountResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContributorCountResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assetCount';
    yield serializers.serialize(
      object.assetCount,
      specifiedType: const FullType(int),
    );
    yield r'userId';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ContributorCountResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ContributorCountResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assetCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.assetCount = valueDes;
          break;
        case r'userId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ContributorCountResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContributorCountResponseDtoBuilder();
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


