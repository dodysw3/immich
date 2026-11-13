//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'integrity_report.g.dart';

/// Integrity report type
class IntegrityReport extends EnumClass {

  @BuiltValueEnumConst(wireName: r'untracked_file')
  static const IntegrityReport untrackedFile = _$untrackedFile;
  @BuiltValueEnumConst(wireName: r'missing_file')
  static const IntegrityReport missingFile = _$missingFile;
  @BuiltValueEnumConst(wireName: r'checksum_mismatch')
  static const IntegrityReport checksumMismatch = _$checksumMismatch;

  static Serializer<IntegrityReport> get serializer => _$integrityReportSerializer;

  const IntegrityReport._(String name): super(name);

  static BuiltSet<IntegrityReport> get values => _$values;
  static IntegrityReport valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class IntegrityReportMixin = Object with _$IntegrityReportMixin;

