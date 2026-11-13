//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_integrity_checksum_job_dto.g.dart';

/// Integrity checksum job config
///
/// Properties:
/// * [cronExpression] - Cron expression for when the integrity check should run
/// * [enabled] - Enabled
/// * [percentageLimit] - Percentage limit of the integrity checksum job
/// * [timeLimit] - How long the integrity checksum job may run for
@BuiltValue()
abstract class AdminConfigIntegrityChecksumJobDto implements Built<AdminConfigIntegrityChecksumJobDto, AdminConfigIntegrityChecksumJobDtoBuilder> {
  /// Cron expression for when the integrity check should run
  @BuiltValueField(wireName: r'cronExpression')
  String get cronExpression;

  /// Enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// Percentage limit of the integrity checksum job
  @BuiltValueField(wireName: r'percentageLimit')
  double get percentageLimit;

  /// How long the integrity checksum job may run for
  @BuiltValueField(wireName: r'timeLimit')
  int get timeLimit;

  AdminConfigIntegrityChecksumJobDto._();

  factory AdminConfigIntegrityChecksumJobDto([void updates(AdminConfigIntegrityChecksumJobDtoBuilder b)]) = _$AdminConfigIntegrityChecksumJobDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigIntegrityChecksumJobDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigIntegrityChecksumJobDto> get serializer => _$AdminConfigIntegrityChecksumJobDtoSerializer();
}

class _$AdminConfigIntegrityChecksumJobDtoSerializer implements PrimitiveSerializer<AdminConfigIntegrityChecksumJobDto> {
  @override
  final Iterable<Type> types = const [AdminConfigIntegrityChecksumJobDto, _$AdminConfigIntegrityChecksumJobDto];

  @override
  final String wireName = r'AdminConfigIntegrityChecksumJobDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigIntegrityChecksumJobDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cronExpression';
    yield serializers.serialize(
      object.cronExpression,
      specifiedType: const FullType(String),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'percentageLimit';
    yield serializers.serialize(
      object.percentageLimit,
      specifiedType: const FullType(double),
    );
    yield r'timeLimit';
    yield serializers.serialize(
      object.timeLimit,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigIntegrityChecksumJobDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigIntegrityChecksumJobDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cronExpression':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.cronExpression = valueDes;
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'percentageLimit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.percentageLimit = valueDes;
          break;
        case r'timeLimit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.timeLimit = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigIntegrityChecksumJobDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigIntegrityChecksumJobDtoBuilder();
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


