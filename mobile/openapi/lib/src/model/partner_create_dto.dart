//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'partner_create_dto.g.dart';

/// PartnerCreateDto
///
/// Properties:
/// * [sharedWithId] - User ID to share with
@BuiltValue()
abstract class PartnerCreateDto implements Built<PartnerCreateDto, PartnerCreateDtoBuilder> {
  /// User ID to share with
  @BuiltValueField(wireName: r'sharedWithId')
  String get sharedWithId;

  PartnerCreateDto._();

  factory PartnerCreateDto([void updates(PartnerCreateDtoBuilder b)]) = _$PartnerCreateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PartnerCreateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PartnerCreateDto> get serializer => _$PartnerCreateDtoSerializer();
}

class _$PartnerCreateDtoSerializer implements PrimitiveSerializer<PartnerCreateDto> {
  @override
  final Iterable<Type> types = const [PartnerCreateDto, _$PartnerCreateDto];

  @override
  final String wireName = r'PartnerCreateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PartnerCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sharedWithId';
    yield serializers.serialize(
      object.sharedWithId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PartnerCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PartnerCreateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sharedWithId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sharedWithId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PartnerCreateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PartnerCreateDtoBuilder();
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


