//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'onboarding_dto.g.dart';

/// OnboardingDto
///
/// Properties:
/// * [isOnboarded] - Is user onboarded
@BuiltValue()
abstract class OnboardingDto implements Built<OnboardingDto, OnboardingDtoBuilder> {
  /// Is user onboarded
  @BuiltValueField(wireName: r'isOnboarded')
  bool get isOnboarded;

  OnboardingDto._();

  factory OnboardingDto([void updates(OnboardingDtoBuilder b)]) = _$OnboardingDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OnboardingDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OnboardingDto> get serializer => _$OnboardingDtoSerializer();
}

class _$OnboardingDtoSerializer implements PrimitiveSerializer<OnboardingDto> {
  @override
  final Iterable<Type> types = const [OnboardingDto, _$OnboardingDto];

  @override
  final String wireName = r'OnboardingDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OnboardingDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'isOnboarded';
    yield serializers.serialize(
      object.isOnboarded,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OnboardingDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OnboardingDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'isOnboarded':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isOnboarded = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OnboardingDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OnboardingDtoBuilder();
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


