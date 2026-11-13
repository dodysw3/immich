//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'partner_update_dto.g.dart';

/// PartnerUpdateDto
///
/// Properties:
/// * [inTimeline] - Show partner assets in timeline
@BuiltValue()
abstract class PartnerUpdateDto implements Built<PartnerUpdateDto, PartnerUpdateDtoBuilder> {
  /// Show partner assets in timeline
  @BuiltValueField(wireName: r'inTimeline')
  bool get inTimeline;

  PartnerUpdateDto._();

  factory PartnerUpdateDto([void updates(PartnerUpdateDtoBuilder b)]) = _$PartnerUpdateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PartnerUpdateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PartnerUpdateDto> get serializer => _$PartnerUpdateDtoSerializer();
}

class _$PartnerUpdateDtoSerializer implements PrimitiveSerializer<PartnerUpdateDto> {
  @override
  final Iterable<Type> types = const [PartnerUpdateDto, _$PartnerUpdateDto];

  @override
  final String wireName = r'PartnerUpdateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PartnerUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'inTimeline';
    yield serializers.serialize(
      object.inTimeline,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PartnerUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PartnerUpdateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'inTimeline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.inTimeline = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PartnerUpdateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PartnerUpdateDtoBuilder();
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


