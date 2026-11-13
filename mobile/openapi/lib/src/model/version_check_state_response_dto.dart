//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'version_check_state_response_dto.g.dart';

/// VersionCheckStateResponseDto
///
/// Properties:
/// * [checkedAt] - Last check timestamp
/// * [releaseVersion] - Release version
@BuiltValue()
abstract class VersionCheckStateResponseDto implements Built<VersionCheckStateResponseDto, VersionCheckStateResponseDtoBuilder> {
  /// Last check timestamp
  @BuiltValueField(wireName: r'checkedAt')
  String? get checkedAt;

  /// Release version
  @BuiltValueField(wireName: r'releaseVersion')
  String? get releaseVersion;

  VersionCheckStateResponseDto._();

  factory VersionCheckStateResponseDto([void updates(VersionCheckStateResponseDtoBuilder b)]) = _$VersionCheckStateResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VersionCheckStateResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VersionCheckStateResponseDto> get serializer => _$VersionCheckStateResponseDtoSerializer();
}

class _$VersionCheckStateResponseDtoSerializer implements PrimitiveSerializer<VersionCheckStateResponseDto> {
  @override
  final Iterable<Type> types = const [VersionCheckStateResponseDto, _$VersionCheckStateResponseDto];

  @override
  final String wireName = r'VersionCheckStateResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VersionCheckStateResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'checkedAt';
    yield object.checkedAt == null ? null : serializers.serialize(
      object.checkedAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'releaseVersion';
    yield object.releaseVersion == null ? null : serializers.serialize(
      object.releaseVersion,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VersionCheckStateResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VersionCheckStateResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'checkedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.checkedAt = valueDes;
          break;
        case r'releaseVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.releaseVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VersionCheckStateResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VersionCheckStateResponseDtoBuilder();
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


