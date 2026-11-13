//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/database_backup_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'database_backup_list_response_dto.g.dart';

/// DatabaseBackupListResponseDto
///
/// Properties:
/// * [backups] - List of backups
@BuiltValue()
abstract class DatabaseBackupListResponseDto implements Built<DatabaseBackupListResponseDto, DatabaseBackupListResponseDtoBuilder> {
  /// List of backups
  @BuiltValueField(wireName: r'backups')
  BuiltList<DatabaseBackupDto> get backups;

  DatabaseBackupListResponseDto._();

  factory DatabaseBackupListResponseDto([void updates(DatabaseBackupListResponseDtoBuilder b)]) = _$DatabaseBackupListResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DatabaseBackupListResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DatabaseBackupListResponseDto> get serializer => _$DatabaseBackupListResponseDtoSerializer();
}

class _$DatabaseBackupListResponseDtoSerializer implements PrimitiveSerializer<DatabaseBackupListResponseDto> {
  @override
  final Iterable<Type> types = const [DatabaseBackupListResponseDto, _$DatabaseBackupListResponseDto];

  @override
  final String wireName = r'DatabaseBackupListResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DatabaseBackupListResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'backups';
    yield serializers.serialize(
      object.backups,
      specifiedType: const FullType(BuiltList, [FullType(DatabaseBackupDto)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DatabaseBackupListResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DatabaseBackupListResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'backups':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DatabaseBackupDto)]),
          ) as BuiltList<DatabaseBackupDto>;
          result.backups.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DatabaseBackupListResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DatabaseBackupListResponseDtoBuilder();
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


