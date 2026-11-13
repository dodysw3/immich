//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'bulk_id_error_reason.g.dart';

/// Error reason
class BulkIdErrorReason extends EnumClass {

  @BuiltValueEnumConst(wireName: r'duplicate')
  static const BulkIdErrorReason duplicate = _$duplicate;
  @BuiltValueEnumConst(wireName: r'no_permission')
  static const BulkIdErrorReason noPermission = _$noPermission;
  @BuiltValueEnumConst(wireName: r'not_found')
  static const BulkIdErrorReason notFound = _$notFound;
  @BuiltValueEnumConst(wireName: r'unknown')
  static const BulkIdErrorReason unknown = _$unknown;
  @BuiltValueEnumConst(wireName: r'validation')
  static const BulkIdErrorReason validation = _$validation;

  static Serializer<BulkIdErrorReason> get serializer => _$bulkIdErrorReasonSerializer;

  const BulkIdErrorReason._(String name): super(name);

  static BuiltSet<BulkIdErrorReason> get values => _$values;
  static BulkIdErrorReason valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class BulkIdErrorReasonMixin = Object with _$BulkIdErrorReasonMixin;

