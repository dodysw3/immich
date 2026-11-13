//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'onboarding_response_dto.g.dart';

/// OnboardingResponseDto
///
/// Properties:
/// * [isOnboarded] - Is user onboarded
@BuiltValue()
abstract class OnboardingResponseDto implements Built<OnboardingResponseDto, OnboardingResponseDtoBuilder> {
  /// Is user onboarded
  @BuiltValueField(wireName: r'isOnboarded')
  bool get isOnboarded;

  OnboardingResponseDto._();

  factory OnboardingResponseDto([void updates(OnboardingResponseDtoBuilder b)]) = _$OnboardingResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OnboardingResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OnboardingResponseDto> get serializer => _$OnboardingResponseDtoSerializer();
}

class _$OnboardingResponseDtoSerializer implements PrimitiveSerializer<OnboardingResponseDto> {
  @override
  final Iterable<Type> types = const [OnboardingResponseDto, _$OnboardingResponseDto];

  @override
  final String wireName = r'OnboardingResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OnboardingResponseDto object, {
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
    OnboardingResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OnboardingResponseDtoBuilder result,
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
  OnboardingResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OnboardingResponseDtoBuilder();
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


