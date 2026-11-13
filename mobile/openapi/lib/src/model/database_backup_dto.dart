//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'database_backup_dto.g.dart';

/// DatabaseBackupDto
///
/// Properties:
/// * [filename] - Backup filename
/// * [filesize] - Backup file size
/// * [timezone] - Backup timezone
@BuiltValue()
abstract class DatabaseBackupDto implements Built<DatabaseBackupDto, DatabaseBackupDtoBuilder> {
  /// Backup filename
  @BuiltValueField(wireName: r'filename')
  String get filename;

  /// Backup file size
  @BuiltValueField(wireName: r'filesize')
  int get filesize;

  /// Backup timezone
  @BuiltValueField(wireName: r'timezone')
  String get timezone;

  DatabaseBackupDto._();

  factory DatabaseBackupDto([void updates(DatabaseBackupDtoBuilder b)]) = _$DatabaseBackupDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DatabaseBackupDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DatabaseBackupDto> get serializer => _$DatabaseBackupDtoSerializer();
}

class _$DatabaseBackupDtoSerializer implements PrimitiveSerializer<DatabaseBackupDto> {
  @override
  final Iterable<Type> types = const [DatabaseBackupDto, _$DatabaseBackupDto];

  @override
  final String wireName = r'DatabaseBackupDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DatabaseBackupDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'filename';
    yield serializers.serialize(
      object.filename,
      specifiedType: const FullType(String),
    );
    yield r'filesize';
    yield serializers.serialize(
      object.filesize,
      specifiedType: const FullType(int),
    );
    yield r'timezone';
    yield serializers.serialize(
      object.timezone,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DatabaseBackupDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DatabaseBackupDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'filename':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.filename = valueDes;
          break;
        case r'filesize':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.filesize = valueDes;
          break;
        case r'timezone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.timezone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DatabaseBackupDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DatabaseBackupDtoBuilder();
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


