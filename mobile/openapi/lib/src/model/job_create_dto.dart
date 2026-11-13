//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/manual_job_name.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'job_create_dto.g.dart';

/// JobCreateDto
///
/// Properties:
/// * [name] 
@BuiltValue()
abstract class JobCreateDto implements Built<JobCreateDto, JobCreateDtoBuilder> {
  @BuiltValueField(wireName: r'name')
  ManualJobName get name;
  // enum nameEnum {  person-cleanup,  face-recheck,  tag-cleanup,  user-cleanup,  memory-cleanup,  memory-create,  backup-database,  integrity-missing-files,  integrity-untracked-files,  integrity-checksum-mismatch,  integrity-missing-files-refresh,  integrity-untracked-files-refresh,  integrity-checksum-mismatch-refresh,  integrity-missing-files-delete-all,  integrity-untracked-files-delete-all,  integrity-checksum-mismatch-delete-all,  };

  JobCreateDto._();

  factory JobCreateDto([void updates(JobCreateDtoBuilder b)]) = _$JobCreateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(JobCreateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<JobCreateDto> get serializer => _$JobCreateDtoSerializer();
}

class _$JobCreateDtoSerializer implements PrimitiveSerializer<JobCreateDto> {
  @override
  final Iterable<Type> types = const [JobCreateDto, _$JobCreateDto];

  @override
  final String wireName = r'JobCreateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    JobCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(ManualJobName),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    JobCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required JobCreateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ManualJobName),
          ) as ManualJobName;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  JobCreateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = JobCreateDtoBuilder();
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


