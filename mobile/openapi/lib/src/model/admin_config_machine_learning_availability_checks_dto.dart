//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_machine_learning_availability_checks_dto.g.dart';

/// AdminConfigMachineLearningAvailabilityChecksDto
///
/// Properties:
/// * [enabled] - Enabled
/// * [interval] 
/// * [timeout] 
@BuiltValue()
abstract class AdminConfigMachineLearningAvailabilityChecksDto implements Built<AdminConfigMachineLearningAvailabilityChecksDto, AdminConfigMachineLearningAvailabilityChecksDtoBuilder> {
  /// Enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'interval')
  int get interval;

  @BuiltValueField(wireName: r'timeout')
  int get timeout;

  AdminConfigMachineLearningAvailabilityChecksDto._();

  factory AdminConfigMachineLearningAvailabilityChecksDto([void updates(AdminConfigMachineLearningAvailabilityChecksDtoBuilder b)]) = _$AdminConfigMachineLearningAvailabilityChecksDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigMachineLearningAvailabilityChecksDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigMachineLearningAvailabilityChecksDto> get serializer => _$AdminConfigMachineLearningAvailabilityChecksDtoSerializer();
}

class _$AdminConfigMachineLearningAvailabilityChecksDtoSerializer implements PrimitiveSerializer<AdminConfigMachineLearningAvailabilityChecksDto> {
  @override
  final Iterable<Type> types = const [AdminConfigMachineLearningAvailabilityChecksDto, _$AdminConfigMachineLearningAvailabilityChecksDto];

  @override
  final String wireName = r'AdminConfigMachineLearningAvailabilityChecksDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigMachineLearningAvailabilityChecksDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'interval';
    yield serializers.serialize(
      object.interval,
      specifiedType: const FullType(int),
    );
    yield r'timeout';
    yield serializers.serialize(
      object.timeout,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigMachineLearningAvailabilityChecksDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigMachineLearningAvailabilityChecksDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'interval':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.interval = valueDes;
          break;
        case r'timeout':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.timeout = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigMachineLearningAvailabilityChecksDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigMachineLearningAvailabilityChecksDtoBuilder();
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


