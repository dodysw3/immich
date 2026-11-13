//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'manual_job_name.g.dart';

/// Manual job name
class ManualJobName extends EnumClass {

  @BuiltValueEnumConst(wireName: r'person-cleanup')
  static const ManualJobName personCleanup = _$personCleanup;
  @BuiltValueEnumConst(wireName: r'face-recheck')
  static const ManualJobName faceRecheck = _$faceRecheck;
  @BuiltValueEnumConst(wireName: r'tag-cleanup')
  static const ManualJobName tagCleanup = _$tagCleanup;
  @BuiltValueEnumConst(wireName: r'user-cleanup')
  static const ManualJobName userCleanup = _$userCleanup;
  @BuiltValueEnumConst(wireName: r'memory-cleanup')
  static const ManualJobName memoryCleanup = _$memoryCleanup;
  @BuiltValueEnumConst(wireName: r'memory-create')
  static const ManualJobName memoryCreate = _$memoryCreate;
  @BuiltValueEnumConst(wireName: r'backup-database')
  static const ManualJobName backupDatabase = _$backupDatabase;
  @BuiltValueEnumConst(wireName: r'integrity-missing-files')
  static const ManualJobName integrityMissingFiles = _$integrityMissingFiles;
  @BuiltValueEnumConst(wireName: r'integrity-untracked-files')
  static const ManualJobName integrityUntrackedFiles = _$integrityUntrackedFiles;
  @BuiltValueEnumConst(wireName: r'integrity-checksum-mismatch')
  static const ManualJobName integrityChecksumMismatch = _$integrityChecksumMismatch;
  @BuiltValueEnumConst(wireName: r'integrity-missing-files-refresh')
  static const ManualJobName integrityMissingFilesRefresh = _$integrityMissingFilesRefresh;
  @BuiltValueEnumConst(wireName: r'integrity-untracked-files-refresh')
  static const ManualJobName integrityUntrackedFilesRefresh = _$integrityUntrackedFilesRefresh;
  @BuiltValueEnumConst(wireName: r'integrity-checksum-mismatch-refresh')
  static const ManualJobName integrityChecksumMismatchRefresh = _$integrityChecksumMismatchRefresh;
  @BuiltValueEnumConst(wireName: r'integrity-missing-files-delete-all')
  static const ManualJobName integrityMissingFilesDeleteAll = _$integrityMissingFilesDeleteAll;
  @BuiltValueEnumConst(wireName: r'integrity-untracked-files-delete-all')
  static const ManualJobName integrityUntrackedFilesDeleteAll = _$integrityUntrackedFilesDeleteAll;
  @BuiltValueEnumConst(wireName: r'integrity-checksum-mismatch-delete-all')
  static const ManualJobName integrityChecksumMismatchDeleteAll = _$integrityChecksumMismatchDeleteAll;

  static Serializer<ManualJobName> get serializer => _$manualJobNameSerializer;

  const ManualJobName._(String name): super(name);

  static BuiltSet<ManualJobName> get values => _$values;
  static ManualJobName valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ManualJobNameMixin = Object with _$ManualJobNameMixin;

