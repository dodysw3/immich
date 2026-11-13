//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'test_email_response_dto.g.dart';

/// TestEmailResponseDto
///
/// Properties:
/// * [messageId] - Email message ID
@BuiltValue()
abstract class TestEmailResponseDto implements Built<TestEmailResponseDto, TestEmailResponseDtoBuilder> {
  /// Email message ID
  @BuiltValueField(wireName: r'messageId')
  String get messageId;

  TestEmailResponseDto._();

  factory TestEmailResponseDto([void updates(TestEmailResponseDtoBuilder b)]) = _$TestEmailResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TestEmailResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TestEmailResponseDto> get serializer => _$TestEmailResponseDtoSerializer();
}

class _$TestEmailResponseDtoSerializer implements PrimitiveSerializer<TestEmailResponseDto> {
  @override
  final Iterable<Type> types = const [TestEmailResponseDto, _$TestEmailResponseDto];

  @override
  final String wireName = r'TestEmailResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TestEmailResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'messageId';
    yield serializers.serialize(
      object.messageId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TestEmailResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TestEmailResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'messageId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.messageId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TestEmailResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TestEmailResponseDtoBuilder();
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


