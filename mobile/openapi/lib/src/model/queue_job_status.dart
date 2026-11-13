//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'queue_job_status.g.dart';

/// Queue job status
class QueueJobStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'active')
  static const QueueJobStatus active = _$active;
  @BuiltValueEnumConst(wireName: r'failed')
  static const QueueJobStatus failed = _$failed;
  @BuiltValueEnumConst(wireName: r'completed')
  static const QueueJobStatus completed = _$completed;
  @BuiltValueEnumConst(wireName: r'delayed')
  static const QueueJobStatus delayed = _$delayed;
  @BuiltValueEnumConst(wireName: r'waiting')
  static const QueueJobStatus waiting = _$waiting;

  static Serializer<QueueJobStatus> get serializer => _$queueJobStatusSerializer;

  const QueueJobStatus._(String name): super(name);

  static BuiltSet<QueueJobStatus> get values => _$values;
  static QueueJobStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class QueueJobStatusMixin = Object with _$QueueJobStatusMixin;

