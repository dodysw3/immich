//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/admin_config_integrity_job_dto.dart';
import 'package:openapi/src/model/admin_config_integrity_checksum_job_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_integrity_checks_dto.g.dart';

/// Integrity checks config
///
/// Properties:
/// * [checksumFiles] 
/// * [missingFiles] 
/// * [untrackedFiles] 
@BuiltValue()
abstract class AdminConfigIntegrityChecksDto implements Built<AdminConfigIntegrityChecksDto, AdminConfigIntegrityChecksDtoBuilder> {
  @BuiltValueField(wireName: r'checksumFiles')
  AdminConfigIntegrityChecksumJobDto get checksumFiles;

  @BuiltValueField(wireName: r'missingFiles')
  AdminConfigIntegrityJobDto get missingFiles;

  @BuiltValueField(wireName: r'untrackedFiles')
  AdminConfigIntegrityJobDto get untrackedFiles;

  AdminConfigIntegrityChecksDto._();

  factory AdminConfigIntegrityChecksDto([void updates(AdminConfigIntegrityChecksDtoBuilder b)]) = _$AdminConfigIntegrityChecksDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigIntegrityChecksDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigIntegrityChecksDto> get serializer => _$AdminConfigIntegrityChecksDtoSerializer();
}

class _$AdminConfigIntegrityChecksDtoSerializer implements PrimitiveSerializer<AdminConfigIntegrityChecksDto> {
  @override
  final Iterable<Type> types = const [AdminConfigIntegrityChecksDto, _$AdminConfigIntegrityChecksDto];

  @override
  final String wireName = r'AdminConfigIntegrityChecksDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigIntegrityChecksDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'checksumFiles';
    yield serializers.serialize(
      object.checksumFiles,
      specifiedType: const FullType(AdminConfigIntegrityChecksumJobDto),
    );
    yield r'missingFiles';
    yield serializers.serialize(
      object.missingFiles,
      specifiedType: const FullType(AdminConfigIntegrityJobDto),
    );
    yield r'untrackedFiles';
    yield serializers.serialize(
      object.untrackedFiles,
      specifiedType: const FullType(AdminConfigIntegrityJobDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigIntegrityChecksDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigIntegrityChecksDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'checksumFiles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigIntegrityChecksumJobDto),
          ) as AdminConfigIntegrityChecksumJobDto;
          result.checksumFiles.replace(valueDes);
          break;
        case r'missingFiles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigIntegrityJobDto),
          ) as AdminConfigIntegrityJobDto;
          result.missingFiles.replace(valueDes);
          break;
        case r'untrackedFiles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigIntegrityJobDto),
          ) as AdminConfigIntegrityJobDto;
          result.untrackedFiles.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigIntegrityChecksDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigIntegrityChecksDtoBuilder();
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


