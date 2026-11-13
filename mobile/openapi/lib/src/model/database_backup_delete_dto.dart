//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'database_backup_delete_dto.g.dart';

/// DatabaseBackupDeleteDto
///
/// Properties:
/// * [backups] - Backup filenames to delete
@BuiltValue()
abstract class DatabaseBackupDeleteDto implements Built<DatabaseBackupDeleteDto, DatabaseBackupDeleteDtoBuilder> {
  /// Backup filenames to delete
  @BuiltValueField(wireName: r'backups')
  BuiltList<String> get backups;

  DatabaseBackupDeleteDto._();

  factory DatabaseBackupDeleteDto([void updates(DatabaseBackupDeleteDtoBuilder b)]) = _$DatabaseBackupDeleteDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DatabaseBackupDeleteDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DatabaseBackupDeleteDto> get serializer => _$DatabaseBackupDeleteDtoSerializer();
}

class _$DatabaseBackupDeleteDtoSerializer implements PrimitiveSerializer<DatabaseBackupDeleteDto> {
  @override
  final Iterable<Type> types = const [DatabaseBackupDeleteDto, _$DatabaseBackupDeleteDto];

  @override
  final String wireName = r'DatabaseBackupDeleteDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DatabaseBackupDeleteDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'backups';
    yield serializers.serialize(
      object.backups,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DatabaseBackupDeleteDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DatabaseBackupDeleteDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'backups':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
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
  DatabaseBackupDeleteDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DatabaseBackupDeleteDtoBuilder();
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


