//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_video_near_dup_dto.g.dart';

/// AdminConfigVideoNearDupDto
///
/// Properties:
/// * [durationRelTol] - Relative duration tolerance as a fraction of the longer video
/// * [enabled] - Group near-duplicate videos via frame, audio, and metadata fingerprints when CLIP preview similarity finds none
/// * [groupThreshold] - Minimum composite similarity before two videos are grouped as near-duplicates
/// * [maxDurationDeltaMs] - Absolute duration tolerance in milliseconds for video near-duplicate candidates
@BuiltValue()
abstract class AdminConfigVideoNearDupDto implements Built<AdminConfigVideoNearDupDto, AdminConfigVideoNearDupDtoBuilder> {
  /// Relative duration tolerance as a fraction of the longer video
  @BuiltValueField(wireName: r'durationRelTol')
  double get durationRelTol;

  /// Group near-duplicate videos via frame, audio, and metadata fingerprints when CLIP preview similarity finds none
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// Minimum composite similarity before two videos are grouped as near-duplicates
  @BuiltValueField(wireName: r'groupThreshold')
  double get groupThreshold;

  /// Absolute duration tolerance in milliseconds for video near-duplicate candidates
  @BuiltValueField(wireName: r'maxDurationDeltaMs')
  int get maxDurationDeltaMs;

  AdminConfigVideoNearDupDto._();

  factory AdminConfigVideoNearDupDto([void updates(AdminConfigVideoNearDupDtoBuilder b)]) = _$AdminConfigVideoNearDupDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigVideoNearDupDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigVideoNearDupDto> get serializer => _$AdminConfigVideoNearDupDtoSerializer();
}

class _$AdminConfigVideoNearDupDtoSerializer implements PrimitiveSerializer<AdminConfigVideoNearDupDto> {
  @override
  final Iterable<Type> types = const [AdminConfigVideoNearDupDto, _$AdminConfigVideoNearDupDto];

  @override
  final String wireName = r'AdminConfigVideoNearDupDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigVideoNearDupDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'durationRelTol';
    yield serializers.serialize(
      object.durationRelTol,
      specifiedType: const FullType(double),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'groupThreshold';
    yield serializers.serialize(
      object.groupThreshold,
      specifiedType: const FullType(double),
    );
    yield r'maxDurationDeltaMs';
    yield serializers.serialize(
      object.maxDurationDeltaMs,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigVideoNearDupDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigVideoNearDupDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'durationRelTol':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.durationRelTol = valueDes;
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'groupThreshold':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.groupThreshold = valueDes;
          break;
        case r'maxDurationDeltaMs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.maxDurationDeltaMs = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigVideoNearDupDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigVideoNearDupDtoBuilder();
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


